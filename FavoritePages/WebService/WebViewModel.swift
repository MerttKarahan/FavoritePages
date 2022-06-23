//
//  AddNewValue.swift
//  FavoritePages
//
//  Created by emn on 30.05.2022.
//

import Foundation
import Firebase

class WebViewModel {
    
    let firebasOperation = FirebaseOperation()
    let currentUser = Auth.auth().currentUser!.uid
    
    func addNewData(pageUrl: String!, pageTitle: String?, finish: @escaping((String?) -> Void)){
        firebasOperation.firebaseAddNewData(pageUrl: pageUrl, pageTitle: pageTitle, finishFirebaseAddNewData: finish)
    }
}





