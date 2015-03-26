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
        var poll = Poll(id: 1, name: "Test poll", alternatives: [])
        polls.append(poll)
        
        return polls
    }
}