import SpriteKit
import GameplayKit
import AVFoundation
import CoreMotion

class GameScene: SKScene
{
 
    //System Values
    var mMainMenuScene : MainMenu!
    var mGameOverScene : GameOver!
    let mPoolSystem = PoolSystem()
    
    let mSoundSystem = CustomSoundSystem()
    
    let mMotionManager = CMMotionManager()
    
    //Game Values
    var mGameStarted = false
    var mGamePaused = false
    var mStoreOpen = false
    var mGameOptionsMenu = false
    
    var mGameSetupComplete = false
    
    var mDeltaTime = Double(0)
    var mPrevTime = Double(0)
    
    var mTextScale = CGFloat(0)
    var mCellSize = CGFloat(0)
    var mGameMovementPercentage = CGFloat(1)
    
    //Touch Values
    var mHoldingTouch = false
    var mPurchaseTimer = CGFloat(0)
    var mPurchaseTimerTime = CGFloat(0.2)
    
    var mSwipeResetTimer = CGFloat(0)
    var mSwipeResetTimerTime = CGFloat(0.5)

    var mTouchPointOne = CGPoint(x: -1000, y: -1000)
    var mTouchPointTwo = CGPoint(x: -1000, y: -1000)
    
    //Player Values
    var mPlayer : Player!
    
    //Game UI
    let mOptionsMenu = OptionsMenu()
    let mStoreMenu = GameStoreMenu()
    
    let mTouchInstruction = SKLabelNode(fontNamed: "HelveticaNeue-Thin")
    let mTouchToStartBackground = SKSpriteNode(imageNamed: "Assets/Squares/BlackSquare.jpg")
    let mTouchToStart = Button(imageNamed: "Assets/MenuButtons/PlayButton-TB")
    
    let mScoreLabel = SKLabelNode(fontNamed: "HelveticaNeue-Thin")
    var mScore = 0
    {
        didSet
        {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            let formatteScore = formatter.string(from: mScore as NSNumber) ?? "0"
            mScoreLabel.text = "SCORE: \(formatteScore)"
        }
    }
    
    let mHealthBar = NumberBar(Start: 100, Max: 100, BackPath: "Assets/Squares/BlackSquare.jpg", ForePath: "Assets/Squares/GreenSquare", Lentgh: 200, Height: 35)
    let mEnergyBar = NumberBar(Start: 0, Max: 100, BackPath: "Assets/Squares/BlackSquare.jpg", ForePath: "Assets/Squares/blueSquare", Lentgh: 200, Height: 35)
    
    var mSelectedProjectile = 0
    
    let mProjectileOneSelectionButton = SKSpriteNode(imageNamed: "Assets/Projectiles/Projectile-0000")
    let mProjectileTwoSelectionButton = SKSpriteNode(imageNamed: "Assets/Projectiles/Projectile-0001")
    let mProjectileThreeSelectionButton = SKSpriteNode(imageNamed: "Assets/Projectiles/Projectile-0002")
    
    let mProjectileOneQuantityLabel = SKLabelNode(fontNamed: "HelveticaNeue-Thin")
    let mProjectileTwoQuantityLabel = SKLabelNode(fontNamed: "HelveticaNeue-Thin")
    let mProjectileThreeQuantityLabel = SKLabelNode(fontNamed: "HelveticaNeue-Thin")
    
    
    let mSelectedProjectileImage = SKSpriteNode(imageNamed: "Assets/Projectiles/Projectile-0000")
    let mSelectedProjectileText = SKLabelNode(fontNamed: "HelveticaNeue-Thin")
    
    //Alternate Controlls
    let mShakeControl = Button(imageNamed: "Assets/OtherInput/ShakeInput")
    let mDirectionNames = [
        "Alt Down Button",
        "Alt Left Down Button",
        "Alt Left Button",
        "Alt Left Up Button",
        "Alt Up Button",
        "Alt Right Up Button",
        "Alt Right Button",
        "Alt Right Down Button"
    ]
    let mDirectionArray = [
        Button(imageNamed: "Assets/OtherInput/DirectionInputs"),
        Button(imageNamed: "Assets/OtherInput/DirectionInputs"),
        Button(imageNamed: "Assets/OtherInput/DirectionInputs"),
        Button(imageNamed: "Assets/OtherInput/DirectionInputs"),
        Button(imageNamed: "Assets/OtherInput/DirectionInputs"),
        Button(imageNamed: "Assets/OtherInput/DirectionInputs"),
        Button(imageNamed: "Assets/OtherInput/DirectionInputs"),
        Button(imageNamed: "Assets/OtherInput/DirectionInputs")
    ]
    
    //Pause Menu
    let mPauseButtonName = "PauseButton-TB"
    let mPauseButton = Button(imageNamed: "Assets/MenuButtons/" + "PauseButton-TB")
    
    let mPauseMenuTitle = SKSpriteNode(imageNamed: "Assets/MenuTextures/PausedTitle-TB")
    
    let mButtons = ["PlayButton-TB", "OptionsButton-TB", "ExitButton-TB"]
    let mResumeButton = Button(imageNamed: "Assets/MenuButtons/" + "PlayButton-TB")
    let mOptionsButton = Button(imageNamed: "Assets/MenuButtons/" + "OptionsButton-TB")
    let mReturnToMainMenuButton = Button(imageNamed: "Assets/MenuButtons/" + "ExitButton-TB")
    
