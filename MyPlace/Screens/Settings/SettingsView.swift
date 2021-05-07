//
//  SettingsView.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-06.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var userInfo: UserInfo
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        
        VStack {
            FirebaseImage(id: userInfo.user.uid)
                .frame(width: 100, height: 100, alignment: .center)
                .clipShape(Circle())
        }
        .onAppear {
            print(userInfo.user)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
