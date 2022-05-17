//
//  ViewController.swift
//  Todo Realm
//
//  Created by Konstantin on 17.05.2022.
//

import UIKit

class CategoryViewController: UITableViewController {
    
    private var categories: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.setupNavigationBar()
        
        categories = ["start", "second", "save the world!"]
        
    }
    
    @IBAction func addButtonAction(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add new category", style: .default) { [weak self] action in
            guard let self = self else { return }
            
            guard let text = alert.textFields?.first?.text else { return }
            
            self.categories.append(text)
            self.tableView.reloadData()
        }
        
        alert.addTextField { $0.placeholder = "Create a new Category" }
        
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    

}

// MARK: - Table view data source

extension CategoryViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoriesCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        let model = categories[indexPath.row]
        content.text = model
        
        cell.contentConfiguration = content
        return cell
    }
    
}

extension CategoryViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToTaskListVC", sender: self)
    }
    
}
