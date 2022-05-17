//
//  TodoListViewController.swift
//  Todo Realm
//
//  Created by Konstantin on 17.05.2022.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    private var todoListArray: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        todoListArray = ["apple", "peach"]
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoListArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListCell", for: indexPath)
        var content = cell.defaultContentConfiguration()

        let model = todoListArray[indexPath.row]
        content.text = model

        cell.contentConfiguration = content
        return cell
    }

}
