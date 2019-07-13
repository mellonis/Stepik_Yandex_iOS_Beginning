//
//  GameControlView.swift
//  Game
//
//  Created by Ruslan Gilmullin on 13/07/2019.
//  Copyright © 2019 Ruslan Gilmullin. All rights reserved.
//

import UIKit

@IBDesignable class GameControlView: UIView {
    let stepper = UIStepper()
    let timeLabel = UILabel()
    let actionButton = UIButton()
    @IBInspectable var gameDuration: TimeInterval {
        get {
            return stepper.value
        }
        set {
            stepper.value = newValue
            updateUI()
        }
    }
    @IBInspectable var gameTimeLeft: TimeInterval = 0 {
        didSet {
            updateUI()
        }
    }
    @IBInspectable var isGameActive = false {
        didSet {
            updateUI()
        }
    }
    var stopStartHandler: (() -> Void)?
    
    override var intrinsicContentSize: CGSize {
        let timeLabelSize = timeLabel.intrinsicContentSize
        let stepperSize = stepper.intrinsicContentSize
        let actionButtonSize = actionButton.intrinsicContentSize
        let width = timeLabelSize.width + timeLabelToStepperMargin + stepperSize.width
        let height = stepperSize.height + actionButtonTopMargin + actionButtonSize.height
        
        return CGSize(width: width, height: height)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private let timeLabelToStepperMargin: CGFloat = 8
    private let actionButtonTopMargin: CGFloat = 8
    
    override func layoutSubviews() {
        let stepperSize = stepper.intrinsicContentSize
        
        stepper.frame = CGRect(
            origin: CGPoint(
                x: bounds.maxX - stepperSize.width,
                y: bounds.minY
            ),
            size: stepperSize
        )
        
        let timeLabelSize = timeLabel.intrinsicContentSize
        
        timeLabel.frame = CGRect(
            origin: CGPoint(
                x: bounds.minX,
                y: bounds.minY + (stepperSize.height - timeLabelSize.height) / 2
            ),
            size: timeLabelSize
        )
        
        let actionButtonSize = actionButton.intrinsicContentSize
        
        actionButton.frame = CGRect(
            origin: CGPoint(
                x: bounds.minX + (bounds.maxX - actionButtonSize.width) / 2,
                y: stepper.frame.maxY + actionButtonTopMargin
            ),
            size: actionButtonSize
        )
    }
    
    @objc func actionButtonTapped() {
        stopStartHandler?()
    }
    
    private func setupViews() {
        addSubview(timeLabel)
        addSubview(stepper)
        addSubview(actionButton)
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = true
        stepper.translatesAutoresizingMaskIntoConstraints = true
        actionButton.translatesAutoresizingMaskIntoConstraints = true
        
        stepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
        stepper.minimumValue = 5
        stepper.maximumValue = 60
        stepper.stepValue = 5
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        actionButton.setTitleColor(actionButton.tintColor, for: .normal)
        updateUI()
    }
    
    @objc func stepperValueChanged() {
        updateUI()
    }
    
    private func updateUI() {
        stepper.isEnabled = !isGameActive
        
        if isGameActive {
            timeLabel.text = "Осталось: \(Int(gameTimeLeft)) сек."
            actionButton.setTitle("Остановить", for: .normal)
        } else {
            timeLabel.text = "Время: \(Int(stepper.value)) сек."
            actionButton.setTitle("Начать", for: .normal)
        }
        
        setNeedsLayout()
    }
}
