//
//  RewardManager.swift
//  DukeRewards
//
//  Created by Anni Chen on 6/8/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import Foundation

class RewardManager {
    /*
     var data: [Reward] = [
        Reward(name: "Duke VS. UNC Game", timeString: "2020-08-29 20:00", location: "K-Ville", description: "Get bumped up to front row!", points: 800, category: "Athletics", image: nil),
        Reward(name: "Chef's Table", timeString: nil, location: "Marketplace", description: "Get a special meal made by Duke Dining!", points: 450, category: "Dining", image: "pitchforks"),
        Reward(name: "Free Zion Jersey", timeString: "2020-03-29 22:00", location: "K-Ville", description: "Signed by Zion Williamson himself!", points: 1000, category: "Athletics", image: "panda_express")]
    
    */
    var data: [Reward] = []
    var filtername = ""
    var encodedate = ""
    var ongoing: Bool = false
    var reloadData: (([Reward]) -> ())?
    
    
    func callFetchData()
    {
        fetchData(filter: filtername, date: encodedate, ongoing: ongoing)
    }
    
    private func fetchData(filter: String, date: String, ongoing: Bool){
        let networkURL = Bundle.main.object(forInfoDictionaryKey: "NetworkURL") as! String
        let spec_url =  "\(networkURL)/rewards.json"
//        "anni.local:3000/rewards.json"

        
        NetworkManager.getJSON(specific_url: spec_url) {jsonData in // closure. Body of the completion function parameter
            if let rewards = jsonData["data"] as? Array<Dictionary<String,Any>>{

                let dateFormatter = DateFormatter()
                // dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSxxx"
                dateFormatter.timeZone = NSTimeZone(name: "EST") as TimeZone?
                
                let date = Date()
                let date_now = dateFormatter.string(from: date)
                
                for reward in rewards {
                    var redeemed: Bool = false
                    var notExpired: Bool = false
                    if let redeemedRewards = User.globalUser.rewards{
                        if(redeemedRewards.contains(reward["id"] as? Int ?? -1)){
                            redeemed = true
                        }
                    }
                    var timeCheck: Bool = false
                    var quantityCheck: Bool = false
                    let expiry_time = reward["expiry_time"] as? String ?? "NA"
                    
                    let expiry_quantity = reward["expiry_quantity"] as? Int ?? -1
                    if(expiry_quantity == -1 || expiry_quantity > 0){
                        quantityCheck = true
                    }
                    
                    if(expiry_time == "NA" || date_now < expiry_time){
                        timeCheck = true
                    }
//                    print(expiry_time)
//                    print(date_now)
//                    print(expiry_time > date_now)
                    notExpired = timeCheck && quantityCheck
                    
                    if(notExpired || redeemed){
                        let currReward = Reward(name: reward["name"] as? String ?? "NA",
                                                timeString: reward["start_time"] as? String ?? "NA",
                                                location: reward["location"] as? String ?? "NA",
                                                description: reward["description"] as? String ?? "NA",
                                                points: reward["points"] as? Int ?? 0,
                                                category: reward["category"] as? String ?? "NA",
                                                image: reward["image"] as? String ?? "Error",
                                                id: reward["id"] as? Int ?? -1,
                                                expiry_time: dateFormatter.date(from: expiry_time),
                                                expiry_quantity: reward["expiry_quantity"] as? Int ?? 0)
                        // no image option in rewards on rails server right now
                        // id of -1 means reward id didn't get through
                        self.data.append(currReward)
//                        print("----In Reward Manager-----")
//                        print(reward["start_time"])
//                        print(reward["expiry_time"])
//                        let r: Date = dateFormatterP.date(from: reward["expiry_time"] as? String ?? "2020-01-01T01:00:00.000-04:00")!
//                        print(dateFormatter.string(from: r))
                    }
                }
                // print("end fetching data")
                // print(self.data[0].description)
            }
            self.reloadData?(self.data)
            // call the closure variable function defined here but body is in EarnVC
            // pass in the data array we created here for use in the tableView
            // I moved this outside of the if let because if the rewards can't be set to jsonData["data"], the stop refresh will still happen
        }
    }
}
