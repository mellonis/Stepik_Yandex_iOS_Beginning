//
//  StartViewController.swift
//  EditTitleViewController
//
//  Created by Ruslan Gilmullin on 21/07/2019.
//  Copyright © 2019 Ruslan Gilmullin. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBAction func changeTitleButtonClicked(_ sender: UIButton) {
        let editTitleViewController = EditTitleViewController(model: model)
        
        navigationController?.pushViewController(editTitleViewController, animated: true)
    }
    
    private let model = Model(title: "Привет!")
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Экран 1"
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
