//
//  ColorPickerView.swift
//  Notes
//
//  Created by Ruslan Gilmullin on 14/07/2019.
//  Copyright © 2019 Ruslan Gilmullin. All rights reserved.
//

import UIKit
import CocoaLumberjack

@IBDesignable class ColorPickerView: UIView {
    @IBOutlet weak var selectColorWrapper: UIView!
    @IBOutlet weak var selectedColorView: UIView!
    @IBOutlet weak var selectedColorLabel: UILabel!
    @IBOutlet weak var brightnessSlider: UISlider!
    @IBOutlet weak var huePalette: UIView!
    @IBOutlet weak var doneButton: UIButton!
    @IBAction func brightnessSliderValueChanged(_ sender: UISlider) {
        setNeedsDisplay()
    }
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        colorPicked?()
    }
    
    var colorPicked: (() -> Void)?
    private var gradientLayer: CAGradientLayer?
    private var gradientLayer2: CAGradientLayer?
    private var targetLayer: CAShapeLayer?
    private var lastPalletePoint: CGPoint?
    
    @IBInspectable var selectedColor: UIColor = .green {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        pickColorFromPoint(touch: touches.first)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        pickColorFromPoint(touch: touches.first)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        pickColorFromPoint(touch: touches.first)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        if let gradientLayer = gradientLayer {
            gradientLayer.removeFromSuperlayer()
        } else {
            gradientLayer = CAGradientLayer()
        }
        
        if let gradientLayer2 = gradientLayer2 {
            gradientLayer2.removeFromSuperlayer()
        } else {
            gradientLayer2 = CAGradientLayer()
        }
        
        if let targetLayer = targetLayer {
            targetLayer.removeFromSuperlayer()
        } else {
            targetLayer = CAShapeLayer()
            targetLayer!.fillColor = UIColor.clear.cgColor
            targetLayer!.strokeColor = UIColor.black.cgColor
            targetLayer!.lineWidth = 1
        }
        
        gradientLayer!.frame = huePalette.bounds
        gradientLayer2!.frame = huePalette.bounds
        gradientLayer!.transform = CATransform3DMakeRotation(CGFloat.pi / 2, 0, 0, 1)
        gradientLayer!.colors = [
            UIColor.red.cgColor,
            UIColor.purple.cgColor,
            UIColor.blue.cgColor,
            UIColor.blue.cgColor,
            UIColor.green.cgColor,
            UIColor.yellow.cgColor,
            UIColor.red.cgColor,
        ]
        
        let brightness = CGFloat((brightnessSlider?.value ?? 127.0) / (brightnessSlider?.maximumValue ?? 255.0))
        
        DDLogDebug("Brightness is \(brightness)")
        
        gradientLayer2!.colors = [
            UIColor.init(white: brightness, alpha: 0).cgColor,
            UIColor.init(white: brightness, alpha: 1).cgColor,
        ]
        huePalette.layer.insertSublayer(gradientLayer!, at: 0)
        huePalette.layer.insertSublayer(gradientLayer2!, at: 1)
        
        if let lastPalletePoint = lastPalletePoint {
            let path = UIBezierPath(
                arcCenter: lastPalletePoint,
                radius: 15,
                startAngle: 0,
                endAngle: CGFloat.pi * 2,
                clockwise: true
            )
            
            targetLayer!.path = path.cgPath
            huePalette.layer.insertSublayer(targetLayer!, at: 2)
            self.lastPalletePoint = nil
        }
    }
    
    private func pickColorFromPoint(touch: UITouch?) {
        guard touch != nil else { return }
        
        if let location = touch?.location(in: huePalette) {
            if huePalette.layer.bounds.contains(location) {
                lastPalletePoint = location
                DDLogDebug("Touch location is (\(location.x), \(location.y))")
                selectedColor = huePalette.colorOfPoint(point: location)
                DDLogDebug("Color is \(selectedColor)")
                updateUI()
            }
        }
    }
    
    private func loadViewFromXib() -> UIView {
        let bundle = Bundle.init(for: type(of: self))
        let nib = UINib(nibName: "ColorPickerView", bundle: bundle)
        
        return nib.instantiate(withOwner: self, options: nil).first! as! UIView
    }
    
    private func setupViews() {
        let xibView = loadViewFromXib()
        
        xibView.frame = self.bounds
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(xibView)
        selectColorWrapper.layer.borderColor = UIColor.black.cgColor
        selectColorWrapper.layer.borderWidth = 1
        selectColorWrapper.layer.cornerRadius = 14
        selectedColorView.layer.cornerRadius = 14
        selectedColorLabel.layer.backgroundColor = UIColor.white.cgColor
        huePalette.layer.borderColor = UIColor.black.cgColor
        huePalette.layer.borderWidth = 1
        updateUI()
    }
    
    private func updateUI() {
        selectedColorView.layer.backgroundColor = selectedColor.cgColor
        selectedColorLabel.text = "#\(selectedColor.toHex() ?? "??????")"
    }
}

extension UIColor {
    func toHex(alpha: Bool = false) -> String? {
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)
        
        if components.count >= 4 {
            a = Float(components[3])
        }
        
        if alpha {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
}

extension UIView {
    func colorOfPoint(point: CGPoint) -> UIColor {
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        var pixelData: [UInt8] = [0, 0, 0, 0]
        let context = CGContext(
            data: &pixelData,
            width: 1,
            height: 1,
            bitsPerComponent: 8,
            bytesPerRow: 4,
            space: colorSpace,
            bitmapInfo:
            bitmapInfo.rawValue
        )
        
        context!.translateBy(x: -point.x, y: -point.y)
        self.layer.render(in: context!)
        
        let red = CGFloat(pixelData[0]) / CGFloat(255.0)
        let green = CGFloat(pixelData[1]) / CGFloat(255.0)
        let blue = CGFloat(pixelData[2]) / CGFloat(255.0)
        let alpha = CGFloat(pixelData[3]) / CGFloat(255.0)
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        
        return color
    }
}
