//
//  GameScene.swift
//  Fire Rides
//
//  Created by Németh Bendegúz on 2017. 10. 29..
//  Copyright © 2017. Németh Bendegúz. All rights reserved.
//

import SpriteKit

enum UpdateStages {
    case firstStage, secondStage, thirdStage, fourthStage
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private let defaults = UserDefaults.standard
    
    private var ball: SKSpriteNode!
    
    private var dot: SKSpriteNode!
    
    private var dotBackup: SKSpriteNode!
    
    private var localDot: SKSpriteNode!

    private var rope: SKSpriteNode!
    
    private var ropeBackup: SKSpriteNode!
    
    private var localRope: SKSpriteNode!
        
    private var scoreLabelNode: SKLabelNode!
    
    private var bestLabelNode: SKLabelNode!
    
    private var howToLabelNode1: SKLabelNode!

    private var howToLabelNode2: SKLabelNode!
    
    private var isFirstTouch = true
    
    private var isTouchInProgress = false
    
    private var score = 0 {
        didSet {
                updatePointsLabel()
        }
    }
    
    private var highScore = 0
    
    private var previousBallPosition: CGFloat = -100
    
    private var bottomColumns = [SKSpriteNode]()

    private var topColumns = [SKSpriteNode]()
    
    private var caveHeight: CGFloat = 975
    
    private var lastUpdateStage: UpdateStages = .fourthStage
    
    private var currentUpdateStage: UpdateStages = .firstStage {
        didSet {
            updateColumns()
        }
    }
    
    private var countForLevelUp = 0 {
        didSet {
            if countForLevelUp >= 3 {
                ColorGenerator.updateMainColor()
                updateCaveHeight()
                countForLevelUp = 0
            }
        }
    }
    
