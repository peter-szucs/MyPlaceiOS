//
//  SplashView.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-06.
//

import SwiftUI
import Firebase

struct SplashView: View {
    
    @EnvironmentObject var userInfo: UserInfo
    @StateObject private var viewModel = SplashViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if userInfo.isUserAuthenticated == .undefined {
                    SplashLoadingView()
                } else if userInfo.isUserAuthenticated == .signedOut {
                    FirstPageView()
                } else if userInfo.isUserAuthenticated == .signedIn {
                    MapView()
                } else {
                    RegisterSecondView()
                }
            }
            .onAppear {
                self.userInfo.initialSetup()
                
            }
        }
        
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}


