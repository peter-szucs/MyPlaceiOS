//
//  AddPlaceView.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-09.
//

import SwiftUI

struct AddPlaceView: View {
    
    @StateObject private var viewModel = AddPlaceViewModel()
    @State var place: Place
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            FormTextView(text: LocalizedStringKey("AddPlace_name"))
            TextField(LocalizedStringKey("AddPlace_namePH"), text: $viewModel.place.title)
                .modifier(TextFieldClearButton(text: $viewModel.place.title))
                .padding([.leading, .trailing])
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            FormTextView(text: LocalizedStringKey("AddPlace_description"))
            TextEditor(text: $viewModel.place.description)
                .frame(width: UIScreen.main.bounds.width - 40, height: 200)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 5)
                .border(Color("TextEditorBorderColor"), width: 1)
                .cornerRadius(3)
                .padding(.horizontal)
            
            FormTextView(text: LocalizedStringKey("AddPlace_tags"))
            AddPlaceTagsView(tags: viewModel.place.tags)
                .padding(.horizontal)
            Button(action: {
                viewModel.showingSheet = true
            }, label: {
                AddPlaceAddTagsView()
                    .padding(.horizontal, 10)
            })
            .sheet(isPresented: $viewModel.showingSheet) {
                AddTagsView()
            }
            Spacer()
        }
        .navigationBarTitle(LocalizedStringKey("AddPlace_title"), displayMode: .inline)
        .toolbar(content: {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {
                    hideKeyboard()
                }, label: {
                    Image(systemName: "keyboard.chevron.compact.down")
                })
                Button(action: {
                    // Check for non empty fields
                    
                }, label: {
                    Text(LocalizedStringKey("Save"))
                })
            }
            
        })
        .onAppear {
            viewModel.place = place
        }
    }
}

struct AddPlaceView_Previews: PreviewProvider {
    static var previews: some View {
        AddPlaceView(place: Place(uid: "", title: "The Place", description: "A very very nice place", tags: [2, 3], lat: 0, lng: 0))
    }
}
