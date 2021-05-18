//
//  TabBarView.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-17.
//

import SwiftUI

struct TabBarView: View {
    
    @Binding var offset: CGFloat
    @Binding var tagNr: Int
    @State var width: CGFloat = 0
    var tabs: [LocalizedStringKey]
    
    var body: some View {
        GeometryReader { proxy -> AnyView in
            
            let equalWidth = proxy.frame(in: .global).width / CGFloat(tabs.count)
            
            DispatchQueue.main.async {
                self.width = equalWidth
            }
            
            return AnyView(
                ZStack(alignment: .bottomLeading, content: {
                    
                    Capsule()
                        .fill(Color("MainBlue"))
                        .frame(width: equalWidth - 15, height: 4)
                        .offset(x: getOffset() + 7, y: 1)
                    
                    HStack(spacing: 0) {
                        ForEach(tabs.indices, id:\.self) { index in
                            Text(tabs[index])
                                .font(.footnote)
                                .fontWeight(.bold)
                                .foregroundColor((getIndexFromOffset() == CGFloat(index) ? .primary : .secondary))
                                .frame(width: equalWidth, height: 40)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    withAnimation {
                                        tagNr = index
                                    }
                                }
                        }
                    }
                })
                .frame(maxWidth: .infinity, maxHeight: 40, alignment: .center)
//                .clipShape(Capsule())
            )
        }
        .padding()
        .frame(height: 40)
    }
    
    func getOffset() -> CGFloat {
        let progress = offset / UIScreen.main.bounds.width
        
        return progress * width
    }
    
    // To change font color if using colored "Cell"
    func getIndexFromOffset() -> CGFloat {
        let indexFloat = offset / UIScreen.main.bounds.width
        return indexFloat.rounded(.toNearestOrAwayFromZero)
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsListView(viewModel: FriendsListViewModel(friendsList: [Friend(info: User(uid: "dfg34gsdrfg34", firstName: "John", lastName: "Appleseed", userName: "Johnny", friends: []), status: "accepted"), Friend(info: User(uid: "234g4352g45g", firstName: "Greg", lastName: "Sender", userName: "Friendsender1000", friends: []), status: "sent"), Friend(info: User(uid: "", firstName: "Bob", lastName: "Hope", userName: "BobbyBoy", friends: []), status: "recieved")]))
    }
}
