//
//  ViewController.swift
//  Notes
//
//  Created by Ruslan Gilmullin on 14/07/2019.
//  Copyright © 2019 Ruslan Gilmullin. All rights reserved.
//

import UIKit
import CocoaLumberjack

class ViewController: UIViewController {
    @IBOutlet weak var colorPickerView: ColorPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        colorPickerView.colorPicked = { [weak self] in self?.colorPicked() }
    }

    private func colorPicked() {
        DDLogDebug("Color has been picked. It is \(colorPickerView.selectedColor)")
    }
}

