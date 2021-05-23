//
//  AvatarImageView.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-23.
//

import SwiftUI

struct AvatarImageView: View {
    
    @State var image: Image?
    
    var body: some View {
        HStack {
            if image != nil {
                image!
                    .resizable()
                    .scaledToFill()
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .foregroundColor(Color("MainLightBlue"))
            }
        }
    }
}

struct AvatarImageView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarImageView()
    }
}
