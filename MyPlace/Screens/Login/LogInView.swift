//
//  LogInView.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-03-11.
//

import SwiftUI

struct LogInView: View {
    
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        VStack(alignment: .leading) {
//            HStack {
//                Spacer()
//                VStack(alignment: .center) {
//                    Text("myPlace")
//                        .bold()
//                        .font(Font.system(size: 60, weight: .bold))
//                    Image("Logo")
//                        .offset(x: 0, y: -50)
////                        .padding(.bottom, 100)
//                        .shadow(color: .gray, radius: 3, x: 0.0, y: 5)
//                }
//                Spacer()
//            }
            VStack(alignment: .leading) {
                FormTextView(text: LocalizedStringKey("EMail"))
                TextField(LocalizedStringKey("EMailPlaceHolder"), text: $email, onEditingChanged: { (changed) in
                    print("EMail oneditingchanged: \(changed)")
                }) {
                    print("EMail onCommit: \(email)")
                }
                .padding([.leading, .trailing, .bottom])
                .textFieldStyle(RoundedBorderTextFieldStyle())
                
                FormTextView(text: LocalizedStringKey("Password"))
                TextField(LocalizedStringKey("PasswordPlaceHolder"), text: $password)
                    .padding([.leading, .trailing, .bottom])
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 20)
                
                HStack(alignment: .center) {
                    Spacer()
                    Button {
                        print("Done tapped")
                    } label: {
                        Text(LocalizedStringKey("Done"))
                    }
                    .buttonStyle(ButtonStyleRegular(foregroundColor: .white, backgroundColor: Color("MainBlue")))
                    Spacer()
                }
                Spacer()
            }
//            .offset(x: 0, y: -50)
        }
        .navigationBarTitle(Text(LocalizedStringKey("LogIn")), displayMode: .inline)
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
