//
//  Notification.swift
//  DukeRewards
//
//  Created by Kyra Chan on 6/10/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import Foundation

class Notification {
    
    let header: String?
    let time: Date?
    let description: String?
    let category: String?
    
    init (header: String?, timeString: String?, description: String?, category: String?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSxxx"
        dateFormatter.timeZone = NSTimeZone(name: "EST") as TimeZone?
        if let safeString = timeString { // this if let ensures the timeString we pass in is a string
            let date = dateFormatter.date(from: safeString)
            self.time = date ?? nil // if the safeString is not in the correct format, then date is nil so we have to handle that
            // when it was self.time = date!, an error occurs if you forcefully unwrap a nil value
            // self.time = nil
        } else {
            self.time = nil
        }
        self.header = header
        self.description = description
        self.category = category
    }
}
