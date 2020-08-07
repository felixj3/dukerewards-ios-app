//
//  EventViewController.swift
//  DukeRewards
//
//  Created by Kyra Chan on 6/4/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {
    @IBOutlet weak var navBar: UINavigationItem!
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var eventDescription: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var showQRbutton: UIButton!
    

    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    var event: Event?
    let dateFormatterPrint = DateFormatter()
    let defaults = UserDefaults.standard
    var localArray = User.globalUser.bookmarkArray
    override func viewDidLoad() {
        super.viewDidLoad()

        
        dateFormatterPrint.dateFormat = "MM/dd/YYYY h:mma"
        dateFormatterPrint.timeZone = NSTimeZone(name: TimeZone.current.identifier) as TimeZone?
        if User.globalUser.bookmarkArray.contains(event!.id) {
            bookmarkButton.isSelected = true
        }
        // Do any additional setup after loading the view.
        
        if let safeEvent = event {
            eventName?.text = safeEvent.name
            if let safeTime = safeEvent.start_time {
                eventTime?.text = "Time: \(dateFormatterPrint.string(from: safeTime))"
            } else {
                eventTime?.text = "Time: NA"
            }
            eventLocation?.text = "Location: \(safeEvent.location)"
            eventDescription?.text = safeEvent.description
            NetworkManager.getEventImageFromURL(url: safeEvent.image){image in
                self.eventImage.image = image
            }
            registerButton.layer.cornerRadius = 8
            showQRbutton.layer.cornerRadius = 8
        } else {
            print("Event is nil.")
        }

        eventDescription.sizeToFit()
        let value = 250 + Float(eventName.frame.size.height +
            eventTime.frame.size.height +
            eventLocation.frame.size.height +
            eventDescription.frame.size.height) + 300
        containerHeight.constant = CGFloat(value)
        createPointsLabel()
        
        if(User.globalUser.adminEnabled!){
            showQRbutton.isHidden = false
        }else{
            showQRbutton.isHidden = true
        }
    }
    
    func createPointsLabel() {
        let rightBarButton = UIBarButtonItem(customView: UserManager.createPointsLabel())
        navBar.rightBarButtonItem = rightBarButton
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        defaults.set(User.globalUser.bookmarkArray, forKey: "bookmarkEvent")
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    var getEventFromEarnVC2: ((String) -> Event?)?
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let viewController = segue.destination as? ScannerViewController {
//            viewController.event = event
            viewController.getEventFromEarnVC = { QR in
                return self.getEventFromEarnVC2?(QR)
            }
        }
    }
    
    
    @IBAction func scanPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "showDetail", sender: sender)
    }
    @IBAction func bookmarkPressed(_ sender: UIButton) {
        if let index = User.globalUser.bookmarkArray.firstIndex(of: event!.id) {
            User.globalUser.bookmarkArray.remove(at: index)
            
        } else {
            User.globalUser.bookmarkArray.append(event!.id)
        }
        bookmarkButton.isSelected = !bookmarkButton.isSelected
    }
    
    @IBAction func showCodePressed(_ sender: Any) {
        guard let qrViewController = storyboard?.instantiateViewController(withIdentifier: "displayQR") as? QRCodeViewController else { return }
        qrViewController.codeContents = event?.QRnumber
        qrViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        present(qrViewController, animated: true, completion: nil)
    }
}
