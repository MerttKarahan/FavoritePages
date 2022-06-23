//
//  LoginViewModel.swift
//  FavoritePages
//
//  Created by emn on 24.05.2022.
//

import Foundation
import FirebaseAuth

class LoginViewModel {
    
    var firebaseOperation = FirebaseOperation()
    
    func signInButtonClicked(email: String?, password: String?, finish: @escaping ((String?) -> Void)) {
        firebaseOperation.firebaseSignInButtonClicked(email: email, password: password, finishFirebaseSign: finish)
    }
    
    func registerButtonClicked(email: String?, password: String?, finish: @escaping ((String?) -> Void)) {
        firebaseOperation.firebaseRegisterButtonClicked(email: email, password: password, finishFirebaseRegister: finish)
    }
    
}
