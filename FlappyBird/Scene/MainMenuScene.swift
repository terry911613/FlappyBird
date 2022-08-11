//
//  MainMenuScene.swift
//  FlappyBird
//
//  Created by 李泰儀 on 2022/8/12.
//

import SpriteKit

class MainMenuScene: SKScene {
    
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
                
            }
        }
    }
    
    func setup() {
        setupBackground()
        setupButtons()
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
}
