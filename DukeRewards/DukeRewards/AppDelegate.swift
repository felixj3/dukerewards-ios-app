//
//  AppDelegate.swift
//  DukeRewards
//
//  Created by codeplus on 6/3/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    
    var window: UIWindow?
    var notificationCenter: UNUserNotificationCenter!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.notificationCenter = UNUserNotificationCenter.current()
        
        // register as it's delegate
        notificationCenter.delegate = self
        
        // define what do you need permission to use
        let options: UNAuthorizationOptions = [.alert, .sound]
        
        // request permission
        notificationCenter.requestAuthorization(options: options) { (granted, error) in
            if !granted {
                print("Permission not granted")
            }
        }
        
        if launchOptions?[UIApplication.LaunchOptionsKey.location] != nil {
            print("I woke up thanks to geofencing")
        }
        // Override point for customization after application launch.
        return true
    }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        print("url is \(url.absoluteString)")
        return true
    }
    
    
    

}



extension AppDelegate: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // when app is onpen and in foregroud
        completionHandler(.alert)
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

           // get the notification identifier to respond accordingly
           let identifier = response.notification.request.identifier

           // do what you need to do
           print(identifier)
           // ...
       }

}