    let mPauseBackground = SKSpriteNode(imageNamed: "Assets/Squares/BlackSquare.jpg")

    //Round System
    let mRoundText = SKLabelNode(fontNamed: "HelveticaNeue-Thin")
    
    var mRoundTimeRemaining = 30
    var mRoundTimer = Float(0)
    var mRoundNumber = 0
    {
        didSet
        {
            SetRoundInformation()
        }
    }
    var mNumberOfVirusesToSpawnPerRound = 3
    var mNumberOfCellsSpawned = 0
    {
        didSet
        {
            SetRoundInformation()
        }
    }
    var mNumberOfWhiteBloodCellsKilled = 0
    {
        didSet
        {
            SetRoundInformation()
        }
    }
    var mVirusSpawnTimer = Float(0)
    var mVirusSpawnTimeToMeet = Float(1)
    var mBossSpawned = false
    let mBossRoundNumber = 4
    
    let mBossWhiteBloodCell = BossWhiteBloodCell(back: "Assets/Viruses/WhiteBloodCell-0001-SpikesOnly", front: "Assets/Viruses/WhiteBloodCell-0001-BodyOnly", speed: 120, id: 1000)
    
    //Game Over Values
    var mGameOver = false
    var mGameOverTimer = Float(0)
    
    //User Save Values
    let defaults = UserDefaults.standard
    
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
        
        print("Pool System Object Requests Complete")
        
        //Setting Default Values For Buttons / Images / Text and objects
        mTextScale = CGFloat(frame.width / 32)
        mCellSize = CGFloat(frame.height / 7)
        
        print(frame.height / 7)
        mGameMovementPercentage = CGFloat((frame.height / 7) / 100)

        //Initialising Store Menu
        if !mGameSetupComplete
        {
            mOptionsMenu.SetupGameOptionsMenu(scene: self, audioOn: defaults.bool(forKey: "AudioToggleValue"), altOn: defaults.bool(forKey: "AltToggleValue"))
            mStoreMenu.SetupGameStore(scene: self)
            mSoundSystem.SetupCustomSoundSystem()
        }
        
        mOptionsMenu.InitialiseOptionsMenu()
        mStoreMenu.InitialiseStoreMenu()
        
        //Initialising Player
        if !mGameSetupComplete
        {
            mPlayer = Player(back: "Assets/Viruses/Virus-0000-SpikesOnly", front: "Assets/Viruses/Virus-0000-BodyOnly", speed: 2)
        }
        
        mBossSpawned = false
        
        mPlayer.InitialisePlayer(scene: self, name: "Player", zposition: 8)
        mPlayer.SpawnPlayer(position: CGPoint(x: frame.midX, y: frame.midY), size: CGSize(width: mCellSize, height: mCellSize))
        mPlayer.SetSpeed(to: Float(mGameMovementPercentage * 200))
        
        //Touch to start
        mTouchToStartBackground.position = CGPoint(x: frame.midX, y: frame.midY)
        mTouchToStartBackground.size = CGSize(width: frame.maxX, height: frame.maxY)
        mTouchToStartBackground.zPosition = 200
        mTouchToStartBackground.alpha = 0.8
        addChild(mTouchToStartBackground)
        
        mTouchInstruction.fontSize = mTextScale * 2
        mTouchInstruction.position = CGPoint(x: frame.midX, y: frame.midY + (frame.maxY / 7))
        mTouchInstruction.text = "Touch Button to Start!"
        mTouchInstruction.zPosition = 201
        mTouchInstruction.horizontalAlignmentMode = .center
        mTouchInstruction.isUserInteractionEnabled = false
        addChild(mTouchInstruction)
        
        mTouchToStart.name = "Touch To Start"
        mTouchToStart.size = CGSize(width: frame.maxY / 5, height: frame.maxY / 5)
        mTouchToStart.position = CGPoint(x: frame.midX, y: frame.midY)
        mTouchToStart.SetButtonPosition(to: mTouchToStart.position)
        mTouchToStart.SetButtonState(value: true)
        mTouchToStart.zPosition = 201
        addChild(mTouchToStart)
        
        //Creating MainMenu Buttons
        mPauseMenuTitle.name = "MenuTitle"
        mPauseMenuTitle.size = CGSize(width: (frame.height / 1.5), height: (frame.height / 3) / 1.5)
        mPauseMenuTitle.position = CGPoint(x: -1000, y: 0)
        mPauseMenuTitle.zPosition = 99
        addChild(mPauseMenuTitle)
        
        mPauseButton.name = mPauseButtonName
        mPauseButton.size = CGSize(width: frame.maxX / 10, height: frame.maxX / 10)
        mPauseButton.position = CGPoint(x: mPauseButton.frame.width / 2 + 10, y: frame.maxY - 10 - mPauseButton.frame.height / 2)
        mPauseButton.SetButtonPosition(to: mPauseButton.position)
        mPauseButton.zPosition = 100
        addChild(mPauseButton)

        mResumeButton.name = mButtons[0]
        mResumeButton.size = CGSize(width: frame.maxY / 5, height: frame.maxY / 5)
        mResumeButton.position = CGPoint(x: frame.midX + (-1 * mResumeButton.frame.width * 2), y: frame.midY)
        mResumeButton.SetButtonPosition(to: mResumeButton.position)
        mResumeButton.SetButtonState(value: false)
        mResumeButton.zPosition = 100
        addChild(mResumeButton)
        
