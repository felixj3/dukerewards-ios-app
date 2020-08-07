//
//  NotificationManager.swift
//  DukeRewards
//
//  Created by Kyra Chan on 6/10/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import Foundation

class NotificationManager {
    
    /*
     var data: [Notification] = [
        Notification(header: "Free t-shirts for first 50 people at VT game!", timeString: "2020-08-29 20:00", description: "Bring your Duke ID and win a free t-shirt if you come to the game early!", category: "Athletics"),
        Notification(header: "Special deal at Sazon today!", timeString: "2020-08-14 12:00", description: "Limited offer of Sazon's specialty steak bowl, only available today from 11:00AM to 2:00PM.", category: "Dining"),
        Notification(header: "Start of School Sale - 20% off!", timeString: "2020-08-12 16:00", description: "Duke Stores is having a 20% off student sale, open from Fri-Sun", category: "Stores")]
    
 */
    var data: [Notification] = []
    var filtername = ""
    var encodedate = ""
    var ongoing: Bool = false
    var reloadData: (([Notification]) -> ())?
    
    
    func callFetchData()
    {
        fetchData(filter: filtername, date: encodedate, ongoing: ongoing)
    }
    
    private func fetchData(filter: String, date: String, ongoing: Bool){
        let spec_url = Bundle.main.object(forInfoDictionaryKey: "NetworkURL") as! String + "/announcements.json"
        
        NetworkManager.getJSON(specific_url: spec_url) {jsonData in // closure. Body of the completion function parameter
            if let notifications = jsonData["data"] as? Array<Dictionary<String,Any>>{
                for notification in notifications {
                    // let created_at = notification["created_at"] as? String ?? "NA"
                    // let dateAndTime = NetworkManager.formatTime(created_at: created_at) // format's ruby time to swift time format
                    
                    let currNotification = Notification(header: notification["title"] as? String ?? "NA",
                                            timeString: notification["created_at"] as? String ?? "NA",
                                            description: notification["description"] as? String ?? "NA",
                                            category: notification["category"] as? String ?? "NA")
                    self.data.append(currNotification)
                }
            }
            self.reloadData?(self.data)
            // call the closure variable function defined here but body is in EarnVC
            // pass in the data array we created here for use in the tableView
        }
    }
}
