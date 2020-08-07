//
//  UserManager.swift
//  DukeRewards
//
//  Created by codeplus on 6/18/20.
//  Copyright © 2020 Duke University. All rights reserved.
//


import Foundation
import UIKit

class UserManager {
   
    typealias Users = [User]
    //var users = [User]()
    var data: [User] = []
    var filtername = ""
    var encodedate = ""
    var ongoing: Bool = false
    var reloadData: (([User]) -> ())?
    //var profileData: (([User]) -> ())?
    var stopRefresh: (() -> ())?
    var updateRewards: (([Int]) -> ())?
    
     func callFetchData()
    {
        fetchData(filter: filtername, date: encodedate, ongoing: ongoing)
    }
    
    //URLSession to pull all users data in json file
    //Use decoder to decode data from JSON to User object
    //Return an array of users objects and sort it by total point value
    static func createPointsLabel() -> UIStackView{
        // Create athletics points label with icon
        // Create Image Icon Attachment
        let athleticsImageAttachment = NSTextAttachment()
        athleticsImageAttachment.image = UIImage(systemName: "dollarsign.circle.fill")?.withTintColor(UIColor(red: 1.00, green: 0.39, blue: 0.39, alpha: 1.00))
        // Set bound to reposition
        let athleticsImageOffsetY: CGFloat = -3
        let athleticsImageOffsetX: CGFloat = 1
        athleticsImageAttachment.bounds = CGRect(x: athleticsImageOffsetX, y: athleticsImageOffsetY, width: athleticsImageAttachment.image!.size.width - 2, height: athleticsImageAttachment.image!.size.height - 2)
        // Create string with attachment
        let athleticsAttachmentString = NSAttributedString(attachment: athleticsImageAttachment)
        // Initialize mutable string
        let athleticsText = NSMutableAttributedString(string: "")
        // Add image to mutable string
        athleticsText.append(athleticsAttachmentString)
        // Add your text to mutable string
        let athleticsTextAfterIcon = NSAttributedString(string: " " + String(describing: User.globalUser.athletics_points!) + "  ")
        athleticsText.append(athleticsTextAfterIcon)
        let athleticsLabel = UILabel()
        athleticsLabel.backgroundColor = UIColor(red: 0.05, green: 0.08, blue: 0.23, alpha: 1.00)
        athleticsLabel.layer.masksToBounds = true
        athleticsLabel.layer.cornerRadius = 10
        athleticsLabel.font = UIFont(name: "Avenir Regular", size: 10)
        athleticsLabel.textColor = UIColor.white
        athleticsLabel.textAlignment = .left
        //athleticsLabel.textAlignment = .center
        athleticsLabel.attributedText = athleticsText
        
        // Create dining points label with icon
        // Create Image Icon Attachment
        let diningImageAttachment = NSTextAttachment()
        diningImageAttachment.image = UIImage(systemName: "dollarsign.circle.fill")?.withTintColor(UIColor(red: 1.00, green: 0.85, blue: 0.38, alpha: 1.00))
        // Set bound to reposition
        let diningImageOffsetY: CGFloat = -3
        let diningImageOffsetX: CGFloat = 1
        diningImageAttachment.bounds = CGRect(x: diningImageOffsetX, y: diningImageOffsetY, width: diningImageAttachment.image!.size.width - 2, height: diningImageAttachment.image!.size.height - 2)
        // Create string with attachment
        let diningAttachmentString = NSAttributedString(attachment: diningImageAttachment)
        // Initialize mutable string
        let diningText = NSMutableAttributedString(string: "")
        // Add image to mutable string
        diningText.size()
        diningText.append(diningAttachmentString)
        // Add your text to mutable string
        let diningTextAfterIcon = NSAttributedString(string:" " + String(describing: User.globalUser.dining_points!) + "  ")
        diningText.append(diningTextAfterIcon)
        
        let diningLabel = UILabel()
        diningLabel.backgroundColor = UIColor(red: 0.05, green: 0.08, blue: 0.23, alpha: 1.00)
        diningLabel.layer.masksToBounds = true
        diningLabel.layer.cornerRadius = 10
        diningLabel.adjustsFontSizeToFitWidth = (true)
        diningLabel.textColor = UIColor.white
        diningLabel.textAlignment = .left
        diningLabel.attributedText = diningText
        diningLabel.layoutMargins = UIEdgeInsets(top: 0, left: 1, bottom: 5, right: 0)
        
        let stackView = UIStackView(arrangedSubviews: [athleticsLabel, diningLabel])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.setCustomSpacing(1, after: athleticsLabel)
        stackView.setCustomSpacing(2, after: diningLabel)
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
        return stackView
    }
           
