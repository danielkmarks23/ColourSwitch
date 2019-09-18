import SpriteKit

class MenuScene: SKScene {
    
    override func didMove(to view: SKView) {
        
        backgroundColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
        
        addLogo()
        addLabels()
    }
    
    func addLogo() {
        
        let logo = SKSpriteNode(imageNamed: "logo")
        logo.size = CGSize(width: frame.size.width / 4, height: frame.size.width / 4)
        logo.position = CGPoint(x: frame.midX, y: frame.midY + frame.size.height / 4)
        addChild(logo)
    }
    
    func addLabels() {
        
        let playLabel = SKLabelNode(text: "Tap to Play!")
        setupLabel(label: playLabel, fontSize: 50.0, position: CGPoint(x: frame.midX, y: frame.midY))
        addChild(playLabel)
        animate(label: playLabel)
        
        let highScoreLabel = SKLabelNode(text: "Highscore: \(UserDefaults.standard.integer(forKey: "HighScore"))")
        setupLabel(label: highScoreLabel, fontSize: 40.0, position: CGPoint(x: frame.midX, y: frame.midY - highScoreLabel.frame.size.height * 4))
        addChild(highScoreLabel)
        
        let recentScoreLabel = SKLabelNode(text: "Recent Score: \(UserDefaults.standard.integer(forKey: "RecentScore"))")
        setupLabel(label: recentScoreLabel, fontSize: 40.0, position: CGPoint(x: frame.midX, y: highScoreLabel.position.y - recentScoreLabel.frame.size.height * 2))
        addChild(recentScoreLabel)
    }
    
    func setupLabel(label: SKLabelNode, fontSize: CGFloat, position: CGPoint) {
        
        label.fontName = "AvenirNext-Bold"
        label.fontSize = fontSize
        label.position = position
    }
    
    func animate(label: SKLabelNode) {
        
        let scaleUp = SKAction.scale(to: 1.1, duration: 0.5)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.5)
        
        let sequence = SKAction.sequence([scaleUp, scaleDown])
        label.run(SKAction.repeatForever(sequence))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let view = view {
            
            let gameScene = GameScene(size: view.bounds.size)
            view.presentScene(gameScene)
        }
    }
}
