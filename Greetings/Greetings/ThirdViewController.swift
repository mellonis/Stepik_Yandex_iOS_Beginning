//
//  ThirdViewController.swift
//  Greetings
//
//  Created by Ruslan Gilmullin on 21/07/2019.
//  Copyright © 2019 Ruslan Gilmullin. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.addTarget(self, action: #selector(updateNameAndShowGreeting), for: .editingDidEndOnExit)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        nameTextField.text = Storage.person.name
    }
    
    @objc private func updateNameAndShowGreeting() {
        if let name = nameTextField.text {
            if name.count > 0 {
                Storage.person.name = name
                tabBarController?.selectedIndex = 0
            }
        }
    }
}
