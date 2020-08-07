//
//  Event_test1.swift
//  DukeRewards
//
//  Created by Anni Chen on 6/10/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import Foundation

struct Event_test1 {
    let name: String?
    let description: String?
    let location: String?
    let start_time: Date?
    let end_time: Date?
    let image: String
    let categories: [String]?
    
    init (name: String, description: String, location: String, start_time: String?, end_time: String?, image: String, categories: [String]?) {
        self.name = name
        self.description = description
        self.location = location
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        if let safeStart = start_time {
            let date = dateFormatter.date(from: safeStart)
            self.start_time = date!
        } else {
            self.start_time = nil
        }
        if let safeEnd = end_time {
            let date = dateFormatter.date(from: safeEnd)
            self.end_time = date!
        } else {
            self.end_time = nil
        }
        self.image = image
        self.categories = categories
    }
}
