//
//  RankingsViewController.swift
//  DukeRewards
//
//  Created by codeplus on 6/4/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit

class RankingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var rankingsTableView: UITableView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var rankNumber: UILabel!
    @IBOutlet weak var pointsNumber: UILabel!
    @IBOutlet weak var categoryBreakdownButton: UIButton!
    
    @IBOutlet weak var searchResultLabel: UILabel!
    let userManager = UserManager()
    let refreshControl = UIRefreshControl() // declare private constant property to VC for refreshing data
    var sortData: [User]!
    typealias Users = [User]
    var users = [User]()
    var allUsernames: [String]!

    
    override func viewDidLoad() {
        searchBar.delegate = self
        super.viewDidLoad()
        searchBar.searchTextField.backgroundColor = UIColor(red: 0.89, green: 0.91, blue: 0.93, alpha: 1.00)
        searchBar.placeholder = "Search by username"
        categoryBreakdownButton.layer.cornerRadius = 8
        //setUpTableView()
        sortData = users
        userManager.reloadData = {data in
            self.users = data
            self.sortData = data
            self.rankingsTableView.reloadData()
            print("reloadData")
           
            self.refreshControl.endRefreshing() // end refreshing UI symbol. Closure for rewardManager defined here so no need to define again
            self.setUpTableView()
          
        }
        
       // self.rankingsTableView.rowHeight = UITableView.automaticDimension
      //  self.rankingsTableView.estimatedRowHeight = 600
        searchBar.showsCancelButton = false
        userManager.callFetchData()
        
        
       
        // add refresh control to table view, call function refresh once user refreshes
        self.refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        rankingsTableView.refreshControl = refreshControl
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Data...")
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        createPointsLabel()
    }
    
    func createPointsLabel() {
        let rightBarButton = UIBarButtonItem(customView: UserManager.createPointsLabel())
        navBar.rightBarButtonItem = rightBarButton
    }
    
