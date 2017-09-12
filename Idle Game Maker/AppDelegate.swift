//
//  AppDelegate.swift
//  Idle Game Maker
//
//  Created by Albert Wu on 9/2/17.
//  Copyright © 2017 Old Friend. All rights reserved.
//

import UIKit
import os.log

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var games: NSMutableDictionary = NSMutableDictionary()
    var timeSinceLastOpened: Double = 0.0
    var gamesNeedToSaveLastTime = NSMutableDictionary()
    
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("games")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if let savedGames = loadGames() {
            games = savedGames
        }
        if let savedLastTime = loadTimeLastClosed() {
            timeSinceLastOpened = NSTimeIntervalSince1970 - savedLastTime
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        saveTimeLastClosed()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    //MARK: Private Methods
    private func loadGames() -> NSMutableDictionary? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: AppDelegate.ArchiveURL.path) as? NSMutableDictionary
    }
    
    private func loadTimeLastClosed() -> TimeInterval? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: AppDelegate.DocumentsDirectory.appendingPathComponent("timelastclosed").path) as? TimeInterval
    }
    
    private func saveTimeLastClosed() {
        let timeLastClosed = NSTimeIntervalSince1970
        for name in gamesNeedToSaveLastTime.allKeys {
            let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(timeLastClosed, toFile: AppDelegate.DocumentsDirectory.appendingPathComponent("timelastclosedfor" + (name as! String)).path)
            if isSuccessfulSave {
                os_log("Saving timelastclosed for was successful", log: OSLog.default, type: .debug)
            }
            else {
                os_log("Failed to save timelastclosed...", log: OSLog.default, type: .debug)
            }
        }
        
        
    }
    
    //MARK: GLOBAL STATIC FUNCTIONS
    static func deleteFile(path: String) -> Bool{
        let exists = FileManager.default.fileExists(atPath: path)
        if exists {
            do {
                try FileManager.default.removeItem(atPath: path)
            }catch let error as NSError {
                print("error: \(error.localizedDescription)")
                return false
            }
        }
        return exists
    }
    static func saveGames(gamesPassed: NSMutableDictionary) {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(gamesPassed, toFile: AppDelegate.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Saving games with global function was successful", log: OSLog.default, type: .debug)
        }
        else {
            os_log("Failed to save games with global function...", log: OSLog.default, type: .debug)
        }
        //save the current gameIdentifier to know which game
        //was last displayed by the buildingTableViewController
    }
    

}

