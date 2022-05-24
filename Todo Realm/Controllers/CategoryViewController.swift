//
//  ViewController.swift
//  Todo Realm
//
//  Created by Konstantin on 17.05.2022.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    private let realm = try! Realm()
    
    private var categories: Results<Category>?
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar
            .setupNavigationBar(barColor: .systemBlue, textColor: .white)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    override func updateModel(at indexPath: IndexPath) {
        guard let currentCategory = categories?[indexPath.row] else { return }
        deleteCategories(category: currentCategory)
    }
    
}

// MARK: - Table view data source

extension CategoryViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        var content = cell.defaultContentConfiguration()
        guard let model = categories?[indexPath.row] else { return cell }
        
        if model.hexColor == "" {
            updateHexColor(category: model, hexColor: UIColor.randomFlat().hexValue())
        }
        let barColor = UIColor(hexString: model.hexColor)!
        let textColor = ContrastColorOf(barColor, returnFlat: true)
        
        cell.backgroundColor = barColor
        content.text = model.name
        content.textProperties.color = textColor
        
        cell.contentConfiguration = content
        return cell
    }
    
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
    
    private func updateHexColor(category: Category, hexColor: String) {
        do {
            try realm.write {
                category.hexColor = hexColor
            }
        } catch {
            print("Error saving done status, \(error)")
        }
        tableView.reloadData()
    }
    
    private func loadCategories() {
        
        categories = realm.objects(Category.self)
        tableView.reloadData()
        
    }
}
