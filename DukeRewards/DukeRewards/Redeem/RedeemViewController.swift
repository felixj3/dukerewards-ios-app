//
//  RedeemViewController.swift
//  DukeRewards
//
//  Created by Kyra Chan on 6/4/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit

class RedeemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var navBar: UINavigationItem!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var filterDropdown: UIButton!
    @IBOutlet weak var filterStackView: UIStackView!
    @IBOutlet var filterOptions: [UIButton]!
    
    @IBOutlet weak var sortDropdown: UIButton!
    @IBOutlet weak var sortStackView: UIStackView!
    @IBOutlet var sortOptions: [UIButton]!
    
    @IBOutlet weak var tableview: RedeemTableView!
    
    @IBOutlet weak var searchResultLabel: UILabel!
    
    
    let rewardManager = RewardManager()
    let dateFormatterPrint = DateFormatter()
    
    let refreshControl = UIRefreshControl() // declare private constant property to VC for refreshing data
    
    var rewardData = [Reward]()
    var sortData = [Reward]()
    var filterCriteria = "Default"
    var sortCriteria = "Default"
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBar.searchTextField.backgroundColor = UIColor(red: 0.89, green: 0.91, blue: 0.93, alpha: 1.00)
        searchBar.placeholder = "Search by name / location / description"
        searchBar.searchTextField.adjustsFontSizeToFitWidth = true
//        rewardManager.reloadData = {data in
//            self.rewardData = data
//            self.sortData = data
//            self.tableview.reloadData()
//            print("reloadData")
//            self.refreshControl.endRefreshing() // end refreshing UI symbol. Closure for rewardManager defined here so no need to define again
//        }
        
