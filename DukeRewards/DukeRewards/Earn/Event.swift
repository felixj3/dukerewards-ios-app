//
//  Event.swift
//  DukeRewards
//
//  Created by Kyra Chan on 6/4/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import Foundation

class Event {
    let id: Int
    let name: String
    let description: String
    let location: String
    let start_time: Date?
    let end_time: Date?
    let image: String
    let category: String?
    let points: Int
    let QRnumber: String
    let radius: String
    init (id: Int, name: String, description: String, location: String, start_time: String?, end_time: String?, image: String, category: String?,
          points: Int, QRnumber: String, radius: String) {
        self.id = id
        self.name = name
        self.description = description
        self.location = location
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        if let safeStart = start_time {
            let date = dateFormatter.date(from: safeStart)
            self.start_time = date ?? nil
        } else {
            self.start_time = nil
        }
        if let safeEnd = end_time {
            let date = dateFormatter.date(from: safeEnd)
            self.end_time = date ?? nil
        } else {
            self.end_time = nil
        }
        self.image = image
        self.category = category
        self.points = points
        self.QRnumber = QRnumber
        self.radius = radius
    }
    
}

