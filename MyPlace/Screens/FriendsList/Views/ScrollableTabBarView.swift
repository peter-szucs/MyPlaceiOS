//
//  ScrollableTabBarView.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-17.
//

import SwiftUI

struct ScrollableTabBarView<Content: View>: UIViewRepresentable {
    
    // variable to store SwiftUI View
    var content: Content
    var rect: CGRect
    
    @Binding var offset: CGFloat
    
    var tabs: [Any]
    
    let scrollView = UIScrollView()
    
    init(tabs: [Any], rect: CGRect, offset: Binding<CGFloat>, @ViewBuilder content: () -> Content) {
        self.content = content()
        self._offset = offset
        self.rect = rect
        self.tabs = tabs
    }
    
    func makeCoordinator() -> Coordinator {
        return ScrollableTabBarView.Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        
        setupScrollView()
        
        scrollView.contentSize = CGSize(width: rect.width * CGFloat(tabs.count), height: rect.height)
        scrollView.addSubview(extractView())
        scrollView.delegate = context.coordinator
        return scrollView
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        if uiView.contentOffset.x != offset {
            
            uiView.delegate = nil
            
            UIView.animate(withDuration: 0.4) {
                uiView.contentOffset.x = offset
            } completion: { (status) in
                if status { uiView.delegate = context.coordinator }
            }

        }
    }
    
    func setupScrollView() {
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    func extractView() -> UIView {
        let controller = UIHostingController(rootView: content)
        controller.view.frame = CGRect(x: 0, y: 0, width: rect.width * CGFloat(tabs.count), height: rect.height)
        return controller.view!
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: ScrollableTabBarView
        
        init(parent: ScrollableTabBarView) {
            self.parent = parent
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            parent.offset = scrollView.contentOffset.x
        }
    }
}

struct ScrollableTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsListView(viewModel: FriendsListViewModel(friendsList: [Friend(info: User(uid: "dfg34gsdrfg34", firstName: "John", lastName: "Appleseed", userName: "Johnny", friends: []), status: "accepted"), Friend(info: User(uid: "234g4352g45g", firstName: "Greg", lastName: "Sender", userName: "Friendsender1000", friends: []), status: "sent"), Friend(info: User(uid: "", firstName: "Bob", lastName: "Hope", userName: "BobbyBoy", friends: []), status: "recieved")]))
    }
}
