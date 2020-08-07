//
//  AnnouncementViewController.swift
//  DukeRewards
//
//  Created by Kyra Chan on 6/10/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit

class AnnouncementViewController: UIViewController {

    @IBOutlet weak var notificationHeader: UILabel!
    @IBOutlet weak var notificationTime: UILabel!
    @IBOutlet weak var notificationDescription: UILabel!
    @IBOutlet weak var announcementCategory: UILabel!
    
    var notification: Notification?
    let dateFormatterPrint = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatterPrint.dateFormat = "MM-dd HH:mm"
        // Do any additional setup after loading the view.
        notificationHeader?.text = notification?.header ?? "N/A"
        if let safeTime = notification?.time {
            notificationTime?.text = "Time Posted: \(dateFormatterPrint.string(from: safeTime))"
        } else {
            notificationTime?.text = "Time Posted: N/A"
        }
        notificationDescription?.text = notification?.description ?? "N/A"
        announcementCategory.text = "  "+(notification?.category ?? "")+"  "
        announcementCategory.layer.masksToBounds = true
        announcementCategory.layer.cornerRadius = 5
        colorCategoryLabel()
    }
    
    func colorCategoryLabel() {
        if announcementCategory.text == "  Athletics  " {
            announcementCategory.backgroundColor = UIColor(red: 0.95, green: 0.44, blue: 0.44, alpha: 1.00)
        }
        else if announcementCategory.text == "  Dining  " {
            announcementCategory.backgroundColor = UIColor(red: 1.00, green: 0.85, blue: 0.38, alpha: 1.00)
        }
        else {
            announcementCategory.backgroundColor = UIColor(red: 0.43, green: 0.76, blue: 0.89, alpha: 1.00)
        }
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