        mOptionsButton.name = mButtons[1]
        mOptionsButton.size = CGSize(width: frame.maxY / 5, height: frame.maxY / 5)
        mOptionsButton.position = CGPoint(x: frame.midX + (0 * mOptionsButton.frame.width * 2), y: frame.midY)
        mOptionsButton.SetButtonPosition(to: mOptionsButton.position)
        mOptionsButton.SetButtonState(value: false)
        mOptionsButton.zPosition = 100
        addChild(mOptionsButton)
        
        mReturnToMainMenuButton.name = mButtons[2]
        mReturnToMainMenuButton.size = CGSize(width: frame.maxY / 5, height: frame.maxY / 5)
        mReturnToMainMenuButton.position = CGPoint(x: frame.midX + (1 * mReturnToMainMenuButton.frame.width * 2), y: frame.midY)
        mReturnToMainMenuButton.SetButtonPosition(to: mReturnToMainMenuButton.position)
        mReturnToMainMenuButton.SetButtonState(value: false)
        mReturnToMainMenuButton.zPosition = 100
        addChild(mReturnToMainMenuButton)
        
        mPauseBackground.position = CGPoint(x: frame.midX, y: frame.midY)
        mPauseBackground.size = CGSize(width: 0, height: 0)
        mPauseBackground.zPosition = 98
        mPauseBackground.alpha = 0.8
        addChild(mPauseBackground)
        
        //Game UI
        mScoreLabel.fontSize = mTextScale * 2
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
        
        let ProjectileButtonsSize = CGFloat(50)
        mProjectileOneSelectionButton.position = CGPoint(x: frame.maxX  + (-ProjectileButtonsSize * 3) - 20, y: frame.maxY - ProjectileButtonsSize)
        mProjectileOneSelectionButton.zPosition = 90
        mProjectileOneSelectionButton.size = CGSize(width: ProjectileButtonsSize, height: ProjectileButtonsSize)
        mProjectileOneSelectionButton.name = "ProjectileButtonOne"
        addChild(mProjectileOneSelectionButton)
        
        mProjectileTwoSelectionButton.position = CGPoint(x: frame.maxX + (-ProjectileButtonsSize * 2) - 10, y: frame.maxY - ProjectileButtonsSize)
        mProjectileTwoSelectionButton.zPosition = 90
        mProjectileTwoSelectionButton.size = CGSize(width: ProjectileButtonsSize, height: ProjectileButtonsSize)
        mProjectileTwoSelectionButton.name = "ProjectileButtonTwo"
        addChild(mProjectileTwoSelectionButton)
        
        mProjectileThreeSelectionButton.position = CGPoint(x: frame.maxX - ProjectileButtonsSize, y: frame.maxY - ProjectileButtonsSize)
        mProjectileThreeSelectionButton.zPosition = 90
        mProjectileThreeSelectionButton.size = CGSize(width: ProjectileButtonsSize, height: ProjectileButtonsSize)
        mProjectileThreeSelectionButton.name = "ProjectileButtonThree"
        addChild(mProjectileThreeSelectionButton)

        mProjectileOneQuantityLabel.fontSize = 25
        mProjectileOneQuantityLabel.position = CGPoint(x: frame.maxX + (-ProjectileButtonsSize * 3) - 20, y: frame.maxY - (ProjectileButtonsSize / 2))
        mProjectileOneQuantityLabel.text = "0"
        mProjectileOneQuantityLabel.zPosition = 91
        mProjectileOneQuantityLabel.horizontalAlignmentMode = .center
        mProjectileOneQuantityLabel.isUserInteractionEnabled = false
        addChild(mProjectileOneQuantityLabel)
        
        mProjectileTwoQuantityLabel.fontSize = 25
        mProjectileTwoQuantityLabel.position = CGPoint(x: frame.maxX + (-ProjectileButtonsSize * 2) - 10, y: frame.maxY - (ProjectileButtonsSize / 2))
        mProjectileTwoQuantityLabel.text = "0"
        mProjectileTwoQuantityLabel.zPosition = 91
        mProjectileTwoQuantityLabel.horizontalAlignmentMode = .center
        mProjectileTwoQuantityLabel.isUserInteractionEnabled = false
        addChild(mProjectileTwoQuantityLabel)
        
        mProjectileThreeQuantityLabel.fontSize = 25
        mProjectileThreeQuantityLabel.position = CGPoint(x: frame.maxX - ProjectileButtonsSize, y: frame.maxY - (ProjectileButtonsSize / 2))
        mProjectileThreeQuantityLabel.text = "0"
        mProjectileThreeQuantityLabel.zPosition = 91
        mProjectileThreeQuantityLabel.horizontalAlignmentMode = .center
        mProjectileThreeQuantityLabel.isUserInteractionEnabled = false
        addChild(mProjectileThreeQuantityLabel)
        
        
        mSelectedProjectileImage.position = CGPoint(x: frame.maxX - ProjectileButtonsSize, y: frame.maxY - (ProjectileButtonsSize * 2))
        mSelectedProjectileImage.zPosition = 90
        mSelectedProjectileImage.size = CGSize(width: ProjectileButtonsSize, height: ProjectileButtonsSize)
        mSelectedProjectileImage.name = "SelectedProjectileImage"
        addChild(mSelectedProjectileImage)
        
