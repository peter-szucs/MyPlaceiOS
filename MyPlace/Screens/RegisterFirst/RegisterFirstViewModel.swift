//
//  RegisterFirstViewModel.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-05.
//

import SwiftUI
import Firebase

final class RegisterFirstViewModel: ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var goToNextScreen: Bool = false
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var rePassword: String = ""
    @Published var errorMessage: LocalizedStringKey = LocalizedStringKey("Empty")
    @Published var errorMessageColor: Color = .white
    
    func isEmailEmpty() -> Bool {
        return email == ""
    }
    
    func isPasswordEmpty() -> Bool {
        return password == ""
    }
    
    func isRePasswordEmpty() -> Bool {
        return rePassword == ""
    }
    
    func isFieldsEmpty() -> Bool {
        return isEmailEmpty() || isPasswordEmpty() || isRePasswordEmpty()
    }
    
    func isPasswordsEqual() -> Bool {
        return password == rePassword
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func validateCredentials() -> Bool {
        if !isFieldsEmpty() {
            if isValidEmail() {
                if isPasswordsEqual() {
                    errorMessage = LocalizedStringKey("OnboardingSuccess")
                    errorMessageColor = .white
                    return true
                } else {
                    errorMessage = LocalizedStringKey("OnboardingPassesMismatch")
                    errorMessageColor = .red
                    return false
                }
            } else {
                errorMessage = LocalizedStringKey("OnboardingInvalidEmail")
                errorMessageColor = .red
            }
        } else {
            errorMessage = LocalizedStringKey("OnboardingFieldsEmpty")
            errorMessageColor = .red
            return false
        }
        return false
    }
    
    func createUser() {
        if validateCredentials() {
            isLoading = true
            Auth.auth().createUser(withEmail: email, password: password) { [self] (result, error) in
                if error != nil {
                    // MARK: TODO: Alert to show error
                    print(error?.localizedDescription)
                    isLoading = false
                    return
                } else {
                    print("Success Creating User")
                    isLoading = false
                    goToNextScreen = true
                }
            }
        } else {
            print("Credentials not filled in properly")
        }
    }
}
