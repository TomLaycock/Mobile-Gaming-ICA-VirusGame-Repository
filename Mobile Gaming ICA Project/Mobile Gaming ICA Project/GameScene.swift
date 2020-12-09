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
    
    var mTouchPointOne = CGPoint(x: -1000, y: -1000)
    var mTouchPointTwo = CGPoint(x: -1000, y: -1000)
    
    //Game UI
    let mOptionsMenu = OptionsMenu()
    let mStoreMenu = GameStoreMenu()
    
    let mSoundSystem = CustomSoundSystem()
    
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
    
    //Alternate Controlls
    let mShakeControl = SKSpriteNode(imageNamed: "Assets/OtherInput/ShakeInput")
    let mDirectionInputImageSource = "Assets/PtherInput/DirectionInputs"
    
    //Pause Menu
    let mPauseButtonName = "PauseButton-TB"
    let mPauseButton = Button(imageNamed: "Assets/MenuButtons/" + "PauseButton-TB")
    
    let mPauseMenuTitle = SKSpriteNode(imageNamed: "Assets/MenuTextures/PausedTitle-TB")
    
    let mButtons = ["PlayButton-TB", "OptionsButton-TB", "ExitButton-TB"]
    let mResumeButton = Button(imageNamed: "Assets/MenuButtons/" + "PlayButton-TB")
    let mOptionsButton = Button(imageNamed: "Assets/MenuButtons/" + "OptionsButton-TB")
    let mReturnToMainMenuButton = Button(imageNamed: "Assets/MenuButtons/" + "ExitButton-TB")
    
    let mPauseBackground = SKSpriteNode(imageNamed: "Assets/Squares/BlackSquare.jpg")
    
    var mGamePaused = false
    var mStoreOpen = false
    var mGameOptionsMenu = false
    
    var mGameSetupComplete = false
    
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

        for _ in 1...10
        {
            let EnergyToSpawn = mPoolSystem.GetNextAvailableEnergyBall()
            EnergyToSpawn.Spawn(with: Int.random(in: 1...5), otherCells: mPoolSystem.GetEnergyBalls())
        }
        
        for _ in 1...3
        {
            let WhiteBloodCell = mPoolSystem.GetNextAvailableWhiteBloodCell()
            WhiteBloodCell.SpawnWhiteBloodCell(size: CGSize(width: 100, height: 100), otherCells: mPoolSystem.GetWhiteBloodCells())
            WhiteBloodCell.SetSpeed(to: Float(Int.random(in: 60...100)))
        }
        
        print("Pool System Object Requests Complete")
        
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
        
        mPlayer.InitialisePlayer(scene: self, name: "Player", zposition: 8)
        mPlayer.SpawnPlayer(position: CGPoint(x: frame.midX, y: frame.midY), size: CGSize(width: 100, height: 100))
        mPlayer.SetSpeed(to: 200)
        
        //Creating MainMenu Buttons
        mPauseMenuTitle.name = "MenuTitle"
        mPauseMenuTitle.size = CGSize(width: frame.midX, height: frame.midX / 3)
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
        mPauseBackground.alpha = 0.8
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
        
        print("UI Setup Complete")
        
        mMotionManager.startAccelerometerUpdates()
        mMotionManager.startGyroUpdates()
        
        mGameSetupComplete = true
        
        
        /*let swipeRight : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.Swipe))
        swipeRight.direction = .right

        view.addGestureRecognizer(swipeRight)*/
        
    }
    
    /*@objc func Swipe(sender: UISwipeGestureRecognizer) {

        print(sender.location(in: view))
        //print(sender.location(ofTouch: , in: view))
        print("Object has been swiped")

    }*/

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
    
    func SwipePerformed() -> Bool
    {
        
        let SwipeRequiredDist = CGFloat(20)
        let SwipeDist = Vector2.magnitude(v: Vector2(CGPoint: mTouchPointTwo) - Vector2(CGPoint: mTouchPointOne))
        
        if SwipeDist < SwipeRequiredDist
        {
            mTouchPointOne = CGPoint(x: -1000, y: -1000)
            mTouchPointTwo = CGPoint(x: -1000, y: -1000)
            
            return false
        }
        
        print("Firing Projectile")
        
        if mStoreMenu.mProjectileOneQuantity > 0 && mSelectedProjectile == 0 ||
            mStoreMenu.mProjectileTwoQuantity > 0 && mSelectedProjectile == 1 ||
            mStoreMenu.mProjectileThreeQuantity > 0 && mSelectedProjectile == 2
        {
            
            let LaunchDirection = Vector2.normalise(v: Vector2(CGPoint: mTouchPointTwo) - Vector2(CGPoint: mTouchPointOne))
            let projectileToLaunch = GetNextProjectile()
            projectileToLaunch.Spawn(at: mPlayer.GetPosition(), dir: LaunchDirection, with: mSelectedProjectile + 1, speed: 450)
            
            mTouchPointOne = CGPoint(x: -1000, y: -1000)
            mTouchPointTwo = CGPoint(x: -1000, y: -1000)
            
            return true
            
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
            let location = touch.location(in: self)
            //let touchedNode = atPoint(location)
            if mTouchPointOne == CGPoint(x: -1000, y: -1000)
            {
                mTouchPointOne = location
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches
        {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            if(!mGamePaused && !mStoreOpen && !mGameOptionsMenu)
            {
                mTouchPointTwo = location
                
                let SwipePerformedValue = SwipePerformed()
                
                if SwipePerformedValue { return }
            }
            
            //Menu Buttons
            if touchedNode.name == mPauseButtonName && !mStoreOpen
            {
                TogglePauseMenu()
                mSoundSystem.PlaySound(sound: "Button-0000")
            }
            else if touchedNode.name == mButtons[0] //Resume Game
            {
                TogglePauseMenu()
                mSoundSystem.PlaySound(sound: "Button-0000")
            }
            else if touchedNode.name == mButtons[1] //Options Menu
            {
                mOptionsMenu.ToggleOptionsMenu(to: true)
                TogglePauseMenuSpecifc(to: false)
                
                mPauseButton.SetButtonState(value: false)
                mStoreMenu.mStoreButton.SetButtonState(value: false)
                
                mSoundSystem.PlaySound(sound: "Button-0000")
            }
            else if touchedNode.name == mButtons[2] //Return to main menu
            {
                mSoundSystem.PlaySound(sound: "Button-0000")
                
                ResetGameScene()
                removeAllChildren()
                
                mMainMenuScene.scaleMode = .resizeFill
                view?.presentScene(mMainMenuScene, transition: .fade(withDuration: 0.5))
            }
            
            //Projectiles
            if touchedNode.name == "ProjectileButtonOne"
            {
                mSelectedProjectile = 0
            }
            else if touchedNode.name == "ProjectileButtonTwo"
            {
                mSelectedProjectile = 1
            }
            else if touchedNode.name == "ProjectileButtonThree"
            {
                mSelectedProjectile = 2
            }
            
            if !mGamePaused
            {
                let NodePressedName = String(touchedNode.name ?? "None")

                mStoreMenu.UpdateStoreMenu(pressed: NodePressedName)
            }

            if mGameOptionsMenu
            {
                let NodePressedName = String(touchedNode.name ?? "None")
                mOptionsMenu.UpdateOptionsMenu(pressed: NodePressedName)
            }
            
            //If player has chosen to use touch controls instead
            if defaults.bool(forKey: "AltToggleValue")
            {
                
            }
        }
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
        
        if(!mGamePaused && !mStoreOpen && !mGameOptionsMenu)
        {
            
            var playerRotVector = Vector2(x: 0, y: 0)
            var playerAccVector = Vector2(x: 0, y: 0)
            
            //If Device motion Controlls Are Enabled
            if !defaults.bool(forKey: "AltToggleValue")
            {
            
                if let gyroscope = mMotionManager.gyroData
                {
                    playerRotVector = Vector2(x: Float(gyroscope.rotationRate.x), y: Float(gyroscope.rotationRate.y))
                }
                
                if let accelerometer = mMotionManager.accelerometerData
                {
                    //physicsWorld.gravity = CGVector(dx: accelerometer.acceleration.y * -50, dy: accelerometer.acceleration.x*50)
                    playerAccVector = Vector2(x: Float(-accelerometer.acceleration.y), y: Float(accelerometer.acceleration.x))
                }
                
            }
            
            if mPlayer.GetAlive()
            {
                mPlayer.UpdateMovementDirection(rotation: playerRotVector, acceleration: playerAccVector)
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
            
            if mPoolSystem.GetNumberOfWhiteBloodCellsAlive() < 3
            {
                let WhiteBloodCell = mPoolSystem.GetNextAvailableWhiteBloodCell()
                WhiteBloodCell.SpawnWhiteBloodCell(size: CGSize(width: 100, height: 100), otherCells: mPoolSystem.GetWhiteBloodCells())
                WhiteBloodCell.SetSpeed(to: Float(Int.random(in: 60...100)))
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
            }
            
            for projectile in mPoolSystem.GetProjectileTwoPool()
            {
                if !projectile.GetAlive() { continue }
                
                projectile.Update()
                projectile.CheckCollisionWithWhiteBloodCells(cells: mPoolSystem.GetWhiteBloodCells())
            }
            
            for projectile in mPoolSystem.GetProjectileThreePool()
            {
                if !projectile.GetAlive() { continue }
                
                projectile.Update()
                projectile.CheckCollisionWithWhiteBloodCells(cells: mPoolSystem.GetWhiteBloodCells())
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
    
    func ResetGameScene()
    {
        mPoolSystem.ResetPools()
        
        TogglePauseMenuSpecifc(to: false)
        mStoreMenu.ToggleStoreMenu(to: false)
        
        mHealthBar.SetNumberBarValue(to: mHealthBar.mNumberBarMax)
        mEnergyBar.SetNumberBarValue(to: 0)
        
        mScore = 0
        
        mScoreLabel.text = "SCORE: 0"
    }
 
    func GetDeltaTime() -> Double
    {
        return self.mDeltaTime
    }
 
    func ShakeDevice()
    {
        if mPlayer.GetEnergy() >= mPlayer.GetMaxEnergy()
        {
            
            mPlayer.SetEnergy(to: CGFloat(0))
            
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
                    WhiteBloodCellInstance.DestroyWhiteBloodCell()
                }
            }
            
        }
        
    }
    
}
