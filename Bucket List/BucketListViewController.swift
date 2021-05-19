//
//  ViewController.swift
//  Bucket List
//
//  Created by Daniel Caccia on 19/05/21.
//

import UIKit

class BucketListViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return count of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BucketItemCell", for: indexPath)
        
//        cell.textLabel?.text = the cell title here
        
        return cell
    }
    
}

