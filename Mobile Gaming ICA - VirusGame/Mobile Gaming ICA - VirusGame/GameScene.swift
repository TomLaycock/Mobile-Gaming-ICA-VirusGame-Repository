import SpriteKit
import GameplayKit
import AVFoundation
import CoreMotion

class GameScene: SKScene
{
    
    let mMotionManager = CMMotionManager()
    
    let mScoreLabel = SKLabelNode(fontNamed: "HelveticaNeue-Thin")
    
    
    var audioPlayer1 : AVAudioPlayer!
    var audioPlayer2 : AVAudioPlayer!
    
    override func didMove(to view: SKView) {
        let sound1 = Bundle.main.path(forResource: "ButtonClicks/Button-0000", ofType: "wav")
        //let sound2 = Bundle.main.path(forResource: "beep07", ofType: "wav")
        do {
            audioPlayer1 = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound1!))
            //audioPlayer2 = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound2!))
        } catch {
            print(error)                             
        }
        
        mScoreLabel.fontSize = 72
        mScoreLabel.position = CGPoint(x: frame.midX, y: 20)
        mScoreLabel.text = "SCORE: 0"
        mScoreLabel.zPosition = 100
        mScoreLabel.horizontalAlignmentMode = .center
        addChild(mScoreLabel)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //audioPlayer2.play()
        let playSound = SKAction.playSoundFileNamed("ButtonClicks/Button-0001", waitForCompletion: true)
        self.run(playSound)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        audioPlayer1.play()
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake
        {
            audioPlayer2.stop()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval)
    {
        
    }
    
}
