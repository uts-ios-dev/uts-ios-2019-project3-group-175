//
//  NeedListViewController.swift
//  GroceryHelper2
//
//  Created by user150278 on 6/2/19.
//  Copyright © 2019 user150278. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class NeedListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    // Database reference
    var refItems: DatabaseReference!
    // Current user
    let user = Auth.auth().currentUser?.email
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var itemTextField: UITextField!
    
    // Arrays to keep track of data
    var items = [String]()
    var keyArray = [String]()
    
    override func viewDidLoad() {
        self.itemTextField.delegate = self
        tableView.tableFooterView = UIView.init(frame: .zero)
        tableView.dataSource = self
        tableView.delegate = self
        refItems = Database.database().reference().child("itemsNeed")
        loadData()
    }
    
    
    /// Removes keyboard when return is clicked
    ///
    /// - Parameter textField: Textfield being typed
    /// - Returns: false
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    /// Loads users needed items from database and adds items to tableview
    func loadData() {
        refItems.queryOrdered(byChild: "addedByUser").queryEqual(toValue: user!).observe(.value, with: { snapshot in
            if snapshot.exists() {
                // Removes items and reload database
                self.items.removeAll()
                self.tableView.reloadData()
                
                // Iterates through all items in database and adds data to arrays and table view
                for i in snapshot.children {
                    let user_snap = i as! DataSnapshot
                    let dict = user_snap.value as! [String: String?]
                    let name = dict["name"] as? String
                    let key = dict["id"] as? String
                    
                    self.keyArray.insert(key!, at: 0)
                    self.items.insert(name!, at: 0)
                    self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                }
            }
        })
    }
    
    
    /// Number of items
    ///
    /// - Parameters:
    ///   - tableView: tableview
    ///   - section: section
    /// - Returns: number of items
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    
    /// Returns height of table view cells
    ///
    /// - Parameters:
    ///   - tableView: table view
    ///   - indexPath: index of cell
    /// - Returns: height of cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 47
    }
    
    
    /// Returns cell of index. Initializes lable and button
    ///
    /// - Parameters:
    ///   - tableView: table view
    ///   - indexPath: index of cell
    /// - Returns: cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if let lbl = cell?.contentView.viewWithTag(101) as? UILabel {
            lbl.text = items[indexPath.row]
        }
        
        if let btn = cell?.contentView.viewWithTag(102) as? UIButton {
            btn.addTarget(self, action: #selector(deleteRow(_ :)), for: .touchUpInside)
        }
        
        return cell!
    }
    
    
    /// Deletes clicked row from table view and database
    ///
    /// - Parameter sender: Delete button
    @objc func deleteRow(_ sender: UIButton) {
        
        let point = sender.convert(CGPoint.zero, to: tableView)
        guard let indexPath = tableView.indexPathForRow(at: point) else {
            return
        }
        
        refItems.child(keyArray[indexPath.row]).removeValue()
        let itemToRemove = items.remove(at: indexPath.row)
        print(indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
        
        let msg = UIAlertController(title: "", message: "Do you want to add item to Have list?", preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
            let refHave = Database.database().reference().child("itemsHave")
          
            let key = refHave.childByAutoId().key
            let item = ["id": key!,
                        "name": itemToRemove as String,
                        "addedByUser": self.user!
                ] as [String : Any]
            
            refHave.child(key!).setValue(item)
            
        } )
        let no = UIAlertAction(title: "No", style: .default, handler:{ (action) -> Void in
        } )
        
        msg.addAction(yes)
        msg.addAction(no)
        
        self.present(msg, animated: true, completion: nil)
    }
    
    
    /// Adds item to table view
    ///
    /// - Parameter sender:
    @IBAction func addItem(_ sender: Any) {
        items.insert(itemTextField.text!, at: 0)
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .right)
        
        addItem()
    }
    
    /// Adds item to database with id, name of item and by which user
    func addItem() {
        
        let key = refItems.childByAutoId().key
        let item = ["id": key!,
                    "name": itemTextField.text! as String,
                    "addedByUser": user!
            ] as [String : Any]
        
        refItems.child(key!).setValue(item)
        itemTextField.text = ""
    }
    
    
}


    
    


    
    

