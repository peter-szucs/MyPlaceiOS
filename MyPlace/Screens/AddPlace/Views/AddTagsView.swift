//
//  AddTagsView.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-10.
//

import SwiftUI

struct AddTagsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: AddPlaceViewModel
    
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
                    TagCell(selectedTags: self.$viewModel.place.tagIds, tag: tag)
                }
            }
        }
    }
}

struct AddTagsView_Previews: PreviewProvider {
    static var previews: some View {
        AddTagsView(viewModel: AddPlaceViewModel())
    }
}

