//
//  FriendsListCellView.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-07.
//

import SwiftUI

struct FriendsListCellView: View {
    
    var user: User
    
    var body: some View {
        HStack {
            FirebaseImage(id: user.uid)
                .frame(width: 32, height: 32, alignment: .center)
            Text(user.userName)
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width, height: 60)
    }
}

struct FriendsListCellView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsListCellView(user: User(uid: "", firstName: "Pete", lastName: "Switch", userName: "Pettin"))
            .previewLayout(.fixed(width: UIScreen.main.bounds.width, height: 60))
    }
}
