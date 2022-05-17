//
//  ViewController.swift
//  Todo Realm
//
//  Created by Konstantin on 17.05.2022.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    private let realm = try! Realm()
    
    private var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.setupNavigationBar()
        
        loadCategories()
        
    }
    
    @IBAction func addButtonAction(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add new category", style: .default) { [weak self] action in
            guard let self = self else { return }
            
            guard let text = alert.textFields?.first?.text else { return }
            
            let newCategory = Category()
            newCategory.name = text
            
            self.save(category: newCategory)
        }
        
        alert.addTextField { $0.placeholder = "Create a new Category" }
        
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    

}

// MARK: - Table view data source

extension CategoryViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoriesCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        let model = categories?[indexPath.row]
        content.text = model?.name
        
        cell.contentConfiguration = content
        return cell
    }
    
}

extension CategoryViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToTaskListVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? TodoListViewController else { return }
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        
        destinationVC.selectedCategory = categories?[indexPath.row]
    }
    
}

// MARK: - Data Manipulation Method

extension CategoryViewController {
    
    private func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
 
        tableView.reloadData()
    }
    
    private func loadCategories() {
        
        categories = realm.objects(Category.self)
        tableView.reloadData()
        
    }
    
}
