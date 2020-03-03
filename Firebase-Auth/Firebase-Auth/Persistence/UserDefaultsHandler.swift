//
//  UserDefaults.swift
//  Firebase-Auth
//
//  Created by Cameron Rivera on 3/3/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import Foundation

struct UserDefaultsKeys{
    static let phoneNumKey = "phoneNumber"
    static let verificationID = "verificationID"
}

struct FirebaseData{
    static var verificationCode = ""
}

struct UserDefaultsHandler{
    static func setObject(_ string: String){
        UserDefaults.standard.set(string, forKey: UserDefaultsKeys.phoneNumKey)
    }
    
    static func getPhoneNum() -> String{
        guard let phoneNumber = UserDefaults.standard.object(forKey: UserDefaultsKeys.phoneNumKey) as? String else{
            return ""
        }
        return phoneNumber
    }
    
    static func setVerification(_ verification: String){
        UserDefaults.standard.set(verification, forKey: UserDefaultsKeys.verificationID)
    }
    
    static func getVerification() -> String{
        guard let verification = UserDefaults.standard.object(forKey: UserDefaultsKeys.verificationID) as? String else {
            return ""
        }
        return verification
    }
}
