//
//  MapView.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-05.
//

import SwiftUI
import Firebase

struct MapView: View {
    @State var image: Image?
    
    var body: some View {
        FirebaseImage(id: Auth.auth().currentUser!.uid)
            .frame(width: 150, height: 150, alignment: .center)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
