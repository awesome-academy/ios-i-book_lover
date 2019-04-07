//
//  AppDelegate.swift
//  ios-i-book-lover
//
//  Created by nguyen.nam.khanh on 4/3/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {        
        if checkRecordExists() {
            if let vc = Storyboards.main.instantiateViewController(withIdentifier: TabBarController.className)
                as? TabBarController {
                window?.rootViewController = vc
            }
        } else {
            if let vc = Storyboards.home.instantiateViewController(withIdentifier: WelcomeViewController.className)
                as? WelcomeViewController {
                window?.rootViewController = vc
            }
        }

        return true
    }

    func checkRecordExists() -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.includesSubentities = false
        
        var entitiesCount = 0
        
        do {
            entitiesCount = try managedContext.count(for: fetchRequest)
        } catch {
            print("error executing fetch request: \(error)")
        }
        
        return entitiesCount > 0
    }
    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BookLover")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

