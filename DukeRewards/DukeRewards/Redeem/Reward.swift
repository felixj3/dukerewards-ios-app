//
//  Reward.swift
//  DukeRewards
//
//  Created by Anni Chen on 6/8/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import Foundation

class Reward {
    let name: String
    let time: Date?
    let location: String
    let description: String
    let points: Int
    let category: String?
    let image: String?
    let id: Int // unique ID for the reward
    let expiry_time: Date?
    var expiry_quantity: Int?
    
    init (name: String, timeString: String?, location: String, description: String, points: Int?, category: String?, image: String?, id: Int, expiry_time: Date?, expiry_quantity: Int?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSxxx"
        dateFormatter.timeZone = NSTimeZone(name: "EST") as TimeZone?
        if let safeString = timeString {
            let date = dateFormatter.date(from: safeString)
            self.time = date ?? nil
        } else {
            self.time = nil
        }
        self.name = name
        self.location = location
        self.description = description
        self.points = points ?? 0
        self.category = category
        self.image = image
        self.id = id
        self.expiry_time = expiry_time
        self.expiry_quantity = expiry_quantity
    }
}

