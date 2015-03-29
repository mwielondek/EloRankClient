//
//  RateViewController.swift
//  EloRankClient
//
//  Created by Milosz Wielondek on 28/03/15.
//  Copyright (c) 2015 Milosz Wielondek. All rights reserved.
//

import UIKit

class RateViewController: UIViewController {

    @IBOutlet weak var altImageView1: UIImageView!
    @IBOutlet weak var altImageView2: UIImageView!
    @IBAction func handleTap(sender: UITapGestureRecognizer) {
        if let image = sender.view as? UIImageView {
            // create challenge response
            let result = image.tag // 1 if alt1, 2 if alt2, 0 if draw (not implemented client side yet)
            Backend.postChallengeResponse(challengeId!, results: result)
            // get next challenge
            getNewChallenge()
        }
    }
    
    var challengeId: Int?
    var pollId: Int?
    var alternatives: [Alternative] = []
    
    var alt1: Alternative? {
        didSet {
            altImageView1.image = UIImage(data: NSData(contentsOfURL: NSURL(string: alt1!.url)!)!)
        }
    }
    var alt2: Alternative? {
        didSet {
            altImageView2.image = UIImage(data: NSData(contentsOfURL: NSURL(string: alt2!.url)!)!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func getNewChallenge() {
        // TODO: add activity indicator
        Backend.getChallenge(forPollId: pollId!) {
            (var alts: NSDictionary?) in
            self.challengeId = (alts!["id"] as Int)
            self.alt1 = self.alternatives.filter { $0.id == (alts!["alt1"] as Int) }[0]
            self.alt2 = self.alternatives.filter { $0.id == (alts!["alt2"] as Int) }[0]
        }
    }


    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
