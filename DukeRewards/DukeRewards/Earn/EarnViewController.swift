//
//  EarnViewController.swift
//  DukeRewards
//
//  Created by Kyra Chan on 6/4/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit

class EarnViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet var transparentBackground: UIImageView!
    @IBOutlet var tutorialMain: UIImageView!
    @IBOutlet var tapRecognizer: UITapGestureRecognizer!
    var loadTutorial: Bool = true
    
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet var filterOptions: [UIButton]!
    @IBOutlet weak var filterStackView: UIStackView!
    @IBOutlet weak var filterDropdown: UIButton!
    
    @IBOutlet weak var sortDropdown: UIButton!
    @IBOutlet weak var sortStackView: UIStackView!
    @IBOutlet var sortOptions: [UIButton]!
    
    @IBOutlet weak var tableview: EarnTableView!
    
    @IBOutlet weak var searchResultLabel: UILabel!
    let eventManager = EventManager()
    
//    public var passDataToScanner:(([Event]) -> ())?
    let defaults = UserDefaults.standard
    // for hamburger menu
    let transiton = SlideInTransition()
    var topView: UIView?
    
    var dateFormatterPrint = DateFormatter()
    
    let refreshControl = UIRefreshControl() // see redeemVC for comments regarding refreshControl
    
    var earnData = [Event]()
    var sortData = [Event]()
    var filterCriteria:String = "Default"
    var sortCriteria:String = "Default"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchbar.searchTextField.backgroundColor = UIColor(red: 0.89, green: 0.91, blue: 0.93, alpha: 1.00)
        searchbar.placeholder = "Search by name / location / description"
        searchbar.searchTextField.adjustsFontSizeToFitWidth = true
        // Do any additional setup after loading the view.
        
        // opens another thread to wait for data to load in table, then reloads tableView
        eventManager.reloadData = {data in // closure body that is defined in Event Manager
            // passes data to global variable EarnData for tableView to reload
            self.earnData = data
            self.sortData = data
            self.tableview.reloadData()
            self.refreshControl.endRefreshing()
//            let lm = LocationManager()
//            lm.setCenter(event: self.sortData[1])
        }
        setUpFilterDropdown()
        setUpSortDropdown()
        
        eventManager.callFetchData()
        setUpTableView()
        dateFormatterPrint.dateFormat = "MM/dd/YYYY h:mma"
        dateFormatterPrint.timeZone = NSTimeZone(name: TimeZone.current.identifier) as TimeZone?


     
        // for refreshing data
        self.refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableview.refreshControl = refreshControl
        
        // let dukeNavyBlue = UIColor(red: 1/255, green:33/255, blue: 105/255, alpha: 1.0)
        // let attributedStringColor = [NSAttributedString.Key.foregroundColor : dukeNavyBlue];
        // refreshControl.attributedTitle = NSAttributedString(string: "Fetching Data...", attributes: attributedStringColor)
        // refreshControl.tintColor = dukeNavyBlue
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Data...")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        
        sortAndFilter()
        
        // adds the points to the right bar button item
        
        createPointsLabel()
        
        //        let segmentBarItem = UIBarButtonItem(customView: User.globalUser.button!)
        //        navBar.rightBarButtonItem = segmentBarItem
        if(!loadTutorial){
            removeImages()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        defaults.set(User.globalUser.bookmarkArray, forKey: "bookmarkEvent")
    }
    
    @IBAction func removeImagesFromScreen(_ sender: Any) {
        removeImages()
    }
    
    func removeImages(){
        transparentBackground.removeFromSuperview()
        tutorialMain.removeFromSuperview()
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
    
    @objc func refresh(sender:Any){
        self.refreshControl.attributedTitle = NSAttributedString(string: "Fetching Data...")
        eventManager.data.removeAll()
        
        NetworkManager.stopRefresh = { () in
            // see redeemVC for full comments regarding this closure
            DispatchQueue.main.async{
                self.refreshControl.attributedTitle = NSAttributedString(string: "Error Fetching Data")
                self.refreshControl.endRefreshing()
            }
        }

        eventManager.callFetchData()
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
        let cell = tableview.dequeueReusableCell(withIdentifier: "event_cell", for: indexPath) as! EarnTableViewCell

        cell.link = self
        let currEvent = sortData[indexPath.row]
        if let safeStart = currEvent.start_time {
            cell.eventTime?.text = "Time: \(dateFormatterPrint.string(from: safeStart))"
        } else {
            cell.eventTime?.text = "Time: NA"
        }
        cell.eventLocation?.text = currEvent.location
        cell.eventDescription?.text = currEvent.description
//        cell.earnButton.setTitle("Earn +\(currEvent.points)", for: .normal)
        // cell.eventPoints?.text = "+\(currEvent.points)"
        let attachment = NSTextAttachment()
        if currEvent.category?.lowercased() == "dining"{
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
        
        let myString = NSMutableAttributedString(string: "Earn \(currEvent.points) ")
        myString.append(attachmentString)
        
        cell.eventPoints?.attributedText = myString
            
        cell.eventCategory.layer.masksToBounds = true
        cell.eventCategory.layer.cornerRadius = 5
        cell.eventCategory.sizeToFit()
        cell.eventCategory?.text = "  "+(currEvent.category ?? "")+"  "
        // cell.eventImage.image = UIImage(named: currEvent.image)
        cell.eventName?.text = currEvent.name
        cell.bookmarkButton.isSelected = User.globalUser.bookmarkArray.contains(currEvent.id)
        cell.colorCategoryLabel()
        NetworkManager.getEventImageFromURL(url: currEvent.image){image in
            cell.eventImage.image = image
        }
        return cell
    }

    // when bookmark icon is clicked
    func handleMarkAsBookmark(cell: EarnTableViewCell) {
        // To figure out which event cell is tapped
        let indexPathTapped = tableview.indexPath(for: cell)
        let currEvent = sortData[indexPathTapped!.row]
        if let index = User.globalUser.bookmarkArray.firstIndex(of: currEvent.id) {
            User.globalUser.bookmarkArray.remove(at: index)
        } else {
            User.globalUser.bookmarkArray.append(currEvent.id)
        }
        cell.bookmarkButton.isSelected = !cell.bookmarkButton.isSelected
    
    }
    
    // when filter dropdown is clicked
    @IBAction func handleFilterSelection(_ sender: UIButton) {
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
        case bookmarks = "Bookmarks"
        case earned = "Earned"
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
    func sortAndFilter() {
        print("sortAndFilter --------------")
        if filterCriteria != "Default" {
            guard let filter = Filters(rawValue: filterCriteria) else {
                return
            }
            switch filter {
            case .athletics:
                print(filterCriteria)
                sortData = earnData.filter{$0.category == "Athletics"}
            case .dining:
                print(filterCriteria)
                sortData = earnData.filter{$0.category == "Dining"}
            case .earned:
                print(filterCriteria)
                
            case .bookmarks:
                print(filterCriteria)
                sortData = []
                    for currID in User.globalUser.bookmarkArray {
                        if let index = earnData.firstIndex(where: {$0.id == currID}) {
                            let currEvent = earnData[index]
                            sortData.append(currEvent)
                        }
                    }
            case .none:
                print(filterCriteria)
                sortData = earnData
            }
        } else {
            print("filter default")
        }
        searchResultLabel.isHidden = (sortData.count != 0);
        if sortCriteria != "Default" {
            guard let sort = Sorts(rawValue: sortCriteria) else {
                return
            }
            switch sort {
            case .AtoZ:
                sortData = sortData.sorted(by: {$0.name < $1.name})
            case .eventTime:
                print(sortCriteria)
                sortByTime()
            case .pointsUp:
                print(sortCriteria)
                sortData = sortData.sorted(by: {$0.points < $1.points})
            case .datePosted:
                print(sortCriteria)
                print("date posted")
            case .pointsDown:
                print(sortCriteria)
                sortData = sortData.sorted(by: {$0.points > $1.points})
            case .none:
                print(sortCriteria)
                print("do nothing")
            }
        } else {
            print("sort Default")
        }
        tableview.reloadData()
    }
     
    func sortByTime() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let defaultTime = dateFormatter.date(from: "1970-01-01T00:00:00Z")
        sortData = sortData.sorted(by: {
            $0.start_time?.compare(($1.start_time ?? defaultTime)!) == .orderedAscending
        })
    }

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
    
    // MARK: - Navigation
    var eventClicked: Event?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        eventClicked = sortData[indexPath.row]
        performSegue(withIdentifier: "showDetail", sender: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
        // no more grayed out cell after user hits back
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let viewController = segue.destination as? EventViewController {
            viewController.event = eventClicked
            viewController.getEventFromEarnVC2 = {QR in
                return self.getEventForScanner(QR: QR)
                // this came from event view controller
            }
        }
    }
    
     // In my practice xcode files, I had other classes inherit the hamburger menu by setting them as a subclass of EarnViewController. The problem here would be that I'd have to override every single method here just to prevent myself from copying the hamburger menu code. Below is that copied code, delete it if a better way is found
    
    // when hamburger menu is tapped
    @IBAction func didTapMenu(_ sender: Any) {
        guard let menuViewController = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController else { return }
        
        // print("before closures after menu is tapped")
        
        // closure in SlideInTransition is defined here
        // when the main thread approahces this line, a second thread goes to closeMenuVC definition in slide in transition and waits for it to be called. Once it's called (in someAction function in SlideInTransition), it pops back over here to execute the body of the function. I assume if someAction is never called, then this is never executed. Not sure when the "thread" disappears exactly. This is all from my understanding but it may not be accurate
        transiton.closeMenuVC = { () in
            self.navigationController?.popViewController(animated: true)
            menuViewController.dismiss(animated: true, completion: nil)
        }
        
        menuViewController.didTapMenuType = { menuType in
            self.transitionToNew(menuType)
            // body of function didTapMenuType in MenuVC
        }
        
        // print("after closures after menu is tapped")
        
        menuViewController.modalPresentationStyle = .overFullScreen
        // menuViewController.modalPresentationStyle = .overCurrentContext
        menuViewController.transitioningDelegate = self
        present(menuViewController, animated: true)
    }
    
    // assist in hamburger menu sliding transition
    func transitionToNew(_ menuType: MenuType) {
           //let title = String(describing: menuType).capitalized
           //self.title = title
        // that line above was making the tab names change. self.title refers to this viewControllers title and that's what the tab bar displayed. Commenting it out should work
        // print("transition")
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
               self.topView = view
             
    */
           case .scanner:
                guard let scannerViewController = storyboard?.instantiateViewController(withIdentifier: "scanner") as? UINavigationController else { return }
                if let scannerVC = scannerViewController.viewControllers.first as? ScannerViewController {
                    scannerVC.getEventFromEarnVC = { QR in
                        print(QR)
                        print("completionHandler here -------------")
                        return self.getEventForScanner(QR: QR)
                    }
                }
                
                scannerViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                self.present(scannerViewController, animated: true, completion: nil)
           case .settings:
               guard let settingsViewController = storyboard?.instantiateViewController(withIdentifier: "settings") as? SettingsViewController else { return }
               settingsViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
               self.present(settingsViewController, animated: true, completion: nil)
            
            /*
               print("what's up")
               let view = UIView()
               view.backgroundColor = .blue
               view.frame = self.view.bounds
               self.view.addSubview(view)
               self.topView = view
            */
            
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
    
    func getEventForScanner(QR: String) -> Event?{
        let i = self.earnData.firstIndex(where: {$0.QRnumber == QR})
        if let safeIndex = i{
            // safeIndex should be a valid index if unwrapped
            return earnData[safeIndex]
        }else{
            return nil
        }
    }

}

// help with delegation for hamburger menu. Not entirely sure how this works right now but it works
extension EarnViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = true
        return transiton
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = false
        return transiton
    }
}

