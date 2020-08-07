//
//  EventManager.swift
//  DukeRewards
//
//  Created by Anni Chen on 6/4/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import Foundation


class EventManager {
    var filtername = ""
    var encodedate = ""
    var ongoing: Bool = false
    var reloadData: (([Event]) -> ())? // define closure variable to pass information to EarnVC
    var data: [Event] = []
    
    init() {
        // print(data)
        // Reason for callFetchData method was because the call to fetchData used to be in init, which became a problem at some point since we didn't have a closure defined when it was called, so the data became thrown away. 
    }
    
    func callFetchData(){
        fetchData(filter: filtername, date: encodedate, ongoing: ongoing)
    }
    
//    private func fetchData(filter: String, date: String, ongoing: Bool){
//        let spec_url = "https://calendar-test.oit.duke.edu/events/index.json?&topic=&future_days=90&user_date=&feed_type=simple&local=true"
//
//        NetworkManager.getJSON(specific_url: spec_url) {jsonData in // closure. Body of the completion function parameter
//            if let events = jsonData["events"] as? Array<Dictionary<String,Any>>{
//                // print("start fetching data")
//                for event in events {
//                    let addressDict = event["location"] as! Dictionary<String,String>
//                    let currEvent = Event(id: event["id"] as? String ?? "NA",
//                        name: event["summary"] as? String ?? "NA",
//                        description: event["description"] as? String ?? "NA",
//                        location: addressDict["address"] ?? "NA",
//                        start_time: event["start_timestamp"] as? String ?? "",
//                        end_time: event["end_timestamp"] as? String ?? "",
//                        image: event["image"] as? String ?? "defaultImage",
//                        categories: event["categories"] as? [String] ?? nil,
//                        points: event["points"] as? Int ?? 0,
//                        QRnumber: "ffejiwofiewofFOR TESTING")
//
//                    self.data.append(currEvent)
//                }
//                // print("end fetching data")
//            }
//            self.reloadData?(self.data)
//            // call the closure variable function defined here but body is in EarnVC
//            // pass in the data array we created here for use in the tableView
//        }
//    }
    private func fetchData(filter: String, date: String, ongoing: Bool) {
            let spec_url = Bundle.main.object(forInfoDictionaryKey: "NetworkURL") as! String + "/events.json"
//                "anni.local:3000/events.json"
            NetworkManager.getJSON(specific_url: spec_url) {jsonData in // closure. Body of the completion function parameter
                if let events = jsonData["data"] as? Array<Dictionary<String,Any>>{
                    // print("start fetching data")
                    for event in events {
                        let currEvent = Event(id: event["id"] as? Int ?? 0,
                            name: event["name"] as? String ?? "NA",
                            description: event["description"] as? String ?? "NA",
                            location: event["location"] as? String ?? "NA",
                            start_time: event["start_time"] as? String ?? "",
                            end_time: event["end_time"] as? String ?? "",
                            image: event["image"] as? String ?? "defaultImage",
                            category: event["category"] as? String ?? "NA",
                            points: event["points"] as? Int ?? 0,
                            QRnumber: event["QRnumber"] as? String ?? "ERROR",
                            radius: event["radius"] as? String ?? "Large")
                        self.data.append(currEvent)
                        print("----In Event Manager----")
                        print(event["radius"] )
                    }
                }
                self.reloadData?(self.data)
                    // print("end fetching data")
                    // print(self.data[0].description)
            }
                
                // call the closure variable function defined here but body is in EarnVC
                // pass in the data array we created here for use in the tableView
                // I moved this outside of the if let because if the rewards can't be set to jsonData["data"], the stop refresh will still happen
    }
        
    
   
    // this is what duke event attendance app does for images
    static func getRandomImageURL() -> String{
        let imageURLs:[String] = ["https://calendar.duke.edu/assets/v2016/featured-event-4.png",
                                  "https://calendar.duke.edu/assets/v2016/featured-event-3.png",
                                  "https://calendar.duke.edu/assets/v2016/featured-event-4.png",
                                  "https://calendar.duke.edu/assets/v2016/featured-event-5.png"]
        let randomNumber = Int.random(in: 0...3)
        return imageURLs[randomNumber]
    }
    
    
    // To manage all the APIs to create Event class
    func getDetails(_ index: Int) -> Event {
        return data[index]
    }
}

