//
//  ColorPickerViewController.swift
//  Notes
//
//  Created by Ruslan Gilmullin on 22/07/2019.
//  Copyright © 2019 Ruslan Gilmullin. All rights reserved.
//

import UIKit
import CocoaLumberjack

class ColorPickerViewController: UIViewController {
    @IBOutlet weak var selectedColorView: UIView!
    @IBOutlet weak var selectedColorTitle: UILabel!
    @IBOutlet weak var brightnessSlider: UISlider!
    @IBOutlet weak var palleteView: UIView!
    @IBAction func brightnessSliderValueChanged(_ sender: UISlider) {
        let brightness = CGFloat((brightnessSlider?.value ?? 127.0) / (brightnessSlider?.maximumValue ?? 255.0))
        
        setBrightness(brightness: brightness);
    }

    private var gradientLayer: CAGradientLayer?
    private var gradientLayer2: CAGradientLayer?
    private var targetLayer: CAShapeLayer?
    private var lastTouch: UITouch?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradientLayer = CAGradientLayer()
        gradientLayer2 = CAGradientLayer()
        
        if let gradientLayer = gradientLayer, let gradientLayer2 = gradientLayer2 {
            gradientLayer.frame = palleteView.bounds
            gradientLayer2.frame = palleteView.bounds
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
        
        targetLayer = CAShapeLayer()
        
        if let targetLayer = targetLayer {
            targetLayer.fillColor = UIColor.clear.cgColor
            targetLayer.strokeColor = UIColor.black.cgColor
            targetLayer.lineWidth = 1
        }
        
        palleteView.layer.insertSublayer(gradientLayer!, at: 0)
        palleteView.layer.insertSublayer(gradientLayer2!, at: 1)
        setBrightness(brightness: 0.5)
        
        if let color = Storage.customColor {
            selectedColorView.layer.backgroundColor = color.cgColor
            selectedColorTitle.text = "#\(color.toHex() ?? "??????")"
        }
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
    
    private func pickColorFromPoint(touch: UITouch?) {
        guard touch != nil else { return }
        
        lastTouch = touch!
        
        if let location = touch?.location(in: palleteView) {
            if palleteView.layer.bounds.contains(location) {
                let path = UIBezierPath(
                    arcCenter: location,
                    radius: 15,
                    startAngle: 0,
                    endAngle: CGFloat.pi * 2,
                    clockwise: true
                )
                
                targetLayer!.path = path.cgPath
                palleteView.layer.insertSublayer(targetLayer!, at: 2)
                DDLogDebug("Touch location is (\(location.x), \(location.y))")
                let color = palleteView.colorOfPoint(point: location)
                DDLogDebug("Color is \(color)")
                Storage.customColor = color
                selectedColorView.layer.backgroundColor = color.cgColor
                selectedColorTitle.text = "#\(color.toHex() ?? "??????")"
            }
        }
    }
    
    private func setBrightness(brightness: CGFloat) {
        DDLogDebug("Brightness is \(brightness)")
        
        gradientLayer2!.colors = [
            UIColor.init(white: brightness, alpha: 0).cgColor,
            UIColor.init(white: brightness, alpha: 1).cgColor,
        ]
        
        if let lastTouch = lastTouch {
            pickColorFromPoint(touch: lastTouch)
        }
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
