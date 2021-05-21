//
//  BucketListViewController.swift
//  Bucket List
//
//  Created by Daniel Caccia on 19/05/21.
//

import UIKit
import CoreData

class BucketListViewController: UITableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var bucketItemArray = [BucketItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var bucketItemTitle = UITextField()
        var bucketItemDescription = UITextField()
        
        let alert = UIAlertController(title: "Add New Bucket List Item", message: "", preferredStyle: .alert)
        
        let cancelItem = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let addItem = UIAlertAction(title: "Add Item", style: .default) { (addItem) in
            let newBucketItem = BucketItem(context: self.context)

            newBucketItem.title = !bucketItemTitle.isEmpty ? bucketItemTitle.text : "New Bucket Item"
            newBucketItem.desc = bucketItemDescription.text
            
            self.bucketItemArray.append(newBucketItem)
            self.saveItems()
        }
        
        alert.addTextField { (alertTitleTextField) in
            alertTitleTextField.placeholder = "Create new item"
            bucketItemTitle = alertTitleTextField
        }
        
        alert.addTextField { (alertDescriptionTextField) in
            alertDescriptionTextField.placeholder = "Enter item description"
            bucketItemDescription = alertDescriptionTextField
        }
        
        alert.addAction(cancelItem)
        alert.addAction(addItem)
        
        present(alert, animated: true, completion: nil)
    }
    
//MARK: - Model Manipulation Methods
        
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<BucketItem> = BucketItem.fetchRequest()) {
        do {
            bucketItemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error)")
        }
        
        tableView.reloadData()
    }

//MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bucketItemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BucketItemCell", for: indexPath)
        let currentItem = bucketItemArray[indexPath.row]
        
        cell.textLabel?.text = currentItem.title
        cell.detailTextLabel?.text = currentItem.desc
        
        return cell
    }
}

//MARK: - TableView Delegate Methods

extension BucketListViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var bucketItemTitle = UITextField()
        var bucketItemDescription = UITextField()
        
        let currentItem = bucketItemArray[indexPath.row]
        
        let alert = UIAlertController(title: "Bucket List Item", message: "", preferredStyle: .alert)
        
        let goBack = UIAlertAction(title: "Back", style: .default, handler: nil)
        let modifyItem = UIAlertAction(title: "Modify", style: .default) { (modifyItem) in
            self.bucketItemArray[indexPath.row].title = !bucketItemTitle.isEmpty ? bucketItemTitle.text : "New Bucket Item"
            self.bucketItemArray[indexPath.row].desc = bucketItemDescription.text

            self.saveItems()
        }
        
        let deleteItem = UIAlertAction(title: "Delete", style: .destructive) { [self] (deleteItem) in
            context.delete(bucketItemArray[indexPath.row])
            
            self.bucketItemArray.remove(at: indexPath.row)
            self.saveItems()
        }
        
        alert.addTextField { (alertTitleTextField) in
            alertTitleTextField.placeholder = "Item title"
            alertTitleTextField.text = currentItem.title
            
            bucketItemTitle = alertTitleTextField
        }
        
        alert.addTextField { (alertDescriptionTextField) in
            alertDescriptionTextField.placeholder = "Item description"
            alertDescriptionTextField.text = currentItem.desc
            
            bucketItemDescription = alertDescriptionTextField
        }
        
        alert.addAction(goBack)
        alert.addAction(modifyItem)
        alert.addAction(deleteItem)
        
        present(alert, animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

//MARK: -  UISearchBar Delegate Methods

extension BucketListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<BucketItem> = BucketItem.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
            searchBarSearchButtonClicked(searchBar)
        }
    }
    
}

//MARK: - Extensions

extension UITextField {

    var isEmpty: Bool {
        return text?.trimmingCharacters(in: .whitespaces) == ""
    }
    
}