    override func didMove(to view: SKView) {
        
        highScore = defaults.integer(forKey: "highScore")
        
        self.physicsWorld.contactDelegate = self
        
        dot = childNode(withName: "dot") as? SKSpriteNode
        
        dotBackup = dot.copy() as? SKSpriteNode
        
        rope = childNode(withName: "rope") as? SKSpriteNode
        
        ropeBackup = rope.copy() as? SKSpriteNode
        
        ball = childNode(withName: "ball") as? SKSpriteNode
        
        scoreLabelNode = ball?.childNode(withName: "scoreLabelNode") as? SKLabelNode
        
        bestLabelNode = ball?.childNode(withName: "bestLabelNode") as? SKLabelNode
        
        howToLabelNode1 = ball?.childNode(withName: "howToLabelNode1") as? SKLabelNode

        howToLabelNode2 = ball?.childNode(withName: "howToLabelNode2") as? SKLabelNode
        
        scoreLabelNode.text = String(highScore)
        
        for child in children {
            if child.name == "bottomColumn" {
                if let child = child as? SKSpriteNode {
                    bottomColumns.append(child)
                }
            } else if child.name == "topColumn" {
                if let child = child as? SKSpriteNode {
                    topColumns.append(child)
                }
            }
        }
        
        for (bottomColumn, topColumn) in zip(bottomColumns, topColumns) {
            bottomColumn.color = ColorGenerator.updateSecondaryColors()
            topColumn.color = bottomColumn.color
            bottomColumn.position.y = ColumnPositionGenerator.updatePosition()
            topColumn.position.y = bottomColumn.position.y + caveHeight + CGFloat(arc4random_uniform(51))
        }
        
        rope.size.height = ((topColumns[5].position.y - 277.5) + Swift.abs(bottomColumns[5].position.y + 275)) / 1.5
        ball.position.y = rope.position.y - rope.size.height
        
        let joint = SKPhysicsJointPin.joint(withBodyA: dot.physicsBody!,
                                            bodyB: rope.physicsBody!,
                                            anchor: CGPoint(x: dot.frame.midX, y: dot.frame.midY))
        self.physicsWorld.add(joint)
        
        let joint2 = SKPhysicsJointPin.joint(withBodyA: rope.physicsBody!,
                                            bodyB: ball.physicsBody!,
                                            anchor: CGPoint(x: ball.frame.midX, y: ball.frame.midY))
        self.physicsWorld.add(joint2)
        
        dot.position.y = topColumns[5].position.y - 277.5
        
        ball.position.x = -150
        ball.physicsBody?.applyImpulse(CGVector(dx: 5, dy: 0))
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.isUserInteractionEnabled = false
        
        if isFirstTouch {
            dot.removeFromParent()
            rope.removeFromParent()
            bestLabelNode.removeFromParent()
            howToLabelNode1.removeFromParent()
            howToLabelNode2.removeFromParent()
            ball.physicsBody?.velocity.dx = 0
            ball.physicsBody?.velocity.dy = 0
            ball.physicsBody?.applyImpulse(CGVector(dx: 5, dy: 5))
            isFirstTouch = false
        } else {
            localDot = dotBackup.copy() as? SKSpriteNode
            localRope = ropeBackup.copy() as? SKSpriteNode
            let position = min( max( 0, Int((ball.position.x + 207) / 50) + 2), 39)
            localDot.position.x = topColumns[position].position.x
            localDot.position.y = topColumns[position].position.y - 277.5
            
            localRope.size.height = distanceBetweenPoints(first: ball.position, second: localDot.position)
            localRope.zRotation = atan2(localDot.position.y - ball.position.y, localDot.position.x - ball.position.x) - (CGFloat.pi / 2)
            localRope.position.x = topColumns[position].position.x
            localRope.position.y = topColumns[position].position.y - 277.5
            
            let joint = SKPhysicsJointPin.joint(withBodyA: localDot.physicsBody!,
                                                bodyB: localRope.physicsBody!,
                                                anchor: CGPoint(x: localDot.frame.midX, y: localDot.frame.midY))
            
            let joint2 = SKPhysicsJointPin.joint(withBodyA: localRope.physicsBody!,
                                                 bodyB: ball.physicsBody!,
                                                 anchor: CGPoint(x: ball.frame.midX, y: ball.frame.midY))
            
            self.addChild(localDot)
            self.addChild(localRope)
            
            self.physicsWorld.add(joint)
            self.physicsWorld.add(joint2)
            
            isTouchInProgress = true
            
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.isUserInteractionEnabled = true
        
        if localDot != nil {
            localDot.removeFromParent()
            localRope.removeFromParent()
            
            isTouchInProgress = false
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        // Create local variables for two physics bodies
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        // Assign the two physics bodies so that the one with the
        // lower category is always stored in firstBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if  firstBody.categoryBitMask == ball.physicsBody?.categoryBitMask &&
            secondBody.categoryBitMask == bottomColumns[0].physicsBody?.categoryBitMask {
            
            highScore = max(score, highScore)
            defaults.set(highScore, forKey: "highScore")
            
            ColorGenerator.reset()
            ColumnPositionGenerator.reset()
            
            guard let gameScene = GameScene(fileNamed: "GameScene") else {
                fatalError("GameScene not found")
            }
            let transition = SKTransition.flipVertical(withDuration: 1.0)
            gameScene.scaleMode = .aspectFill
            view?.presentScene(gameScene, transition: transition)
            
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if isTouchInProgress {
            if let dx = ball.physicsBody?.velocity.dx {
                if dx < CGFloat(500) {
                    ball.physicsBody?.velocity.dx += 10
                }
            }
        }
        if ball.position.x > 1400 {
            if localDot != nil {
                localDot.position.x -= 1500
                localRope.position.x -= 1500
            }
            ball.position.x -= 1500
            previousBallPosition = -100
            currentUpdateStage = .thirdStage
        } else if ball.position.x > 900 {
            currentUpdateStage = .secondStage
        } else if ball.position.x > 400 {
            currentUpdateStage = .firstStage
        } else {
            currentUpdateStage = .fourthStage
        }
        
        if ball.position.x > previousBallPosition + 50 && !isFirstTouch {
            score += 10
            previousBallPosition = ball.position.x
        }
        
    }
    
    private func updateColumns() {
        if currentUpdateStage != lastUpdateStage {
            switch currentUpdateStage {
            case .firstStage:
                for x in 0...9 {
                    bottomColumns[x].color = bottomColumns[x + 30].color
                    topColumns[x].color = topColumns[x + 30].color
                    bottomColumns[x].position.y = bottomColumns[x + 30].position.y
                    topColumns[x].position.y = topColumns[x + 30].position.y
                }
                lastUpdateStage = currentUpdateStage
            case .secondStage:
                for x in 10...19 {
                    bottomColumns[x].color = ColorGenerator.updateSecondaryColors()
                    topColumns[x].color = bottomColumns[x].color
                    bottomColumns[x].position.y = ColumnPositionGenerator.updatePosition()
                    topColumns[x].position.y = bottomColumns[x].position.y + caveHeight + CGFloat(arc4random_uniform(51))
                }
                lastUpdateStage = currentUpdateStage
            case .thirdStage:
                for x in 20...29 {
                    bottomColumns[x].color = ColorGenerator.updateSecondaryColors()
                    topColumns[x].color = bottomColumns[x].color
                    bottomColumns[x].position.y = ColumnPositionGenerator.updatePosition()
                    topColumns[x].position.y = bottomColumns[x].position.y + caveHeight + CGFloat(arc4random_uniform(51))
                }
                lastUpdateStage = currentUpdateStage
            case .fourthStage:
                for x in 30...39 {
                    bottomColumns[x].color = ColorGenerator.updateSecondaryColors()
                    topColumns[x].color = bottomColumns[x].color
                    bottomColumns[x].position.y = ColumnPositionGenerator.updatePosition()
                    topColumns[x].position.y = bottomColumns[x].position.y + caveHeight + CGFloat(arc4random_uniform(51))
                }
                countForLevelUp += 1
                lastUpdateStage = currentUpdateStage
            }
        }
    }
    
    private func updateCaveHeight() {
        if caveHeight > 825 {
            caveHeight -= 30
        }
    }
    
    private func updatePointsLabel() {
        scoreLabelNode.text = String(score)
    }
    
    private func distanceBetweenPoints(first: CGPoint, second: CGPoint) -> CGFloat {
        return CGFloat(hypotf(Float(second.x) - Float(first.x), Float(second.y) - Float(first.y)))
    }
    
}

