//
//  AlternativesTableViewController.swift
//  EloRankClient
//
//  Created by Milosz Wielondek on 26/03/15.
//  Copyright (c) 2015 Milosz Wielondek. All rights reserved.
//

import UIKit

class AlternativesTableViewController: UITableViewController {

    var alternatives: [Alternative] = [] {
        didSet {
            println("New alternatives value set")
            tableView.reloadData()
        }
    }
    
    var pollId: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl?.beginRefreshing()
        tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alternatives.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(PollsTableViewController.Storyboard.tableCellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = alternatives[indexPath.row].name
        cell.detailTextLabel?.text = "Score: \(alternatives[indexPath.row].score)"
        
        return cell
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "rate" {
            if let rvc = segue.destinationViewController as? RateViewController {
                Backend.getChallenge(forPollId: pollId!) {
                    (var alts: NSDictionary?) in
                    rvc.alt1 = self.alternatives.filter { $0.id == (alts!["alt1"] as Int) }[0]
                    rvc.alt2 = self.alternatives.filter { $0.id == (alts!["alt2"] as Int) }[0]
                }
            }
        }
    }
    
}
