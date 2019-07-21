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
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        model.title = titleTextField.text ?? ""
        dismiss(animated: true, completion: nil)
    }
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

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleTextField.text = model.title
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
