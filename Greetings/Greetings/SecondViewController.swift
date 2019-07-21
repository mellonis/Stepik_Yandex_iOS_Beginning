//
//  SecondViewController.swift
//  Greetings
//
//  Created by Ruslan Gilmullin on 21/07/2019.
//  Copyright © 2019 Ruslan Gilmullin. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    @IBOutlet weak var greetingLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        greetingLabel.text = "Hello, \(Storage.person.name)"
    }
}
