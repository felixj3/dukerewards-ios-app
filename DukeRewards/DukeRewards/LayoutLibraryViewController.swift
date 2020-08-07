//
//  LayoutLibraryViewController.swift
//  DukeRewards
//
//  Created by codeplus on 7/17/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit

class LayoutLibraryViewController: UIViewController {
    
    static var currentStoryboard = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // attaches a coin image to end of phrase
    static func getCoinImageAttachment(category: String, phrase: String) -> NSMutableAttributedString{
        let attachment = NSTextAttachment()
        if category.lowercased() == "dining"{
            attachment.image = UIImage(systemName: "dollarsign.circle.fill")?.withTintColor(UIColor(red: 1.00, green: 0.85, blue: 0.38, alpha: 1.00))
        }
        else{
            attachment.image = UIImage(systemName: "dollarsign.circle.fill")?.withTintColor(UIColor(red: 1.00, green: 0.39, blue: 0.39, alpha: 1.00))
        }
        let attachmentString = NSAttributedString(attachment: attachment)
        
        // Set bound to reposition
        let diningImageOffsetY: CGFloat = -4
        let diningImageOffsetX: CGFloat = 0
        attachment.bounds = CGRect(x: diningImageOffsetX, y: diningImageOffsetY, width: attachment.image!.size.width, height: attachment.image!.size.height)
        
        let myString = NSMutableAttributedString(string: phrase)
        myString.append(attachmentString)
        
        return myString
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
