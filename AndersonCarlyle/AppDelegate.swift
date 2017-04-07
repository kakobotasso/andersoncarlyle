//
//  AppDelegate.swift
//  AndersonCarlyle
//
//  Created by Kako Botasso on 01/04/17.
//  Copyright © 2017 Kako Botasso & Anderson Macedo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        var appDefaults = [String: Any]()
        appDefaults["cotacao_dolar"] = "3.2"
        appDefaults["iof"] = "6.38"
        UserDefaults.standard.register(defaults: appDefaults)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {}

    func applicationWillTerminate(_ application: UIApplication) {}


}

