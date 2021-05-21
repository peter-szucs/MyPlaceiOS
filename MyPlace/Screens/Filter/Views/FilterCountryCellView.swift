//
//  FilterCountryCellView.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-21.
//

import SwiftUI

struct FilterCountryCellView: View {
    
    @Binding var selectedCountries: [String]
    @State var countryCode: String
    @State var countryName: String
    @State var countryFlag: String
    var isSelected: Bool {
        for i in 0..<selectedCountries.count {
            if selectedCountries[i] == countryCode {
                return true
            }
        }
        return false
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
        FilterCountryCellView(selectedCountries: .constant(["SE"]), countryCode: "SE", countryName: "Sverige", countryFlag: "")
    }
}
