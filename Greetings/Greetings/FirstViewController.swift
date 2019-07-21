//
//  FirstViewController.swift
//  Greetings
//
//  Created by Ruslan Gilmullin on 21/07/2019.
//  Copyright © 2019 Ruslan Gilmullin. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        if let name = nameTextField.text {
            if name.count > 0 {
                Storage.person.name = name
                performSegue(withIdentifier: "Login", sender: self)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
