//
//  AdminViewController.swift
//  DukeRewards
//
//  Created by codeplus on 7/6/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit

// THIS VIEW CONTROLLER is not currently being used, but future features may require an extended admin view controller

class AdminViewController: UIViewController {

    @IBOutlet weak var enableAdmin: UIButton!
    @IBOutlet weak var message: UILabel!
    var grouper: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // check grouper somehow
        
        if(grouper){
            message.text = "Welcome"
        }
        else{
            message.text = "You do not have admin access!"
        }
        buttonText()
    }
    
    func buttonText(){
        if(User.globalUser.adminEnabled!){
            enableAdmin.setTitle("Disable Admin", for: .normal)
        }else{
            enableAdmin.setTitle("Enable Admin", for: .normal)
        }
    }
    
    @IBAction func enableAdminPressed(_ sender: Any) {
        User.globalUser.flip()
        // flips the boolean value for admin enabled
        buttonText()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
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
