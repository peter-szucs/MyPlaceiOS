//
//  LoginViewModel.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-04.
//

import SwiftUI
import Firebase

final class LoginViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var logIn = false
    @Published var errorMessage = LocalizedStringKey("Empty")
    @Published var errorMessageColor: Color = Color("MainBW")
    
    func signInUser() {
        isLoading = true
        if (email == "" && password == "") {
            errorMessage = LocalizedStringKey("OnboardingFieldsEmpty")
            errorMessageColor = .red
            isLoading = false
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                self.handleError(error!)
                self.isLoading = false
                return
            }
            self.errorMessageColor = Color("MainBW")
            print(result!)
            self.logIn = true
            self.isLoading = false
        }
        
    }
    
    func handleError(_ error: Error) {
        if let errorCode = AuthErrorCode(rawValue: error._code) {
            print(errorCode.errorMessage)
            self.errorMessage = errorCode.errorMessage
            self.errorMessageColor = .red
        }
    }
}

extension AuthErrorCode {
    var errorMessage: LocalizedStringKey {
        switch self {
        case .networkError:
            return LocalizedStringKey("FIRerror_NetworkError")
        case .invalidEmail:
            return LocalizedStringKey("FIRerror_InvalidEmail")
        case .wrongPassword:
            return LocalizedStringKey("FIRerror_WrongPassword")
        case .userNotFound:
            return LocalizedStringKey("FIRerror_UserNotFound")
        default:
            return LocalizedStringKey("UnknownError")
        }
    }
}

