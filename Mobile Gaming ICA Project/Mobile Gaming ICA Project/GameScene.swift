import SpriteKit
import GameplayKit
import AVFoundation
import CoreMotion

class GameScene: SKScene
{
 
    //Game Values
    var mMainMenuScene : MainMenu!
    let mPoolSystem = PoolSystem()
    
    var mDeltaTime = Double(0)
    var mPrevTime = Double(0)
    
    let mMotionManager = CMMotionManager()

    var mPlayer : Player!
    
    //Game UI
    let mScoreLabel = SKLabelNode(fontNamed: "HelveticaNeue-Thin")
    
    let mHealthBar = NumberBar(Start: 100, Max: 100, BackPath: "Assets/Squares/BlackSquare.jpg", ForePath: "Assets/Squares/GreenSquare", Lentgh: 200, Height: 35)
    let mEnergyBar = NumberBar(Start: 100, Max: 100, BackPath: "Assets/Squares/BlackSquare.jpg", ForePath: "Assets/Squares/blueSquare", Lentgh: 200, Height: 35)
    
    //Pause Menu
    let mPauseButtonName = "PauseButton-TB"
    let mPauseButton = Button(imageNamed: "Assets/MenuButtons/" + "PauseButton-TB")
    
    let mButtons = ["PlayButton-TB", "OptionsButton-TB", "ExitButton-TB"]
    let mResumeButton = Button(imageNamed: "Assets/MenuButtons/" + "PlayButton-TB")
    let mOptionsButton = Button(imageNamed: "Assets/MenuButtons/" + "OptionsButton-TB")
    let mReturnToMainMenuButton = Button(imageNamed: "Assets/MenuButtons/" + "ExitButton-TB")
    
    let mPauseBackground = SKSpriteNode(imageNamed: "Assets/Squares/BlackSquare.jpg")
    
    var mGamePaused = false
    
    var mGameSetupComplete = false
    
    //Game Sounds
    var audioPlayer1 : AVAudioPlayer!
    
