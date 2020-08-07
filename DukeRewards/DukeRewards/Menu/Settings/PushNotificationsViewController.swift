//
//  PushNotificationsViewController.swift
//  DukeRewards
//
//  Created by codeplus on 6/9/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit

class PushNotificationsViewController: UIViewController {

    @IBOutlet weak var pushNotificationsSwitch: UISwitch!
    
    @IBOutlet weak var announcementSwitch: UISwitch!
    
    
    @IBOutlet weak var eventSwitch: UISwitch!
    
    @IBOutlet weak var rewardSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func receiveOn(_ sender: Any) {
       
        if pushNotificationsSwitch.isOn{
            announcementSwitch.setOn(true, animated: true)
            announcementSwitch.isEnabled = true
            
            eventSwitch.setOn(true, animated: true)
            eventSwitch.isEnabled = true
          
            rewardSwitch.setOn(true, animated: true)
            rewardSwitch.isEnabled = true
            
        }
        else {
            pushNotificationsSwitch.setOn(false, animated: true)
            announcementSwitch.isEnabled = false
            announcementSwitch.setOn(false, animated: true)
            eventSwitch.isEnabled = false
            eventSwitch.setOn(false, animated: true)
            rewardSwitch.isEnabled = false
            rewardSwitch.setOn(false, animated: true)
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