        mSelectedProjectileText.fontSize = 17
        mSelectedProjectileText.position = CGPoint(x: frame.maxX - (ProjectileButtonsSize * 2), y: frame.maxY - (ProjectileButtonsSize * 2))
        mSelectedProjectileText.text = "SELECTED PROJECTILE:"
        mSelectedProjectileText.zPosition = 91
        mSelectedProjectileText.horizontalAlignmentMode = .right
        mSelectedProjectileText.verticalAlignmentMode = .center
        mSelectedProjectileText.isUserInteractionEnabled = false
        addChild(mSelectedProjectileText)
        
        //Alternate Controls - Setup for positions - scales
        let ShakeButtonSize = frame.maxY / 7
        
        mShakeControl.position = CGPoint(x: 0 + 50, y: frame.midY)
        mShakeControl.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        mShakeControl.zPosition = 91
        mShakeControl.size = CGSize(width: ShakeButtonSize, height: ShakeButtonSize)
        mShakeControl.name = "Alt Shake Button"
        mShakeControl.isHidden = true
        addChild(mShakeControl)
        
        let DirectionButtonSize = frame.maxY / 12
        var DirectionCounter = 0
        for direction in mDirectionArray
        {
            direction.anchorPoint = CGPoint(x: 0.5, y: 2)
            direction.position = CGPoint(x: frame.maxX - (frame.maxY / 7), y: frame.midY)
            direction.zPosition = 91
            direction.zRotation = CGFloat(GLKMathDegreesToRadians(Float(45 * DirectionCounter)))
            direction.size = CGSize(width: DirectionButtonSize, height: DirectionButtonSize * 0.66)
            direction.name = mDirectionNames[DirectionCounter]
            direction.isHidden = true
            addChild(direction)
            
            DirectionCounter = DirectionCounter + 1
        }
        
        //Round UI
        mRoundText.fontSize = mTextScale
        mRoundText.position = CGPoint(x: frame.midX - 50, y: frame.maxY - 50)
        mRoundText.zPosition = 91
        mRoundText.horizontalAlignmentMode = .center
        addChild(mRoundText)

        mRoundTimeRemaining = 30
        mRoundNumber = 0
        
        mNumberOfCellsSpawned = 0
        
        mBossWhiteBloodCell.InitialiseBossWhiteBloodCell(scene: self, name: "Boss White Blood Cell", zposition: 7)
        
        print("UI Setup Complete")
        
        mMotionManager.startAccelerometerUpdates()
        mMotionManager.startGyroUpdates()
        
        ToggleAlternateControlView(to: mOptionsMenu.mAlternateControlsValue)
        
