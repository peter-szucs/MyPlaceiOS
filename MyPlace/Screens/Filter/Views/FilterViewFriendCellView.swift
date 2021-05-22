//
//  FilterViewFriendCellView.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-20.
//

import SwiftUI

struct FilterViewFriendCellView: View {

    @State var user: Friend
    @State var isPressed = false
    @Binding var selectedUsers: [Friend]
    
    var isSelected: Bool {
        for i in 0..<selectedUsers.count {
            if selectedUsers[i].info.uid == user.info.uid {
                return true
            }
        }
        return false
    }
    
    var body: some View {
        HStack {
            FirebaseImage(id: user.info.uid)
                .frame(width: 40, height: 40, alignment: .center)
                .clipShape(Circle())
                .padding(10)
            Text(user.info.userName)
                .font(.title3)
            Spacer()
            
            if isSelected {
                Image(systemName: "checkmark")
                    .padding(.horizontal)
                    .foregroundColor(.green)
            }
        }
    }
}

struct FilterViewFriendCellView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id:\.self) {
            FilterViewFriendCellView(user: Friend(info: User(uid: "", firstName: "Pete", lastName: "Switch", userName: "Pettin", friends: [], places: []), status: "accepted"), selectedUsers: .constant([]))
//                .previewLayout(.fixed(width: UIScreen.main.bounds.width, height: 80)).preferredColorScheme($0)
                .previewLayout(.sizeThatFits).preferredColorScheme($0)
        }
    }
}
