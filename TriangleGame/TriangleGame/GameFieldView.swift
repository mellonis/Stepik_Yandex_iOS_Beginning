//
//  GameFieldView.swift
//  Game
//
//  Created by Ruslan Gilmullin on 13/07/2019.
//  Copyright © 2019 Ruslan Gilmullin. All rights reserved.
//

import UIKit

@IBDesignable class GameFieldView: UIView {
    @IBInspectable var bufferSize: CGFloat = GameFieldView.bufferSize {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var isShapeHidden = false {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var shapeColor: UIColor = .red {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var shapePosition: CGPoint = CGPoint(x: GameFieldView.bufferSize, y: GameFieldView.bufferSize) {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var shapeSize: CGSize = CGSize(width: 40, height: 40) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private static let bufferSize: CGFloat = 8
    private var currentPath: UIBezierPath?
    var shapeHitHandler: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard !isShapeHidden else {
            currentPath = nil
            return
        }
        
        shapeColor.setFill()
        currentPath = getTrianglePath(in: CGRect(origin: shapePosition, size: shapeSize))
        currentPath!.fill()
    }
    
    func getTrianglePath(in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.close()
        path.stroke()
        path.fill()
        
        return path
    }
    
    func randomizeShapes() {
        let minX = self.bufferSize
        let minY = self.bufferSize
        let maxX = self.bounds.maxX - shapeSize.width - self.bufferSize
        let maxY = self.bounds.maxY - shapeSize.height - self.bufferSize
        let x = CGFloat.random(in: minX..<maxX)
        let y = CGFloat.random(in: minY..<maxY)
        
        shapePosition = CGPoint(x: x, y: y)
    }
    
    func setupViews() {
        layer.borderWidth = 1
        layer.cornerRadius = 8
        layer.borderColor = UIColor.gray.cgColor
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        guard shapeHitHandler != nil else { return }
        guard let currentParth = currentPath else { return }
        
        let isSchapeWasHit = touches.contains(where: { touch -> Bool in
            let touchPoint = touch.location(in: self)
            
            return currentParth.contains(touchPoint)
        })
        
        if (isSchapeWasHit) {
            shapeHitHandler!()
        }
    }
}