        mGameSetupComplete = true
    }
    
    //Toggles the Visibility of Alternate controls
    func ToggleAlternateControlView(to Value: Bool)
    {
        mShakeControl.isHidden = !Value
        
        for direction in mDirectionArray
        {
            direction.isHidden = !Value
        }
    }

    //Returns next available projectile for currently selected projectile type
    func GetNextProjectile() -> Projectile
    {
        if mSelectedProjectile == 0
        {
            mStoreMenu.mProjectileOneQuantity = mStoreMenu.mProjectileOneQuantity - 1
            return mPoolSystem.GetNextAvailableProjectileOne()
        }
        else if mSelectedProjectile == 1
        {
            mStoreMenu.mProjectileTwoQuantity = mStoreMenu.mProjectileTwoQuantity - 1
            return mPoolSystem.GetNextAvailableProjectileTwo()
        }
        else if mSelectedProjectile == 2
        {
            mStoreMenu.mProjectileThreeQuantity = mStoreMenu.mProjectileThreeQuantity - 1
            return mPoolSystem.GetNextAvailableProjectileThree()
        }
        
        print("Selected Projectile Is Invalid - Returing Projectile One")
        return mPoolSystem.GetNextAvailableProjectileOne()
    }
    
    func MathMax(a A: Int, b B: Int) -> Int
    {
        if A > B
        {
            return A
        }
        else
        {
            return B
        }
    }
    
    //Perform swipe for firing projectile
    func SwipePerformed() -> Bool
    {
        
        //Checking swipe dist and values
        let SwipeRequiredDist = CGFloat(20)
        let SwipeDist = Vector2.magnitude(v: Vector2(CGPoint: mTouchPointTwo) - Vector2(CGPoint: mTouchPointOne))
        
        if SwipeDist < SwipeRequiredDist
        {
            mTouchPointOne = CGPoint(x: -1000, y: -1000)
            mTouchPointTwo = CGPoint(x: -1000, y: -1000)
            
            return false
        }
        
        //Fires Projectile
        if mStoreMenu.mProjectileOneQuantity > 0 && mSelectedProjectile == 0 ||
            mStoreMenu.mProjectileTwoQuantity > 0 && mSelectedProjectile == 1 ||
            mStoreMenu.mProjectileThreeQuantity > 0 && mSelectedProjectile == 2
        {
            
            mSoundSystem.PlaySound(sound: "Projectile Shoot", scene: self)
            
            let LaunchDirection = Vector2.normalise(v: Vector2(CGPoint: mTouchPointTwo) - Vector2(CGPoint: mTouchPointOne))
            let projectileToLaunch = GetNextProjectile()
            projectileToLaunch.Spawn(at: mPlayer.GetPosition(), dir: LaunchDirection, with: (mSelectedProjectile * 4) + MathMax(a: 1, b: mSelectedProjectile * 1), speed: 450)
            
            mTouchPointOne = CGPoint(x: -1000, y: -1000)
            mTouchPointTwo = CGPoint(x: -1000, y: -1000)
            
            return true
            
        }
        else //Plays Small Click sound to signify no ammo
        {
            mSoundSystem.PlaySound(sound: "Small Click", scene: self)
        }
        
        mTouchPointOne = CGPoint(x: -1000, y: -1000)
        mTouchPointTwo = CGPoint(x: -1000, y: -1000)
        
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //let playSound = SKAction.playSoundFileNamed("ButtonClicks/Button-0001", waitForCompletion: true)
        //self.run(playSound)
        
        //mHealthBar.DecreaseNumberBarValue(by: 1)
        //mEnergyBar.IncreaseNumberBarValue(by: 1)
        
        for touch in touches
        {
            mHoldingTouch = true
            
            let location = touch.location(in: self)
            //let touchedNode = atPoint(location)
            if mTouchPointOne == CGPoint(x: -1000, y: -1000)
            {
                mSwipeResetTimer = 0
                mTouchPointOne = location
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches
        {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            mHoldingTouch = false;
            
            //Checking start game touch
            if !mGameStarted
            {
                if touchedNode.name == "Touch To Start"
                {
                    mTouchToStart.SetButtonState(value: false)
                    mTouchToStartBackground.size = CGSize(width: 0, height: 0)
                    mTouchToStartBackground.isHidden = true
                    mTouchInstruction.isHidden = true
                    mGameStarted = true
                }
                return
            }
            
            //Checking game swipe feature
            if(!mGamePaused && !mStoreOpen && !mGameOptionsMenu)
            {
                mTouchPointTwo = location
                
                if mTouchPointOne != CGPoint(x: -1000, y: -1000)
                {
                
                    let SwipePerformedValue = SwipePerformed()
                    
                    if SwipePerformedValue { return }
                    
                }
            }
            
            //Menu Buttons
            if touchedNode.name == mPauseButtonName && !mStoreOpen
            {
                TogglePauseMenu()
                mSoundSystem.PlaySound(sound: "Button Zero", scene: self)
            }
            else if touchedNode.name == mButtons[0] //Resume Game
            {
                TogglePauseMenu()
                mSoundSystem.PlaySound(sound: "Button Zero", scene: self)
            }
            else if touchedNode.name == mButtons[1] //Options Menu
            {
                mOptionsMenu.ToggleOptionsMenu(to: true)
                TogglePauseMenuSpecifc(to: false)
                
                mPauseButton.SetButtonState(value: false)
                mStoreMenu.mStoreButton.SetButtonState(value: false)
                
                mSoundSystem.PlaySound(sound: "Button Zero", scene: self)
            }
            else if touchedNode.name == mButtons[2] //Return to main menu
            {
                mSoundSystem.PlaySound(sound: "Button Zero", scene: self)
                
                ResetGameScene()
                removeAllChildren()
                
                mMainMenuScene.scaleMode = .resizeFill
                view?.presentScene(mMainMenuScene, transition: .fade(withDuration: 0.5))
            }
            
            //Projectiles
            if !mGamePaused && !mGameOptionsMenu && !mStoreOpen
            {
                if touchedNode.name == "ProjectileButtonOne"
                {
                    mSoundSystem.PlaySound(sound: "Projectile Select", scene: self)
                    mSelectedProjectile = 0
                    mSelectedProjectileImage.texture = SKTexture(imageNamed: "Assets/Projectiles/Projectile-0000")
                }
                else if touchedNode.name == "ProjectileButtonTwo"
                {
                    mSoundSystem.PlaySound(sound: "Projectile Select", scene: self)
                    mSelectedProjectile = 1
                    mSelectedProjectileImage.texture = SKTexture(imageNamed: "Assets/Projectiles/Projectile-0001")
                }
                else if touchedNode.name == "ProjectileButtonThree"
                {
                    mSoundSystem.PlaySound(sound: "Projectile Select", scene: self)
                    mSelectedProjectile = 2
                    mSelectedProjectileImage.texture = SKTexture(imageNamed: "Assets/Projectiles/Projectile-0002")
                }
            }
            
            //Updating Game Sub Menus
            if !mGamePaused
            {
                let NodePressedName = String(touchedNode.name ?? "None")
                mStoreMenu.UpdateStoreMenu(pressed: NodePressedName) //Store Menu
            }

            if mGameOptionsMenu
            {
                let NodePressedName = String(touchedNode.name ?? "None")
                mOptionsMenu.UpdateOptionsMenu(pressed: NodePressedName) //options Menu
            }
            
            //If player has chosen to use touch controls instead
            if defaults.bool(forKey: "AltToggleValue")
            {
                if touchedNode.name == "Alt Shake Button"
                {
                    self.ShakeDevice()
                }
                else if touchedNode.name == "Alt Down Button"
                {
                    if mPlayer.GetAlive() && !mGameOver && mGameStarted
                    {
                        mPlayer.SetPlayerMovementDirection(to: Vector2.normalise(v: Vector2(x: 0, y: -1)))
                    }
                }
                else if touchedNode.name == "Alt Left Down Button"
                {
                    if mPlayer.GetAlive() && !mGameOver && mGameStarted
                    {
                        mPlayer.SetPlayerMovementDirection(to: Vector2.normalise(v: Vector2(x: 1, y: -1)))
                    }
                }
                else if touchedNode.name == "Alt Left Button"
                {
                    if mPlayer.GetAlive() && !mGameOver && mGameStarted
                    {
                        mPlayer.SetPlayerMovementDirection(to: Vector2.normalise(v: Vector2(x: 1, y: 0)))
                    }
                }
                else if touchedNode.name == "Alt Left Up Button"
                {
                    if mPlayer.GetAlive() && !mGameOver && mGameStarted
                    {
                        mPlayer.SetPlayerMovementDirection(to: Vector2.normalise(v: Vector2(x: 1, y: 1)))
                    }
                }
                else if touchedNode.name == "Alt Up Button"
                {
                    if mPlayer.GetAlive() && !mGameOver && mGameStarted
                    {
                        mPlayer.SetPlayerMovementDirection(to: Vector2.normalise(v: Vector2(x: 0, y: 1)))
                    }
                }
                else if touchedNode.name == "Alt Right Up Button"
                {
                    if mPlayer.GetAlive() && !mGameOver && mGameStarted
                    {
                        mPlayer.SetPlayerMovementDirection(to: Vector2.normalise(v: Vector2(x: -1, y: 1)))
                    }
                }
                else if touchedNode.name == "Alt Right Button"
                {
                    if mPlayer.GetAlive() && !mGameOver && mGameStarted
                    {
                        mPlayer.SetPlayerMovementDirection(to: Vector2.normalise(v: Vector2(x: -1, y: 0)))
                    }
                }
                else if touchedNode.name == "Alt Right Down Button"
                {
                    if mPlayer.GetAlive() && !mGameOver && mGameStarted
                    {
                        mPlayer.SetPlayerMovementDirection(to: Vector2.normalise(v: Vector2(x: -1, y: -1)))
                    }
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval)
    {
        
        //Checks if the Game has Ended
        if mGameOver
        {
            mGameOverTimer = mGameOverTimer + Float(mDeltaTime)
            
            if mGameOverTimer >= 1
            {
                //Player Lost
                if mPlayer.mHealth <= 0
                {
                    mGameOverScene.ToggleGameOverScreenWin(value: false, score: mScore)
                    
                    ResetGameScene()
                    removeAllChildren()

                    //Switching to Game over Scene
                    mGameOverScene.scaleMode = .resizeFill
                    view?.presentScene(mGameOverScene, transition: .fade(withDuration: 0.5))
                }
                
                //Player Won
                if mRoundNumber == mBossRoundNumber && !mBossWhiteBloodCell.GetAlive() && mBossWhiteBloodCell.GetHealth() <= 0
                {
                    mGameOverScene.ToggleGameOverScreenWin(value: true, score: mScore)
                    
                    ResetGameScene()
                    removeAllChildren()

                    //Switching to Game over Scene
                    mGameOverScene.scaleMode = .resizeFill
                    view?.presentScene(mGameOverScene, transition: .fade(withDuration: 0.5))
                }
            }
            
            return
        }
        
        //Checks if player has died
        if mPlayer.mHealth <= 0
        {
            mPlayer.DestroyPlayer() //Removes player
            
            mSoundSystem.PlaySound(sound: "Cell Death", scene: self) //Plays Death Sound
            
            //Starts Shake particle for Game Over Effect
            if let mShakeParticle = SKEmitterNode(fileNamed: "ShakeEffect")
            {
                mShakeParticle.position = CGPoint(x: frame.midX, y: frame.midY)
                addChild(mShakeParticle)

                let removeAfterDead = SKAction.sequence([SKAction.wait(forDuration: 1), SKAction.removeFromParent()])
                mShakeParticle.run(removeAfterDead)
            }
            
            mGameOver = true
        }
        
        if mRoundNumber == mBossRoundNumber && !mBossWhiteBloodCell.GetAlive() && mBossWhiteBloodCell.GetHealth() <= 0
        {
            //Starts Shake particle for Game Over Effect
            if let mShakeParticle = SKEmitterNode(fileNamed: "ShakeEffect")
            {
                mShakeParticle.position = CGPoint(x: frame.midX, y: frame.midY)
                addChild(mShakeParticle)

                let removeAfterDead = SKAction.sequence([SKAction.wait(forDuration: 1), SKAction.removeFromParent()])
                mShakeParticle.run(removeAfterDead)
            }
            
            mGameOver = true
        }
        
        //Calculating Delta Time
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
        
        if !mGameStarted
        {
            return
        }
        
        //Updates the Store Menu and Holding Purchase Timers
        if mStoreOpen && !mGamePaused
        {
            if mHoldingTouch
            {
                mPurchaseTimer = mPurchaseTimer + CGFloat(mDeltaTime)
                
                if mPurchaseTimer >= mPurchaseTimerTime
                {
                    mPurchaseTimer = 0
                    
                    let touchedNode = atPoint(mTouchPointOne)
                    
                    let NodePressedName = String(touchedNode.name ?? "None")

                    mStoreMenu.UpdateStoreMenu(pressed: NodePressedName)
                }
            }
        }
        
        //Reset Swipe First Touch if not been held
        mSwipeResetTimer = mSwipeResetTimer + CGFloat(mDeltaTime)
        if !mHoldingTouch
        {
            if mSwipeResetTimer >= mSwipeResetTimerTime
            {
                mTouchPointOne = CGPoint(x: -1000, y: -1000)
            }
        }
        
        //if the Game has not Ended - Been Paused - Store is not Open and The Options menu is closed
        if(!mGamePaused && !mStoreOpen && !mGameOptionsMenu)
        {
            
            //Round System Management
            if mRoundNumber < mBossRoundNumber
            {
                if mRoundTimeRemaining <= 0 || mNumberOfCellsSpawned >= mNumberOfVirusesToSpawnPerRound && mPoolSystem.GetNumberOfWhiteBloodCellsAlive() <= 0
                {
                    mRoundNumber = mRoundNumber + 1
                    mNumberOfVirusesToSpawnPerRound = 3 + (2 * mRoundNumber)
                    mRoundTimeRemaining = 30
                    mNumberOfCellsSpawned = 0
                }
            }

            mRoundTimer = mRoundTimer + Float(mDeltaTime)
            if mRoundTimer >= 1
            {
                mRoundTimer = 0
                mRoundTimeRemaining = mRoundTimeRemaining - 1
            }
            
            //Spawns more white blood cells if the round requires more
            if (mNumberOfCellsSpawned < mNumberOfVirusesToSpawnPerRound && mRoundNumber < mBossRoundNumber)
            {
                mVirusSpawnTimer = mVirusSpawnTimer + Float(mDeltaTime)
                
                if mVirusSpawnTimer >= mVirusSpawnTimeToMeet
                {
                    mNumberOfCellsSpawned = mNumberOfCellsSpawned + 1
                    mVirusSpawnTimeToMeet = Float.random(in: 0.5...1.6)
                    mVirusSpawnTimer = 0
                    
                    let WhiteBloodCell = mPoolSystem.GetNextAvailableWhiteBloodCell()
                    WhiteBloodCell.SpawnWhiteBloodCell(size: CGSize(width: mCellSize, height: mCellSize), otherCells: mPoolSystem.GetWhiteBloodCells())
                    WhiteBloodCell.SetSpeed(to: Float(mGameMovementPercentage * CGFloat(Int.random(in: 60...100))))
                    
                    SetRoundInformation()
                }
            }
            
            //If the final round is active spawn the boss white blood cell
            if mRoundNumber == mBossRoundNumber && !mBossSpawned
            {
                mBossSpawned = true
                mBossWhiteBloodCell.SpawnWhiteBloodCell(size: CGSize(width: mCellSize * 2, height: mCellSize * 2), otherCells: mPoolSystem.GetWhiteBloodCells())
                mBossWhiteBloodCell.SetSpeed(to: Float(mGameMovementPercentage * 120))
            }
            
            //If Device motion Controlls Are Enabled
            if !defaults.bool(forKey: "AltToggleValue")
            {
                
                //Player Movement
                var playerRotVector = Vector2(x: 0, y: 0)
                var playerAccVector = Vector2(x: 0, y: 0)
            
                if let gyroscope = mMotionManager.gyroData
                {
                    playerRotVector = Vector2(x: Float(gyroscope.rotationRate.x), y: Float(gyroscope.rotationRate.y))
                }
                
                if let accelerometer = mMotionManager.accelerometerData
                {
                    //physicsWorld.gravity = CGVector(dx: accelerometer.acceleration.y * -50, dy: accelerometer.acceleration.x*50)
                    playerAccVector = Vector2(x: Float(-accelerometer.acceleration.y), y: Float(accelerometer.acceleration.x))
                }
                
                if mPlayer.GetAlive()
                {
                    mPlayer.UpdateMovementDirection(rotation: playerRotVector, acceleration: playerAccVector)
                }
                
            }
            
            if mPlayer.GetAlive()
            {
                mPlayer.UpdatePlayer(speed: 2)
            }
            
            //Updating White Blood Cells
            for WhiteBloodCellInstance in mPoolSystem.GetWhiteBloodCells()
            {
                if WhiteBloodCellInstance.GetAlive()
                {
                    WhiteBloodCellInstance.MoveTowards(target: mPlayer.GetPosition())
                    WhiteBloodCellInstance.Update(rotationSpeed: 1)
                    WhiteBloodCellInstance.CheckCollisionWithPlayer(player: mPlayer)
                }
            }
            
            if mBossWhiteBloodCell.GetAlive()
            {
                mBossWhiteBloodCell.MoveTowards(target: mPlayer.GetPosition())
                mBossWhiteBloodCell.Update(rotationSpeed: 1)
                mBossWhiteBloodCell.CheckCollisionWithPlayer(player: mPlayer)
            }
            
            //Update Energy Balls
            for EnergyBallInstance in mPoolSystem.GetEnergyBalls()
            {
                if EnergyBallInstance.GetAlive()
                {
                    EnergyBallInstance.CheckCollisionWithPlayer(player: mPlayer)
                }
            }
            
            if mPoolSystem.GetNumberOfEnergyBallsAlive() < 10
            {
                let EnergyToSpawn = mPoolSystem.GetNextAvailableEnergyBall()
                EnergyToSpawn.Spawn(with: Int.random(in: 1...5), otherCells: mPoolSystem.GetEnergyBalls())
            }
         
            //---------------------------------------------------------------------------------//
            //-------------------------------- Update Projectiles -----------------------------//
            //---------------------------------------------------------------------------------//
            
            for projectile in mPoolSystem.GetProjectileOnePool()
            {
                if !projectile.GetAlive() { continue }
                
                projectile.Update()
                projectile.CheckCollisionWithWhiteBloodCells(cells: mPoolSystem.GetWhiteBloodCells())
                projectile.CheckCollisionWithBoss(cell: mBossWhiteBloodCell)
            }
            
            for projectile in mPoolSystem.GetProjectileTwoPool()
            {
                if !projectile.GetAlive() { continue }
                
                projectile.Update()
                projectile.CheckCollisionWithWhiteBloodCells(cells: mPoolSystem.GetWhiteBloodCells())
                projectile.CheckCollisionWithBoss(cell: mBossWhiteBloodCell)
            }
            
            for projectile in mPoolSystem.GetProjectileThreePool()
            {
                if !projectile.GetAlive() { continue }
                
                projectile.Update()
                projectile.CheckCollisionWithWhiteBloodCells(cells: mPoolSystem.GetWhiteBloodCells())
                projectile.CheckCollisionWithBoss(cell: mBossWhiteBloodCell)
            }
            
        }
        else
        {
            //Game Paused
        }
        
    }
    
    //Opening / Closing the pause menu
    func TogglePauseMenu()
    {
        mGamePaused = !mGamePaused
           
        mPauseButton.SetButtonState(value: !mGamePaused)
        
        mResumeButton.SetButtonState(value: mGamePaused)
        mOptionsButton.SetButtonState(value: mGamePaused)
        mReturnToMainMenuButton.SetButtonState(value: mGamePaused)
        
        if mGamePaused
        {
            mStoreMenu.mStoreButton.SetButtonState(value: false)
            mPauseBackground.size = CGSize(width: frame.maxX, height: frame.maxY)
            mPauseMenuTitle.position = CGPoint(x: frame.midX, y: frame.maxY - mPauseMenuTitle.frame.height / 1.5)
        }
        else
        {
            mStoreMenu.mStoreButton.SetButtonState(value: true)
            mPauseBackground.size = CGSize(width: 0, height: 0)
            mPauseMenuTitle.position = CGPoint(x: -1000, y: 0)
        }
    }
    
    //Open / Close pause menu with provded value
    func TogglePauseMenuSpecifc(to Value: Bool)
    {
        mGamePaused = Value
        
        mPauseButton.SetButtonState(value: !Value)
        
        mResumeButton.SetButtonState(value: Value)
        mOptionsButton.SetButtonState(value: Value)
        mReturnToMainMenuButton.SetButtonState(value: Value)
        
        if mGamePaused
        {
            mStoreMenu.mStoreButton.SetButtonState(value: false)
            mPauseBackground.size = CGSize(width: frame.maxX, height: frame.maxY)
            mPauseMenuTitle.position = CGPoint(x: frame.midX, y: frame.maxY - mPauseMenuTitle.frame.height / 1.5)
        }
        else
        {
            mStoreMenu.mStoreButton.SetButtonState(value: true)
            mPauseBackground.size = CGSize(width: 0, height: 0)
            mPauseMenuTitle.position = CGPoint(x: -1000, y: 0)
        }
    }
    
    //Resets game values ready to be played again
    func ResetGameScene()
    {
        mGameStarted = false
        mRoundTimeRemaining = 30
        mRoundNumber = 0
        mNumberOfVirusesToSpawnPerRound = 3
        mNumberOfCellsSpawned = 0
        
        mTouchToStart.SetButtonState(value: true)
        mTouchToStartBackground.size = CGSize(width: frame.maxX, height: frame.maxY)
        mTouchToStartBackground.isHidden = false
        mTouchInstruction.isHidden = false
        
        mPoolSystem.ResetPools()
        
        TogglePauseMenuSpecifc(to: false)
        mStoreMenu.ToggleStoreMenu(to: false)
        
        mHealthBar.SetNumberBarValue(to: mHealthBar.mNumberBarMax)
        mEnergyBar.SetNumberBarValue(to: 0)
        
        mScore = 0
        mNumberOfWhiteBloodCellsKilled = 0
        
        mScoreLabel.text = "SCORE: 0"
        
        mGameOver = false
        mGameOverTimer = 0
    }
 
    func GetDeltaTime() -> Double
    {
        return self.mDeltaTime
    }
 
    //Performs the shake functionality destroying all White Blood Cells and Damaging the Boss White Blood Cell
    func ShakeDevice()
    {
        if mPlayer.GetEnergy() >= mPlayer.GetMaxEnergy()
        {
            
            mPlayer.SetEnergy(to: CGFloat(0))
            
            mSoundSystem.PlaySound(sound: "Power Up", scene: self)
            
            if let mShakeParticle = SKEmitterNode(fileNamed: "ShakeEffect")
            {
                mShakeParticle.position = CGPoint(x: frame.midX, y: frame.midY)
                addChild(mShakeParticle)

                let removeAfterDead = SKAction.sequence([SKAction.wait(forDuration: 1), SKAction.removeFromParent()])
                mShakeParticle.run(removeAfterDead)
            }
            
            for WhiteBloodCellInstance in mPoolSystem.GetWhiteBloodCells()
            {
                if WhiteBloodCellInstance.GetAlive()
                {
                    WhiteBloodCellInstance.DestroyWhiteBloodCell(playSound: false)
                }
            }
         
            if mBossWhiteBloodCell.GetAlive() && mBossWhiteBloodCell.GetHealth() > 0
            {
                mBossWhiteBloodCell.DecreaseHealth(by: 20)
            }
            
        }
        else
        {
            mSoundSystem.PlaySound(sound: "Small Click", scene: self)
        }
        
    }
    
    func SetRoundInformation()
    {
        let totalAlive = mPoolSystem.GetNumberOfWhiteBloodCellsAlive()
        
        mRoundText.text = "WAVE: " + String(mRoundNumber + 1) + "    CELLS REMAINING: " + String(totalAlive)
    }
    
}
