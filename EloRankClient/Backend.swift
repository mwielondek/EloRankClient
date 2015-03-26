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
    
    class func getPolls(completionHandler: (polls: [Poll]) -> ()) {
        var polls = [Poll]()

        Alamofire.request(.GET, serverURL+"/polls")
            .responseJSON { (_,_,data,_) in
                if let parsed = data as? [NSDictionary] {
                    polls = parsed.map { (var poll) -> Poll in
                        return Poll(id: poll["id"] as Int,
                                    name: poll["name"] as String,
                                    alternativesCount: 1)
                    }
                }
                println("Got json back")
                completionHandler(polls: polls)
        }
    }
    
    class func getAlternatives(forPollId pollId: Int) -> [Alternative] {
        var alternatives = [Alternative]()
        
        // dummy alternative
        var alt = Alternative(id: 1, name: "Alt 1", url: "alt1.jpg", score: 400, rankedTimes: 2)
        alternatives.append(alt)
        return alternatives
    }
}