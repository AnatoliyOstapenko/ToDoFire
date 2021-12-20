//
//  ToDoTasksViewController.swift
//  ToDoFire
//
//  Created by MacBook on 19.12.2021.
//

import UIKit

class ToDoTasksViewController: UIViewController {
    
    
    @IBOutlet weak var toDoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toDoTableView.dataSource = self
        toDoTableView.delegate = self

        // Do any additional setup after loading the view.
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    }
    
}

extension ToDoTasksViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.identifier, for: indexPath)
        
        
        cell.backgroundColor = .clear
        cell.textLabel?.text = "index path row = \(indexPath.row)"
        
        
        return cell
    }
    
    
}