// MARK: Search bar methods
extension EarnViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarSearchButtonClicked")
        searchbar.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchText = searchBar.text!.lowercased().alphanumeric
        if searchText == "" {
            print("serach bar change")
            searchBar.endEditing(true)
            searchBar.resignFirstResponder()
            sortData = earnData
            tableview.reloadData()
            return
        }
        
        sortData = []
        for currEvent in earnData {
            let name = currEvent.name.lowercased().folding(options: .diacriticInsensitive, locale: .current).alphanumeric
            let location = currEvent.location.lowercased().folding(options: .diacriticInsensitive, locale: .current).alphanumeric
            let description = currEvent.description.lowercased().folding(options: .diacriticInsensitive, locale: .current).alphanumeric
            if name.contains(searchText) || location.contains(searchText) || description.contains(searchText) {
                sortData.append(currEvent)
            }
        }
        searchResultLabel.isHidden = (sortData.count != 0);
        
        tableview.reloadData()
        
    }

    
    
    
    
}
extension UIAlertController {
    func isValidName(_ name: String) -> Bool {
        return (name.count > 0)
    }
    @objc func textDidChange() {
        if let name = textFields?[0].text,
            let username = textFields?[1].text,
            let action = actions.last {
            action.isEnabled = isValidName(name) && isValidName(username)
        }
    }
}


