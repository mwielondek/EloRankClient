//
//  Backend.swift
//  EloRankClient
//
//  Created by Milosz Wielondek on 26/03/15.
//  Copyright (c) 2015 Milosz Wielondek. All rights reserved.
//

import Foundation

class Backend {
    private let serverURL = NSURL(string: "localhost:8080")
    
    class func getPolls() -> [Poll] {
        var polls: [Poll] = []
        
        // dummy poll
        var poll = Poll(id: 1, name: "Test poll", alternatives: [])
        polls.append(poll)
        
        return polls
    }
    
    class func getAlternatives(forPollId pollId: Int) -> [Alternative] {
        var alternatives = [Alternative]()
        
        // dummy alternative
        var alt = Alternative(id: 1, name: "Alt 1", url: "alt1.jpg", score: 400, rankedTimes: 2)
        alternatives.append(alt)
        return alternatives
    }
}