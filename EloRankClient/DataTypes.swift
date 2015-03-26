//
//  DataTypes.swift
//  EloRankClient
//
//  Created by Milosz Wielondek on 26/03/15.
//  Copyright (c) 2015 Milosz Wielondek. All rights reserved.
//
import Foundation

struct Poll {
    let id: Int
    let name: String
    let alternatives: [Alternative]
}

struct Alternative {
    let id: Int
    let name: String?
    let url: String
    let score: Int
    let rankedTimes: Int
}

struct Challenge {}