    override func didMove(to view: SKView) {

        //Initialising Pool System
        if !mGameSetupComplete
        {
            mPoolSystem.SetupPoolSystem(scene: self)
            print("Pool System First Time Initialisation")
        }
        else
        {
            mPoolSystem.ReInitialise()
            print("Re Initialising Pool System")
        }

        for _ in 1...10
        {
            let EnergyToSpawn = mPoolSystem.GetNextAvailableEnergyBall()
            EnergyToSpawn.Spawn(at: CGPoint(x: Int.random(in: 10...Int(frame.maxX - 10)), y: Int.random(in: 10...Int(frame.maxY - 10))), with: 1)
        }
        
        for _ in 1...3
        {
            let WhiteBloodCell = mPoolSystem.GetNextAvailableWhiteBloodCell()
            WhiteBloodCell.SpawnWhiteBloodCell(position: CGPoint(x: Int.random(in: 60...Int(frame.maxX - 60)), y: Int.random(in: 60...Int(frame.maxY - 60))), size: CGSize(width: 100, height: 100))
            WhiteBloodCell.SetSpeed(to: 100)
        }
        
        print("Pool System Object Requests Complete")
        
        //Initialising Player
        if !mGameSetupComplete
        {
            mPlayer = Player(back: "Assets/Viruses/Virus-0000-SpikesOnly", front: "Assets/Viruses/Virus-0000-BodyOnly", speed: 2)
        }
        
        mPlayer.InitialisePlayer(scene: self, name: "Player", zposition: 8)
        mPlayer.SpawnPlayer(position: CGPoint(x: frame.midX, y: frame.midY), size: CGSize(width: 100, height: 100))
        
        
        //Initialising Sound
        let sound1 = Bundle.main.path(forResource: "Sounds/ButtonClicks/Button-0000", ofType: "wav")
        do {
            audioPlayer1 = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound1!))
        } catch {
            print(error)
        }
        
        //Creating MainMenu Buttons
        mPauseButton.name = mPauseButtonName
        mPauseButton.size = CGSize(width: frame.maxX / 10, height: frame.maxX / 10)
        mPauseButton.position = CGPoint(x: mPauseButton.frame.width / 2 + 10, y: frame.maxY - 10 - mPauseButton.frame.height / 2)
        mPauseButton.SetButtonPosition(to: mPauseButton.position)
        mPauseButton.zPosition = 100
        addChild(mPauseButton)

        mResumeButton.name = mButtons[0]
        mResumeButton.size = CGSize(width: frame.maxX / 6, height: frame.maxX / 6)
        mResumeButton.position = CGPoint(x: frame.midX + (-1 * mResumeButton.frame.width * 2), y: frame.midY)
        mResumeButton.SetButtonPosition(to: mResumeButton.position)
        mResumeButton.SetButtonState(value: false)
        mResumeButton.zPosition = 100
        addChild(mResumeButton)
        
        mOptionsButton.name = mButtons[1]
        mOptionsButton.size = CGSize(width: frame.maxX / 6, height: frame.maxX / 6)
        mOptionsButton.position = CGPoint(x: frame.midX + (0 * mOptionsButton.frame.width * 2), y: frame.midY)
        mOptionsButton.SetButtonPosition(to: mOptionsButton.position)
        mOptionsButton.SetButtonState(value: false)
        mOptionsButton.zPosition = 100
        addChild(mOptionsButton)
        
        mReturnToMainMenuButton.name = mButtons[2]
        mReturnToMainMenuButton.size = CGSize(width: frame.maxX / 6, height: frame.maxX / 6)
        mReturnToMainMenuButton.position = CGPoint(x: frame.midX + (1 * mReturnToMainMenuButton.frame.width * 2), y: frame.midY)
        mReturnToMainMenuButton.SetButtonPosition(to: mReturnToMainMenuButton.position)
        mReturnToMainMenuButton.SetButtonState(value: false)
        mReturnToMainMenuButton.zPosition = 100
        addChild(mReturnToMainMenuButton)
        
        mPauseBackground.position = CGPoint(x: frame.midX, y: frame.midY)
        mPauseBackground.size = CGSize(width: 0, height: 0)
        mPauseBackground.zPosition = 99
        mPauseBackground.alpha = 0.5
        addChild(mPauseBackground)
        
        //Game UI
        mScoreLabel.fontSize = 72
        mScoreLabel.position = CGPoint(x: frame.midX, y: 20)
        mScoreLabel.text = "SCORE: 0"
        mScoreLabel.zPosition = 100
        mScoreLabel.horizontalAlignmentMode = .center
        addChild(mScoreLabel)
        
        mHealthBar.SetBarPosition(to: CGPoint(x: 10, y: 30))
        mHealthBar.SetBarZPosition(to: 90)
        addChild(mHealthBar.GetBarBackground())
        addChild(mHealthBar.GetBarForeground())
        addChild(mHealthBar.GetBarText())
        
        mEnergyBar.SetBarPosition(to: CGPoint(x: 10, y: 75))
        mEnergyBar.SetBarZPosition(to: 90)
        addChild(mEnergyBar.GetBarBackground())
        addChild(mEnergyBar.GetBarForeground())
        addChild(mEnergyBar.GetBarText())

        print("UI Setup Complete")
        
        mMotionManager.startAccelerometerUpdates()
        mMotionManager.startGyroUpdates()
        
        mGameSetupComplete = true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //let playSound = SKAction.playSoundFileNamed("ButtonClicks/Button-0001", waitForCompletion: true)
        //self.run(playSound)
        
        mHealthBar.DecreaseNumberBarValue(by: 1)
        
        for touch in touches
        {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            if touchedNode.name == mPauseButtonName
            {
                TogglePauseMenu()
                audioPlayer1.play()
            }
            else if touchedNode.name == mButtons[0]
            {
                TogglePauseMenu()
                audioPlayer1.play()
            }
            else if touchedNode.name == mButtons[1]
            {
                audioPlayer1.play()
            }
            else if touchedNode.name == mButtons[2]
            {
                audioPlayer1.play()
                
                ResetGameScene()
                removeAllChildren()
                
                mMainMenuScene.scaleMode = .resizeFill
                view?.presentScene(mMainMenuScene, transition: .fade(withDuration: 0.5))
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {

    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval)
    {
        
        if(mDeltaTime == 0)
        {
            mDeltaTime = Double(0.015)
            mPrevTime = currentTime
        }
        else
        {
            mDeltaTime = currentTime - mPrevTime
            mPrevTime = currentTime
        }
        
        //print(String(currentTime) + "    " + String(mPrevTime) + "     " + String(mDeltaTime))
        
        if(!mGamePaused)
        {
            
            /*if let accelerometer = mMotionManager.accelerometerData
            {
                //physicsWorld.gravity = CGVector(dx: accelerometer.acceleration.y * -50, dy: accelerometer.acceleration.x*50)
            }*/
            
            var playerPositionModifier = Vector2(x: 0, y: 0)
            
            if let gyroscope = mMotionManager.gyroData
            {
                playerPositionModifier = Vector2(x: Float(gyroscope.rotationRate.x), y: Float(gyroscope.rotationRate.y))
            }
            
            if mPlayer.GetAlive()
            {
                mPlayer.UpdateMovementDirection(by: playerPositionModifier)
                mPlayer.UpdatePlayer()
            }
            
            for cell in mPoolSystem.GetWhiteBloodCells()
            {
                if cell.GetAlive()
                {
                    cell.MoveTowards(target: CGPoint(x: 0, y: 0))
                }
            }
            
        }
        else
        {
            //Game Paused
        }
        
    }
 
    func TogglePauseMenu()
    {
        mGamePaused = !mGamePaused
           
        mPauseButton.SetButtonState(value: !mGamePaused)
        
        mResumeButton.SetButtonState(value: mGamePaused)
        mOptionsButton.SetButtonState(value: mGamePaused)
        mReturnToMainMenuButton.SetButtonState(value: mGamePaused)
        
        if mGamePaused
        {
            mPauseBackground.size = CGSize(width: frame.maxX, height: frame.maxY)
        }
        else
        {
            mPauseBackground.size = CGSize(width: 0, height: 0)
        }
    }
 
    func TogglePauseMenuSpecifc(to Value: Bool)
    {
        mGamePaused = Value
        
        mPauseButton.SetButtonState(value: !Value)
        
        mResumeButton.SetButtonState(value: Value)
        mOptionsButton.SetButtonState(value: Value)
        mReturnToMainMenuButton.SetButtonState(value: Value)
        
        if mGamePaused
        {
            mPauseBackground.size = CGSize(width: frame.maxX, height: frame.maxY)
        }
        else
        {
            mPauseBackground.size = CGSize(width: 0, height: 0)
        }
    }
    
    func ResetGameScene()
    {
        mPoolSystem.ResetPools()
        
        TogglePauseMenuSpecifc(to: false)
        
        mHealthBar.SetNumberBarValue(to: mHealthBar.mNumberBarMax)
        mEnergyBar.SetNumberBarValue(to: mEnergyBar.mNumberBarMax)
        
        mScoreLabel.text = "SCORE: 0"
    }
 
    func GetDeltaTime() -> Double
    {
        return self.mDeltaTime
    }
 
    func ShakeDevice()
    {
        
    }
    
}
