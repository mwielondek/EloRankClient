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
                alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.Default) { _ in
                    self.refreshControl?.beginRefreshing()
                    self.tableView.setContentOffset(CGPoint(x: 0, y: self.tableView.contentOffset.y-self.refreshControl!.frame.size.height), animated: true)
                    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
                        sleep(1)
                        self.refresh()
                    }
                })
                self.presentViewController(alert, animated: true, completion: nil)
            }
            self.refreshControl?.endRefreshing()
        }
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
            // remeber to change arg
            Backend.getAlternatives(forPollId: polls[tableView.indexPathForSelectedRow()!.row].id) {
                atvc.alternatives = $0 ?? []
                atvc.refreshControl?.endRefreshing()
                atvc.refreshControl?.removeFromSuperview()
            }
            println("preparing segue")
            atvc.navigationItem.title = (sender as UITableViewCell).textLabel?.text
        }
    }

}
