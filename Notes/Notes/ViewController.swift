//
//  ViewController.swift
//  Notes
//
//  Created by Ruslan Gilmullin on 14/07/2019.
//  Copyright © 2019 Ruslan Gilmullin. All rights reserved.
//

import UIKit
import CocoaLumberjack

enum VisibleScreen {
    case noteEditing
    case colorPicker
}

class ViewController: UIViewController {
    @IBOutlet weak var noteEditingView: NoteEditingView!
    @IBOutlet weak var colorPickerView: ColorPickerView!
    
    private var visibleScreen: VisibleScreen = .noteEditing {
        didSet {
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteEditingView.requestCustomColor = { [weak self] in
            self?.requestCustomColor()
        }
        colorPickerView.colorPicked = { [weak self] in
            self?.colorPicked()
        }
        updateUI()
    }
    
    private func colorPicked() {
        visibleScreen = .noteEditing
        noteEditingView.noteColor = colorPickerView.selectedColor
    }
    
    private func requestCustomColor() {
        visibleScreen = .colorPicker
        colorPickerView.selectedColor = noteEditingView.noteColor
    }
    
    private func updateUI() {
        switch visibleScreen {
        case .noteEditing:
            noteEditingView.isHidden = false
            colorPickerView.isHidden = true
        default:
            noteEditingView.isHidden = true
            colorPickerView.isHidden = false
        }
    }
}

