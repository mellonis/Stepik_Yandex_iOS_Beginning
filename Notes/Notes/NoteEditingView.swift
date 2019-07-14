//
//  NoteEditingView.swift
//  Notes
//
//  Created by Ruslan Gilmullin on 14/07/2019.
//  Copyright © 2019 Ruslan Gilmullin. All rights reserved.
//

import UIKit
import CocoaLumberjack

@IBDesignable class NoteEditingView: UIView, UITextViewDelegate {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextWrapperView: UIView!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var bodyTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var destroyDateHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var useDestroyDateSwitch: UISwitch!
    @IBOutlet weak var destroyDateDatePicker: UIDatePicker!
    @IBOutlet weak var whiteColorTagView: UIView!
    @IBOutlet weak var redColorTagView: UIView!
    @IBOutlet weak var greenColorTagView: UIView!
    @IBOutlet weak var customColorTagView: UIView!
    @IBAction func useDestroyDateValueChanged(_ sender: UISwitch) {
        updateUI()
    }
    @IBAction func whiteColorTagTapped(_ sender: UITapGestureRecognizer) {
        noteColor = UIColor.white
    }
    @IBAction func redColorTagTapped(_ sender: UITapGestureRecognizer) {
        noteColor = UIColor.red
    }
    @IBAction func greenColorTagTapped(_ sender: UITapGestureRecognizer) {
        noteColor = UIColor.green
    }
    @IBAction func customColorTagLongPressed(_ sender: UILongPressGestureRecognizer) {
        requestCustomColor?()
        
        guard gradientLayer != nil && gradientLayer2 != nil else { return }
        
        gradientLayer!.removeFromSuperlayer()
        gradientLayer2!.removeFromSuperlayer()
        gradientLayer = nil
        gradientLayer2 = nil
    }
    
    @IBInspectable var noteTitle: String {
        get {
            return titleTextField.text ?? ""
        }
        set {
            return titleTextField.text = newValue
        }
    }
    
    @IBInspectable var noteBoby: String {
        get {
            return bodyTextView.text
        }
        set {
            bodyTextView.text = newValue
        }
    }
    
    @IBInspectable var useDestroyDate: Bool {
        get {
            return useDestroyDateSwitch.isOn
        }
        set {
            useDestroyDateSwitch.isOn = newValue
        }
    }
    
    @IBInspectable var noteDestroyDate: Date? {
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
    
    @IBInspectable var noteColor: UIColor = UIColor.white {
        didSet {
            updateUI()
        }
    }
    
    var requestCustomColor: (() -> Void)?
    private var customColor: UIColor?
    private var gradientLayer: CAGradientLayer?
    private var gradientLayer2: CAGradientLayer?
    private var targetLayer: CAShapeLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    override func draw(_ rect: CGRect) {
        guard gradientLayer != nil && gradientLayer2 != nil else { return }
        
        customColorTagView.layer.insertSublayer(gradientLayer!, at: 0)
        customColorTagView.layer.insertSublayer(gradientLayer2!, at: 1)
    }
    
    private func loadViewFromXib() -> UIView {
        let bundle = Bundle.init(for: type(of: self))
        let nib = UINib(nibName: "NoteEditingView", bundle: bundle)
        
        return nib.instantiate(withOwner: self, options: nil).first! as! UIView
    }
    
    private func setupViews() {
        let xibView = loadViewFromXib()
        
        xibView.frame = self.bounds
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(xibView)
        bodyTextView.delegate = self
        
        let borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        
        titleTextField.layer.borderColor = borderColor
        
        [bodyTextView, whiteColorTagView, redColorTagView, greenColorTagView, customColorTagView]
            .forEach { (view: UIView?) -> Void in
                if let view = view {
                    view.layer.borderColor = borderColor
                    view.layer.borderWidth = 1
                    view.layer.cornerRadius = 5
                }
            }
        
        whiteColorTagView.backgroundColor = UIColor.white
        redColorTagView.backgroundColor = UIColor.red
        greenColorTagView.backgroundColor = UIColor.green
        
        gradientLayer = CAGradientLayer()
        
        if let gradientLayer = gradientLayer {
            gradientLayer.frame = customColorTagView.bounds
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
            gradientLayer2.frame = customColorTagView.bounds
            gradientLayer2.colors = [
                UIColor.init(white: 0.5, alpha: 0).cgColor,
                UIColor.init(white: 0.5, alpha: 1).cgColor,
            ]
        }
        
        updateUI()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateUI()
    }
    
    private func updateUI() {
        bodyTextViewHeightConstraint.constant = bodyTextView.contentSize.height + 24
        bodyTextView.contentOffset = CGPoint.zero
        
        if (useDestroyDateSwitch.isOn) {
            destroyDateHeightConstraint.constant = 150
        } else {
            destroyDateHeightConstraint.constant = 0
        }
        
        destroyDateDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        
        
        
        if let targetLayer = targetLayer {
            targetLayer.removeFromSuperlayer()
        } else {
            targetLayer = CAShapeLayer()
            targetLayer!.fillColor = UIColor.clear.cgColor
            targetLayer!.strokeColor = UIColor.black.cgColor
            targetLayer!.lineWidth = 1
            targetLayer?.frame = whiteColorTagView.bounds
            
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
        }
        
        switch noteColor {
        case UIColor.white:
            whiteColorTagView.layer.addSublayer(targetLayer!)
            break
        case UIColor.red:
            redColorTagView.layer.addSublayer(targetLayer!)
            break
        case UIColor.green:
            greenColorTagView.layer.addSublayer(targetLayer!)
            break
        default:
            customColorTagView.layer.addSublayer(targetLayer!)
            customColorTagView.backgroundColor = noteColor
            break
        }
    }
}
