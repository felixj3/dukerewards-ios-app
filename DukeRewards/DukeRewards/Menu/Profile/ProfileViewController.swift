//
//  ProfileViewController.swift
//  DukeRewards
//
//  Created by codeplus on 6/8/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit



class ProfileViewController: UIViewController, EditViewControllerDelegate {
    
    //let userManager = UserManager()
    
    //var userData = [User]()
    
    
    //declare variables
    
    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var netidLabel: UILabel!

    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var userLabel: UILabel!
    
    
    //let currUser = User.init(name: "Vincent Price", username: "vincentprice20", profile_pic:"https://image.blockbusterbd.net/00416_main_image_04072019225805.png", total_points: 100, athletics_points: 60, dining_points: 40, netid: "vp20", email: "vp20@duke.edu" )
    
    let userManager = UserManager()
  
    typealias Users = [User]
    var users = [User]()

    
    let defaults = UserDefaults.standard // create the userDefaults object

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        userManager.profileData = { data in
//            for user in data{
//
//                // find the user we are looking for by netid
//                // might be kind of slow if there are a bunch of users
//                //need to pass current user netid
//                if(user.netid == User.globalUser.netid){
//                    User.globalUser.name = user.name
//                    User.globalUser.username = user.username
//                    User.globalUser.profile_pic = user.profile_pic
//                    User.globalUser.accumulated_total_points = user.accumulated_total_points
//                    User.globalUser.athletics_points = user.athletics_points
//                    User.globalUser.dining_points = user.dining_points
//                    User.globalUser.netid = user.netid
//                    User.globalUser.email = user.email
//                    User.globalUser.accumulated_athletics_points = user.accumulated_athletics_points
//                    User.globalUser.accumulated_dining_points = user.accumulated_dining_points
//                    User.globalUser.primary_affiliation = user.primary_affiliation
//
//                }
//            }
//
//            if User.globalUser.profile_pic == nil {
//                self.profilePicture.image = UIImage(named: "default_profile")
//                       }
//
//            if User.globalUser.profile_pic != nil {
//                                     self.profilePicture.image = User.globalUser.profile_pic?.toImage()
//                                 }
//
//            self.nameLabel?.text = User.globalUser.name
//            self.usernameLabel?.text = User.globalUser.username
//            self.profilePicture.image = User.globalUser.profile_pic?.toImage()
//            self.netidLabel?.text = User.globalUser.netid
//            self.emailLabel?.text = User.globalUser.email
//            self.userLabel?.text = User.globalUser.primary_affiliation
//        }
//        userManager.callFetchData()
        
        userManager.getUser(completion: { user in
            User.globalUser.name = user.name
            User.globalUser.username = user.username
            User.globalUser.profile_pic = user.profile_pic
            User.globalUser.accumulated_total_points = user.accumulated_total_points
            User.globalUser.athletics_points = user.athletics_points
            User.globalUser.dining_points = user.dining_points
            User.globalUser.netid = user.netid
            User.globalUser.email = user.email
            User.globalUser.accumulated_athletics_points = user.accumulated_athletics_points
            User.globalUser.accumulated_dining_points = user.accumulated_dining_points
            User.globalUser.primary_affiliation = user.primary_affiliation
            
            if User.globalUser.profile_pic == nil {
                self.profilePicture.image = UIImage(named: "default_profile")
            }else{
                self.profilePicture.image = User.globalUser.profile_pic?.toImage()
            }
            self.nameLabel?.text = User.globalUser.name
            self.usernameLabel?.text = User.globalUser.username
            self.profilePicture.image = User.globalUser.profile_pic?.toImage()
            self.netidLabel?.text = User.globalUser.netid
            self.emailLabel?.text = User.globalUser.email
            self.userLabel?.text = User.globalUser.primary_affiliation
        })
        
        //make circular pic
        profilePicture.layer.cornerRadius = profilePicture.frame.size.height/2
        profilePicture.clipsToBounds = true
        
      
    }
    
    func setImage(from url: String) {
          guard let imageURL = URL(string: url) else { return }

              // just not to cause a deadlock in UI!
          DispatchQueue.global().async {
              guard let imageData = try? Data(contentsOf: imageURL) else { return }

              let image = UIImage(data: imageData)
              DispatchQueue.main.async {
                  self.profilePicture.image = image
              }
          }
      }
    
    
//
    
    // dismisses this view controller, takes user back to tab they were on when they clicked the menu
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "ProfileVCToEditVC"){
            let editVC = segue.destination as! EditViewController
            editVC.delegate = self
            editVC.nameNew = nameLabel.text
            editVC.netidNew = netidLabel.text
            editVC.usernameNew = usernameLabel.text
            editVC.emailNew = emailLabel.text
            editVC.newPic = profilePicture.image
        
        }
    }
    
    func doSomethingWith(name: String?, netid: String?, username: String?, email: String?, pic: UIImage?) {
         // Do something here after receiving data from destination view controller (Edit VC)
        // set the labels to whatever edit VC changed them to
        nameLabel?.text = name
        netidLabel?.text = netid
        usernameLabel?.text = username
        defaults.set(username, forKey: "username")
        // set user defaults value after user edited it
        emailLabel?.text = email
        //defaults.set(email, forKey: "email")
        profilePicture.image = pic
       
       
    }
    
    
    
    
}
