//
//  MacawViewController.swift
//  DukeRewards
//
//  Created by codeplus on 6/9/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit
import Macaw

class MacawViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet var barChart: MacawView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //chartView.contentMode = .scaleAspectFit
    }
    
    // MARK: Actions
  
    @IBAction func showDataButton(_ sender: UIButton) {
        MacawChartView.playAnimations()
    }
}
