//
//  AppDelegate.swift
//  Hamburger Button
//
//  Created by Robert Böhnke on 02/07/14.
//  Copyright (c) 2014 Robert Böhnke. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.backgroundColor = UIColor.whiteColor()
        self.window!.rootViewController = ViewController()
        self.window!.makeKeyAndVisible()
        return true
    }
}

