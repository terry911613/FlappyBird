//
//  Bird.swift
//  FlappyBird
//
//  Created by 李泰儀 on 2022/8/6.
//

import SpriteKit

class Bird: SKSpriteNode {
    
    var birdAnimation = [SKTexture]()
    var birdAnimationAction = SKAction()
    var diedTexture = SKTexture()
    
    func setup() {
        
        for i in 2...3 {
            let name = "\(GameManager.shared.getBird().rawValue) \(i)"
            birdAnimation.append(SKTexture(imageNamed: name))
        }
        birdAnimationAction = SKAction.animate(with: birdAnimation, timePerFrame: 0.08, resize: true, restore: true)
        
        diedTexture = SKTexture(imageNamed: "\(GameManager.shared.getBird().rawValue) 4")
        
        name = "Bird"
        zPosition = 3
        // Default anchorPoint is CGPoint(x: 0.5, y: 0.5)
//        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        // use texture will fire multiple times didBegin(_ contact: SKPhysicsContact)
        if let texture = texture {
            physicsBody = SKPhysicsBody(texture: texture, size: size)
        } else {
            physicsBody = SKPhysicsBody(circleOfRadius: size.height / 2)
        }
        physicsBody?.allowsRotation = false
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = ColliderType.Bird
        // use | to set collisionBitMask (= ColliderType.Ground) and (= ColliderType.Ground)
        physicsBody?.collisionBitMask = ColliderType.Ground | ColliderType.Pipes
        physicsBody?.contactTestBitMask = ColliderType.Ground | ColliderType.Pipes | ColliderType.Score
    }
    
    func flap() {
        // set velocity to CGVector(dx: 0, dy: 0) let bird do not affect by fall velocity
        physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        physicsBody?.applyImpulse(CGVector(dx: 0, dy: 135))
        run(birdAnimationAction)
    }
}
