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
            tableView.reloadData()
        }
    }
    
    var pollId: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl?.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    override func viewDidAppear(animated: Bool) {
        refresh(forceScroll: true)
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
    
    func refresh() {
        refresh(forceScroll: false)
    }
    
    func refresh(#forceScroll: Bool) {
        refreshControl?.beginRefreshing()
        if forceScroll {
            tableView.setContentOffset(CGPoint(x: 0, y: self.tableView.contentOffset.y-self.refreshControl!.frame.size.height), animated: true)
        }
        Backend.getAlternatives(forPollId: pollId!) {
            self.alternatives = $0 ?? []
            self.refreshControl?.endRefreshing()
        }
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "rate" {
            if let rvc = segue.destinationViewController as? RateViewController {
                rvc.pollId = pollId
                rvc.alternatives = alternatives
                rvc.getNewChallenge()
            }
        }
    }
    
}
