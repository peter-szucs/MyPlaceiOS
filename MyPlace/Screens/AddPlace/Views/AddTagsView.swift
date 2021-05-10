//
//  AddTagsView.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-10.
//

import SwiftUI

struct AddTagsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = AddPlaceViewModel()
    @State private var selection: Tag?
    @State var selectedTags: [Int] = []
    
    var tagsList: [Tag] {
        var returnList: [Tag] = []
        for i in Tags.allCases {
            returnList.append(Tag(typeValue: i.rawValue))
        }
        return returnList
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Choose Tags")
                    .font(.title2)
                    .padding()
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text(LocalizedStringKey("Done"))
                        .padding()
                })
            }
            Divider()
            List {
                ForEach(tagsList, id:\.id) { tag in
                    TagCell(selectedTags: self.$selectedTags, tag: tag)
                }
            }
        }
    }
}

struct AddTagsView_Previews: PreviewProvider {
    static var previews: some View {
        AddTagsView(selectedTags: [])
    }
}

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
