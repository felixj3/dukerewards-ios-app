//
//  SettingsViewController.swift
//  DukeRewards
//
//  Created by codeplus on 6/8/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit
import DukeOAuth

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    var oAuthService: OAuthService?
    
    @IBOutlet weak var logOutButton: UIButton!
    let data: [String] = ["Push Notifications", "Privacy"]
    
    let cellSpacingHeight:CGFloat = 10
    
    func setUpTableView() {
        self.settingsMenu.delegate = self
        self.settingsMenu.dataSource = self
        self.settingsMenu.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.settingsMenu.backgroundColor = UIColor(red: 0.93, green: 0.94, blue: 0.96, alpha: 1.00)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingsMenu.dequeueReusableCell(withIdentifier: "cellReuseIdentifier") as! SettingsMenuViewCell
        
                
        cell.pushLabel.text = data[indexPath.row]
        
        return cell
    }
   

    @IBOutlet weak var settingsMenu: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            settingsMenu.dataSource = self
        settingsMenu.delegate = self
        
        settingsMenu.tableFooterView = UIView()
        logOutButton.layer.cornerRadius = 8

        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let segueIdentifier: String
        switch indexPath.row {
            case 0:
            segueIdentifier = "setToPush"

            default:
            segueIdentifier = "setToPrivacy"
        }
        self.performSegue(withIdentifier: segueIdentifier, sender: self)
        }
    
    
    
    @IBAction func logOut(_ sender: Any) {
        oAuthService = OAuthService.shared
        // Remove OAuth token from keychain
        oAuthService?.logout()
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)

        let feedVC = self.storyboard?.instantiateViewController(withIdentifier: "onboarding") as? OnboardingViewController
        // self.present(feedVC!, animated: true, completion: nil)
        
        //self.tabBarController?.dismiss(animated: true, completion: nil)
        //self.tabBarController?.view = nil
        
        // dismisses all view controllers except the rootViewController
        // could add code here to set it to the log in page if needed

    }
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