    // gets all users for rankings table
    func fetchData(filter: String, date: String, ongoing: Bool) {
        guard let url = URL(string: Bundle.main.object(forInfoDictionaryKey: "NetworkURL") as! String + "/users.json") else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data, error == nil else {
                print(error?.localizedDescription ?? "Response Error")
                self.stopRefresh?()
                return }
            let decoder = JSONDecoder()
            do{             //here dataResponse received from a network request
                
                let decodedUsers = try decoder.decode(Users.self, from: dataResponse)
                for item in decodedUsers {
                    self.data.append(item)
                }
                self.data.sort(by: {$0.accumulated_total_points ?? 0 > $1.accumulated_total_points ?? 0 })
                
                //let sortedFriends = users.sorted(by: { $0.total_points > $1.total_points })
                //print(decodedUsers[0].name)
                //print(decodedUsers[1].name)
                
                DispatchQueue.main.async { // in other managers, we didn't need a DispatchQueue because the network manager made that call with completion(json)
                    // We need this call in order to change UI and get the main thread to this point
                    self.reloadData?(self.data)
                    // self.profileData?(self.data) // seems like closure can be called even when not defined. Nothing happens in that case
                }
            }
            catch let parsingError {
                print("Error", parsingError)
                self.stopRefresh?()
            }
        }
        task.resume()
    }
    
    // only gets the current user's info, for profile
    func getUser(completion:@escaping (User) -> ()){
        let url = Bundle.main.object(forInfoDictionaryKey: "NetworkURL") as! String + "/users/\(User.globalUser.id).json"
        NetworkManager.getData(specific_url: url){ jsonData in
            let decoder = JSONDecoder()
            do{
                let decodedUser = try decoder.decode(User.self, from: jsonData)
                DispatchQueue.main.async {
                    completion(decodedUser)
                }
            }catch let parsingError {
                print("Error in getUser of UserManager", parsingError)
            }
        }
    }
    
    func uploadUser(completion:@escaping ([String:Any]) -> ()){
        var data = Data()
        do{
            data = try JSONEncoder().encode(User.globalUser)
        }catch{
            print("Error encoding user data in setUpProfileVC")
        }
        
        let u = Bundle.main.object(forInfoDictionaryKey: "NetworkURL") as! String + "/usersMobile"
        NetworkManager.uploadData(uploadData: data, specific_url: u, httpMethod: "PATCH") {responseData in
            //print("Response Data:")
            //print(responseData)
            DispatchQueue.main.async {
                completion(responseData)
            }
        }
    }
    
    func uniqueUsername(completion: @escaping (String) -> ()){
        let networkURL = Bundle.main.object(forInfoDictionaryKey: "NetworkURL") as! String
        let spec_url = "\(networkURL)/uniqueUsername?username=\(User.globalUser.username)"
        NetworkManager.getJSON(specific_url: spec_url){ jsonData in
            if let status = jsonData["status"] as? String{
                completion(status)
            }
        }
    }
    

    func getRewards(){
        let networkURL = Bundle.main.object(forInfoDictionaryKey: "NetworkURL") as! String
        let spec_url = "\(networkURL)/userRewards?netid=\(User.globalUser.netid!)"
        var redeemedRewards: [Int] = []
        NetworkManager.getJSON(specific_url: spec_url) {jsonData in // closure. Body of the completion function parameter
            if let userRewards = jsonData["data"] as? Array<Dictionary<String,Any>>{
                for reward in userRewards {
                    if let id = reward["id"] as? Int{
                        redeemedRewards.append(id)
                        // used to append reward["id"] as? Int ?? -1, but then it's possible that there are a bunch of -1 in the array for no reason
                    }
                }
            }
            self.updateRewards?(redeemedRewards)
        }
    }
}
    
    


    
    



