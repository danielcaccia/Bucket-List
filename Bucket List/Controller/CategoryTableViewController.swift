//
//  CategoryTableViewController.swift
//  Bucket List
//
//  Created by Daniel Caccia on 22/05/21.
//

import UIKit
import CoreData
import SwipeCellKit

class CategoryTableViewController: UITableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categories = [Category]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        tableView.rowHeight = 75.0
        tableView.separatorStyle = .none
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "lbl_add_new_cat".localized, message: "", preferredStyle: .alert)
        
        let cancelCategory = UIAlertAction(title: "lbl_cancel".localized, style: .default, handler: nil)
        let addCategory = UIAlertAction(title: "lbl_add".localized, style: .default) { (addCategory) in
            let newCategory = Category(context: self.context)

            newCategory.name = !textField.isEmpty ? textField.text : "lbl_new_cat".localized

            self.categories.append(newCategory)
            self.saveCategories()
            
            self.tableView.reloadData()
        }
        
        alert.addAction(cancelCategory)
        alert.addAction(addCategory)
        alert.addTextField { (field) in
            field.placeholder = "lbl_cat_name".localized
            textField = field
        }
        
        present(alert, animated: true, completion: nil)
    }

//MARK: - Model Manipulation Methods
    
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error)")
        }
        
        tableView.reloadData()
    }
    
//MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        
        cell.textLabel?.text = categories[indexPath.row].name
        cell.delegate = self
        
        return cell
    }
    
//MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! BucketListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
}

//MARK: - SwipeTableCell Delegate Methods

extension CategoryTableViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "lbl_delete".localized) { action, indexPath in
            self.context.delete(self.categories[indexPath.row])
            
            self.categories.remove(at: indexPath.row)
            self.saveCategories()
        }

        deleteAction.image = UIImage(named: "delete-icon")

        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        
        options.expansionStyle = .destructive
        
        return options
    }
    
}
