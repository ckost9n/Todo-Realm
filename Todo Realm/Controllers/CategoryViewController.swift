//
//  ViewController.swift
//  Todo Realm
//
//  Created by Konstantin on 17.05.2022.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryViewController: UITableViewController {
    
    private let realm = try! Realm()
    
    private var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.setupNavigationBar()
        
        tableView.rowHeight = 80
        
        loadCategories()
        
    }
    
    @IBAction func addButtonAction(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { [weak self] action in
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoriesCell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        var content = cell.defaultContentConfiguration()
        
        let model = categories?[indexPath.row]
        content.text = model?.name
        
        cell.contentConfiguration = content
        return cell
    }
    
}

// MARK: - SwipeTableViewCellDelegate

extension CategoryViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { [weak self] action, indexPath in
            guard let self = self else { return }
            guard let currentCategory = self.categories?[indexPath.row] else { return }
            
            self.deleteCategories(category: currentCategory)
        }
        
        deleteAction.image = UIImage(named: "Trash")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }

//    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) {
//        <#code#>
//    }
//
//    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?, for orientation: SwipeActionsOrientation) {
//        <#code#>
//    }
//
//    func visibleRect(for tableView: UITableView) -> CGRect? {
//        <#code#>
//    }
    
}

// MARK: - TableView delegate method and navigation segue

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
    
    private func deleteCategories(category: Category) {
        do {
            try realm.write {
                realm.delete(category)
            }
        } catch {
            print("Error delete, \(error)")
        }
        
    }
    
    private func loadCategories() {
        
        categories = realm.objects(Category.self)
        tableView.reloadData()
        
    }
    
}
