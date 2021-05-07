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
        
        VStack(alignment: .center) {
            Button(action: {
                viewModel.showPickerAction = true
            }, label: {
                if viewModel.changedImage != nil {
                    viewModel.changedImage?
                        .resizable()
                        .scaledToFill()
                } else {
                    FirebaseImage(id: userInfo.user.uid)
                }
            })
            .frame(width: 100, height: 100, alignment: .center)
            .clipShape(Circle())
            .padding(.top, 20)
            
            TextField(LocalizedStringKey("FirstNamePlaceHolder"), text: $viewModel.firstName)
                .textFieldStyle(UserInfoTextFieldStyle())
                .keyboardType(.alphabet)
                .disableAutocorrection(true)
            
        }
        .onAppear {
            viewModel.originalUserObject = userInfo.user
        }
        .navigationBarTitle(Text(LocalizedStringKey("Menu_profileSettings")), displayMode: .inline)
        .sheet(isPresented: $viewModel.showPickerAction, onDismiss: viewModel.loadImage) {
            ImagePicker(image: $viewModel.pickedImage)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
