//
//  ViewController.swift
//  TriangleGame
//
//  Created by Ruslan Gilmullin on 13/07/2019.
//  Copyright © 2019 Ruslan Gilmullin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var gameControl: GameControlView!
    @IBOutlet weak var gameFieldView: GameFieldView!
    @IBOutlet weak var scoreLabel: UILabel!
    func actionButtonTapped() {
        if gameControl.isGameActive {
            stopGame()
        } else {
            startGame()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameFieldView.shapeHitHandler = { [weak self] in self?.shapeHitHandler() }
        gameControl.stopStartHandler = { [weak self] in self?.actionButtonTapped() }
        gameControl.gameDuration = 20
        stopGame()
    }
    
    private var gameTimer: Timer?
    private var triangleDisplayDuration: TimeInterval = 2
    private var triangleMoveTimer: Timer?
    private var gameScore = 0
    
    @objc private func gameTimerTick() {
        gameControl.gameTimeLeft -= 1
        
        if gameControl.gameTimeLeft <= 0 {
            stopGame()
        }
    }
    
    private func moveTriangleWithScheduledMove() {
        triangleMoveTimer?.invalidate()
        triangleMoveTimer = Timer.scheduledTimer(
            timeInterval: triangleDisplayDuration,
            target: self,
            selector: #selector(moveTriangle),
            userInfo: nil,
            repeats: true
        )
        triangleMoveTimer?.fire()
    }
    
    @objc private func moveTriangle() {
        gameFieldView.randomizeShapes()
    }
    
    func shapeHitHandler() {
        guard gameControl.isGameActive else { return }
        gameScore += 1
        moveTriangleWithScheduledMove()
    }
    
    private func startGame() {
        moveTriangleWithScheduledMove()
        gameTimer?.invalidate()
        gameTimer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(gameTimerTick),
            userInfo: nil,
            repeats: true
        )
        gameScore = 0
        gameControl.gameTimeLeft = gameControl.gameDuration
        gameControl.isGameActive = true
        updateUI()
    }
    
    private func stopGame() {
        gameTimer?.invalidate()
        triangleMoveTimer?.invalidate()
        gameControl.isGameActive = false
        scoreLabel.text = "Последний счёт: \(gameScore)"
        updateUI()
    }
    
    private func updateUI() {
        gameFieldView.isShapeHidden = !gameControl.isGameActive
    }
}
