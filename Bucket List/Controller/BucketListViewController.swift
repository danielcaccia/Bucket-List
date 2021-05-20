//
//  ViewController.swift
//  Bucket List
//
//  Created by Daniel Caccia on 19/05/21.
//

import UIKit

class BucketListViewController: UITableViewController {

    var bucketItemArray = [BucketItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var bucketItemTitle = UITextField()
        var bucketItemDescription = UITextField()
        
        let alert = UIAlertController(title: "Add New Bucket List Item", message: "", preferredStyle: .alert)
        
        let cancelItem = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let addItem = UIAlertAction(title: "Add Item", style: .default) { (addItem) in
            let newBucketItem = BucketItem()

            newBucketItem.title = bucketItemTitle.text ?? "New Item"
            newBucketItem.description = bucketItemDescription.text ?? ""
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTitleTextField) in
            alertTitleTextField.placeholder = "Create new item"
            bucketItemTitle = alertTitleTextField
        }
        
        alert.addTextField { (alertDescriptionTextField) in
            alertDescriptionTextField.placeholder = "Enter new item description"
            bucketItemDescription = alertDescriptionTextField
        }
        
        alert.addAction(cancelItem)
        alert.addAction(addItem)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bucketItemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BucketItemCell", for: indexPath)
        let currentItem = bucketItemArray[indexPath.row]
        
        cell.textLabel?.text = currentItem.title
        cell.accessoryType = currentItem.checked ? .checkmark : .none
        
        return cell
    }
 
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        bucketItemArray[indexPath.row].checked = !bucketItemArray[indexPath.row].checked
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
