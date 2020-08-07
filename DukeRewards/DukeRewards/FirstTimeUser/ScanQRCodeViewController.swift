//
//  ScanQRCodeViewController.swift
//  DukeRewards
//
//  Created by codeplus on 7/17/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit

class ScanQRCodeViewController: UIViewController {
    var tokenBack2: ((String) -> ())?
    @IBOutlet var scanQRCodeNextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    var feedVC: UINavigationController?
    @IBAction func scanQRCodeNextButtonPressed(_ sender: Any) {
        feedVC = self.storyboard?.instantiateViewController(withIdentifier: "navController1") as? UINavigationController
        feedVC!.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        feedVC?.navigationBar.isHidden = true
        self.present(feedVC!, animated: true, completion: nil)
        if let process = feedVC!.viewControllers.first as? ProcessViewController{
            process.tokenBack = { token in
                self.dismiss(animated: true, completion: {                self.tokenBack2?(token)
})
                print("in scanner")

            }
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
