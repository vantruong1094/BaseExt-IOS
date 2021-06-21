//
//  AppDelegate.swift
//  BaseExtension
//
//  Created by Chu Van Truong on 12/9/19.
//  Copyright © 2019 Chu Van Truong. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: BMIViewController())
        window?.makeKeyAndVisible()
        return true
    }

}

