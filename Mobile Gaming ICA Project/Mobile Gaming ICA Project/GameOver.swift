//
//  GameOver.swift
//  Mobile Gaming ICA Project
//
//  Created by Tom on 10/12/2020.
//  Copyright © 2020 Tom. All rights reserved.
//

//
//  MainMenu.swift
//  Mobile Gaming ICA - VirusGame
//
//  Created by LAYCOCK, TOM (Student) on 29/11/2020.
//  Copyright © 2020 LAYCOCK, TOM (Student). All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation
import CoreMotion

class GameOver: SKScene {
    
    var mMainMenu : MainMenu!
    var mGameScene : GameScene!
    
    //Detla Time Calculation
    var mDeltaTime = Double(0)
    var mPrevTime = Double(0)
    
    //Game Over Titles
    let mVictoryTitle = SKSpriteNode(imageNamed: "Assets/MenuTextures/VictoryTitle-TB")
    let mDefeatTitle = SKSpriteNode(imageNamed: "Assets/MenuTextures/DefeatTitle-TB")

    let mFinalScore = SKLabelNode(fontNamed: "HelveticaNeue-Thin")
    
    let mPlayAgainButton = Button(imageNamed: "Assets/MenuButtons/PlayButton-TB")
    let mReturnToMenuButton = Button(imageNamed: "Assets/MenuButtons/ExitButton-TB")
    
    //Systems
    let mSoundSystem = CustomSoundSystem()
    
    //Scene Defaults
    var mSceneLoadingComplete = false
    var mGameWon = false
    var mFinalScoreValue = 0
    
    //User Save Options
    let defaults = UserDefaults.standard
    
    override func didMove(to view: SKView) {

        //Initialising One Time Defaults for Scene
        if !mSceneLoadingComplete
        {
            mSoundSystem.SetupCustomSoundSystem()
        }

        //Initialising Scene Graphics
        mVictoryTitle.name = "VictoryTitle"
        mVictoryTitle.size = CGSize(width: frame.midX, height: frame.midX / 3)
        mVictoryTitle.position = CGPoint(x: frame.midX, y: frame.maxY - mVictoryTitle.frame.height / 1.5)
        mVictoryTitle.zPosition = 59
        mVictoryTitle.isHidden = false
        addChild(mVictoryTitle)
        
        mDefeatTitle.name = "DefeatTitle"
        mDefeatTitle.size = CGSize(width: frame.midX, height: frame.midX / 3)
        mDefeatTitle.position = CGPoint(x: frame.midX, y: frame.maxY - mDefeatTitle.frame.height / 1.5)
        mDefeatTitle.zPosition = 59
        mDefeatTitle.isHidden = false
        addChild(mDefeatTitle)
        
        mFinalScore.fontSize = 50
        mFinalScore.position = CGPoint(x: frame.midX, y: frame.midY)
        mFinalScore.zPosition = 59
        mFinalScore.horizontalAlignmentMode = .center
        mFinalScore.isUserInteractionEnabled = false
        mFinalScore.text = "FINAL SCORE: " + String(mFinalScoreValue)
        addChild(mFinalScore)
        
        let ButtonSize = frame.maxX / 6
        mPlayAgainButton.position = CGPoint(x: frame.midX - ButtonSize * 1.5, y: frame.midY - ButtonSize * 1.2)
        mPlayAgainButton.zPosition = 90
        mPlayAgainButton.size = CGSize(width: ButtonSize, height: ButtonSize)
        mPlayAgainButton.name = "Play Again"
        mPlayAgainButton.SetButtonPosition(to: mPlayAgainButton.position)
        addChild(mPlayAgainButton)

        mReturnToMenuButton.position = CGPoint(x: frame.midX + ButtonSize * 1.5, y: frame.midY - ButtonSize * 1.2)
        mReturnToMenuButton.zPosition = 90
        mReturnToMenuButton.size = CGSize(width: ButtonSize, height: ButtonSize)
        mReturnToMenuButton.name = "Return To Main Menu"
        mReturnToMenuButton.SetButtonPosition(to: mReturnToMenuButton.position)
        addChild(mReturnToMenuButton)

        if mGameWon
        {
            mVictoryTitle.isHidden = false
            mDefeatTitle.isHidden = true
        }
        else
        {
            mDefeatTitle.isHidden = false
            mVictoryTitle.isHidden = true
        }
        
        //One Time Scene Loading Complete
        mSceneLoadingComplete = true
    }
    
    func ResetGameOverScreen()
    {
        mVictoryTitle.isHidden = true
        mDefeatTitle.isHidden = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches
        {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            if touchedNode.name == "Play Again"
            {
                mSoundSystem.PlaySound(sound: "Button Zero", scene: self)
                removeAllChildren()
                
                ResetGameOverScreen()
                
                mGameScene.scaleMode = .resizeFill
                view?.presentScene(mGameScene, transition: .fade(withDuration: 0.5))
            }
            else if touchedNode.name == "Return To Main Menu"
            {
                mSoundSystem.PlaySound(sound: "Button Zero", scene: self)
                removeAllChildren()
                
                ResetGameOverScreen()
                
                mMainMenu.scaleMode = .resizeFill
                view?.presentScene(mMainMenu, transition: .fade(withDuration: 0.5))
            }
        }
    }
    
    func ToggleGameOverScreenWin(value Value: Bool, score FinalScore: Int)
    {
        mFinalScoreValue = FinalScore
        mGameWon = Value
        print(FinalScore)
    }
    
    override func update(_ currentTime: TimeInterval) {
     
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
        
    }
    
    func GetDeltaTime() -> Double
    {
        return self.mDeltaTime
    }
    
}
