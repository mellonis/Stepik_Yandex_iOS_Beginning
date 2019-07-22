//
//  GalleryViewController.swift
//  Notes
//
//  Created by Ruslan Gilmullin on 21/07/2019.
//  Copyright © 2019 Ruslan Gilmullin. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Gallery"
        
        let rightButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        
        navigationItem.rightBarButtonItem = rightButton
    }
}
