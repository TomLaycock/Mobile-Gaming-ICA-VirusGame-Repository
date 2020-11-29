import SpriteKit
import GameplayKit
import AVFoundation
import CoreMotion

class GameScene: SKScene
{
    
    let mMotionManager = CMMotionManager()
    
    //Game UI
    let mScoreLabel = SKLabelNode(fontNamed: "HelveticaNeue-Thin")
    
    //Pause Menu
    let mPauseButtonName = "PauseButton-TB"
    let mPauseButton = Button(imageNamed: "MenuButtons/" + "PauseButton-TB")
    
    let mButtons = ["PlayButton-TB", "OptionsButton-TB", "ExitButton-TB"]
    let mResumeButton = Button(imageNamed: "MenuButtons/" + "PlayButton-TB")
    let mOptionsButton = Button(imageNamed: "MenuButtons/" + "OptionsButton-TB")
    let mReturnToMainMenuButton = Button(imageNamed: "MenuButtons/" + "ExitButton-TB")
    
    var mGamePaused = false
    
    //Game Sounds
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
        
        //Creating MainMenu Buttons
        mPauseButton.name = mPauseButtonName
        mPauseButton.size = CGSize(width: frame.maxX / 10, height: frame.maxX / 10)
        mPauseButton.position = CGPoint(x: mPauseButton.frame.width / 2 + 10, y: frame.maxY - 10 - mPauseButton.frame.height / 2)
        mPauseButton.SetButtonPosition(to: mPauseButton.position)
        addChild(mPauseButton)

        mResumeButton.name = mButtons[0]
        mResumeButton.size = CGSize(width: frame.maxX / 6, height: frame.maxX / 6)
        mResumeButton.position = CGPoint(x: frame.midX + (-1 * mResumeButton.frame.width * 2), y: frame.midY)
        mResumeButton.SetButtonPosition(to: mResumeButton.position)
        mResumeButton.SetButtonState(value: false)
        addChild(mResumeButton)
        
        mOptionsButton.name = mButtons[1]
        mOptionsButton.size = CGSize(width: frame.maxX / 6, height: frame.maxX / 6)
        mOptionsButton.position = CGPoint(x: frame.midX + (0 * mOptionsButton.frame.width * 2), y: frame.midY)
        mOptionsButton.SetButtonPosition(to: mOptionsButton.position)
        mOptionsButton.SetButtonState(value: false)
        addChild(mOptionsButton)
        
        mReturnToMainMenuButton.name = mButtons[2]
        mReturnToMainMenuButton.size = CGSize(width: frame.maxX / 6, height: frame.maxX / 6)
        mReturnToMainMenuButton.position = CGPoint(x: frame.midX + (1 * mReturnToMainMenuButton.frame.width * 2), y: frame.midY)
        mReturnToMainMenuButton.SetButtonPosition(to: mReturnToMainMenuButton.position)
        mReturnToMainMenuButton.SetButtonState(value: false)
        addChild(mReturnToMainMenuButton)
        
        
        //Game UI
        mScoreLabel.fontSize = 72
        mScoreLabel.position = CGPoint(x: frame.midX, y: 20)
        mScoreLabel.text = "SCORE: 0"
        mScoreLabel.zPosition = 100
        mScoreLabel.horizontalAlignmentMode = .center
        addChild(mScoreLabel)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //audioPlayer2.play()
        //let playSound = SKAction.playSoundFileNamed("ButtonClicks/Button-0001", waitForCompletion: true)
        //self.run(playSound)
        
        for touch in touches
        {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            if touchedNode.name == mPauseButtonName
            {
                TogglePauseMenu()
            }
            else if touchedNode.name == mButtons[0]
            {
                TogglePauseMenu()
            }
            else if touchedNode.name == mButtons[1]
            {
                
            }
            else if touchedNode.name == mButtons[2]
            {
                if let scene = MainMenu(fileNamed: "MainMenu")
                {
                    scene.scaleMode = .resizeFill
                    view?.presentScene(scene)
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //audioPlayer1.play()
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        //if motion == .motionShake
        //{
        //    audioPlayer2.stop()
        //}
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval)
    {
        
    }
 
    func TogglePauseMenu()
    {
        mGamePaused = !mGamePaused
           
        mPauseButton.SetButtonState(value: mGamePaused)
        
        mResumeButton.SetButtonState(value: !mGamePaused)
        mOptionsButton.SetButtonState(value: !mGamePaused)
        mReturnToMainMenuButton.SetButtonState(value: !mGamePaused)
    }
    
}
