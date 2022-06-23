//
//  FirebaseOperation.swift
//  FavoritePages
//
//  Created by Mert Karahan on 2.06.2022.
//

import Foundation
import Firebase

class FirebaseOperation {

    let currentUser = Auth.auth().currentUser?.uid
    
    func firebaseSignInButtonClicked(email: String?, password: String?, finishFirebaseSign: @escaping((String?) -> Void)){
        if let email = email, let password = password {
            Auth.auth().signIn(withEmail: email, password: password) { auth, error in
                if let error = error {
                    finishFirebaseSign(error.localizedDescription)
                } else {
                    finishFirebaseSign(nil)
                }
            }
        } else {
            finishFirebaseSign("Please enter Email/Password")
        }
    }
    
    func firebaseRegisterButtonClicked(email: String?, password: String?, finishFirebaseRegister: @escaping ((String?) -> Void)){
        if let email = email, let password = password {
            Auth.auth().createUser(withEmail: email, password: password) { auth, error in
                if let error = error {
                    finishFirebaseRegister(error.localizedDescription)
                } else {
                    finishFirebaseRegister(nil)
                }
            }
        } else {
            finishFirebaseRegister("Please enter Email/Password")
        }
    }
    
    func firebaseLogoutButtonClicked(finishFirebaseLogout: @escaping((String?) -> Void)) {
        do {
            try Auth.auth().signOut()
            finishFirebaseLogout(nil)
        } catch {
            finishFirebaseLogout(error.localizedDescription)
        }
    }
    
    func firebaseGetData(finishFirebaseGetData: @escaping((String?, [FavoriteModel] ) -> Void)) {
        
        let db = Firestore.firestore()
        db.collection("Pages").document(currentUser!).getDocument { (document, error) in
            if let pages = document?["pageDetilsArray"] as? [[String:String]] {
                // Gelen dictionary'ı verilen decodable struct'a çeviren kod
                let data = (try? JSONSerialization.data(withJSONObject: pages)) ?? Data()
                let pagesModel = (try? JSONDecoder().decode([FavoriteModel].self, from: data)) ?? []
                finishFirebaseGetData(nil, pagesModel)
            }
        }
        
    }
    
//    func firebaseGetData(finishFirebaseGetData: @escaping((String?) -> Void)) {
//        self.pagesUrlArray.removeAll()
//        self.pagesTitleArray.removeAll()
//        let db = Firestore.firestore()
//        db.collection("Pages").document(currentUser!).getDocument { document, error in
//            if let pages = document?["pageDetilsArray"] as? [[String:String]] {
//                for page in pages {
//                    let url = page["pageUrl"]
//                    let title = page["pageTitle"]
//                    self.pagesTitleArray.append(title)
//                    self.pagesUrlArray.append(url)
//                }
//            }
//            finishFirebaseGetData(error?.localizedDescription)
//        }
//    }
    
    //                var array: [FavoriteModel] = []
    //                for page in pages {
    //                    let url = page["pageUrl"] ?? ""
    //                    let title = page["pageTitle"] ?? ""
    //                    let model = FavoriteModel(pageUrl: url, pageTitle: title)
    //                    array.append(model)
    //                }
    
    func firebaseDelete(deletedPage: FavoriteModel, finishFirebaseDelete : @escaping((String?) -> Void)) {
        
        let dictionary = deletedPage.dictionary ?? [:]
        
        let data: [String: Any] = ["pageDetilsArray" : FieldValue.arrayRemove([dictionary])]
        
        let db = Firestore.firestore()
        
        let docRef = db.collection("Pages").document(currentUser!)
        
        docRef.updateData(data) { error in
            finishFirebaseDelete(error?.localizedDescription)
        }
    }
    
    func firebaseAddNewData(pageUrl: String!, pageTitle: String?, finishFirebaseAddNewData: @escaping((String?) -> Void)) {
        let model = FavoriteModel(pageUrl: pageUrl, pageTitle: pageTitle ?? "")
        let dictionary = model.dictionary ?? [:]
        
        
        let firestoreDatabase = Firestore.firestore()
        let data: [String: Any] = ["pageDetilsArray": FieldValue.arrayUnion([dictionary])]
        
        firestoreDatabase.collection("Pages").document(currentUser!).setData(data, merge: true) { error in
            finishFirebaseAddNewData(error?.localizedDescription)
        }
    }
    
    func firebaseSetData(data: [FavoriteModel], finishFirebaseSetData: @escaping((String?) -> Void)) {
        
        let dataDict = data.compactMap({ $0.dictionary })
        
        let editData: [String: Any] = ["pageDetilsArray": dataDict]
        
        let db = Firestore.firestore()
        db.collection("Pages").document(currentUser!).setData(editData) { error in
            finishFirebaseSetData(error?.localizedDescription)
        }
    }
    
}
