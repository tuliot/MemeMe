//
//  AppDelegate.swift
//  MemeMe
//
//  Created by Tulio Troncoso on 8/22/16.
//  Copyright © 2016 Tulio. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        // Configure Firebase
        FIRApp.configure()
        FIRDatabase.database().persistenceEnabled = true

        FIRAuth.auth()?.signInWithEmail("blah@blah.com", password: "top_secret") { (user, error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }

//        var myRootRef = FIRDatabase.database().reference()
//        myRootRef.observeEventType(.Value) { (snapshot) in
//            print("\(snapshot.key) -> \(snapshot.value)")
//
//
//        }
//
//        let brianRef = FIRStorage.storage().referenceForURL("gs://meme-me.appspot.com/Leonardo-Cheers.jpg")
//
//        brianRef.dataWithMaxSize(4 * 1024 * 1024) { (data, error) -> Void in
//            if (error != nil) {
//                // Uh-oh, an error occurred!
//                print(error)
//            } else {
//                // Data for "images/island.jpg" is returned
//                let leoImage: UIImage! = UIImage(data: data!)
//                print(leoImage)
//            }
//        }

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