//        rewardManager.callFetchData()
        // there seemed to be a problem where the rewardManager is initialized and fetch is called, but this closure wasn't defined yet since the view didn't load. Then the data never showed up in this class. By having the start function here, it allows the fetch data to happen when this view loads, so the closure is defined
        // code worked when it was here, but I commented it out for organization. It's in updatePage()
        setUpFilterDropdown()
        setUpSortDropdown()
        setUpTableView()
        dateFormatterPrint.dateFormat = "MM/dd/YYYY h:mma"
        // add refresh control to table view, call function refresh once user refreshes
        self.refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableview.refreshControl = refreshControl
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Data...")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        
        // button is updated everytime tab switches
        sortAndFilter()
        
        
        // adds the points to the right bar button item
        createPointsLabel()
        updatePage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        defaults.set(User.globalUser.favoriteArray, forKey: "bookmarkReward")
    }
    
    
    func setUpFilterDropdown() {
        let filterBackgroundView = UIView()
                filterBackgroundView.backgroundColor = UIColor(red: 0.40, green: 0.60, blue: 0.79, alpha: 1.00)
                filterBackgroundView.layer.cornerRadius = 8
                filterBackgroundView.translatesAutoresizingMaskIntoConstraints = false

                // put background view as the most background subviews of stack view
                filterStackView.insertSubview(filterBackgroundView, at: 0)

                // pin the background view edge to the stack view edge
                NSLayoutConstraint.activate([
                    filterBackgroundView.leadingAnchor.constraint(equalTo: filterStackView.leadingAnchor),
                    filterBackgroundView.trailingAnchor.constraint(equalTo: filterStackView.trailingAnchor),
                    filterBackgroundView.topAnchor.constraint(equalTo: filterStackView.topAnchor),
                    filterBackgroundView.bottomAnchor.constraint(equalTo: filterStackView.bottomAnchor)
                ])
                filterDropdown.layer.cornerRadius = 8
                for filterOption in filterOptions {
                    filterOption.layer.cornerRadius = 8
                }
    }
    
    func setUpSortDropdown() {
        let sortBackgroundView = UIView()
                sortBackgroundView.backgroundColor = UIColor(red: 0.40, green: 0.60, blue: 0.79, alpha: 1.00)
                sortBackgroundView.layer.cornerRadius = 8
                sortBackgroundView.translatesAutoresizingMaskIntoConstraints = false

                // put background view as the most background subviews of stack view
                sortStackView.insertSubview(sortBackgroundView, at: 0)

                // pin the background view edge to the stack view edge
                NSLayoutConstraint.activate([
                    sortBackgroundView.leadingAnchor.constraint(equalTo: sortStackView.leadingAnchor),
                    sortBackgroundView.trailingAnchor.constraint(equalTo: sortStackView.trailingAnchor),
                    sortBackgroundView.topAnchor.constraint(equalTo: sortStackView.topAnchor),
                    sortBackgroundView.bottomAnchor.constraint(equalTo: sortStackView.bottomAnchor)
                ])
                sortDropdown.layer.cornerRadius = 8
                for sortOption in sortOptions {
                    sortOption.layer.cornerRadius = 8
                }
    }
    
    func createPointsLabel() {
        let rightBarButton = UIBarButtonItem(customView: UserManager.createPointsLabel())
        navBar.rightBarButtonItem = rightBarButton
    }
    
    @objc func refresh(sender: Any){
        self.refreshControl.attributedTitle = NSAttributedString(string: "Fetching Data...")
        // sets text back to no errors so if this refresh happens right after a refresh that failed, the text is changed accurately
        updatePage()
        // fetches data again for table view
//        rewardManager.data.removeAll() // empties data array in rewardManager
//        // otherwise every refresh will keep appending more data to data array
//
//        NetworkManager.stopRefresh = { () in
//            // this closure stopRefresh is called when NetworkManager receives an error from getting JSON
//            // we are not allowed to make changes to UI on a background thread, so the below code brings us to main thread, where we can display an error message and end refreshing
//            // before, there was no way to end the refresh without calling the completion handler in getJSON of NetworkManager
//            DispatchQueue.main.async{
//                self.refreshControl.attributedTitle = NSAttributedString(string: "Error Fetching Data")
//                self.refreshControl.endRefreshing()
//            }
//        }
//
//        let u = UserManager()
//        u.updateRewards = {array in
//            User.globalUser.rewards = array
//        }
//        u.getRewards()
//
//        rewardManager.callFetchData()
//        // closure in viewDidLoad handles updating the tableView
    }
    
    // called in viewWillAppear and refresh
    func updatePage(){
        rewardManager.data.removeAll()
        
        rewardManager.reloadData = {data in
            self.rewardData = data
            self.sortData = data
            self.tableview.reloadData()
            print("reloadData")
            self.refreshControl.endRefreshing() // end refreshing UI symbol. Closure for rewardManager defined here so no need to define again
        }
        
        NetworkManager.stopRefresh = { () in
            // this closure stopRefresh is called when NetworkManager receives an error from getting JSON
            // we are not allowed to make changes to UI on a background thread, so the below code brings us to main thread, where we can display an error message and end refreshing
            // before, there was no way to end the refresh without calling the completion handler in getJSON of NetworkManager
            DispatchQueue.main.async{
                self.refreshControl.attributedTitle = NSAttributedString(string: "Error Fetching Data")
                self.refreshControl.endRefreshing()
            }
        }
        
        let u = UserManager()
        u.updateRewards = {array in
            User.globalUser.rewards = array
            self.rewardManager.callFetchData()
        }
        u.getRewards()
        
    }
    
    let cellSpacingHeight:CGFloat = 10
    
    func setUpTableView() {
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.tableview.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableview.backgroundColor = UIColor(red: 0.93, green: 0.94, blue: 0.96, alpha: 1.00)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResultLabel.isHidden = (sortData.count != 0)
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
        let currReward = sortData[indexPath.row]
        let cell = tableview.dequeueReusableCell(withIdentifier: "reward_cell", for: indexPath) as! RedeemTableViewCell
        cell.rewardName?.text = currReward.name ?? "NA"
        cell.link = self
        if let safeTime = currReward.time {
            cell.rewardTime?.text = "Time: \(dateFormatterPrint.string(from: safeTime))"
        } else {
            cell.rewardTime?.text = "Time: NA"
        }
        
        cell.rewardLocation?.text = "Location: \(currReward.location ?? "NA")"
        cell.rewardDescription?.text = currReward.description ?? "NA"
        // cell.redeemButton.setTitle("Redeem -\(currReward.points ?? 0)", for: .normal)
        cell.rewardCategory.layer.masksToBounds = true
        cell.rewardCategory.layer.cornerRadius = 5
        cell.rewardCategory.sizeToFit()
        cell.rewardCategory.text = "  "+(currReward.category ?? "")+"  "
        // cell.rewardImage.image = UIImage(named: currReward.image ?? "defaultImage")
        NetworkManager.getRewardImageFromURL(url: currReward.image ?? "error"){image in
            cell.rewardImage.image = image
        }
        cell.colorCategoryLabel()
        if User.globalUser.favoriteArray.contains(currReward.id) {
            cell.favoriteButton.isSelected = true
        }
        else {
            cell.favoriteButton.isSelected = false
        }
        if User.globalUser.rewards!.contains(currReward.id) {
            cell.rewardPoints.text = "Already redeemed"
            cell.rewardPoints.adjustsFontSizeToFitWidth = true
            cell.backgroundColor = UIColor(red: 0.84, green: 0.85, blue: 0.87, alpha: 1.00)
//            cell.redeemButton.setTitle(" Redeemed for \(currReward.points)", for: .normal)
//            cell.redeemButton.isEnabled = false
//            cell.redeemButton.backgroundColor = UIColor.systemGray
        } else{
//            let attachment = NSTextAttachment()
//             if currReward.category?.lowercased() == "dining"{
//                  attachment.image = UIImage(systemName: "circle.fill")?.withTintColor(UIColor(red: 1.00, green: 0.85, blue: 0.38, alpha: 1.00))
//             }
//             else{
//                 attachment.image = UIImage(systemName: "circle.fill")?.withTintColor(UIColor(red: 1.00, green: 0.39, blue: 0.39, alpha: 1.00))
//             }
//             let attachmentString = NSAttributedString(attachment: attachment)
//
//            // Set bound to reposition
//            let diningImageOffsetY: CGFloat = -3
//            let diningImageOffsetX: CGFloat = 0
//            attachment.bounds = CGRect(x: diningImageOffsetX, y: diningImageOffsetY, width: attachment.image!.size.width, height: attachment.image!.size.height)
//
//             let myString = NSMutableAttributedString(string: "-\(currReward.points) ")
//             myString.append(attachmentString)
//
//            cell.rewardPoints?.attributedText = myString
            cell.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.00)
            cell.rewardPoints?.attributedText = LayoutLibraryViewController.getCoinImageAttachment(category: currReward.category!, phrase: "Redeem \(currReward.points) ")
//            cell.redeemButton.setTitle("Redeem -\(currReward.points)", for: .normal)
//            cell.redeemButton.isEnabled = true
//            cell.redeemButton.backgroundColor = UIColor(red:0.44, green:0.54, blue:0.75, alpha:1.0)
        }
        // cell.delegate = self // conformed to TableViewCellDelegate protocol
        cell.reward = currReward // so the cell has an instance of the reward
        return cell
    }

    // when favorite icon is clicked
    func handleMarkAsFavorite(cell: RedeemTableViewCell) {
        // To figure out which event cell is tapped
        let indexPathTapped = tableview.indexPath(for: cell)
        let currReward = sortData[indexPathTapped!.row]
        if let index = User.globalUser.favoriteArray.firstIndex(of: currReward.id) {
            User.globalUser.favoriteArray.remove(at: index)
        } else {
            User.globalUser.favoriteArray.append(currReward.id)
        }
        cell.favoriteButton.isSelected = !cell.favoriteButton.isSelected
        
    }
    
    // when filter dropdown is clicked
    @IBAction func handleFilterSelection(_ sender: UIButton) {
        print("filterTapped")

        filterOptions.forEach {(button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
                if (button.isHidden) {
                    sender.setImage(UIImage(systemName: "chevron.down"), for: .normal)
                } else {
                    sender.setImage(UIImage(systemName: "chevron.up"), for: .normal)
                }
            })
        }
    }
    
    // when sort dropdown is clicked
    @IBAction func handleSortSelection(_ sender: UIButton) {
        print("sortTapped")
        sortOptions.forEach {(button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
                if (button.isHidden) {
                    sender.setImage(UIImage(systemName: "chevron.down"), for: .normal)
                } else {
                    sender.setImage(UIImage(systemName: "chevron.up"), for: .normal)
                }
            })
        }
    }
    
    // filter options
    enum Filters: String {
        case athletics = "Athletics"
        case dining = "Dining"
        case redeemed = "Redeemed"
        case favorites = "Favorites"
        case none = "None"
    }
    
    // sort options
    enum Sorts: String {
        case AtoZ = "A to Z"
        case eventTime = "Event Time"
        case pointsUp = "Least Points"
        case pointsDown = "Most Points"
        case datePosted = "Date Posted"
        case none = "None"
    }
    
    // when a specific filter option is selected
    // TODO: add code for actual filtering
    @IBAction func filterTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle else {
            return
        }
        filterDropdown.setTitle("Filter by: " + title, for: [.normal])
        filterCriteria = title
        filterDropdown.sendActions(for: .touchUpInside)
        sortAndFilter()
    }
     
