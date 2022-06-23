//
//  FavoriteListVC.swift
//  FavoritePages
//
//  Created by emn on 24.05.2022.
//

import UIKit

class FavoriteListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var favoriteListTableView: UITableView!
    
    var favoriteListViewModel = FavoriteListViewModel()

    var selectedUrl: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoriteListViewModel.finishGetData = {
            DispatchQueue.main.async {
                self.favoriteListTableView.reloadData()
            }
        }
        
        favoriteListViewModel.getData { error in
            DispatchQueue.main.async {
                if let error = error {
                    self.makeAlert(titleInput: "Error", messageInput: error)
                }
            }
        }
        
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.plain, target: self, action: #selector(logout))
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addNewElement))
        
        favoriteListTableView.delegate = self
        favoriteListTableView.dataSource = self
    }
    
    @objc func logout() {
        favoriteListViewModel.logout { errdesc in
            if let errdesc = errdesc {
                self.makeAlert(titleInput: "Error", messageInput: errdesc)
            } else {
                self.segue(id: "toLoginVC")
            }
        }
    }
    
    @objc func addNewElement() {
        self.selectedUrl = nil
        self.segue(id: "toWebServiceVC")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! WebVC
        if let selectedUrl = selectedUrl {
            destinationVC.enumType = .preview(selectedUrl)
        } else {
            destinationVC.enumType = .add
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteListViewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.textLabel?.text = favoriteListViewModel.titleAtIndex(indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedUrl = favoriteListViewModel.pages[indexPath.row].pageUrl
        self.segue(id: "toWebServiceVC")
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.favoriteListViewModel.delete(index: indexPath.row) { error in
                DispatchQueue.main.async {
                    if let error = error {
                        self.makeAlert(titleInput: "Error", messageInput: error)
                    }
                }
            }
        }
    }
    
    
    
    
    
    
    
    
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let editAction = UIContextualAction(style: .normal, title:  "Edit", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            let alert = UIAlertController(title: "Edite Title", message: "", preferredStyle: UIAlertController.Style.alert)
            
            alert.addTextField { UITextField in
                UITextField.placeholder = "Edit title.."
            }
            
            let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
            
            let saveButton = UIAlertAction(title: "Save" , style: UIAlertAction.Style.default) { action in
                let editTitle = alert.textFields?[0].text
                self.favoriteListViewModel.editTitle(index: indexPath.row, newTitle: editTitle) { error in
                    if error != nil {
                        self.makeAlert(titleInput: "Error", messageInput: "Please try again")
                    }
                }
            }
            alert.addAction(cancelButton)
            alert.addAction(saveButton)
            self.present(alert, animated: true)
            
            success(true)
        })
        editAction.image = UIImage(systemName: "pencil")
        editAction.backgroundColor = .orange
        
        return UISwipeActionsConfiguration(actions: [editAction])
    }
    
    
    
    
    
    
    
    
    
    
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func segue(id: String!){
        self.performSegue(withIdentifier: id, sender: nil)
    }
}

