//
//  ValidationManager.swift
//  Lessgoo
//
//  Created by Jialiang Xiao on 8/12/23.
//

import Foundation

class ValidationManager: ObservableObject {
    @Published private var _isInputValid: Bool = true
    @Published private var _numFailedAttempts: Int = 0
    
    var isInputValid: Bool { _isInputValid }
    var numFailedAttempts: Int { _numFailedAttempts }
    
    func validateInput(_ input: String) {
        guard input.count >= 4 else {
            self._isInputValid = false
            return
        }
            
        guard input.rangeOfCharacter(from: .letters) != nil else {
            self._isInputValid = false
            return
        }
        self._isInputValid = true
    }
    
    func addNum() {
        print("num before add is \(_numFailedAttempts)")
        self._numFailedAttempts += 1
        print("num after add is \(_numFailedAttempts)")
    }
    
    func resetNum() {
        self._numFailedAttempts = 0
    }
}
