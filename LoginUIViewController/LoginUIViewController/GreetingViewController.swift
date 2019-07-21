//
//  GreetingViewController.swift
//  LoginUIViewController
//
//  Created by Ruslan Gilmullin on 21/07/2019.
//  Copyright © 2019 Ruslan Gilmullin. All rights reserved.
//

import UIKit

class GreetingViewController: UIViewController {
    @IBOutlet weak var greetingLabel: UILabel!
    
    var userName: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        greetingLabel.text = "Hello, \(userName ?? "")"
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
