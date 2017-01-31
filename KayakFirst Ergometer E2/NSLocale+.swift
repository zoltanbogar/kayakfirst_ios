//
//  NSLocale+.swift
//  KayakFirst Ergometer E2
//
//  Created by Balazs Vidumanszki on 2017. 01. 30..
//  Copyright © 2017. Balazs Vidumanszki. All rights reserved.
//

import Foundation

extension NSLocale {
    
    struct AppLocale {
        let countryCode: String
        let countryName: String
    }
    
    class func locales() -> [AppLocale] {
        var locales = [AppLocale]()
        
        for localeCode in NSLocale.isoCountryCodes {
            let countryName = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: localeCode) ?? ""
            let countryCode = localeCode
            let locale = AppLocale(countryCode: countryCode, countryName: countryName)
            locales.append(locale)
        }
        return locales
    }
    
    class func getCountryNameByCode(countryCode: String?) -> String {
        if let code = countryCode {
            return (Locale.current as NSLocale).displayName(forKey: .countryCode, value: code) ?? ""
        } else {
            return ""
        }
    }
    
}
