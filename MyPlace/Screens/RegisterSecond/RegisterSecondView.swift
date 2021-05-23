//
//  RegisterSecondView.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-03-10.
//

import SwiftUI
import FirebaseAuth

struct RegisterSecondView: View {
    
    @EnvironmentObject var userInfo: UserInfo
    @StateObject private var viewModel = RegisterSecondViewModel()
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            HStack(alignment: .center) {
                Spacer()
                Button {
                    viewModel.showPickerAction = true
                } label: {
                    if viewModel.profileImage != nil {
                        viewModel.profileImage?
                            .resizable()
                            .scaledToFill()
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color("MainLightBlue"))
                    }

                }
                .frame(width: 150, height: 150, alignment: .center)
                .clipShape(Circle())
                .padding(.vertical)
                Spacer()
            }
            FormTextView(text: LocalizedStringKey("FirstName"))
            TextField(LocalizedStringKey("FirstNamePlaceHolder"), text: $viewModel.firstName)
                .textFieldStyle(UserInfoTextFieldStyle())
                .keyboardType(.alphabet)
                .disableAutocorrection(true)
            
            FormTextView(text: LocalizedStringKey("LastName"))
            TextField(LocalizedStringKey("LastNamePlaceHolder"), text: $viewModel.lastName)
                .textFieldStyle(UserInfoTextFieldStyle())
                .keyboardType(.alphabet)
                .disableAutocorrection(true)
            
            FormTextView(text: LocalizedStringKey("UserName"))
            TextField(LocalizedStringKey("UserNamePlaceHolder"), text: $viewModel.userName)
                .textFieldStyle(UserInfoTextFieldStyle())
                .keyboardType(.alphabet)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            HStack(alignment: .center) {
                Spacer()
//                NavigationLink(
//                    destination: MapView(),
//                    isActive: $viewModel.finalizeReg,
//                    label: {
//
//                    })
                Button {
                    if viewModel.validateFields() {
                        hideKeyboard()
                        print("View validated fields")
                    }
                    viewModel.finalizeRegistration { (result) in
                        if result {
                            print("Succesful registration")
                            guard let uid = Auth.auth().currentUser?.uid else { return }
                            FirebaseRepository.retrieveUser(uid: uid) { (result) in
                                switch result {
                                case .failure(let error):
                                    print("Error retrieving user:", error)
                                case .success(let user):
                                    self.userInfo.user = user
//                                    self.userInfo.user.uid = uid
                                    userInfo.isUserAuthenticated = .signedIn
                                }
                            }
                        }
                    }
                } label: {
                    Text(LocalizedStringKey("Done"))
                }
                .buttonStyle(ButtonStyleRegular(foregroundColor: .white, backgroundColor: Color("MainBlue")))
                .padding(.top)
                Spacer()
            }
            if viewModel.isLoading {
                ActivityView()
                Spacer()
            }
            Spacer()
        }
        .navigationBarTitle(Text(LocalizedStringKey("Register")), displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $viewModel.showPickerAction, onDismiss: viewModel.loadImage) {
            // MARK: TODO: Add alert or box to choose camera of library
            ImagePicker(image: $viewModel.pickedImage, sourceType: .photoLibrary)
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterSecondView()
    }
}
