//
//  PollsTableViewController.swift
//  EloRankClient
//
//  Created by Milosz Wielondek on 26/03/15.
//  Copyright (c) 2015 Milosz Wielondek. All rights reserved.
//

import UIKit

class PollsTableViewController: UITableViewController {
    
    var polls: [Poll] = [] {
        didSet {
            println("New polls value set")
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl?.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        
        // auto refresh
        self.refreshControl?.beginRefreshing()
        refresh()
    }
    
    func refresh() {
        Backend.getPolls { (var polls) in
            if polls != nil {
                self.polls = polls!
            } else {
                // something went wrong
                var alert = UIAlertController(title: "Network error", message: "No polls to show :(", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.Cancel, handler: self.triggerRefresh))
                alert.addAction(UIAlertAction(title: "Settings", style: UIAlertActionStyle.Default, handler: self.showSettings))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            self.refreshControl?.endRefreshing()
        }
    }
    
    func triggerRefresh(sender: AnyObject?) {
        self.refreshControl?.beginRefreshing()
        // scroll up to show the spinner
        self.tableView.setContentOffset(CGPoint(x: 0, y: self.tableView.contentOffset.y-self.refreshControl!.frame.size.height), animated: true)
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            self.refresh()
        }
    }
    
    func showSettings(sender: AnyObject?) {
        var dialog = UIAlertController(title: "Server settings", message: "Enter server IP", preferredStyle: UIAlertControllerStyle.Alert)
        dialog.addTextFieldWithConfigurationHandler {(var textfield: UITextField!) in
            textfield.placeholder = "Enter address"
            textfield.text = serverURL
        }
        dialog.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.Default) { _ in
                serverURL = (dialog.textFields![0] as UITextField).text
            })
        dialog.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(dialog, animated: true, completion: nil)
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return polls.count
    }
    
    struct Storyboard {
        static let tableCellIdentifier = "tableCellId"
        static let detailCell = "detailCell"
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.tableCellIdentifier, forIndexPath: indexPath) as UITableViewCell

        cell.textLabel?.text = polls[indexPath.row].name
        cell.detailTextLabel?.text = "Alternatives: \(polls[indexPath.row].alternativesCount)"

        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let atvc = segue.destinationViewController as? AlternativesTableViewController {
            var pollId = polls[tableView.indexPathForSelectedRow()!.row].id
            Backend.getAlternatives(forPollId: pollId) {
                atvc.alternatives = $0 ?? []
                atvc.refreshControl?.endRefreshing()
                atvc.refreshControl?.removeFromSuperview()
            }
            atvc.navigationItem.title = (sender as UITableViewCell).textLabel?.text
            atvc.pollId = pollId
        }
    }

}
