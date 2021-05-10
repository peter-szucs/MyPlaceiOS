//
//  SettingsView.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-06.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userInfo: UserInfo
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        
        VStack(alignment: .center) {
            
            // MARK: Find a way to Cache this image (or use another method). it rerenders everytime a change is made (unless you change the image)
            
            ZStack {
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
                .frame(width: 130, height: 130, alignment: .center)
                .clipShape(Circle())
                .padding(.top, 20)
                
                if viewModel.changedImage != nil {
                    Button(action: {
                        viewModel.changedImage = nil
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.primary)
                    })
                    .padding(.bottom, 100)
                    .padding(.leading, 125)
                }
            }
            
            Divider()
                .padding([.horizontal, .top])
            
            FormTextView(text: LocalizedStringKey("Settings_userDetails"))
            TextField(LocalizedStringKey("FirstNamePlaceHolder"), text: $viewModel.newUserObject.firstName)
                .textFieldStyle(UserInfoTextFieldStyle())
                .keyboardType(.alphabet)
                .disableAutocorrection(true)
                .padding(.bottom, 10)
            
            TextField(LocalizedStringKey("LastNamePlaceHolder"), text: $viewModel.newUserObject.lastName)
                .textFieldStyle(UserInfoTextFieldStyle())
                .keyboardType(.alphabet)
                .disableAutocorrection(true)
                .padding(.bottom, 10)
            
            TextField(LocalizedStringKey("UserNamePlaceHolder"), text: $viewModel.newUserObject.userName)
                .textFieldStyle(UserInfoTextFieldStyle())
                .keyboardType(.alphabet)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding(.bottom, 10)
            
            Button(action: {
                viewModel.finalizeEditing { (result) in
                    if result {
                        userInfo.user = viewModel.newUserObject
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }, label: {
                Text(LocalizedStringKey("Save"))
            })
            .buttonStyle(ButtonStyleRegular(foregroundColor: .white, backgroundColor: Color("MainBlue")))
            .padding()
            .disabled(!viewModel.hasChanged || viewModel.isLoading)
            
            if viewModel.isLoading {
                ActivityView()
            }
            
            Spacer()
        }
        .onAppear {
            viewModel.setUpInfo(user: userInfo.user)
        }
        .navigationBarTitle(Text(LocalizedStringKey("Menu_profileSettings")), displayMode: .inline)
        .sheet(isPresented: $viewModel.showPickerAction, onDismiss: viewModel.loadImage) {
            //MARK: TODO: Let user choose camera or library ?
            ImagePicker(image: $viewModel.pickedImage, sourceType: .photoLibrary)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
