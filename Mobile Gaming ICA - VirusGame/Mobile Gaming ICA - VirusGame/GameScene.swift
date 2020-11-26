import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene
{
    
    var audioPlayer1 : AVAudioPlayer!
    var audioPlayer2 : AVAudioPlayer!
    
    override func didMove(to view: SKView) {
        let sound1 = Bundle.main.path(forResource: "beep03", ofType: "wav")
        //let sound2 = Bundle.main.path(forResource: "beep07", ofType: "wav")
        do {
            audioPlayer1 = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound1!))
            //audioPlayer2 = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound2!))
        } catch {
            print(error)                             
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //audioPlayer2.play()
        let playSound = SKAction.playSoundFileNamed("beep07.wav", waitForCompletion: true)
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
