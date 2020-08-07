//
//  LocationManager.swift
//  QRReader
//
//  Created by Anni Chen on 7/21/20.
//  Copyright © 2020 Anni Chen. All rights reserved.
//


import Foundation
import UIKit
import MapKit
import CoreLocation
import UserNotifications

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static var locationManager = CLLocationManager()
    var dateFormatterPrint = DateFormatter()
    var event:Event?
//    static var timer = Timer()
//    static var timerDisplayered = 0;
    override init () {
        super.init()
        LocationManager.locationManager.requestAlwaysAuthorization()
        LocationManager.locationManager.requestWhenInUseAuthorization()
        LocationManager.locationManager.delegate = self
        LocationManager.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        LocationManager.locationManager.startUpdatingLocation()
        dateFormatterPrint.dateFormat = "MM/dd/YYYY h:mma"
        dateFormatterPrint.timeZone = NSTimeZone(name: TimeZone.current.identifier) as TimeZone?
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
    }
    func setCenter(event: Event) {
        guard let locValue: CLLocationCoordinate2D = LocationManager.locationManager.location?.coordinate else {return}
//        LocationManager.timer.invalidate();
//        LocationManager.timerDisplayered = 0;
//        LocationManager.timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(incrementTimer), userInfo: nil, repeats: true)
        self.event = event
        let center = CLLocationCoordinate2D(latitude: locValue.latitude, longitude: locValue.longitude)
        if event.radius == "None" {
            if let safeCategory = event.category {
                updateWeb(status: "none", eventID: String(event.id), eventCategory: safeCategory)
            }
            return
        }
        var radius = 20.0
        if event.radius == "Medium (20m - 100m)" {
            radius = 100.0
        } else if event.radius == "Large (100m - 300m)" {
            radius = 300.0
        }
        let region = CLCircularRegion(center: center, radius: radius, identifier: "center")
        region.notifyOnEntry = true
        region.notifyOnExit = true
        if let safeCategory = event.category {
            updateWeb(status: "enter", eventID: String(event.id), eventCategory: safeCategory)
        } else {
            print("Error, event category is nil.")
        }
        
        
        
        LocationManager.locationManager.startMonitoring(for: region)
        
    }
    
//    @objc func incrementTimer() {
//        LocationManager.timerDisplayered += 1
//        print(LocationManager.timerDisplayered)
//    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Arrive: \(region.identifier)")
        fireNotification(notificationText: "Did Arrive: region.", didEnter: true)
