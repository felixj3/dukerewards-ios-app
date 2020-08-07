//
//  RewardViewController.swift
//  DukeRewards
//
//  Created by Kyra Chan on 6/4/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit

class RewardViewController: UIViewController {
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var rewardImage: UIImageView!
    @IBOutlet weak var rewardName: UILabel!
    @IBOutlet weak var rewardTime: UILabel!
    @IBOutlet weak var rewardExpiration: UILabel!
    @IBOutlet weak var rewardDescription: UILabel!
    @IBOutlet weak var redeemButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    var reward: Reward?
    let dateFormatterPrint = DateFormatter()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatterPrint.dateFormat = "MMM/dd/YYYY h:mma"
        // Do any additional setup after loading the view.
        rewardName?.text = reward?.name ?? "NA"
        
        if User.globalUser.favoriteArray.contains(reward!.id) {
            favoriteButton.isSelected = true
        }
        
        if let safeTime = reward?.time {
            rewardTime?.text = "Time: \(dateFormatterPrint.string(from: safeTime))"
        } else {
            rewardTime?.text = "Time: NA"
        }
        
        rewardExpiration?.text = "Expired: \(reward?.location ?? "NA")"
        rewardDescription?.text = reward?.description ?? "NA"
        // rewardImage?.image = UIImage(named: reward?.image ?? "defaultImage")
        NetworkManager.getRewardImageFromURL(url: reward?.image ?? "error"){image in
            self.rewardImage.image = image
        }
        redeemButton.layer.cornerRadius = 8
        rewardDescription.sizeToFit()
        let value = 250 + Float(rewardName.frame.size.height +
            rewardTime.frame.size.height +
            rewardExpiration.frame.size.height +
            rewardDescription.frame.size.height) + 300
        containerHeight.constant = CGFloat(value)
        createPointsLabel()
        if User.globalUser.rewards!.contains(reward!.id) {
             redeemButton.setTitle("Redeemed", for: .normal)
             redeemButton.backgroundColor = UIColor.systemGray
             redeemButton.isEnabled = false
        }
        else{
            redeemButton.setAttributedTitle(LayoutLibraryViewController.getCoinImageAttachment(category: reward!.category ?? "dining", phrase: "Redeem for \(reward!.points) "), for: .normal)
            // redeemButton.setTitle("Redeem for \(reward!.points)", for: .normal)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        defaults.set(User.globalUser.favoriteArray, forKey: "bookmarkReward")
    }
    
    func createPointsLabel() {
        let rightBarButton = UIBarButtonItem(customView: UserManager.createPointsLabel())
        navBar.rightBarButtonItem = rightBarButton
    }
    
    @IBAction func didTapRedeem(_ sender: Any) {
        createAlert(title: "Confirm Redemption", message: "Are you sure you want to redeem the reward \(rewardName.text!) for \(reward!.points) points?") { () in // closure is only called if user selects "confirm"
            
            var canRedeem: Bool = false
            if(self.reward?.category?.lowercased() == "athletics"){
                if((self.reward?.points)! <= User.globalUser.athletics_points!){
                    canRedeem = true
                }
            }
            else if(self.reward?.category?.lowercased() == "dining"){
                if((self.reward?.points)! <= User.globalUser.dining_points!){
                    canRedeem = true
                }
            }
            
            if(!canRedeem){
                // not enough points to redeem reward
                let alert = UIAlertController(title: "Not Enough Points", message: "Sorry, you do not have enough points to redeem this reward", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
                    alert.dismiss(animated: true, completion: nil)
                }))
                
                self.present(alert, animated: true, completion: nil)}
            else{
                // decrease amount of points that user has
                
                // make call to web app to decrease quantity of reward, provide user netID, AND decrease User points
                var data = Data()
                do{
                    data = try JSONEncoder().encode(User.globalUser)
                    print("here")
                    print(data)
                }catch{
                    print("Error encoding user data in rewardVC")
                }
                // print(String(data: data, encoding: .utf8)!)
                // replace userID=abcd123 with "userID=" + User.netID
                // let u = "http://localhost:3000/rewards/2?userID=abc123"
                
                let u = Bundle.main.object(forInfoDictionaryKey: "NetworkURL") as! String + "/redeem/\(self.reward!.id)"
                NetworkManager.uploadData(uploadData: data, specific_url: u, httpMethod: "PATCH") {responseData in
                    print("Response Data:")
                    print(responseData)
                    // update user points here
                    // if user already redeemed reward, notify with an alert
                    let status = responseData["status"] as? String ?? "ERROR"
                    if(status == "ERROR"){
                        let alert = UIAlertController(title: "Error Redeeming Reward", message: "Sorry, there was an error while redeeming the reward", preferredStyle: UIAlertController.Style.alert)
                        
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
                            alert.dismiss(animated: true, completion: nil)
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
                    }else if(status == "REPEAT"){
                        
                            let alert = UIAlertController(title: "Already Redeemed Reward", message: "You have already redeemed this reward", preferredStyle: UIAlertController.Style.alert)
                            
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
                                alert.dismiss(animated: true, completion: nil)
                            }))
                            
                            self.present(alert, animated: true, completion: nil)
                    }
                    else{
                        if let user = responseData["data"] as? Dictionary<String,Any>{
                            User.globalUser.athletics_points = user["athletics_points"] as? Int ?? User.globalUser.athletics_points
                            User.globalUser.dining_points = user["dining_points"] as? Int ?? User.globalUser.dining_points

                            if let rewardUpdate = responseData["reward"] as? Dictionary<String,Any>{
                                self.reward?.expiry_quantity = rewardUpdate["expiry_quantity"] as? Int ?? self.reward?.expiry_quantity
                                self.createPointsLabel()
                                let alert = UIAlertController(title: "Congratulations!", message: "Check your email soon for additional information about your reward", preferredStyle: UIAlertController.Style.alert)

                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
                                    alert.dismiss(animated: true, completion: nil)
                                }))
                                self.present(alert, animated: true, completion: nil)
                                self.redeemButton.setTitle("Redeemed", for: .normal)
                                self.redeemButton.backgroundColor = UIColor.systemGray
                                self.redeemButton.isEnabled = false
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func favoriteButtonPressed(_ sender: Any) {
        if let index = User.globalUser.favoriteArray.firstIndex(of: reward!.id) {
            User.globalUser.favoriteArray.remove(at: index)
        } else {
            User.globalUser.favoriteArray.append(reward!.id)
        }
        favoriteButton.isSelected = !favoriteButton.isSelected
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // very generic set up for an alert, in case others want to just copy this code and add it to their VC
    func createAlert(title:String, message:String, completion:@escaping () -> Void)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        // add option on button
        alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: { (action) in
            // Handler closure is called once this option is clicked I assume?
            alert.dismiss(animated: true, completion: nil)
            completion() // if selected "confirm", handle it with this closure
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
