//
//  ToDoTasksViewController.swift
//  ToDoFire
//
//  Created by MacBook on 19.12.2021.
//

import UIKit
import Firebase

class ToDoTasksViewController: UIViewController {
    
    
    @IBOutlet weak var toDoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toDoTableView.dataSource = self
        toDoTableView.delegate = self
        
        // change bar buttons color to white
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem?.tintColor = .white

        
    }
    
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // Create alert and action buttons
        let alert = UIAlertController(title: "New Task", message: "Add a new task", preferredStyle: .alert)
        
        // Add
        
        let saveButton = UIAlertAction(title: "SAVE", style: .default) { (action) in
            print("It has been saved")
        }
        let cancelButton = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
        
        alert.addAction(saveButton)
        alert.addAction(cancelButton)
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
         
        // Sign out user
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            
            // dismiss current screen and go back to previous VC
            self.dismiss(animated: true, completion: nil)
            
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
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
