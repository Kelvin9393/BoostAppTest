//
//  String+Extension.swift
//  BoostAppTest
//
//  Created by 2.9mac256 on 22/03/2020.
//

import Foundation

extension String {

    static func randomAlphaNumericString(length : Int) -> String {
        var characters = Array(48...57).map {String(UnicodeScalar($0))}
        characters.append(contentsOf: (Array(97...122).map {String(UnicodeScalar($0))}))
        var randomString = ""

        for _ in 0..<length {
            let randonIndex = Int.random(in: 0 ..< characters.count)
            randomString += characters[randonIndex]
        }
        return randomString
    }
    
    var isValidName: Bool {
        return self.validate(regex: "^[a-zA-Z ]*$")
    }
    
    var isValidEmail: Bool {
        let firstpart = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
        let serverpart = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
        let emailRegex = firstpart + "@" + serverpart + "[A-Za-z]{2,8}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
    
    var isValidPhone: Bool {
        let phoneRegex = "^(\\([0-9]{3}\\) |[0-9]{3}-)[0-9]{3}-[0-9]{4}$" // for americans only 
        return NSPredicate(format:"SELF MATCHES %@", phoneRegex).evaluate(with: self)
    }
    
    func validate(regex: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: self, range: NSRange(self.startIndex..., in: self))
            if !results.isEmpty {
                return true
            } else {
                return false
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return false
        }
    }
}


