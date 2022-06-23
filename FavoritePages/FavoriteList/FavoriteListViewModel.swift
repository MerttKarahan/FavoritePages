//
//  FavoriteListViewModel.swift
//  FavoritePages
//
//  Created by emn on 24.05.2022.
//

import Foundation
import FirebaseAuth
import Firebase


class FavoriteListViewModel {
    
    let firebaseOperation = FirebaseOperation()
    
    //  Pages array'ine bir data geldiği zaman yapılacak işlemi belirten blok. (o işlem de reload data)
    //    tableView.reloadData() işlemi burada(viewmodel'da) yapılamayacağı için böyle bir completion'la viewcontroller'a bildirim yapılmalı
    var finishGetData: (() -> Void)?
    
    var pages: [FavoriteModel] = [] {
        didSet {
            self.finishGetData?()
        }
    }
    
    func logout(finish: @escaping((String?) -> Void)) {
        firebaseOperation.firebaseLogoutButtonClicked(finishFirebaseLogout: finish)
    }
    
    func getData(finish: @escaping ((String?)->Void)) {
        firebaseOperation.firebaseGetData { (error, data) in
            self.pages = data 
            finish(error)
        }
    }
    
    func numberOfRowsInSection() -> Int {
        return self.pages.count
    }
    
    func titleAtIndex(_ index: Int) -> String {
        return self.pages[index].pageTitle
    }
    
    func delete(index: Int, finishDelete: @escaping((String?) -> Void)) {
        let deletePage = self.pages[index]
        firebaseOperation.firebaseDelete(deletedPage: deletePage) { error in
            self.getData(finish: finishDelete)
        }
    }
    
    func editTitle(index: Int, newTitle: String?, finishEditTitle: @escaping((String?) -> Void)) {
        var editArray = self.pages
        editArray[index].pageTitle = newTitle ?? ""
        firebaseOperation.firebaseSetData(data: editArray) { error in
            self.getData(finish: finishEditTitle)
        }
    }
    
}









