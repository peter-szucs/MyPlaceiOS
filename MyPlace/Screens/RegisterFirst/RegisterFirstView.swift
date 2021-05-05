//
//  RegisterFirstView.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-04.
//

import SwiftUI

struct RegisterFirstView: View {
    
    @StateObject private var viewModel = RegisterFirstViewModel()
    
    var body: some View {
        
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
            
            FormTextView(text: LocalizedStringKey("ReEnterPassword"))
            SecureField(LocalizedStringKey("ReEnterPasswordPH"), text: $viewModel.rePassword)
                .padding([.leading, .trailing, .bottom])
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.default)
            
            
            Text(viewModel.errorMessage)
                .padding([.leading, .trailing])
                .foregroundColor(viewModel.errorMessageColor)
           
            
            HStack(alignment: .center) {
                Spacer()
                NavigationLink(
                    destination: RegisterSecondView(),
                    isActive: $viewModel.goToNextScreen,
                    label: {
                        
                    })
                Button {
                    if viewModel.validateCredentials() {
                        hideKeyboard()
                    }
                    viewModel.createUser()
                } label: {
                    Text(LocalizedStringKey("Next"))
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
        .navigationBarTitle(Text(LocalizedStringKey("Register, 1 of 2")), displayMode: .inline )
    }
}

struct RegisterFirstView_Preview: PreviewProvider {
    static var previews: some View {
        RegisterFirstView()
    }
}
