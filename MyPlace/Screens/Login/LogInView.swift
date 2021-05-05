//
//  LogInView.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-03-11.
//

import SwiftUI

struct LogInView: View {
    
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            VStack(alignment: .leading) {
                FormTextView(text: LocalizedStringKey("EMail"))
                TextField(LocalizedStringKey("EMailPlaceHolder"), text: $viewModel.email)
                    .padding([.leading, .trailing, .bottom])
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                FormTextView(text: LocalizedStringKey("Password"))
                SecureField(LocalizedStringKey("PasswordPlaceHolder"), text: $viewModel.password)
                    .padding([.leading, .trailing, .bottom])
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.default)
                
                Text(viewModel.errorMessage)
                    .padding([.leading, .trailing])
                    .foregroundColor(viewModel.errorMessageColor)
                
                HStack(alignment: .center) {
                    Spacer()
                    NavigationLink(
                        destination: MapView(),
                        isActive: $viewModel.logIn,
                        label: {
                            
                        })
                    Button {
                        hideKeyboard()
                        viewModel.signInUser()
                    } label: {
                        Text(LocalizedStringKey("Done"))
                    }
                    .buttonStyle(ButtonStyleRegular(foregroundColor: .white, backgroundColor: Color("MainBlue")))
                    .padding(.top, 20)
                    Spacer()
                }
                if viewModel.isLoading {
                    ActivityView()
                    Spacer()
                }
                Spacer()
            }
        }
        .navigationBarTitle(Text(LocalizedStringKey("LogIn")), displayMode: .inline)
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}


