//
//  ToDoTasksViewController.swift
//  ToDoFire
//
//  Created by MacBook on 19.12.2021.
//

import UIKit
import Firebase

class ToDoTasksViewController: UIViewController {
    
    let db = Firestore.firestore() // invoke Firestore
    
    var tasks: [Task] = []
    
    
    @IBOutlet weak var toDoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toDoTableView.dataSource = self
        toDoTableView.delegate = self
        
        // change bar buttons color to white
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem?.tintColor = .white
        readData()

        
    }
    // Read data from Firebase
    func readData() {
        db.collection("newTask").addSnapshotListener() { (querySnapshot, error) in
            
            self.tasks = [] // Avoid duplicate data in array
            
            guard error == nil, let documents = querySnapshot?.documents else { return }
            
            for doc in documents {
                let data = doc.data()
                // Retrieve user and text from data in Firebase fields
                guard let text = data["bodyField"] as? String, let user = data["senderField"] as? String else { return }
                // Set data in array to show it on TableView
                let item = Task(user: user, newTask: text)
                self.tasks.append(item)
                
                DispatchQueue.main.async {
                    self.toDoTableView.reloadData()
                }
                
            }
        }
    }
    
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // Create alert and action buttons
        let alert = UIAlertController(title: "New Task", message: "Add a new task", preferredStyle: .alert)
        
        // Add text field to alert
        alert.addTextField()
        
        let saveButton = UIAlertAction(title: "SAVE", style: .default) { (action) in
            // Unwraping text from textfield and check for empty string
            // Check for current user is admitted
            guard let taskText = alert.textFields?.first?.text, taskText != "", let userEmail = Auth.auth().currentUser?.email else {
                
                return
            }
            // Actions when button pressed
            // Save data to Firestore
            // newTask - collection name in Firestore, senderField and bodyField are field names in Firestore
            self.db.collection("newTask").addDocument(data: [
                
                "senderField": userEmail,
                "bodyField": taskText
            
            
            ]) { (error) in
                guard error != nil else { return }
                print("There was a issue with saving data to Firestore")
            }
            
            
            print("It has been saved \(taskText) and \(userEmail)")
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
// MARK: - Data Source Method
extension ToDoTasksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.identifier, for: indexPath)
        
        
        cell.backgroundColor = .clear // clear row background
        cell.textLabel?.textColor = .white // set white color to text row
        
        cell.textLabel?.text = tasks[indexPath.row].newTask
        
        
        return cell
    }
    
    
}
// MARK: - Table View Delegate Method
extension ToDoTasksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("wow)))")
        }
    }
    
}
