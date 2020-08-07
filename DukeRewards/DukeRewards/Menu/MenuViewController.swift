//
//  MenuViewController.swift
//  DukeRewards
//
//  Created by codeplus on 6/4/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit

enum MenuType: Int {
    case profile
    case scanner
    case notifications
    case settings
    case about
    case admin
}

class MenuViewController: UITableViewController {

    var didTapMenuType: ((MenuType) -> Void)?

    @IBOutlet weak var adminCell: UITableViewCell!
    @IBOutlet weak var adminCellLabel: UILabel!
    @IBOutlet weak var scanCellLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (User.globalUser.primary_affiliation == "Student" || User.globalUser.primary_affiliation == ""){
            print(User.globalUser.primary_affiliation)
//            adminCell.isHidden = true
        }
        // Do any additional setup after loading the view.
        // print("menu loaded")
        cellText()
    }
    
    
    /*
    var transition: SlideInTransition? // doesn't work, but it's for touchesEnded function
    // doesn't work, ideally it can detect if a touch occurred in dimmingView
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("hello touches ended")
        if let firstTouch = touches.first {
            let hitView = self.view.hitTest(firstTouch.location(in: self.view), with: event)

            if hitView === transition!.dimmingView {
                print("touch is inside")
            } else {
                print("touch is outside")
            }
        }
    }
 */
    
    
    // "buttons" on table view in hamburger menu
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menuType = MenuType(rawValue: indexPath.row) else { return }

        if(menuType == MenuType.admin){
            User.globalUser.flip()
            cellText()
            tableView.deselectRow(at: indexPath, animated: true)
            // the admin case in transitionToNew() of Earn, Redeem, and Rankings will never be called
            // admin view controller is not used anymore, but should remain for now in case of future features
        }else{
            dismiss(animated: true) { [weak self] in
                //print("Dismissing: \(menuType)")
                self?.didTapMenuType?(menuType)
            }
        }
    }
    
    func cellText(){
        if(User.globalUser.adminEnabled!){
            adminCellLabel.text = "Admin: Enabled"
            scanCellLabel.text = "Scan Reward"
        }else{
            adminCellLabel.text = "Admin: Disabled"
            scanCellLabel.text = "Scan Event"
        }
    }
    

    // location on menu is not contrained currently
    // menu is 0.6 width of screen so ideally constrain back button somewhere between 0.5-0.6 width of screen
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true)
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
