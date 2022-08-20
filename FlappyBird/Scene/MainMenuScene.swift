//
//  MainMenuScene.swift
//  FlappyBird
//
//  Created by 李泰儀 on 2022/8/12.
//

import SpriteKit

class MainMenuScene: SKScene {
    
    var birdButton = SKSpriteNode()
    var scoreLabel = SKLabelNode()
    
    override func didMove(to view: SKView) {
        setup()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if atPoint(location).name == "Play" {
                if let gameplay = GameplayScene(fileNamed: "GameplayScene") {
                    gameplay.scaleMode = .aspectFill
                    view?.presentScene(gameplay, transition: SKTransition.doorway(withDuration: 1))
                }
            } else if atPoint(location).name == "Highscore" {
                scoreLabel.removeFromParent()
                setupScoreLabel()
            } else if atPoint(location).name == "Bird" {
                GameManager.shared.toggleBird()
                birdButton.removeFromParent()
                setupBird()
            }
        }
    }
    
    func setup() {
        setupBackground()
        setupButtons()
        setupBird()
    }
    
    func setupBackground() {
        let bg = SKSpriteNode(imageNamed: "BG Day")
        bg.position = .zero
        bg.zPosition = 0
        addChild(bg)
    }
    
    func setupButtons() {
        let play = SKSpriteNode(imageNamed: "Play")
        play.name = "Play"
        play.position = CGPoint(x: -180, y: -50)
        play.zPosition = 1
        play.setScale(0.7)
        
        let highscore = SKSpriteNode(imageNamed: "Highscore")
        highscore.name = "Highscore"
        highscore.position = CGPoint(x: 180, y: -50)
        highscore.zPosition = 1
        highscore.setScale(0.7)
        
        addChild(play)
        addChild(highscore)
    }
    
    func setupBird() {
        birdButton = SKSpriteNode(imageNamed: "Blue 1")
        birdButton.name = "Bird"
        birdButton.position = CGPoint(x: 0, y: 200)
        birdButton.setScale(1.3)
        birdButton.zPosition = 3
        
        var birdSKTextures = [SKTexture]()
        for i in 1...3 {
            let name = "\(GameManager.shared.getBird().rawValue) \(i)"
            birdSKTextures.append(SKTexture(imageNamed: name))
        }
        
        let animateBird = SKAction.animate(with: birdSKTextures, timePerFrame: 0.1, resize: true, restore: true)
        birdButton.run(SKAction.repeatForever(animateBird))
        
        addChild(birdButton)
    }
    
    func setupScoreLabel() {
        scoreLabel = SKLabelNode(fontNamed: "04b_19")
        scoreLabel.fontSize = 120
        scoreLabel.position = CGPoint(x: 0, y: -400)
        scoreLabel.zPosition = 10
        scoreLabel.text = "\(GameManager.shared.getHighScore())"
        addChild(scoreLabel)
    }
}
