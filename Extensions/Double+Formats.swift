//
//  Double+Formats.swift
//  MedLog
//
//  Created by Xoliswa on 2020/01/01.
//  Copyright © 2020 NativeByte. All rights reserved.
//  https://stackoverflow.com/questions/31999748/get-currency-symbols-from-currency-code-with-swift
//

import Foundation

extension Double {
    
    func asPercentage(decimalDigits:Int = 2) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = decimalDigits
        numberFormatter.minimumFractionDigits = decimalDigits
        numberFormatter.percentSymbol = "%"
        numberFormatter.numberStyle = .percent
        numberFormatter.locale = Locale.current
        
        return String(format: "%@", numberFormatter.string(from: NSNumber(value: self/100)) ?? "")
    }
    
    func asCurrency(symbol:String = "", decimalDigits:Int = 2) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = decimalDigits
        numberFormatter.minimumFractionDigits = decimalDigits
        numberFormatter.currencySymbol = self.getSymbolForCurrencyCode(code: symbol.uppercased())
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        
        // Currency symbol space padding
        if let amountString = numberFormatter.string(from: NSNumber(value: self)), let rangeOfSymbol = amountString.range(of: String(numberFormatter.currencySymbol)) {
            if amountString.startIndex == rangeOfSymbol.lowerBound {
                numberFormatter.paddingPosition = .afterPrefix
            } else {
                numberFormatter.paddingPosition = .beforeSuffix
            }
            
            if amountString.rangeOfCharacter(from: CharacterSet(charactersIn: " ")) == nil {
                numberFormatter.formatWidth = amountString.count + 1
                numberFormatter.paddingCharacter = " "
            }
        }
        
        return String(format: "%@", numberFormatter.string(from: NSNumber(value: self)) ?? "")
    }
    
    func asCryptoCurrency(symbol:String = "", decimalDigits:Int?) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = decimalDigits ?? 8
        numberFormatter.minimumFractionDigits = decimalDigits ?? 8
        numberFormatter.numberStyle = .decimal
        numberFormatter.locale = Locale.current
        
        return String(format: "%@ %@", numberFormatter.string(from: NSNumber(value: self)) ?? "", symbol)
    }
    
    static func toDouble(input: String) -> Double? {
         let numberFormatter = NumberFormatter()
         numberFormatter.locale = Locale.current
        
         return numberFormatter.number(from: input)?.doubleValue
    }
    
    private func getSymbolForCurrencyCode(code: String) -> String {
        var candidates: [String] = []
        let locales: [String] = NSLocale.availableLocaleIdentifiers
        for localeID in locales {
            guard let symbol = self.findMatchingSymbol(localeID: localeID, currencyCode: code) else {
                continue
            }
            if symbol.count == 1 {
                return symbol
            }
            candidates.append(symbol)
        }
        let sorted = self.sortAscByLength(list: candidates)
        if sorted.count < 1 {
            return ""
        }
        return sorted[0]
    }

    private func findMatchingSymbol(localeID: String, currencyCode: String) -> String? {
        let locale = Locale(identifier: localeID as String)
        guard let code = locale.currencyCode else {
            return nil
        }
        if code != currencyCode {
            return nil
        }
        guard let symbol = locale.currencySymbol else {
            return nil
        }
        return symbol
    }

    private func sortAscByLength(list: [String]) -> [String] {
        return list.sorted(by: { $0.count < $1.count })
    }
}
