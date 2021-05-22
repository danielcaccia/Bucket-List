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
    var items = [Item]()
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var itemTitle = UITextField()
        var itemDescription = UITextField()
        
        let alert = UIAlertController(title: "Add New Bucket List Item", message: "", preferredStyle: .alert)
        
        let cancelItem = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let addItem = UIAlertAction(title: "Add Item", style: .default) { (addItem) in
            let newItem = Item(context: self.context)

            newItem.title = !itemTitle.isEmpty ? itemTitle.text : "New Item"
            newItem.desc = itemDescription.text
            newItem.parentCategory = self.selectedCategory
            
            self.items.append(newItem)
            self.saveItems()
        }
        
        alert.addAction(cancelItem)
        alert.addAction(addItem)
        alert.addTextField { (titleTextField) in
            titleTextField.placeholder = "Create new item"
            itemTitle = titleTextField
        }
        
        alert.addTextField { (descriptionTextField) in
            descriptionTextField.placeholder = "Enter item description"
            itemDescription = descriptionTextField
        }
        
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
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            items = try context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error)")
        }
        
        tableView.reloadData()
    }

//MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        
        cell.textLabel?.text = items[indexPath.row].title
        cell.detailTextLabel?.text = items[indexPath.row].desc
        
        return cell
    }

//MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var itemTitle = UITextField()
        var itemDescription = UITextField()
        
        let alert = UIAlertController(title: "Bucket List Item", message: "", preferredStyle: .alert)
        
        let goBack = UIAlertAction(title: "Back", style: .default, handler: nil)
        let modifyItem = UIAlertAction(title: "Modify", style: .default) { (modifyItem) in
            self.items[indexPath.row].title = !itemTitle.isEmpty ? itemTitle.text : "New Bucket Item"
            self.items[indexPath.row].desc = itemDescription.text

            self.saveItems()
        }
        
        let deleteItem = UIAlertAction(title: "Delete", style: .destructive) { [self] (deleteItem) in
            context.delete(items[indexPath.row])
            
            self.items.remove(at: indexPath.row)
            self.saveItems()
        }
        
        alert.addTextField { (titleTextField) in
            titleTextField.placeholder = "Item title"
            titleTextField.text = self.items[indexPath.row].title
            
            itemTitle = titleTextField
        }
        
        alert.addTextField { (descriptionTextField) in
            descriptionTextField.placeholder = "Item description"
            descriptionTextField.text = self.items[indexPath.row].desc
            
            itemDescription = descriptionTextField
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
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
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
