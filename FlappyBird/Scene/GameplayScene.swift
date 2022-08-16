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
    var gameStarted = false
    var isAlive = false
    
    var press = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        setup()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if gameStarted == false {
            isAlive = true
            gameStarted = true
            press.removeFromParent()
            bird.physicsBody?.affectedByGravity = true
            spawnObstacles()
        }
        
        if isAlive {
            bird.flap()
        }
        
        for touch in touches {
            let location = touch.location(in: self)
            if atPoint(location).name == "Retry" {
                removeAllActions()
                removeAllChildren()
                setup()
            }
            if atPoint(location).name == "Quit" {
                if let mainMenu = MainMenuScene(fileNamed: "MainMenuScene") {
                    mainMenu.scaleMode = .aspectFill
                    view?.presentScene(mainMenu, transition: SKTransition.doorway(withDuration: 1))
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if isAlive {
            moveBG()
            moveGround()
        }
    }
    
    func setup() {
        
        gameStarted = false
        isAlive = false
        setScore(0)
        
        physicsWorld.contactDelegate = self
        
        createInstructions()
        createBird()
        createBG()
        createGrounds()
        createLabel()
    }
    
    func createInstructions() {
        press = SKSpriteNode(imageNamed: "Press")
        press.position = CGPoint(x: 0, y: 0)
//        press.setScale(1.8)
        press.zPosition = 10
        addChild(press)
    }
    
    func createBird() {
        bird = Bird(imageNamed: "\(GameManager.shared.getBird().rawValue) 1")
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
    
    func createPipes() {
        pipesHolder = SKNode()
        pipesHolder.name = "Holder"
        
        let scoreNode = SKSpriteNode()
        scoreNode.color = .red
        scoreNode.name = "Score"
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
    
    func birdDied() {
        
        removeAction(forKey: "Spawn")
        
        for child in children {
            if child.name == "Holder" {
                child.removeAction(forKey: "Move")
            }
        }
        
        isAlive = false
        
        bird.texture = bird.diedTexture
        
        let scaleUp = SKAction.scale(to: 1, duration: 0.5)
        
        let retry = SKSpriteNode(imageNamed: "Retry")
        retry.name = "Retry"
        retry.position = CGPoint(x: -150, y: -150)
        retry.zPosition = 7
        retry.setScale(0)
        retry.run(scaleUp)
        addChild(retry)
        
        let quit = SKSpriteNode(imageNamed: "Quit")
        quit.name = "Quit"
        quit.position = CGPoint(x: 150, y: -150)
        quit.zPosition = 7
        quit.setScale(0)
        quit.run(scaleUp)
        addChild(quit)
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
            if secondBody.node?.name == "Score" {
                setScore(score + 1)
                secondBody.node?.removeFromParent()
            } else if secondBody.node?.name == "Pipe" {
                if isAlive {
                    birdDied()
                }
            } else if secondBody.node?.name == "Ground" {
                if isAlive {
                    birdDied()
                }
            }
        }
    }
}
