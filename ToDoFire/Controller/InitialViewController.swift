//
//  ViewController.swift
//  ToDoFire
//
//  Created by MacBook on 18.12.2021.
//

import UIKit

class InitialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        // Use the code when you have separate storyboards!!!
        let vc = UIStoryboard(name: "ToDoTasks", bundle: nil).instantiateViewController(withIdentifier: Constants.storyboardIdentifier)
        vc.modalPresentationStyle = .fullScreen
        
        present(vc, animated: true, completion: nil)
        
        
    }
    
}

