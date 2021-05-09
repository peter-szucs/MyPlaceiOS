//
//  AddPlaceAddTagsView.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-09.
//

import SwiftUI

struct AddPlaceAddTagsView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Divider()
            HStack {
                Text(LocalizedStringKey("Add_trunc"))
                    .padding(.horizontal, 10)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(Color("TextEditorBorderColor"))
                    .padding(.horizontal, 10)
            }
            .padding(.vertical)
            Divider()
        }
    }
}

struct AddPlaceAddTagsView_Previews: PreviewProvider {
    static var previews: some View {
        AddPlaceAddTagsView()
            .previewLayout(.fixed(width: UIScreen.main.bounds.width, height: 60))

    }
}
