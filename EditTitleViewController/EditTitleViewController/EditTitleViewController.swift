//
//  EditTitleViewController.swift
//  EditTitleViewController
//
//  Created by Ruslan Gilmullin on 21/07/2019.
//  Copyright © 2019 Ruslan Gilmullin. All rights reserved.
//

import UIKit

class EditTitleViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    private let model: Model
    
    init(model: Model) {
        self.model = model
        super.init(nibName: nil, bundle: nil);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Экран 2"
        
        let leftButton = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveTitle))
        let rightButton = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(discardChangesAndPop))
        
        rightButton.setTitleTextAttributes([.foregroundColor: UIColor.red], for: .normal)
        
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleTextField.text = model.title
    }
    
    @objc private func saveTitle() {
        model.title = titleTextField.text ?? ""
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func discardChangesAndPop() {
        navigationController?.popViewController(animated: true)
    }
}
