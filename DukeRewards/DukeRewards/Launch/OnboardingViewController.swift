//
//  OnboardingViewController.swift
//  DukeRewards
//
//  Created by Kyra Chan on 6/5/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit
import DukeOAuth
import WebKit

class OnboardingViewController: UIViewController {
    
    @IBOutlet var getStartedButton: UIButton!
    var oAuthService: OAuthService?
    var webView: WKWebView?
    var window: UIWindow?
    var userManager = UserManager()
    
    //var oAuthService: OAuthService?
    //var webView: WKWebView?
    @IBOutlet var welcomeLabel: UILabel!
    @IBOutlet var dukeRewardsLabel: UILabel!
    @IBOutlet var furtherDescriptionLabel: UILabel!
    

      typealias Users = [User]
      var users = [User]()
    
    override func viewDidLoad() {
            super.viewDidLoad()
        OAuthService.shared.setClientName(oAuthClientName: "dukerewards")

        oAuthService = OAuthService.shared
        // Do any additional setup after loading the view.
        getStartedButton.layer.cornerRadius = 8
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        // no more constraint error messages
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if ((oAuthService?.isAuthenticated())!) {
            print("Already Logged In")
//            getStartedButton.removeFromSuperview()
//            welcomeLabel.removeFromSuperview()
//
//            dukeRewardsLabel.removeFromSuperview()
//            furtherDescriptionLabel.removeFromSuperview()
            
            getStartedButton.isHidden = true
            welcomeLabel.isHidden = true
            dukeRewardsLabel.isHidden = true
            furtherDescriptionLabel.isHidden = true
            
            // Load WebView View Controller with NetID Login
            
            uploadToken(token: (oAuthService?.getAccessToken())!)
        } else{
            print("Not logged in")
            // No need to call uploadToken here because get started buton does it
            
            getStartedButton.isHidden = false
            welcomeLabel.isHidden = false
            dukeRewardsLabel.isHidden = false
            furtherDescriptionLabel.isHidden = false
            
            /*
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc: ProcessViewController = storyboard.instantiateViewController(identifier: "ProcessViewController") as! ProcessViewController
            let navigationController = UINavigationController(rootViewController: vc)
            self.present(navigationController, animated: true, completion: nil)
            */
            
            //let feedVC = (self.storyboard?.instantiateViewController(withIdentifier: "onboarding")) as! OnboardingViewController
            //self.present(feedVC, animated: true, completion: nil
            
        }
    }
    
    var onboardingPageViewController: OnboardingPageViewController?
    @IBAction func getStartedAction(_ sender: Any) {
        onboardingPageViewController = self.storyboard?.instantiateViewController(withIdentifier: "onboardingPageView") as? OnboardingPageViewController
        onboardingPageViewController?.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(onboardingPageViewController!, animated: true, completion: nil)
        
//        feedVC = self.storyboard?.instantiateViewController(withIdentifier: "navController") as? UINavigationController
//        feedVC!.modalPresentationStyle = UIModalPresentationStyle.fullScreen
//        feedVC?.navigationBar.isHidden = true
//        self.present(feedVC!, animated: true, completion: nil)
//        if let process = feedVC!.viewControllers.first as? ProcessViewController{
//            process.tokenBack = { token in
//                self.uploadToken(token: token)
//            }
//        }

    }
    
    func tokenBack(token: String){
        onboardingPageViewController?.dismiss(animated: true, completion: nil)
        uploadToken(token: token)
    }
    
    func loadMainMenu(_ badConnection: Bool, _ firstTime: Bool){
        let tabVC = self.storyboard?.instantiateViewController(withIdentifier: "mainMenu") as? UITabBarController
        self.present(tabVC!, animated: true, completion: nil)
        
        let earnVC = tabVC?.viewControllers?[1]
        
        if(badConnection){
            let alert = UIAlertController(title: "Bad Connection", message: "Your data did not load correctly. Please check internet connection for full functionality", preferredStyle: UIAlertController.Style.alert)
            
            // add option on button
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            earnVC?.present(alert, animated: true, completion: nil)
        }
        
        if(!firstTime){
            if let earnVCNav = earnVC as? UINavigationController, let earn = earnVCNav.viewControllers.first as? EarnViewController{
                earn.loadTutorial = false
            }
        }
        
    }
    
    func uploadToken(token: String){
        NetworkManager.uploadToken(token: token, failToConnect: {self.loadMainMenu(true, true)}){ jsonData in
            if let userData = jsonData["data"] as? Dictionary<String,Any>{
                //print(userData)
                
                if let netid = userData["netid"] as? String{
                    User.globalUser.netid = netid
                }else{
                    print("DID NOT RECEIVE NETID")
                }
                
                User.globalUser.name = userData["name"] as? String ?? ""
                User.globalUser.username = userData["username"] as? String ?? ""
                User.globalUser.profile_pic = userData["profile_pic"] as? String ?? ""
                User.globalUser.accumulated_total_points = userData["accumulated_total_points"] as? Int ?? 0
                User.globalUser.athletics_points = userData["athletics_points"] as? Int ?? 0
                User.globalUser.dining_points = userData["dining_points"] as? Int ?? 0
                User.globalUser.email = userData["email"] as? String ?? ""
                User.globalUser.accumulated_athletics_points = userData["accumulated_athletics_points"] as? Int ?? 0
                User.globalUser.accumulated_dining_points = userData["accumulated_dining_points"] as? Int ?? 0
                User.globalUser.id = userData["id"] as? Int ?? 0
                User.globalUser.primary_affiliation = userData["primary_affiliation"] as? String ?? ""
                // Make check for grouper here
                if(User.globalUser.primary_affiliation != "Student" && User.globalUser.primary_affiliation != ""){
                    User.globalUser.adminEnabled = true
                    // only place this value is set to true on launch
                }
                
                if let exists = jsonData["exists"] as? Bool{
                    print("Does the user exist: \(exists)")
                    // do logic of loading user/set up profile in the completion function
                    // data is user's data, bool is boolean if they exist or not
                    // data will ALWAYS include their netid, regardless if they have a duke rewards account or not
                    
                    if (exists){
                        // User.globalUser = we gotta parse data in order to set user values

                        // gets a list of the user's redeemed rewards
                        self.userManager.updateRewards = {array in
                            User.globalUser.rewards = array
                        }
                        self.userManager.getRewards()
                        self.loadMainMenu(false, false)
                    }
                    else{
                        // go to setup vc
                        guard let setUpProfileViewController = self.storyboard?.instantiateViewController(withIdentifier: "setUpProfile") as? SetUpProfileViewController else { return }
                        setUpProfileViewController.dismissVC = {
                            self.loadMainMenu(false, true)
                        }
                        setUpProfileViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                        self.present(setUpProfileViewController, animated: true)
                    }
                }
            }else{
                print("Onboarding VC Error parsing user data")
                self.loadMainMenu(true, true)
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
