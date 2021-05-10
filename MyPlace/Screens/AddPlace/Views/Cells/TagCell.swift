//
//  TagCell.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-10.
//

import SwiftUI

struct TagCell: View {
    
    @Binding var selectedTags: [Int]
    
    let tag: Tag
    var isSelected: Bool {
        return selectedTags.contains(tag.id)
    }
    
    var body: some View {
        
        HStack {
            Image((tag.type?.tagIconName())!)
                .resizable()
                .renderingMode(.template)
                .scaledToFill()
                .foregroundColor(Color("MainLightBlue"))
                .frame(width: 24, height: 24)
                .padding(5)
                .padding(.leading, 8)
            Text((tag.type?.tagName())!)
                .padding(.leading)
            Spacer()
            if isSelected {
                Image(systemName: "checkmark")
                    .foregroundColor(.green)
                    .padding(.horizontal)
            }
        }
        .padding(.vertical, 10)
        .background(isSelected ? Color("TagSelected") : Color("TagNotSelected"))
        .cornerRadius(10)
        .onTapGesture {
            if !isSelected {
                self.selectedTags.append(tag.id)
            } else {
                if let index = selectedTags.firstIndex(of: tag.id) {
                    selectedTags.remove(at: index)
                }
                
            }
        }
    }
}
