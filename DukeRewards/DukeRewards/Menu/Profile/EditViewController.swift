//
//  EditViewController.swift
//  DukeRewards
//
//  Created by codeplus on 6/8/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit

// in order to pass data back to ProfileVC as this VC is dismissed
// This is the Delegate Concept and Protocol used by Apple Cocoa Library
protocol EditViewControllerDelegate : NSObjectProtocol{
    func doSomethingWith(name: String?, netid: String?, username: String?, email: String?, pic: UIImage?)
}

extension UIImage {
    func toString() -> String? {
        let data: Data? = self.jpegData(compressionQuality: 0.8)
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
}

extension String {
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
}

class EditViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    //declare variables
    
    let userManager = UserManager()
    
    // for passing data back to profile
    weak var delegate : EditViewControllerDelegate?

    @IBOutlet weak var userLabel: UILabel!
    
    @IBOutlet weak var nameField2: UITextField!
    
    @IBOutlet weak var netidField2: UITextField!
    
    @IBOutlet weak var usernameField2: UITextField!
    
    @IBOutlet weak var emailField2: UITextField!

    @IBOutlet weak var profilePicture: UIImageView!
    
    
       var nameNew:String?
       var netidNew:String?
       var usernameNew:String?
       var emailNew:String?
       var newPic: UIImage!
    
       
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField2.delegate = self
        netidField2.delegate = self
        usernameField2.delegate = self
        emailField2.delegate = self
        
        
        
      
        
    
        
        // the "new" fields allow information from profile to be passed into Edit VC
        nameField2?.text = nameNew
        netidField2?.text = netidNew
        usernameField2?.text = usernameNew
        emailField2?.text = emailNew
        profilePicture.image = newPic
       
        
        
        //make keyboard popup after clicking edit
        nameField2.becomeFirstResponder()
        
        
        
        //makes profile picture circular
        profilePicture.layer.cornerRadius = profilePicture.frame.size.height/2
        profilePicture.clipsToBounds = true

        // Do any additional setup after loading the view.
        
        userLabel.text = User.globalUser.primary_affiliation
    }
    
 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameField2.resignFirstResponder()
        netidField2.resignFirstResponder()
        usernameField2.resignFirstResponder()
        emailField2.resignFirstResponder()
        
        
        return true
    }
    
    
    // when user clicks done at top right of page
    @IBAction func doneEditing(_ sender: Any) {
//        if let delegate = delegate{
//            // doSomethingWith passes data from Edit VC back to Profile VC
//            delegate.doSomethingWith(name: nameField2.text, netid: netidField2.text, username: usernameField2.text, email: emailField2.text, pic: profilePicture.image)
//
//        }
        
        User.globalUser.name = nameField2.text ?? ""
        User.globalUser.email = emailField2.text ?? ""
        User.globalUser.username = usernameField2.text ?? ""
        User.globalUser.profile_pic = profilePicture.image?.toString()
        
//        self.dismiss(animated: true, completion: nil)
//
//        var data = Data()
//        do{
//            data = try JSONEncoder().encode(User.globalUser)
//            print("here")
//
//            //print(data)
//        }catch{
//            print("Error encoding user data in rewardVC")
//        }
//
//        let networkURL = Bundle.main.object(forInfoDictionaryKey: "NetworkURL") as! String
//        let u = "\(networkURL)/usersMobile"
//        NetworkManager.uploadData(uploadData: data, specific_url: u, httpMethod: "PATCH") {responseData in
//            //print("Response Data:")
//            //print(responseData)
//
//
//            if let user = responseData["data"] as? Dictionary<String,Any>{
//                User.globalUser.username = user["username"] as? String ?? User.globalUser.username
//                User.globalUser.name = user["name"] as? String ?? User.globalUser.name
//                User.globalUser.email = user["email"] as? String ?? User.globalUser.email
//                User.globalUser.profile_pic = user["profile_pic"] as? String ?? User.globalUser.profile_pic
//            }
//        }
        if User.globalUser.username == usernameNew{
            // username never changed
            customDismiss()
        }else{
            handleUniqueUsername()
        }
    }
    
    func handleUniqueUsername(){
        UserManager().uniqueUsername{ status in
            if status == "SUCCESS"{
                UserManager().uploadUser(){ responseData in
                    if let user = responseData["data"] as? Dictionary<String,Any>{
                        User.globalUser.username = user["username"] as? String ?? User.globalUser.username
                        User.globalUser.name = user["name"] as? String ?? User.globalUser.name
                        User.globalUser.email = user["email"] as? String ?? User.globalUser.email
                        User.globalUser.profile_pic = user["profile_pic"] as? String ?? User.globalUser.profile_pic
                        self.customDismiss()
                    }else{
                        print("Error deocding data in edit VC")
                    }
                }
            }else{
                let alert = UIAlertController(title: "Username Already Taken", message: "\"\(User.globalUser.username)\" is already taken. Please choose another option, or continue to use \"\(self.usernameNew!)\"", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(action) in
                    alert.dismiss(animated: true, completion: { () in self.usernameField2.becomeFirstResponder()})
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func customDismiss(){
        if let delegate = delegate{
            // doSomethingWith passes data from Edit VC back to Profile VC
            delegate.doSomethingWith(name: nameField2.text, netid: netidField2.text, username: usernameField2.text, email: emailField2.text, pic: profilePicture.image)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
     // dismisses keyboard when user touches blank spot on screen
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

        self.profilePicture.image  = newPic
        
    }
    
    

    
    
    
}


