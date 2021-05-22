//
//  FilterCountryCellView.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-21.
//

import SwiftUI

struct FilterCountryCellView: View {
    
    @Binding var selectedCountry: String
    @State var countryCode: String
    @State var countryName: String
    @State var countryFlag: String
    var isSelected: Bool {
        return selectedCountry == countryCode
    }
    
    var body: some View {
        HStack {
            Text("\(countryFlag)")
                .padding(4)
            Text("\(countryName)")
                .padding(4)
            Spacer()
            if isSelected {
                Image(systemName: "checkmark")
                    .foregroundColor(.green)
                    .padding(4)
            }
        }
    }
}

struct FilterCountryCellView_Previews: PreviewProvider {
    static var previews: some View {
        FilterCountryCellView(selectedCountry: .constant("SE"), countryCode: "SE", countryName: "Sverige", countryFlag: "")
    }
}
