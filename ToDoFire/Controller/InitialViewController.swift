//
//  ViewController.swift
//  ToDoFire
//
//  Created by MacBook on 18.12.2021.
//

import UIKit
import Firebase

class InitialViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var alarmLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 25.0 // add corner radius for login button
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        alarmLabel.alpha = 0 // hide label
        
        // If user isn't log out, it will perform action in closure
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                self.goToDoTasksVC()
            }
        }
    }
    // Clear text field when ViewConroller appears again
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
            // check for empty lines
            warningText("Don't leave an empty email or password line")
            return
        }
        // Sign in existing users
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            // check for incorrect email or password
            if let error = error {
                self?.warningText("\(error.localizedDescription), \n try again")
            } else {
                self?.goToDoTasksVC()
            }
        }
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
            
            warningText("Email or password is incorrect")
            return }
        
        // Registration a new user in Firebase
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                // Show up error definition if user type information incorrectly
                self.warningText("\(error.localizedDescription), \n try again")
                
            } else {
                
                self.goToDoTasksVC()
            }
            
        }
        
        
    }
    // Animated warning text
    func warningText(_ text: String) {
        alarmLabel.text = text
        
        // Animation manager
        UIView.animate(withDuration: 4, delay: 0, options: .autoreverse) { [weak self] in
            self?.alarmLabel.alpha = 1
        } completion: { (true) in
            self.alarmLabel.alpha = 0
        }

    }
    func goToDoTasksVC() {
        // Use the code when you have separate storyboards!!!
        // Switch from Main to ToDoTasks storyboard
        let vc = UIStoryboard(name: "ToDoTasks", bundle: nil).instantiateViewController(withIdentifier: Constants.storyboardIdentifier)

        vc.modalPresentationStyle = .fullScreen // open full screen
        present(vc, animated: true, completion: nil)
    }
    
    
}

// MARK:- TextField

extension InitialViewController: UITextFieldDelegate {
    
    // It happens when return button pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide keyboard
        emailTextField.endEditing(true)
        passwordTextField.endEditing(true)
        return true
    }
    
    
}

