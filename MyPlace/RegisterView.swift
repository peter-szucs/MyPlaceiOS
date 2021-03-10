//
//  RegisterView.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-03-10.
//

import SwiftUI

struct RegisterView: View {
    
    @State var userObject = User()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Användarnamn")
                .font(.callout)
                .bold()
                .multilineTextAlignment(.leading)
                .padding(.leading)
            TextField("Användarnamn...", text: $userObject.userName, onEditingChanged: { (changed) in
                print("Usernamen oneditingchanged: \(changed)")
            }) {
                print("Username onCommit")
            }
            .padding([.leading, .bottom])
            .textFieldStyle(RoundedBorderTextFieldStyle())
            
            HStack(alignment: .center) {
                Spacer()
                Button {
                    print("Done tapped")
                } label: {
                    Text("Klar")
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
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
