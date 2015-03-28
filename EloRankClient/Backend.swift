//
//  Backend.swift
//  EloRankClient
//
//  Created by Milosz Wielondek on 26/03/15.
//  Copyright (c) 2015 Milosz Wielondek. All rights reserved.
//

import Foundation
import Alamofire

private let serverURL = "http://localhost:8080"

class Backend {
    
    class func getPolls(completionHandler: (polls: [Poll]?) -> ()) {

        Alamofire.request(.GET, serverURL+"/polls")
            .responseJSON { (_,_,data,_) in
                if let parsed = data as? [NSDictionary] {
                    var polls = parsed.map { (var poll) -> Poll in
                        return Poll(id: poll["id"] as Int,
                                    name: poll["name"] as String,
                                    alternativesCount: poll["alternativesCount"] as Int)
                    }
                    println("Got json back")
                    completionHandler(polls: polls)
                } else {
                    println("Something went wrong when trying to fetch polls :(")
                    completionHandler(polls: nil)
                }
        }
    }
    
    class func getAlternatives(forPollId pollId: Int, completionHandler: (alternatives: [Alternative]?) -> ()) {

        Alamofire.request(.GET, serverURL+"/polls/\(pollId)")
            .responseJSON { (_,_,data,_) in
                if let parsed = data as? [NSDictionary] {
                    var alternatives = (parsed[0]["alternatives"] as? [NSDictionary])!.map { (var alt) -> Alternative in
                        // TODO: implement name serverside/db
                        return Alternative(id: alt["id"] as Int, name: alt["name"] as String, url: alt["url"] as String,
                            score: alt["score"] as Int, rankedTimes: alt["ranked_times"] as Int)
                    }
                    println("Got json back (alts)")
                    completionHandler(alternatives: alternatives)
                }
        }
        
    }
}