//
//  PlaceMarkAddress.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-12.
//

import Foundation

struct PlaceMarkAddress {
    var PMName: String
    var PMAddress: String
    var PMAddress2: String
    var PMZipCode: String
    var PMNeighbourhood: String
    var PMState: String
    var PMCountry: String
    var PMCountryCode: String
    
    init() {
        self.PMName = ""
        self.PMAddress = ""
        self.PMAddress2 = ""
        self.PMZipCode = ""
        self.PMNeighbourhood = ""
        self.PMState = ""
        self.PMCountry = ""
        self.PMCountryCode = ""
    }
    
    init(name: String?, thoroughfare: String?, subThoroughfare: String?, postalCode: String?, subLocality: String?, administrativeArea: String?, country: String?, countryCode: String) {
        self.PMName = name ?? ""
        self.PMAddress = thoroughfare ?? ""
        self.PMAddress2 = subThoroughfare ?? ""
        self.PMZipCode = postalCode ?? ""
        self.PMNeighbourhood = subLocality ?? ""
        self.PMState = administrativeArea ?? ""
        self.PMCountry = country ?? ""
        self.PMCountryCode = countryCode
    }
    
    init?(documentData: [String : Any]?) {
        guard let documentData = documentData else {
            self.init()
            return
            
        }
        let name = documentData[FIRKeys.Address.name] as? String ?? "unknown"
        let address = documentData[FIRKeys.Address.thoroughfare] as? String ?? "unknown"
        let address2 = documentData[FIRKeys.Address.subThoroughfare] as? String ?? "unknown"
        let zipcode = documentData[FIRKeys.Address.postalCode] as? String ?? "unknown"
        let neighbourhood = documentData[FIRKeys.Address.subLocality] as? String ?? "unknown"
        let state = documentData[FIRKeys.Address.administrativeArea] as? String ?? "unknown"
        let country = documentData[FIRKeys.Address.country] as? String ?? "unknown"
        let countryCode = documentData[FIRKeys.Address.countryCode] as? String ?? "unknown"
        
        self.init(name: name,
                  thoroughfare: address,
                  subThoroughfare: address2,
                  postalCode: zipcode,
                  subLocality: neighbourhood,
                  administrativeArea: state,
                  country: country,
                  countryCode: countryCode)
    }
    
    static func dataDict(name: String, thoroughfare: String, subThoroughfare: String, postalCode: String, subLocality: String, administrativeArea: String, country: String, countryCode: String) -> [String : Any] {
        var data: [String : Any]
        
        data = [FIRKeys.Address.name: name,
                FIRKeys.Address.thoroughfare: thoroughfare,
                FIRKeys.Address.subThoroughfare: subThoroughfare,
                FIRKeys.Address.postalCode: postalCode,
                FIRKeys.Address.subLocality: subLocality,
                FIRKeys.Address.administrativeArea: administrativeArea,
                FIRKeys.Address.country: country,
                FIRKeys.Address.countryCode: countryCode]
        
        return data
    }
    
    static func dataDict(placemarkAddress: PlaceMarkAddress) -> [String : Any] {
        var data: [String : Any]
        
        data = [FIRKeys.Address.name: placemarkAddress.PMName,
                FIRKeys.Address.thoroughfare: placemarkAddress.PMAddress,
                FIRKeys.Address.subThoroughfare: placemarkAddress.PMAddress2,
                FIRKeys.Address.postalCode: placemarkAddress.PMZipCode,
                FIRKeys.Address.subLocality: placemarkAddress.PMNeighbourhood,
                FIRKeys.Address.administrativeArea: placemarkAddress.PMState,
                FIRKeys.Address.country: placemarkAddress.PMCountry,
                FIRKeys.Address.countryCode: placemarkAddress.PMCountryCode]
        
        return data
    }
}
