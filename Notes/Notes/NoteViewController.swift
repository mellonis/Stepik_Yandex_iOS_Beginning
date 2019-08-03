//
//  NoteViewController.swift
//  Notes
//
//  Created by Ruslan Gilmullin on 21/07/2019.
//  Copyright © 2019 Ruslan Gilmullin. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {
    @IBOutlet weak var noteTitleTextField: UITextField!
    @IBOutlet weak var noteBodyTextView: UITextView!
    @IBOutlet weak var noteBodyTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var useDestroyDateSwitch: UISwitch!
    @IBOutlet weak var destroyDateDatePicker: UIDatePicker!
    @IBOutlet weak var destroyDatePickerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var whiteTagView: UIView!
    @IBOutlet weak var greenTagView: UIView!
    @IBOutlet weak var redTagView: UIView!
    @IBOutlet weak var paletteTagView: UIView!
    @IBAction func useDestroyDateValueChanged(_ sender: UISwitch) {
        useDestroyDate = sender.isOn
    }
    @IBAction func whiteTagTapped(_ sender: UITapGestureRecognizer) {
        noteTag = .white
    }
    @IBAction func greenTagTapped(_ sender: UITapGestureRecognizer) {
        noteTag = .green
    }
    @IBAction func redTagTapped(_ sender: UITapGestureRecognizer) {
        noteTag = .red
    }
    @IBAction func paletteTagLongPressed(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .ended {
            gradientLayer?.removeFromSuperlayer()
            gradientLayer2?.removeFromSuperlayer()
            gradientLayer = nil
            gradientLayer2 = nil
            Storage.customColor = noteTag
            performSegue(withIdentifier: "ColorPicker", sender: self)
        }
    }
    var noteTitle: String {
        get {
            return noteTitleTextField.text ?? ""
        }
        set {
            noteTitleTextField?.text = newValue
        }
    }
    var noteBody: String {
        get {
            return noteBodyTextView.text
        }
        set {
            noteBodyTextView.text = newValue
        }
    }
    var useDestroyDate: Bool {
        get {
            return useDestroyDateSwitch.isOn
        }
        set {
            useDestroyDateSwitch.isOn = newValue
            updateUI()
        }
    }
    var noteDestroyDate: Date? {
        get {
            if (useDestroyDate) {
                return destroyDateDatePicker.date
            }
            
            return nil
        }
        set {
            if let newValue = newValue {
                if useDestroyDate {
                    destroyDateDatePicker.date = newValue
                }
            }
        }
    }
    var noteTag: UIColor = UIColor.white {
        didSet {
            updateUI()
        }
    }
    private var gradientLayer: CAGradientLayer?
    private var gradientLayer2: CAGradientLayer?
    private var targetLayer: CAShapeLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        
        noteTitleTextField.layer.borderColor = borderColor
        
        [noteBodyTextView, whiteTagView, greenTagView, redTagView, paletteTagView]
            .forEach { (view: UIView?) -> Void in
                if let view = view {
                    view.layer.borderColor = borderColor
                    view.layer.borderWidth = 1
                    view.layer.cornerRadius = 5
                }
        }
        
        whiteTagView.backgroundColor = UIColor.white
        greenTagView.backgroundColor = UIColor.green
        redTagView.backgroundColor = UIColor.red
        gradientLayer = CAGradientLayer()
        
        if let gradientLayer = gradientLayer {
            gradientLayer.frame = paletteTagView.bounds
            gradientLayer.transform = CATransform3DMakeRotation(CGFloat.pi / 2, 0, 0, 1)
            gradientLayer.colors = [
                UIColor.red.cgColor,
                UIColor.purple.cgColor,
                UIColor.blue.cgColor,
                UIColor.blue.cgColor,
                UIColor.green.cgColor,
                UIColor.yellow.cgColor,
                UIColor.red.cgColor,
            ]
        }
        
        gradientLayer2 = CAGradientLayer()
        
        if let gradientLayer2 = gradientLayer2 {
            gradientLayer2.frame = paletteTagView.bounds
            gradientLayer2.colors = [
                UIColor.init(white: 0.5, alpha: 0).cgColor,
                UIColor.init(white: 0.5, alpha: 1).cgColor,
            ]
        }
        
        targetLayer = CAShapeLayer()
        targetLayer!.fillColor = UIColor.clear.cgColor
        targetLayer!.strokeColor = UIColor.black.cgColor
        targetLayer!.lineWidth = 1
        targetLayer?.frame = whiteTagView.bounds
        
        let path = UIBezierPath(
            arcCenter: CGPoint(x: 45, y: 20),
            radius: 12,
            startAngle: 0,
            endAngle: CGFloat.pi * 2,
            clockwise: true
        )
        
        path.move(to: CGPoint(
            x: 38,
            y: 7
        ))
        
        path.addLine(to: CGPoint(
            x: 45,
            y: 32
        ))
        
        path.addLine(to: CGPoint(
            x: 57,
            y: 0
        ))
        
        targetLayer?.path = path.cgPath
        noteBodyTextView.delegate = self
        setupViewResizerOnKeyboardShown()
        
        if Storage.noteUid != nil {
            let note = Storage.noteBook.notes[Storage.noteIx!]
            
            noteTitle = note.title
            noteBody = note.content
            noteTag = note.color
            noteDestroyDate = note.selfDestructDate
            useDestroyDateSwitch.isOn = note.selfDestructDate != nil
        } else {
            noteTitle = ""
            noteBody = ""
            noteTag = .white
            noteDestroyDate = nil
            useDestroyDateSwitch.isOn = false
        }
    }
    
    override func viewWillLayoutSubviews() {
        guard gradientLayer != nil && gradientLayer2 != nil else { return }
        
        paletteTagView.layer.insertSublayer(gradientLayer!, at: 0)
        paletteTagView.layer.insertSublayer(gradientLayer2!, at: 1)
    }
    
    override func viewDidLayoutSubviews() {
        updateUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        var note: Note
        
        if let noteUid = Storage.noteUid {
            note = Note(uid: noteUid, title: noteTitle, content: noteBody, color: noteTag, importance: .usual, selfDestructDate: noteDestroyDate)
        } else {
            note = Note(title: noteTitle, content: noteBody, color: noteTag, importance: .usual, selfDestructDate: noteDestroyDate)
        }
        
        Storage.noteBook.add(note)
        Storage.updateTable = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let color = Storage.customColor {
            Storage.customColor = nil
            noteTag = color
        }
    }
    
    private func updateUI() {
        noteBodyTextViewHeightConstraint.constant = noteBodyTextView.contentSize.height + 24
        noteBodyTextView.contentOffset = CGPoint.zero
        destroyDateDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        
        destroyDateDatePicker.isHidden = !useDestroyDate
        
        if useDestroyDate {
            destroyDatePickerHeightConstraint.constant = 100
        } else {
            destroyDatePickerHeightConstraint.constant = 0
        }
        
        if let targetLayer = targetLayer {
            targetLayer.removeFromSuperlayer()
        }
        
        switch noteTag {
        case UIColor.white:
            whiteTagView.layer.addSublayer(targetLayer!)
            break
        case UIColor.green:
            greenTagView.layer.addSublayer(targetLayer!)
            break
        case UIColor.red:
            redTagView.layer.addSublayer(targetLayer!)
            break
        default:
            paletteTagView.layer.addSublayer(targetLayer!)
            paletteTagView.backgroundColor = noteTag
            gradientLayer?.removeFromSuperlayer()
            gradientLayer2?.removeFromSuperlayer()
            break
        }
    }
}

extension NoteViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if (textView == noteBodyTextView) {
            updateUI()
        }
    }
}

extension NoteViewController {
    func setupViewResizerOnKeyboardShown() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShowForResizing),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHideForResizing),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc func keyboardWillShowForResizing(notification: Notification) {
        if
            let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let window = self.view.window?.frame {
            self.view.frame = CGRect(
                x: self.view.frame.origin.x,
                y: self.view.frame.origin.y,
                width: self.view.frame.width,
                height: window.origin.y + window.height - keyboardSize.height
            )
        }
    }
    
    @objc func keyboardWillHideForResizing(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let viewHeight = self.view.frame.height
            self.view.frame = CGRect(
                x: self.view.frame.origin.x,
                y: self.view.frame.origin.y,
                width: self.view.frame.width,
                height: viewHeight + keyboardSize.height
            )
        }
    }
}
