//
//  AddPlaceView.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-09.
//

import SwiftUI

struct AddPlaceView: View {
    
    @StateObject private var viewModel = AddPlaceViewModel()
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            FormTextView(text: LocalizedStringKey("AddPlace_name"))
            TextField(LocalizedStringKey("AddPlace_namePH"), text: $viewModel.place.title)
                .textFieldStyle(UserInfoTextFieldStyle())
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .disableAutocorrection(true)
//                .modifier(TextFieldClearButton(text: $viewModel.place.title))
            
            FormTextView(text: LocalizedStringKey("AddPlace_description"))
            TextEditor(text: $viewModel.place.description)
                .frame(minWidth: UIScreen.main.bounds.width - 40, maxWidth: UIScreen.main.bounds.width - 40, minHeight: 50, maxHeight: 200)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 5)
                .border(Color("TextEditorBorderColor"), width: 1)
                .cornerRadius(3)
                .padding(.horizontal)
            
            FormTextView(text: LocalizedStringKey("AddPlace_tags"))
            AddPlaceTagsView(tags: viewModel.place.tags)
                .padding(.horizontal)
            AddPlaceAddTagsView()
                .padding(.horizontal, 10)
            Spacer()
        }
        .navigationBarTitle(LocalizedStringKey("AddPlace_title"), displayMode: .inline)
        
    }
}

struct AddPlaceView_Previews: PreviewProvider {
    static var previews: some View {
        AddPlaceView()
    }
}
