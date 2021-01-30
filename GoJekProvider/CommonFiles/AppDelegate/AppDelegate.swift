//
//  AppDelegate.swift
//  GoJekProvider
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Stripe
import CoreData
import Firebase
import GoogleMaps
import GooglePlaces
import GoogleSignIn
import UserNotifications
import IQKeyboardManagerSwift
import FBSDKCoreKit
import FirebaseCore

var tempRequestId: String? = ""
var tempRequestType: ActiveStatus? = Optional.none

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark {
                isDarkMode = true
            }
            else {
                isDarkMode = false
            }
        }
        didFinishLaunchingSetup()
        registerPush(forApp: application)
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        XSocketIOManager.sharedInstance.closeSocketConnection()
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        if #available(iOS 13.0, *) {
             if UITraitCollection.current.userInterfaceStyle == .dark {
                 isDarkMode = true
             }
             else {
                 isDarkMode = false
             }
         }
         else{
             isDarkMode = false
         }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
            if #available(iOS 13.0, *) {
             if UITraitCollection.current.userInterfaceStyle == .dark {
                 isDarkMode = true
             }
             else {
                 isDarkMode = false
             }
         }
         else{
             isDarkMode = false
         }
        XSocketIOManager.sharedInstance.establishSocketConnection()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "GoJekProvider")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension AppDelegate {
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
           return GIDSignIn.sharedInstance()?.handle(url) ?? false  || ApplicationDelegate.shared.application(app, open: url, options: options)
       }
    
    private func setRootController() {
        // Override point for customization after application launch.
        let splash = LoginRouter.createLoginModule()
        let navigationController = UINavigationController()
        navigationController.viewControllers = [splash]
        navigationController.isNavigationBarHidden = true
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    private func setAppearance() {
        //tab bar style
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.setCustomFont(name: .medium, size: .x12)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.setCustomFont(name: .medium, size: .x12)], for: .selected)
    }
    
    func localizable() {
        
        if let languageStr = UserDefaults.standard.value(forKey: MyAccountConstant.Language) as? String, let language = Language(rawValue: languageStr) {
            LocalizeManager.share.setLocalization(language: language)
        }else {
            LocalizeManager.share.setLocalization(language: .english)
        }
    }
    
    func didFinishLaunchingSetup() {
        UNUserNotificationCenter.current().delegate = self
        IQKeyboardManager.shared.enable = true
        FirebaseApp.configure()
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        localizable()
        setAppearance()
        XSocketIOManager.sharedInstance.establishSocketConnection()
        startNetworkMonitoring()
        setRootController()
    }
    
    func startNetworkMonitoring() {
        let reachability = Reachability()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.reachabilityChanged),
                                               name: ReachabilityChangedNotification,
                                               object: reachability)
        do {
            try reachability?.startNotifier()
        } catch {
            print("Could not start reachability notifier")
        }
    }
    
    @objc func reachabilityChanged(notification: Notification) {
        let reachability = notification.object as! Reachability
        switch reachability.currentReachabilityStatus {
        case .notReachable:
            print("Network became unreachable")
            
        case .reachableViaWiFi:
            print("Network reachable through WiFi")
            
        case .reachableViaWWAN:
            print("Network reachable through Cellular Data")
        }
    }
}

//MARK:- UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        deviceTokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("Apn Token ", deviceTokenString)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound])
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void)
    {
        print(response)
        
        let json = response.notification.request.content.userInfo
        if let theJSONData = try?  JSONSerialization.data(withJSONObject: json,options: .prettyPrinted),let theJSONText = String(data: theJSONData,encoding: String.Encoding.ascii) {
            print("JSON string = \n\(theJSONText)")
        }
        
        let notification = json["message"] as? [String:Any]
        let notificationType =  notification!["topic"] as? String
        
       
        
        if notificationType == pushNotificationType.chat_transport.rawValue {
                   //UIApplication.topViewController()?.navigationController?.popViewController(animated: true)
                   NotificationCenter.default.post(name: Notification.Name(pushNotificationType.chat_transport.rawValue), object: nil)
               }

        //For ChatOrder
        
        if notificationType == pushNotificationType.chat_order.rawValue {
            //UIApplication.topViewController()?.navigationController?.popViewController(animated: true)
            NotificationCenter.default.post(name: Notification.Name(pushNotificationType.chat_order.rawValue), object: nil)
        }
        if notificationType == pushNotificationType.chat_service.rawValue {
                   //UIApplication.topViewController()?.navigationController?.popViewController(animated: true)
                   NotificationCenter.default.post(name: Notification.Name(pushNotificationType.chat_service.rawValue), object: nil)
        }
        
        
        //For Chat
               
               if notificationType == pushNotificationType.chat.rawValue {
                   //UIApplication.topViewController()?.navigationController?.popViewController(animated: true)
                   NotificationCenter.default.post(name: Notification.Name(pushNotificationType.chat.rawValue), object: nil)
               }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("Error in Notification  \(error.localizedDescription)")
    }
    
    // MARK:- Register Push
    private func registerPush(forApp application : UIApplication) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.alert, .sound]) { (granted, error) in
            
            if granted {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        }
    }
}