//    func sortByTime() {
//        sortData = []
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
//        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
//        let defaultTime = dateFormatter.date(from: "1970-01-01T00:00:00Z")
//        sortData = sortData.sorted(by: {
//            $0.start_time?.compare(($1.start_time ?? defaultTime)!) == .orderedAscending
//        })
//    }
    
    // when a specific sort option is selected
    @IBAction func sortTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle else {
                   return
        }
        sortDropdown.setTitle("Sort: " + title, for: [.normal])
        sortCriteria = title
        sortDropdown.sendActions(for: .touchUpInside)

        sortAndFilter()
    
    }
    func sortAndFilter() {
           if filterCriteria != "Default" {
               guard let filter = Filters(rawValue: filterCriteria) else {
                   return
               }
               switch filter {
               case .athletics:
                   sortData = rewardData.filter{$0.category == "Athletics"}
               case .dining:
                   sortData = rewardData.filter{$0.category == "Dining"}
               case .redeemed:
                    sortData = []
                    for currID in User.globalUser.rewards! {
                        if let index = rewardData.firstIndex(where: {$0.id == currID}) {
                            let currReward = rewardData[index]
                            sortData.append(currReward)
                        }
                    }
               case .favorites:
                    sortData = []
                    for currID in User.globalUser.favoriteArray {
                        if let index = rewardData.firstIndex(where: {$0.id == currID}) {
                            let currReward = rewardData[index]
                            sortData.append(currReward)
                        }
                    }
               case .none:
                    sortData = rewardData
            }
            }
        
           if sortCriteria != "Default" {
               guard let sort = Sorts(rawValue: sortCriteria) else {
                   return
               }
               switch sort {
               case .AtoZ:
                    sortData = sortData.sorted(by: {$0.name < $1.name})
               case .eventTime:
                    print("nothing here yet")
//                   sortByTime()
               case .pointsUp:
                   sortData = sortData.sorted(by: {$0.points < $1.points})
               case .datePosted:
                   print("date posted")
               case .pointsDown:
                   sortData = sortData.sorted(by: {$0.points > $1.points})
               case .none:
                   print("do nothing")
               }
           } else {
               print("sort Default")
           }
           tableview.reloadData()
       }
    
    
    // MARK: - Navigation
    var rewardClicked: Reward?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        rewardClicked = sortData[indexPath.row]
        performSegue(withIdentifier: "showDetail", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let viewController = segue.destination as? RewardViewController {
            viewController.reward = rewardClicked
        }
    }
    
    
    // copied code form EarnViewController
    // In my practice xcode files, I had other classes inherit the hamburger menu by setting them as a subclass of EarnViewController. The problem here would be that I'd have to override every single method here just to prevent myself from copying the hamburger menu code. Below is that copied code, delete it if a better way is found
    
    let transiton = SlideInTransition()
    var topView: UIView?
    
    // when hamburger menu is tapped
    @IBAction func didTapMenu(_ sender: Any) {
        guard let menuViewController = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController else { return }
        // earnVC has comments for closeMenuVC
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
        // see Earn VC for explanation of above 2 lines

           topView?.removeFromSuperview()
           switch menuType {
            // this currently dictates what happens when each option is pressed. Goal is to either load up a new viewcontroller or view, whatever Kaila plans to implement
           case .profile:
               guard let profileViewController = storyboard?.instantiateViewController(withIdentifier: "profile") as? ProfileViewController else { return }
               profileViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
               self.present(profileViewController, animated: true, completion: nil)
               /*
               print("hello")
               let view = UIView()
               view.backgroundColor = .yellow
               view.frame = self.view.bounds
               self.view.addSubview(view)
               self.topView = view
    */
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
extension RedeemViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = true
        return transiton
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = false
        return transiton
    }
}
// help with delegation for button clicked on tableViewCell
//extension RedeemViewController: RedeemTableViewCellDelegate{
//    func redeemTableViewCell(_ redeemTableViewCell: RedeemTableViewCell, redeemButtonTappedFor reward: Reward){
//        rewardClicked = reward
//        performSegue(withIdentifier: "showDetail", sender: nil)
//    }
//}
extension RedeemViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchText = searchBar.text!.lowercased().alphanumeric

        
        if searchText == "" {
            searchBar.endEditing(true)
            searchBar.resignFirstResponder()
            sortData = rewardData
            tableview.reloadData()
            return
        }
        
        sortData = []
        for currReward in rewardData {
            let name = currReward.name.lowercased().folding(options: .diacriticInsensitive, locale: .current).alphanumeric
            let location = currReward.location.lowercased().folding(options: .diacriticInsensitive, locale: .current).alphanumeric
            let description = currReward.description.lowercased().folding(options: .diacriticInsensitive, locale: .current).alphanumeric
            if (name.contains(searchText)) || ((location.contains(searchText)) ) || ((description.contains(searchText)) ) {
                sortData.append(currReward)
                
            }
        }
        
        tableview.reloadData()
    }

    
    
    
}
extension String {
    var alphanumeric: String {
        return self.components(separatedBy: CharacterSet.alphanumerics.inverted).joined().lowercased()
    }
}
