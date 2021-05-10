//
//  AddedPhotosView.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-10.
//

import SwiftUI

struct AddedPhotosView: View {
    var image: Image?
    var type: AddedImageType
    @Binding var showPicker: ActiveSheet?
    
    var body: some View {
        
        HStack(spacing: 20) {
            switch type {
            case .pickedImage:
                image!
                    .resizable()
                    .scaledToFill()
            case .addImage:
                Image(systemName: "camera.fill")
                    .font(.title)
                    .animation(.easeInOut)
                    .foregroundColor(Color("MainDarkBlue"))
            }
        }
        .foregroundColor(Color("MainDarkBlue"))
        .frame(width: 72, height: 72)
        .clipped()
        .border(Color("MainDarkBlue"))
        .animation(.easeInOut)
        .onTapGesture {
            switch type {
            case .pickedImage:
                // Delete image
                ()
            case .addImage:
                showPicker = .second
            }
        }
        .onLongPressGesture(minimumDuration: 3.0) {
            if type != .addImage {
                // Delete image from collection
                // Add animation ??
                print("!!! long press triggered \r\n!!! New line!")
            }
        }
    }
}

struct AddedPhotosView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id:\.self) {
            AddedPhotosView(image: nil, type: .addImage, showPicker: .constant(.second)).preferredColorScheme($0).previewLayout(.fixed(width: 240, height: 120))
        }
        
    }
}

enum AddedImageType {
    case addImage, pickedImage
}
