//
//  MyPlaceApp.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-03-10.
//

import SwiftUI
import Firebase

@main
struct MyPlaceApp: App {
    
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var userInfo = UserInfo()

    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            SplashView()
                .environmentObject(userInfo)
        }
    }
}
