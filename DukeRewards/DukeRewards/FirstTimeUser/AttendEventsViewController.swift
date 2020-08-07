//
//  AttendEventsViewController.swift
//  DukeRewards
//
//  Created by codeplus on 7/17/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit

class AttendEventsViewController: UIViewController {
    var tokenBack3: ((String) -> ())?

    @IBOutlet var attendEventsNextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func attendEventsNextButtonPressed(_ sender: Any) {
        guard let scanQRCodeViewController = self.storyboard?.instantiateViewController(withIdentifier: "scanQRCode") as? ScanQRCodeViewController else { return }
        print("before closure")
        scanQRCodeViewController.tokenBack2 = { token in
            self.dismiss(animated: true, completion: {            self.tokenBack3?(token)
})
            print("in closure")
        }
        print("after closure")
        self.present(scanQRCodeViewController, animated: true, completion: nil)
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
