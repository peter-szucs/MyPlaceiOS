//
//  AddPlaceView.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-09.
//

import SwiftUI

struct AddPlaceView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = AddPlaceViewModel()
    @State var place: Place
    
    var body: some View {
        
        VStack {
            if viewModel.isLoading {
                ActivityView()
            } else {
                VStack(alignment: .leading) {
                    
                    FormTextView(text: LocalizedStringKey("AddPlace_name"))
                    TextField(LocalizedStringKey("AddPlace_namePH"), text: $viewModel.place.title)
                        .modifier(TextFieldClearButton(text: $viewModel.place.title))
                        .padding([.leading, .trailing])
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    
                    VStack(alignment: .leading) {
                        Text(viewModel.place.PMData.PMName)
                        HStack {
                            Text(viewModel.place.PMData.PMAddress)
                            Text(viewModel.place.PMData.PMAddress2)
                        }
                        HStack {
                            Text(viewModel.place.PMData.PMZipCode)
                            Text(viewModel.place.PMData.PMNeighbourhood)
                        }
                        Text(viewModel.place.PMData.PMState)
                        Text(viewModel.place.PMData.PMCountry)
                    }
                    .font(.footnote)
                    .padding(.horizontal)
                    
                    FormTextView(text: LocalizedStringKey("AddPlace_description"))
                    TextEditor(text: $viewModel.place.description)
                        .frame(width: UIScreen.main.bounds.width - 40, height: 150)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 5)
                        .border(Color("TextEditorBorderColor"), width: 1)
                        .cornerRadius(3)
                        .padding(.horizontal)
                    
                    VStack(alignment: .leading) {
                        FormTextView(text: LocalizedStringKey("AddPlace_tags"))
                        AddPlaceTagsView(tags: viewModel.place.tags)
                            .padding(.horizontal)
                        Button(action: {
                            viewModel.activeSheet = .first
                        }, label: {
                            AddPlaceAddTagsView()
                                .padding(.horizontal, 10)
                                .accentColor(.gray)
                        })
                    }
                    
                    ScrollView(.horizontal) {
                        VStack(alignment: .leading) {
                            HStack(spacing: 20) {
                                ForEach(viewModel.images, id:\.self) { image in
                                    AddedPhotosView(image: Image(uiImage: image), type: .pickedImage, showPicker: $viewModel.activeSheet)
                                }
                                AddedPhotosView(image: nil, type: .addImage, showPicker: $viewModel.activeSheet)
                            }
                        }
                        .padding(.horizontal, 10)
                    }
                    .frame(maxWidth: UIScreen.main.bounds.width - 20, minHeight: 80, maxHeight: 100, alignment: .center)
                    Text(viewModel.emptyFieldsMessage)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                    Spacer()
                }
                
            }
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
                    print("!!! \(viewModel.place)")
                    viewModel.finalizePlace { (success) in
                        if success {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }, label: {
                    Text(LocalizedStringKey("Save"))
                })
            }
            
        })
        .sheet(item: $viewModel.activeSheet) { item in
            switch item {
            case .first:
                AddTagsView(viewModel: viewModel)
            case .second:
                ImagePicker(image: $viewModel.pickedImage, sourceType: .camera).onDisappear { viewModel.loadImages() }
            }
        }
        .onAppear {
            viewModel.place = place
        }
    }
}

struct AddPlaceView_Previews: PreviewProvider {
    static var previews: some View {
        AddPlaceView(place: Place(uid: "", title: "A Place", description: "Very nice place", PMData: PlaceMarkAddress(name: "Home", thoroughfare: "Homestreet", subThoroughfare: "22", postalCode: "555 55", subLocality: "State", administrativeArea: "City", country: "Country"), tagIds: [1, 0, 3], lat: 0, lng: 0))
    }
}
