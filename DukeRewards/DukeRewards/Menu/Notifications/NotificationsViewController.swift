//
//  NotificationsViewController.swift
//  DukeRewards
//
//  Created by codeplus on 6/8/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableview: UITableView!
    
    let notificationManager = NotificationManager()
    let dateFormatterPrint = DateFormatter()
    
    var notificationData = [Notification]()
    
    let refreshControl = UIRefreshControl() // see RedeemVC for comments regarding refreshControl
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.searchTextField.backgroundColor = UIColor(red: 0.89, green: 0.91, blue: 0.93, alpha: 1.00)
        notificationManager.reloadData = {data in
            self.notificationData = data
            self.tableview.reloadData()
            // print("first closure")
            self.refreshControl.endRefreshing()
        }
        
        notificationManager.callFetchData()
        
        setUpTableView()
        dateFormatterPrint.dateFormat = "MM-dd HH:mm"
        dateFormatterPrint.timeZone = NSTimeZone(name: TimeZone.current.identifier) as TimeZone?
        // Do any additional setup after loading the view.
        
        self.refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableview.refreshControl = refreshControl
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Data...")
    }
    
    @objc func refresh(sender:Any){
        self.refreshControl.attributedTitle = NSAttributedString(string: "Fetching Data...")
        notificationManager.data.removeAll()
        /*
        notificationManager.reloadData = {data in
            print("second closure")
            self.refreshControl.endRefreshing()
        }
        */
        NetworkManager.stopRefresh = { () in
            // see redeemVC for full comments regarding this closure
            DispatchQueue.main.async{
                self.refreshControl.attributedTitle = NSAttributedString(string: "Error Fetching Data")
                self.refreshControl.endRefreshing()
            }
        }
        notificationManager.callFetchData()
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
        return notificationData.count
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
        let cell = tableview.dequeueReusableCell(withIdentifier: "notification_cell", for: indexPath) as! NotificationTableViewCell
        let currNotification = notificationData[indexPath.row]
        cell.notificationHeader?.text = currNotification.header ?? "NA"
        if let safeTime = currNotification.time {
            cell.notificationTime?.text = "Time Posted: \(dateFormatterPrint.string(from: safeTime))"
        } else {
            cell.notificationTime?.text = "Time Posted: N/A"
        }
        
        cell.notificationDescription?.text = currNotification.description ?? "NA"
        cell.announcementCategory.layer.masksToBounds = true
        cell.announcementCategory.layer.cornerRadius = 5
        cell.announcementCategory.sizeToFit()
        cell.announcementCategory.text = "  "+(currNotification.category ?? "")+"  "
        cell.colorCategoryLabel()
        return cell
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
    var notificationClicked: Notification?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        notificationClicked = notificationData[indexPath.row]
        performSegue(withIdentifier: "showDetail", sender: nil)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let viewController = segue.destination as? AnnouncementViewController {
            viewController.notification = notificationClicked
        }
    }

}
