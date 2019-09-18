import SpriteKit

enum PlayColors {
    static let colors = [
        UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0),
        UIColor(red: 241/255, green: 196/255, blue: 15/255, alpha: 1.0),
        UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0),
        UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
    ]
}

enum SwitchState: Int {
    
    case red
    case yellow
    case green
    case blue
}

class GameScene: SKScene {
    
    var colorSwitch: SKSpriteNode!
    var switchState = SwitchState.red
    var currentColorIndex: Int?
    
    var score = 0
    let scoreLabel = SKLabelNode(text: "0")
    
    override func didMove(to view: SKView) {
        
        setupPhysics()
        layoutScene()
    }
    
    func setupPhysics() {
        
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0)
        physicsWorld.contactDelegate = self
    }
    
    func layoutScene() {
        
        backgroundColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
        colorSwitch = SKSpriteNode(imageNamed: "ColorCircle")
        colorSwitch.size = CGSize(width: frame.size.width / 3, height: frame.size.width / 3)
        colorSwitch.position = CGPoint(x: frame.midX, y: frame.minY + colorSwitch.size.height)
        colorSwitch.zPosition = ZPositions.colorSwitch
        colorSwitch.physicsBody = SKPhysicsBody(circleOfRadius: colorSwitch.size.width / 2)
        colorSwitch.physicsBody?.categoryBitMask = PhysicsCategories.switchCategory
        colorSwitch.physicsBody?.isDynamic = false
        addChild(colorSwitch)
        
        scoreLabel.fontName = "AvenirNext-Bold"
        scoreLabel.fontSize = 60.0
        scoreLabel.fontColor = .white
        scoreLabel.alpha = 0.6
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        scoreLabel.zPosition = ZPositions.label
        addChild(scoreLabel)
        
        spawnBall()
    }
    
    func updateScoreLabel() {
        
        scoreLabel.text = "\(score)"
    }
    
    func spawnBall() {
        
        currentColorIndex = Int(arc4random_uniform(UInt32(4)))
        
        let ball = SKShapeNode(circleOfRadius: 15)
        ball.strokeColor = SKColor.clear
        ball.fillColor = PlayColors.colors[currentColorIndex ?? 0]
        
        ball.name = "Ball"
        ball.position = CGPoint(x: frame.midX, y: frame.maxY)
        ball.zPosition = ZPositions.ball
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 15)
        ball.physicsBody?.categoryBitMask = PhysicsCategories.ballCategory
        ball.physicsBody?.contactTestBitMask = PhysicsCategories.switchCategory
        ball.physicsBody?.collisionBitMask = PhysicsCategories.none
        addChild(ball)
    }
    
    func turnWheel() {
        
        if let newState = SwitchState(rawValue: switchState.rawValue + 1) {
            
            switchState = newState
        } else {
            
            switchState = .red
        }
        
        colorSwitch.run(SKAction.rotate(byAngle: .pi / 2, duration: 0.25))
    }
    
    func gameOver() {
        
        UserDefaults.standard.set(score, forKey: "RecentScore")
        
        if score > UserDefaults.standard.integer(forKey: "HighScore") {
            
            UserDefaults.standard.set(score, forKey: "HighScore")
        }
        
        if let view = view {
            
            let menuScene = MenuScene(size: view.bounds.size)
            view.presentScene(menuScene)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        turnWheel()
    }
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if contactMask == PhysicsCategories.ballCategory | PhysicsCategories.switchCategory {
            
            if let ball = contact.bodyA.node?.name == "Ball" ? contact.bodyA.node as? SKShapeNode : contact.bodyB.node as? SKShapeNode {
                
                if currentColorIndex == switchState.rawValue {
                    
                    run(SKAction.playSoundFileNamed("bling", waitForCompletion: false))
                    score += 1
                    updateScoreLabel()
                    
                    ball.run(SKAction.fadeOut(withDuration: 0.35)) {
                        
                        ball.removeFromParent()
                        self.spawnBall()
                    }
                } else {
                    
                    gameOver()
                }
            }
        }
    }
}
