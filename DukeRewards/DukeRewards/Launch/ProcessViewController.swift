//
//  ProcessViewController.swift
//  DukeRewards
//
//  Created by Kyra Chan on 6/5/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit
import DukeOAuth
import WebKit

class ProcessViewController: UIViewController {
    // Storyboard connection to Login button
    @IBOutlet var loginButton: UIButton!
    
    // Get an instance of the OAuth Service
    var oAuthService: OAuthService?
    var webView: WKWebView?
    let AUTH_HEADER = "Authorization"
    var tokenBack: ((String) -> ())?

    
    override func viewDidLoad() {
        // Load the instance of the OAuth service
        oAuthService = OAuthService.shared
        // Determine if user has received an OAuth token (can be nil)
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
        loginButton.layer.cornerRadius = 8
        // OAuthService.shared.setClientName(oAuthClientName: "dukerewards")
    }
    
    var onboardVC: OnboardingViewController?
    
    override func viewWillAppear(_ animated: Bool) {
        onboardVC = self.presentingViewController as? OnboardingViewController
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        // Set the OAuth service name for the client to use when requesting an OAuth token or logging out
        //oAuthService?.setClientName(oAuthClientName: "dukeeventattendance")
        // Determine if user has received an OAuth token (cannot be nil)
        print("LOGIN BUTTON PRESSED")
               if oAuthService!.isAuthenticated() {
                   print ("Login")
                // Request a new OAuth token when current token is expired
                   oAuthService?.refreshToken(navController: self.navigationController!) { success, statusCode in
                       if success {
                           print ("SUCCESS")
                        // Load WebView View Controller with NetID Login
                           DispatchQueue.main.async {
//                               let tabVC = self.storyboard?.instantiateViewController(withIdentifier: "mainMenu") as? UITabBarController
//                               self.present(tabVC!, animated: true, completion: nil)
                            self.dismiss(animated: true, completion: nil)
                            self.onboardVC?.tokenBack(token: (self.oAuthService?.getAccessToken())!)
                           }
                       }
                   }
               }
               else if let navController = self.navigationController {
                print ("Log in")
                // Allow user to login with NetID, receive an OAuth token, and store this token on device's keychain
                   oAuthService?.authenticate(navController: navController) {success in
                       if success {
                           print ("LOGIN SUCCESS")
                        // Load WebView View Controller with NetID Login
                           DispatchQueue.main.async {
//                               let tabVC = self.storyboard?.instantiateViewController(withIdentifier: "mainMenu") as? UITabBarController
//                               self.present(tabVC!, animated: false, completion: nil)
                            self.dismiss(animated: true, completion: nil)
                            self.onboardVC?.tokenBack(token: (self.oAuthService?.getAccessToken())!)
                           }
                        
                       } else {
                           print ("LOGIN FAILED")
                       }
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
