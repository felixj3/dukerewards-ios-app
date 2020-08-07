//
//  NavBarController.swift
//  DukeRewards
//
//  Created by Kyra Chan on 6/24/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit

class NavBarController: UINavigationController {

    @IBOutlet weak var earnNavBar: UINavigationBar!

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
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