//        LocationManager.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(incrementTimer), userInfo: nil, repeats: true)
        print("Arrive ------")
        
        
    }
     
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Leave: \(region.identifier)")
        
        fireNotification(notificationText: "Did Exit: region", didEnter: false)
        print("Leave ------")
        if let safeEvent = event, let safeCategory = safeEvent.category {
            updateWeb(status: "leave", eventID: String(safeEvent.id), eventCategory: safeCategory)
            LocationManager.locationManager.stopMonitoring(for: region)
        } else {
            print("Error, event/ event category is nil")
        }
        
    }
    
    func fireNotification(notificationText: String, didEnter: Bool) {
        print("fire")
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.getNotificationSettings { (settings) in
            if settings.alertSetting == .enabled {
                let content = UNMutableNotificationContent()
                content.title = didEnter ? "Entered Region" : "Exited Region"
                content.body = notificationText
                content.sound = UNNotificationSound.default
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                
                let request = UNNotificationRequest(identifier: "Test", content: content, trigger: trigger)
                
                notificationCenter.add(request, withCompletionHandler: { (error) in
                    if error != nil {
                        print("Error adding notification with identifier ")
                    }
                })
            }
        }
    }
    
    func updateWeb(status:String, eventID:String, eventCategory:String) {
        
        let dic = ["status": status, "eventID": eventID, "eventCategory": eventCategory] as [String : String]
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(dic) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                var data = Data()
                do{
                    data = try JSONEncoder().encode(jsonString)
                    
                    let u = Bundle.main.object(forInfoDictionaryKey: "NetworkURL") as! String + "/attend/\(User.globalUser.id)"
                    print(User.globalUser.id)
                    NetworkManager.uploadData(uploadData: data, specific_url: u, httpMethod: "POST", completion: {responseData in
                        if let message = responseData["status"] as? String {
                            if message == "SUCCESS in enter" || message == "FAIL in enter" {
//                                 render json: {status: 'SUCCESS in enter', data: attendance, user: nil}, status: :ok
                                if let attendance = responseData["data"] as? Dictionary<String,Any> {
                                    self.handleResponseData(status, message, attendance, nil)
                                }
                            } else if message == "FAIL in leave" {
//                                render json: {status: 'FAIL in leave', data: nil, user: nil}, status: :ok
                                self.fireNotification(notificationText: "Error. Exiting before entering.", didEnter: status=="enter")
                                return;
                            } else if message == "SUCCESS in leave" || message == "SUCCESS in none" {
//                                render json: {status: 'SUCCESS in leave', data: attendance, user: user}, status: :ok
                                if let attendance = responseData["data"] as? Dictionary<String,Any>, let user = responseData["user"] as? Dictionary<String,Any>{
                                    self.handleResponseData(status, message, attendance, user)
                                }
                            } else if message == "Attended events before" || message == "FAIL in none" {
                                self.fireNotification(notificationText: "Sorry, you could not attend this event because you have attended it before.", didEnter: true)
                            }
                            
                        }
                        
                    })
                    
                    
                }catch{
                    print("Error encoding user data in LocationManager")
                }
                
            }
        }
    }
    
    func handleResponseData(_ status:String,_ message:String,_ attendance: Dictionary<String,Any>, _ user:Dictionary<String,Any>?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"
        
        let defaultTime = dateFormatter.date(from: "1970-01-01T00:00:00.000-00:00")
        if status == "enter" {
            if let safeArrivalTime = attendance["arrivalTime"] {
                print("savearrivaltime")
                print(safeArrivalTime)
                let arriveTime = dateFormatter.date(from: safeArrivalTime as! String)
                let arriveString = dateFormatterPrint.string(from: (arriveTime ?? defaultTime!))
                print(arriveString)
                if message == "SUCCESS in enter" {
                    fireNotification(notificationText: "SUCCESS! Checked in \(event!.name) at \(arriveString)", didEnter: true)
                } else if message == "FAIL in enter" || message == "FAIL in none" {
                    fireNotification(notificationText: "You have already checked in \(event!.name) at \(arriveString)", didEnter: true)
                }
            } else {
                fireNotification(notificationText: "Error. Arrival time is nil.", didEnter: true)
            }
            
        } else if status == "leave" || status == "none" {
            if message == "SUCCESS in leave" || message == "SUCCESS in none" {
                let exitTime = dateFormatter.date(from: attendance["exitTime"] as! String)
                let exitString = dateFormatterPrint.string(from: (exitTime ?? defaultTime!))
//                fireNotification(notificationText: "Congrats! You've earned \(attendance["pointsEarned"])", didEnter: true)
                if let safeUser = user {
                    User.globalUser.accumulated_total_points = safeUser["accumulated_total_points"] as? Int
                    User.globalUser.accumulated_athletics_points = safeUser["accumulated_athletics_points"] as? Int
                    User.globalUser.accumulated_dining_points = safeUser["accumulated_dining_points"] as? Int
                    User.globalUser.athletics_points = safeUser["athletics_points"] as? Int
                    User.globalUser.dining_points = safeUser["dining_points"] as? Int
                } else {
                    print("Error: user should not be nil.")
                }
                fireNotification(notificationText: "Congrats! You've checked out \(event!.name) at \(exitString) and earned \(attendance["pointsEarned"]!) points.", didEnter: false)
            }
        }
    }
    
    
}

