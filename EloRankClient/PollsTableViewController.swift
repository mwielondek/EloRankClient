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
        Backend.getPolls {
            self.polls = $0
        }
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return polls.count
    }
    
    private struct Storyboard {
        static let pollCellIdentifier = "poll"
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.pollCellIdentifier, forIndexPath: indexPath) as UITableViewCell

        cell.textLabel?.text = polls[indexPath.row].name
        cell.detailTextLabel?.text = "Alternatives: \(polls[indexPath.row].alternativesCount)"

        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let atvc = segue.destinationViewController as? AlternativesTableViewController {
            atvc.alternatives = Backend.getAlternatives(forPollId: 1)
            atvc.navigationItem.title = (sender as UITableViewCell).textLabel?.text
        }
    }

}
