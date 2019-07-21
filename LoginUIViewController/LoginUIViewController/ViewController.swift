//
//  ViewController.swift
//  LoginUIViewController
//
//  Created by Ruslan Gilmullin on 21/07/2019.
//  Copyright © 2019 Ruslan Gilmullin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func SingInButtonTouched(_ sender: Any) {
        if let userName = loginTextField.text {
            if userName.count > 0 {
                let greetingViewController = GreetingViewController()
                
                greetingViewController.userName = userName
                present(greetingViewController, animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

