//
//  GameplayScene.swift
//  FlappyBird
//
//  Created by 李泰儀 on 2022/8/4.
//

import SpriteKit

class GameplayScene: SKScene {
    
    var bird = Bird()
    
    override func didMove(to view: SKView) {
        setup()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        bird.flap()
    }
    
    override func update(_ currentTime: TimeInterval) {
        moveBG()
        moveGround()
    }
    
    func setup() {
        createBird()
        createBG()
        createGrounds()
    }
    
    func createBird() {
        bird = Bird(imageNamed: "Blue 1")
        bird.setup()
        bird.position = CGPoint(x: -50, y: 0)
        addChild(bird)
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
//            ground.position = CGPoint(x: CGFloat(i) * ground.size.width,
//                                      y: -(frame.size.height / 2 - ground.size.height / 2))
            ground.position = CGPoint(x: CGFloat(i) * ground.size.width, y: -(frame.size.height / 2))
            if let texture = ground.texture {
                ground.physicsBody = SKPhysicsBody(texture: texture, size: ground.size)
            } else {
                ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
            }
            ground.physicsBody?.affectedByGravity = false
            ground.physicsBody?.isDynamic = false
            ground.physicsBody?.categoryBitMask = ColliderType.Ground
            // No need to set collisionBitMask and contactTestBitMask because Bird class already set
//            ground.physicsBody?.collisionBitMask = ColliderType.Bird
//            ground.physicsBody?.contactTestBitMask = ColliderType.Bird
            addChild(ground)
        }
    }
    
    func moveBG() {
        enumerateChildNodes(withName: "BG") { [weak self] node, _ in
            guard let self = self else { return }
            
            node.position.x -= 4.5
            
            if node.position.x < -self.frame.width {
                node.position.x += self.frame.width * 3
            }
        }
    }
    
    func moveGround() {
        enumerateChildNodes(withName: "Ground") { [weak self] node, _ in
            guard let self = self else { return }
            
            node.position.x -= 2
            
            if node.position.x < -self.frame.width {
                node.position.x += self.frame.width * 3
            }
        }
    }
}
