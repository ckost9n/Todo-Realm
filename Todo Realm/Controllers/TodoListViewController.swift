//
//  TodoListViewController.swift
//  Todo Realm
//
//  Created by Konstantin on 17.05.2022.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    private var realm = try! Realm()
    
    private var todoItems: Results<Item>?
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }
    @IBAction func addButtonAction(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add todo list", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add new element", style: .default) { [weak self] action in
            guard let self = self else { return }
            
            guard let text = alert.textFields?.first?.text else { return }
            guard let selectedCategory = self.selectedCategory else { return }
            do {
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = text
                    selectedCategory.items.append(newItem)
                }
            } catch {
                print("Error saving new items, \(error)")
            }
            self.tableView.reloadData()
        }
        alert.addTextField { $0.placeholder = "Create new item" }
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListCell", for: indexPath)
        var content = cell.defaultContentConfiguration()

        let model = todoItems?[indexPath.row]
        content.text = model?.title

        cell.contentConfiguration = content
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        

        tableView.deselectRow(at: indexPath, animated: true)
    }

}

// MARK: - UISearchBarDelegate

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
}

extension TodoListViewController {
    
    private func save(item: Item) {
        
    }
    
    private func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
    }
    
}
