//
//  SetUpProfileViewController.swift
//  DukeRewards
//
//  Created by Kyra Chan on 6/30/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit

class SetUpProfileViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    //declare variables

    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var netidField: UITextField!
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var emailField: UITextField!

    @IBOutlet weak var profileImage: UIImageView!
    
       var nameNew:String?
       var netidNew:String?
       var usernameNew:String?
       var emailNew:String?
       var newPic: UIImage!
    var dismissVC: (() -> ())?
    
    @IBOutlet weak var createAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = self
        netidField.delegate = self
        usernameField.delegate = self
        emailField.delegate = self
        
        nameField?.text = User.globalUser.name
        netidField?.text = User.globalUser.netid
        usernameField?.text = User.globalUser.username
        emailField?.text = User.globalUser.email
        profileImage?.image = UIImage(named: "default_profile")
        
        
        createAccountButton.layer.cornerRadius = 8
        
        //make keyboard popup after clicking edit
        nameField.becomeFirstResponder()
        
        //makes profile picture circular
        profileImage.layer.cornerRadius = profileImage.frame.size.height/2
        profileImage.clipsToBounds = true

        // Do any additional setup after loading the view.
        
        // App notification that alerts app when keyboard shows/hides
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification){
        guard let userInfo = notification.userInfo else {return} // gives info on user specs, we need the keyboard height
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        if self.view.frame.origin.y == 0{
            self.view.frame.origin.y -= keyboardFrame.height // raises view, somehow it's animated with keyboard raise
        }
    }
    @objc func keyboardWillHide(notification: NSNotification){
        if self.view.frame.origin.y != 0{
            self.view.frame.origin.y = 0 // sets view back to normal
        }
    }
 
    @IBAction func createAccount(_ sender: Any) {
        User.globalUser.setUsername(usernameField?.text ?? "")
        User.globalUser.setEmail(emailField?.text ?? "")
        User.globalUser.profile_pic = profileImage.image?.toString()
        profileImage.image = newPic
        
//        UserManager().uploadUser(){
//            self.dismiss(animated: true, completion: nil)
//            self.dismissVC?()
//        }
        handleUniqueUsername()
    }
    
    func handleUniqueUsername(){
        UserManager().uniqueUsername{ status in
            if status == "SUCCESS"{
                UserManager().uploadUser(){ responseData in
                    self.dismiss(animated: true, completion: nil)
                    self.dismissVC?()
                }
            }else{
                let alert = UIAlertController(title: "Username Already Taken", message: "\"\(User.globalUser.username)\" is already taken. Please choose another option", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(action) in
                    alert.dismiss(animated: true, completion: { () in self.usernameField.becomeFirstResponder()})
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameField.resignFirstResponder()
        netidField.resignFirstResponder()
        usernameField.resignFirstResponder()
        emailField.resignFirstResponder()
        return true
    }
    
//    func alertUserSetup() {
//            var textFieldName = UITextField()
//            var textFieldUsername = UITextField()
//            let alert = UIAlertController(title: "Please set up your profile.", message:"Your email and full name will be used when redeeming rewards. Your username might be appearing on leader board. ", preferredStyle: .alert)
//            let action = UIAlertAction(title:"Done", style: .default) { (action) in
//                self.defaults.set(textFieldName.text, forKey: "Name")
//                self.defaults.set(textFieldUsername.text, forKey: "Username")
//            }
//            alert.addTextField { (alertTextField) in
//                alertTextField.placeholder = "Enter your full name."
//                alertTextField.addTarget(alert, action: #selector(alert.textDidChange), for: .editingChanged)
//                textFieldName = alertTextField
//            }
//            alert.addTextField { (alertTextField) in
//                alertTextField.placeholder = "Enter your username. e.g. blue devils"
//                alertTextField.addTarget(alert, action: #selector(alert.textDidChange), for: .editingChanged)
//                textFieldUsername = alertTextField
//            }
//
//            action.isEnabled = false
//            alert.addAction(action)
//            present(alert, animated: true, completion: nil)
//        }
//
//    }
//    extension UIAlertController {
//        func isValidName(_ name: String) -> Bool {
//            return (name.count > 0)
//        }
//        @objc func textDidChange() {
//            if let name = textFields?[0].text,
//                let username = textFields?[1].text,
//                let action = actions.last {
//                action.isEnabled = isValidName(name) && isValidName(username)
//            }
//        }
//    }
    
    
     // dismisses keyboard when user touches blank spot on screen
    // TODO: Change the connection, although there is no "Done" button for this page now, unlike for the edit profile page
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func uploadPhoto(_ sender: Any) {
            let picker = UIImagePickerController()
            picker.allowsEditing = true
            picker.delegate = self
            present(picker, animated: true)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let newPic = info[.editedImage] as? UIImage else { return }

        dismiss(animated: true)

        profileImage.image  = newPic
    }
}
