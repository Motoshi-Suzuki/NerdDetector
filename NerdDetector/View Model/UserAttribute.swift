//
//  UserAttribute.swift
//  NerdDetector
//
//  Created by Motoshi Suzuki on 2021/07/12.
//

import SwiftUI

class UserAttribute: ObservableObject {
    @Published var isNerd = false
    
    func setAttribute(isNerdArray: [Bool]) {
        if isNerdArray == [true, false] {
            self.isNerd = true
            
        } else if isNerdArray == [false, true] {
            self.isNerd = false
        }
    }
    
    func printMessage(isNerd: Bool, messageForNerd: String, messageForNonNerd: String) {
        switch isNerd {
        case true:
            print(messageForNerd)
        case false:
            print(messageForNonNerd)
        }
    }
}
