//
//  GameplayScene.swift
//  FlappyBird
//
//  Created by 李泰儀 on 2022/8/4.
//

import SpriteKit

class GameplayScene: SKScene {
    
    var bird = Bird()
    var pipesHolder = SKNode()
    var scoreLabel = SKLabelNode(fontNamed: "04b_19")
    var score = 0
    
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
        physicsWorld.contactDelegate = self
        createBird()
        createBG()
        createGrounds()
        spawnObstacles()
        createLabel()
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
    
    var recordScore = 0
    
    func createPipes() {
        pipesHolder = SKNode()
        pipesHolder.name = "Holder"
        
        let scoreNode = SKSpriteNode()
        scoreNode.color = .red
        recordScore += 1
        scoreNode.name = "Score:\(recordScore)"
        scoreNode.position = .zero
        scoreNode.size = CGSize(width: 5, height: 300)
        scoreNode.physicsBody = SKPhysicsBody(rectangleOf: scoreNode.size)
        scoreNode.physicsBody?.categoryBitMask = ColliderType.Score
        scoreNode.physicsBody?.collisionBitMask = 0
        scoreNode.physicsBody?.affectedByGravity = false
        scoreNode.physicsBody?.isDynamic = false
        
        let upPipe = setupPipe(imageNamed: "Pipe 1", y: 630, zRotation: CGFloat.pi)
        let downPipe = setupPipe(imageNamed: "Pipe 1", y: -630)
        pipesHolder.zPosition = 5
        pipesHolder.position = CGPoint(x: (frame.width / 2) + upPipe.frame.width,
                                       y: .random(in: -300...300))
        pipesHolder.addChild(upPipe)
        pipesHolder.addChild(downPipe)
        pipesHolder.addChild(scoreNode)
        
        addChild(pipesHolder)
        
        let destination = (frame.width / 2) + upPipe.frame.width
        let move = SKAction.moveTo(x: -destination, duration: 5)
        let remove = SKAction.removeFromParent()
        pipesHolder.run(SKAction.sequence([move, remove]), withKey: "Move")
    }
    
    func setupPipe(imageNamed: String, y: CGFloat, zRotation: CGFloat = .zero) -> SKSpriteNode {
        let pipe = SKSpriteNode(imageNamed: imageNamed)
        pipe.name = "Pipe"
        pipe.position = CGPoint(x: 0, y: y)
        
        pipe.yScale = 1.5
        pipe.zRotation = zRotation
        if let texture = pipe.texture {
            pipe.physicsBody = SKPhysicsBody(texture: texture, size: pipe.size)
        } else {
            pipe.physicsBody = SKPhysicsBody(rectangleOf: pipe.size)
        }
        pipe.physicsBody?.affectedByGravity = false
        pipe.physicsBody?.isDynamic = false
        pipe.physicsBody?.categoryBitMask = ColliderType.Pipes
        return pipe
    }
    
    func spawnObstacles() {
        let spawn = SKAction.run { [weak self] in
            guard let self = self else { return }
            self.createPipes()
        }
        let delay = SKAction.wait(forDuration: 2)
        let sequence = SKAction.sequence([spawn, delay])
        run(SKAction.repeatForever(sequence), withKey: "Spawn")
    }
    
    func createLabel() {
        scoreLabel.zPosition = 6
        scoreLabel.position = CGPoint(x: 0, y: 450)
        scoreLabel.fontSize = 120
        scoreLabel.text = String(score)
        addChild(scoreLabel)
    }
    
    func setScore(_ score: Int) {
        self.score = score
        scoreLabel.text = String(score)
    }
}

extension GameplayScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        if contact.bodyA.node?.name == "Bird" {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.node?.name == "Bird" {
            guard let secondNodeName = secondBody.node?.name else { return }
            if secondNodeName.contains("Score") {
                if let numberStr = secondNodeName.split(separator: ":").first(where: { $0 != "Score" }),
                   let number = Int(numberStr) {
                    setScore(number)
                }
            } else if secondNodeName.contains("Pipe") {
                print("didBegin Collided with Pipe")
            } else if secondNodeName.contains("Ground") {
                print("didBegin Collided with Ground")
            }
        }
    }
}
