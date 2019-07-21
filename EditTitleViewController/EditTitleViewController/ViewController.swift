//
//  ViewController.swift
//  EditTitleViewController
//
//  Created by Ruslan Gilmullin on 21/07/2019.
//  Copyright © 2019 Ruslan Gilmullin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBAction func changeTitleButtonClicked(_ sender: UIButton) {
        let editTitleViewController = EditTitleViewController(model: model)
        
        present(editTitleViewController, animated: true, completion: nil);
    }
    
    private let model = Model(title: "Првиет!")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        titleLabel.text = model.title
    }
}

class Model {
    var title: String
    
    init(title: String = "") {
        self.title = title
    }
}
