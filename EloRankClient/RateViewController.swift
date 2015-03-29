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


    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
