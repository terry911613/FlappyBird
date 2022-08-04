//
//  GameplayScene.swift
//  FlappyBird
//
//  Created by 李泰儀 on 2022/8/4.
//

import SpriteKit

class GameplayScene: SKScene {
    
    override func didMove(to view: SKView) {
        setup()
    }
    
    func setup() {
        createBG()
        createGrounds()
    }
    
    func createBG() {
        for i in 0...2 {
            let bg = SKSpriteNode(imageNamed: "BG Day")
            bg.name = "BG"
            bg.zPosition = 0
            bg.anchorPoint = anchorPoint
            bg.position = CGPoint(x: CGFloat(i) * bg.size.width, y: 0)
            addChild(bg)
        }
    }
    
    func createGrounds() {
        for i in 0...2 {
            let ground = SKSpriteNode(imageNamed: "Ground")
            ground.name = "Ground"
            ground.zPosition = 4
            ground.anchorPoint = anchorPoint
            print("UIScreen.main.bounds = \(UIScreen.main.bounds)")
            print("UIScreen.main.bounds.maxY = \(UIScreen.main.bounds.maxY)")
            print("UIScreen.main.bounds.minY = \(UIScreen.main.bounds.minY)")
            print("ground.size.height / 2 = \(ground.size.height / 2)")
            print("frame = \(frame.size)")
            ground.position = CGPoint(x: CGFloat(i) * ground.size.width,
                                      y: -(frame.size.height / 2 - ground.size.height / 2))
//            ground.position = CGPoint(x: CGFloat(i) * ground.size.width, y: -(frame.size.height / 2))
            addChild(ground)
        }
    }
}
