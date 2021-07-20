//
//  AppDelegate.swift
//  NerdDetector
//
//  Created by Motoshi Suzuki on 2021/07/10.
//

import UIKit
import Amplify
import AmplifyPlugins
import AWSCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        do {
            Amplify.Logging.logLevel = .verbose
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.configure()
            print("Amplify configured with Auth plugins")
        } catch {
            print("An error occurred setting up Amplify: \(error)")
        }
        
        let credentialsProvider = AWSCognitoCredentialsProvider(
            regionType: .APNortheast1,
            identityPoolId: "ap-northeast-1:ed73b243-e660-4ac9-a406-e13783b26e5e"
        )
        let awsConfig = AWSServiceConfiguration(
            region: .APNortheast1,
            credentialsProvider: credentialsProvider
        )
        AWSServiceManager.default().defaultServiceConfiguration = awsConfig
        
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


}

