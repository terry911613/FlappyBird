//
//  Bird.swift
//  FlappyBird
//
//  Created by 李泰儀 on 2022/8/6.
//

import SpriteKit

class Bird: SKSpriteNode {
    
    func setup() {
        name = "Bird"
        zPosition = 3
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        if let texture = texture {
            physicsBody = SKPhysicsBody(texture: texture, size: size)
        } else {
            physicsBody = SKPhysicsBody(circleOfRadius: size.height / 2)
        }
        physicsBody?.affectedByGravity = true
        physicsBody?.categoryBitMask = ColliderType.Bird
        // use | to set collisionBitMask (= ColliderType.Ground) and (= ColliderType.Ground)
        physicsBody?.collisionBitMask = ColliderType.Ground | ColliderType.Pipes
        physicsBody?.contactTestBitMask = ColliderType.Ground | ColliderType.Pipes | ColliderType.Score
    }
    
    func flap() {
        // set velocity to CGVector(dx: 0, dy: 0) let bird do not affect by fall velocity
        physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        physicsBody?.applyImpulse(CGVector(dx: 0, dy: 240))
    }
}