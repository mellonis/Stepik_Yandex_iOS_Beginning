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
                let tapBarController = UITabBarController()
                let secondViewController = SecondViewController()
                let thirdViewController = ThirdViewController()
                
                secondViewController.model = model
                secondViewController.tabBarItem = UITabBarItem(title: "Greeting", image: UIImage(named: "greeting-tap-bar-item-icon"), selectedImage: nil)
                thirdViewController.model = model
                thirdViewController.tabBarItem = UITabBarItem(title: "Edit", image: UIImage(named: "edit-tap-bar-item-icon"), selectedImage: nil)
                
                tapBarController.setViewControllers([secondViewController, thirdViewController], animated: true)
                tapBarController.selectedIndex = 0
                
                model?.name = name
                
                present(tapBarController, animated: true, completion: nil)
            }
        }
    }
    
    var model: Model?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
