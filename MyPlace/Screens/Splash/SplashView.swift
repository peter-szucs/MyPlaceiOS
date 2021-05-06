//
//  SplashView.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-06.
//

import SwiftUI

struct SplashView: View {
    
    @EnvironmentObject var userInfo: UserInfo
    
    var body: some View {
        Group {
            if userInfo.isUserAuthenticated == .undefined {
                SplashLoadingView()
                
            } else if userInfo.isUserAuthenticated == .signedOut {
                FirstPageView()
            } else {
                MapView()
            }
        }
        .onAppear {
            self.userInfo.configureFirebaseStateDidChange()
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}


