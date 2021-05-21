//
//  SearchBarView.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-21.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchString: String
    @State private var isEditing = false
    
    var body: some View {
        HStack {
            TextField(LocalizedStringKey("Search_trunc"), text: $searchString)
                .padding(8)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        if isEditing {
                            Button(action: {
                                self.searchString = ""
                            }, label: {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            })
                        }
                    }
                )
                .padding(.horizontal, 10)
                .onTapGesture {
                    isEditing = true
                }
            if isEditing {
                Button(action: {
                    withAnimation {
                        self.isEditing = false
                        self.searchString = ""
                        hideKeyboard()
                    }
                    
                }, label: {
                    Text(LocalizedStringKey("Cancel"))
                })
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id:\.self) {
            SearchBarView(searchString: .constant(""))
                .previewLayout(.sizeThatFits).preferredColorScheme($0)
        }
    }
}
