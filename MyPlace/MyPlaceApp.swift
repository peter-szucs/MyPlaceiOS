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
    var user: User?
    init() {
        FirebaseApp.configure()
//        user = Auth()
    }
    
    var body: some Scene {
        WindowGroup {
            if user != nil {
//                MapView()
            } else {
                FirstPageView()
    //                .environmentObject(user)
            }
            
        }
    }
}
