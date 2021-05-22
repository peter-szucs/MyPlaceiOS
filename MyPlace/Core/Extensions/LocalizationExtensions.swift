//
//  LocalizationExtensions.swift
//  MyPlace
//
//  Created by Peter Szücs on 2021-05-21.
//

import Foundation
import CoreLocation

extension NSLocale {
    
    struct Locale {
        let countryCode: String
        let countryName: String
    }
    
    class func locales() -> [Locale] {
        var locales = [Locale]()
        guard let userLocale = NSLocale.current.languageCode else { return [] }
        for localeCode in NSLocale.isoCountryCodes {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: localeCode])
            let name = NSLocale(localeIdentifier: userLocale).displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(localeCode)"
            locales.append(Locale(countryCode: localeCode as String, countryName: name))
        }
        return locales
    }
    
    class func getCountryName(from countryCode: String) -> String {
        guard let userLocale = NSLocale.current.languageCode else { return "Unknown language" }
        if let name = NSLocale(localeIdentifier: userLocale).displayName(forKey: .countryCode, value: countryCode) {
            return name
        } else {
            return countryCode
        }
        
    }
}
