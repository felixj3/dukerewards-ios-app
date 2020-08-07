//
//  SceneDelegate.swift
//  DukeRewards
//
//  Created by codeplus on 6/3/20.
//  Copyright © 2020 Duke University. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let screenHeight = UIScreen.main.bounds.size.height
        print("The height of the screen is \(screenHeight)")
        
        // Return the correct storyboard
        let storyboard: UIStoryboard = returnStoryboard()
        
        // Display the correct storyboard
        self.window?.rootViewController = storyboard.instantiateInitialViewController()
        self.window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    func returnStoryboard() -> UIStoryboard {
        let screenHeight = UIScreen.main.bounds.size.height
        var storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        switch screenHeight {
        // iPhone 11, 11 Pro Max
        case 896.0:
            storyboard = UIStoryboard(name: "Main", bundle: nil)
            LayoutLibraryViewController.currentStoryboard = "Main"
            print("This is the 896 storyboard")
            break
        // iPhone 11 Pro, X
        case 812.0:
            storyboard = UIStoryboard(name: "Main-812", bundle: nil)
            LayoutLibraryViewController.currentStoryboard = "Main-812"
            print("This is the 812 storyboard")
            break
        // iPhone 8 Plus, 7 Plus
        case 736.0:
            storyboard = UIStoryboard(name: "Main-736", bundle: nil)
            LayoutLibraryViewController.currentStoryboard = "Main-736"
            print("This is the 736 storyboard")
            break
        // iPhone 8, SE, 6s, 7
        case 667.0:
            storyboard = UIStoryboard(name: "Main-667", bundle: nil)
            LayoutLibraryViewController.currentStoryboard = "Main-667"
            print("This is the 667 storyboard")
            break
        default:
            storyboard = UIStoryboard(name: "Main", bundle: nil)
            LayoutLibraryViewController.currentStoryboard = "Main"
            print("This is the 896 storyboard")
            break
        }
        return storyboard
    }


}