var userClicked: User?
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    userClicked = sortData[indexPath.row]
    performSegue(withIdentifier: "showUser", sender: nil)
    
    tableView.deselectRow(at: indexPath, animated: true)
    // no more grayed out cell after user hits back
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destination.
    // Pass the selected object to the new view controller.
    if let viewController = segue.destination as? ShowUserViewController {
        viewController.user = userClicked
    }
}

    @objc func refresh(sender: Any){
        self.refreshControl.attributedTitle = NSAttributedString(string: "Fetching Data...")
        // sets text back to no errors so if this refresh happens right after a refresh that failed, the text is changed accurately
        
        // fetches data again for table view
        userManager.data.removeAll() // empties data array in rewardManager
        // otherwise every refresh will keep appending more data to data array
        
        userManager.stopRefresh = { () in
            // this closure stopRefresh is called when NetworkManager receives an error from getting JSON
            // we are not allowed to make changes to UI on a background thread, so the below code brings us to main thread, where we can display an error message and end refreshing
            // before, there was no way to end the refresh without calling the completion handler in getJSON of NetworkManager
            DispatchQueue.main.async{
                self.refreshControl.attributedTitle = NSAttributedString(string: "Error Fetching Data")
                self.refreshControl.endRefreshing()
            }
        }
    
    userManager.callFetchData()
    // closure in viewDidLoad handles updating the tableView
}
    
    let cellSpacingHeight:CGFloat = 10
    
    func setUpTableView() {
        self.rankingsTableView.delegate = self
        self.rankingsTableView.dataSource = self
        self.rankingsTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.rankingsTableView.backgroundColor = UIColor(red: 0.93, green: 0.94, blue: 0.96, alpha: 1.00)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResultLabel.isHidden = (sortData.count != 0);
        return sortData.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = rankingsTableView.dequeueReusableCell(withIdentifier: "rankingsCell", for: indexPath) as! RankingsTableViewCell
        let userPerson = sortData[indexPath.row]
            for (index,user) in users.enumerated() {
                if user.username == userPerson.username {
                    DispatchQueue.main.async{
                        cell.rankNumber.text = "\(index + 1)"
                    }
                }
                cell.rankNumber.text = ""

                cell.profilePic.image = userPerson.profile_pic?.toImage()

                cell.profilePic.image = userPerson.profile_pic?.toImage()
                cell.userName.text = userPerson.username

                cell.pointsNumber.text = "\(userPerson.accumulated_total_points ?? 0 )"
            }
        
        return cell
        
    
    }
    // MARK: - Navigation
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        currentRankings = data[indexPath.row]
//    }
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//        if let rankingsViewController = segue.destination as? RankingsViewController {
//            rankingsViewController.rankings = currentRankings
//            rankingsViewController.rankNumber?.text = currentRankings[0]
//            rankingsViewController.userName?.text = currentRankings[1]
//            rankingsViewController.pointsNumber?.text = currentRankings[2]
//        }
//    }
    // copied code form EarnViewController
    // In my practice xcode files, I had other classes inherit the hamburger menu by setting them as a subclass of EarnViewController. The problem here would be that I'd have to override every single method here just to prevent myself from copying the hamburger menu code. Below is that copied code, delete it if a better way is found
    
    let transiton = SlideInTransition()
    var topView: UIView?
    
    // when hamburger menu is tapped
    @IBAction func didTapMenu(_ sender: Any) {
        guard let menuViewController = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController else { return }
        // refer to earnVC for comments explaining closeMenuVC
        transiton.closeMenuVC = { () in
            menuViewController.dismiss(animated: true, completion: nil)
        }
        menuViewController.didTapMenuType = { menuType in
            self.transitionToNew(menuType)}
        menuViewController.modalPresentationStyle = .overFullScreen
        menuViewController.transitioningDelegate = self
        present(menuViewController, animated: true)
    }
    
    // assist in hamburger menu sliding transition
    func transitionToNew(_ menuType: MenuType) {
           //let title = String(describing: menuType).capitalized
           //self.title = title

           topView?.removeFromSuperview()
           switch menuType {
            // this currently dictates what happens when each option is pressed. Goal is to either load up a new viewcontroller or view, whatever Kaila plans to implement
           case .profile:
               guard let profileViewController = storyboard?.instantiateViewController(withIdentifier: "profile") as? ProfileViewController else { return }
               profileViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
               //present(profileViewController, animated: true)
               self.present(profileViewController, animated: true, completion: nil)
               /*
               print("hello")
               let view = UIView()
               view.backgroundColor = .yellow
               view.frame = self.view.bounds
               self.view.addSubview(view)
               self.topView = view   */
            case .scanner:
                guard let scannerViewController = storyboard?.instantiateViewController(withIdentifier: "scanner") as? UINavigationController else { return }
                if let scannerVC = scannerViewController.viewControllers.first as? ScannerViewController {
                    if let nav = navigationController{
                        if let tab = nav.tabBarController{
                            if let nav = tab.viewControllers?[1] as? UINavigationController{
                                if let earn = nav.viewControllers.first as? EarnViewController{
                                    scannerVC.getEventFromEarnVC = {QR in
                                        return earn.getEventForScanner(QR: QR)
                                    }
                                }
                            }
                        }
                    }
                }
                scannerViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                self.present(scannerViewController, animated: true, completion: nil)
        
           case .settings:
               
               guard let settingsViewController = storyboard?.instantiateViewController(withIdentifier: "settings") as? SettingsViewController else { return }
               settingsViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
               self.present(settingsViewController, animated: true, completion: nil)
            
           case .notifications:
                guard let notificationViewController = storyboard?.instantiateViewController(withIdentifier: "notifications") as? NotificationsViewController else { return }
                notificationViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                self.present(notificationViewController, animated: true, completion: nil)
                
           case .about:
                guard let aboutViewController = storyboard?.instantiateViewController(withIdentifier: "aboutProcess") as? AboutProcessViewController else { return }
                               aboutViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                               self.present(aboutViewController, animated: true, completion: nil)
           case .admin:
                guard let adminViewController = storyboard?.instantiateViewController(withIdentifier: "admin") as? AdminViewController else { return }
                adminViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                self.present(adminViewController, animated: true, completion: nil)
            
           // default: no default tab since tutorial envisioned a tab to go back to previous screen
               //break
           }
       }
}

// help with delegation for hamburger menu. Not entirely sure how this works right now but it works
extension RankingsViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = true
        return transiton
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = false
        return transiton
    }
}

extension RankingsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarSearchButtonClicked")
        searchBar.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchText = searchBar.text!.lowercased().alphanumeric
        if searchText == "" {
            print("serach bar change")
            searchBar.endEditing(true)
            searchBar.resignFirstResponder()
            sortData = users
            rankingsTableView.reloadData()
            return
        }
        
        sortData = []
        for currUser in users {
            let username = currUser.username.lowercased().folding(options: .diacriticInsensitive, locale: .current).alphanumeric
            if username.contains(searchText) {
                sortData.append(currUser)
            }
        }
        searchResultLabel.isHidden = (sortData.count != 0);
        
        rankingsTableView.reloadData()
        
    }
    
}


