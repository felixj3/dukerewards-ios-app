//
//  ProfileEditor2ViewController.swift
//  DukeRewards
//
//  Created by codeplus on 6/8/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit


class ProfileEditor2ViewController: UIViewController, UITextFieldDelegate {

    
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var netidField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var mobileField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    
    
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        nameField.isUserInteractionEnabled = true;
        netidField.isUserInteractionEnabled = true;
        usernameField.isUserInteractionEnabled = true;
        mobileField.isUserInteractionEnabled = true;
        emailField.isUserInteractionEnabled = true;
    }
    
    
    @IBAction func nameFieldDone(_ sender: Any) {
        resignFirstResponder()
    }
    
    @IBAction func netidFieldDone(_ sender: Any) {
        resignFirstResponder()
    }
    
    @IBAction func usernameFieldDone(_ sender: Any) {
        resignFirstResponder()
    }
    @IBAction func emailFieldDone(_ sender: Any) {
        resignFirstResponder()
    }
    
    @IBAction func mobileFieldDone(_
        sender: Any) {
        resignFirstResponder()
    }
    
    override func viewDidLoad() {
           super.viewDidLoad()
           
           //makes profile picture circular
           profilePicture.layer.cornerRadius = profilePicture.frame.size.height/2
           profilePicture.clipsToBounds = true
        
            
               
    }
}
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: Selector("editTableView"))
        
    
//    func editTableView()
//     {
//        if self.navigationItem.rightBarButtonItem?.title == "Edit"
//        {
//            self.navigationItem.rightBarButtonItem?.title = "Done"
//               nameField.isUserInteractionEnabled = true;
//                netidField.isUserInteractionEnabled = true;
//                 usernameField.isUserInteractionEnabled = true;
//                  mobileField.isUserInteractionEnabled = true;
//                 emailField.isUserInteractionEnabled = true;
//
//        }
//
//        else
//        {
//            self.navigationItem.rightBarButtonItem?.title = "Edit"
//            //when youre finishing editing
//            nameField.isUserInteractionEnabled = false;
//                          netidField.isUserInteractionEnabled = false;
//                          usernameField.isUserInteractionEnabled = false;
//                            mobileField.isUserInteractionEnabled = false;
//                            emailField.isUserInteractionEnabled = false;
//        }
//       }

//    }
    
   
    
    
        
    
    
    
    
//}

  

     
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    

