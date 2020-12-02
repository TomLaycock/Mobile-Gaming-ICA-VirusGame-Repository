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

    //Game UI
    let mScoreLabel = SKLabelNode(fontNamed: "HelveticaNeue-Thin")
    
    let mHealthBar = NumberBar(Start: 100, Max: 100, BackPath: "Squares/BlackSquare.jpg", ForePath: "Squares/GreenSquare", Lentgh: 200, Height: 35)
    let mEnergyBar = NumberBar(Start: 100, Max: 100, BackPath: "Squares/BlackSquare.jpg", ForePath: "Squares/blueSquare", Lentgh: 200, Height: 35)
    
    //Pause Menu
    let mPauseButtonName = "PauseButton-TB"
    let mPauseButton = Button(imageNamed: "MenuButtons/" + "PauseButton-TB")
    
    let mButtons = ["PlayButton-TB", "OptionsButton-TB", "ExitButton-TB"]
    let mResumeButton = Button(imageNamed: "MenuButtons/" + "PlayButton-TB")
    let mOptionsButton = Button(imageNamed: "MenuButtons/" + "OptionsButton-TB")
    let mReturnToMainMenuButton = Button(imageNamed: "MenuButtons/" + "ExitButton-TB")
    
    var mGamePaused = false
    
    var mGameSetupComplete = false
    
    //Game Sounds
    var audioPlayer1 : AVAudioPlayer!
    
    override func didMove(to view: SKView) {

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
        }
        
        let sound1 = Bundle.main.path(forResource: "ButtonClicks/Button-0000", ofType: "wav")
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
        
        mHealthBar.SetBarPosition(to: CGPoint(x: 10, y: 30))
        addChild(mHealthBar.GetBarBackground())
        addChild(mHealthBar.GetBarForeground())
        addChild(mHealthBar.GetBarText())
        
        mEnergyBar.SetBarPosition(to: CGPoint(x: 10, y: 75))
        addChild(mEnergyBar.GetBarBackground())
        addChild(mEnergyBar.GetBarForeground())
        addChild(mEnergyBar.GetBarText())

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
                view?.presentScene(mMainMenuScene)
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
            mDeltaTime = Double(1 / 60)
            mPrevTime = currentTime
        }
        else
        {
            mDeltaTime = currentTime - mPrevTime
            mPrevTime = currentTime
        }
        
        print(mDeltaTime)
        
        if(!mGamePaused)
        {
            
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
    }
 
    func TogglePauseMenuSpecifc(to Value: Bool)
    {
        mGamePaused = Value
        
        mPauseButton.SetButtonState(value: !Value)
        
        mResumeButton.SetButtonState(value: Value)
        mOptionsButton.SetButtonState(value: Value)
        mReturnToMainMenuButton.SetButtonState(value: Value)
    }
    
    func ResetGameScene()
    {
        mPoolSystem.ResetPools()
        
        TogglePauseMenuSpecifc(to: false)
        
        mHealthBar.SetNumberBarValue(to: mHealthBar.mNumberBarMax)
        mEnergyBar.SetNumberBarValue(to: mEnergyBar.mNumberBarMax)
        
        mScoreLabel.text = "SCORE: 0"
    }
    
}
