//
//  RegisterView.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-03-10.
//

import SwiftUI

struct RegisterView: View {
    
    @State var userObject = User()
    @State var showPickerAction = false
    @State var pickedImage = UIImage()
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack(alignment: .center) {
                Spacer()
                Button {
                    print("ImageButton tapped")
                } label: {
                    if (userObject.profileImage != nil) {
                        Image(uiImage: pickedImage)
                            .resizable()
                            .scaledToFit()
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color("MainLightBlue"))
                    }
                    
                }
                .frame(width: 130, height: 130, alignment: .center)
                .clipShape(Circle())
                .padding()
                Spacer()
            }
            
            Text(LocalizedStringKey("FirstName"))
                .font(.callout)
                .bold()
                .multilineTextAlignment(.leading)
                .padding(.leading)
            TextField(LocalizedStringKey("FirstNamePlaceHolder"), text: $userObject.firstName, onEditingChanged: { (changed) in
                print("FirstName oneditingchanged: \(changed)")
            }) {
                print("FirstName onCommit: \(userObject.firstName)")
            }
            .padding([.leading, .trailing, .bottom])
            .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Text(LocalizedStringKey("LastName"))
                .font(.callout)
                .bold()
                .multilineTextAlignment(.leading)
                .padding(.leading)
            TextField(LocalizedStringKey("LastNamePlaceHolder"), text: $userObject.lastName, onEditingChanged: { (changed) in
                print("LastName oneditingchanged: \(changed)")
            }) {
                print("LastName onCommit: \(userObject.lastName)")
            }
            .padding([.leading, .trailing, .bottom])
            .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Text(LocalizedStringKey("UserName"))
                .font(.callout)
                .bold()
                .multilineTextAlignment(.leading)
                .padding(.leading)
            TextField(LocalizedStringKey("UserNamePlaceHolder"), text: $userObject.userName, onEditingChanged: { (changed) in
                print("Username oneditingchanged: \(changed)")
            }) {
                print("Username onCommit: \(userObject.userName)")
            }
            .padding([.leading, .trailing, .bottom])
            .textFieldStyle(RoundedBorderTextFieldStyle())
            
            HStack(alignment: .center) {
                Spacer()
                Button {
                    print("Done tapped")
                } label: {
                    Text(LocalizedStringKey("Done"))
                        .font(.headline)
                        .padding()
                }
                .frame(width: 150, alignment: .center)
                .foregroundColor(.white)
                .background(Color("MainBlue"))
                .cornerRadius(5)
                Spacer()
            }
            Spacer()
        }
        .navigationBarTitle(Text(LocalizedStringKey("Register")), displayMode: .inline)
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
