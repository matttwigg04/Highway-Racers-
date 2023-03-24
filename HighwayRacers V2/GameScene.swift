//
//  GameScene.swift
//  HighwayRacers V2
//
//  Created by Matthew Twigg on 6/2/21.
//  Copyright © 2021 Matthew Twigg. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var userCar = SKSpriteNode()
    
    var canMove = false
    var userCarUp = true
    var userCarDown = false
    
    let userCarMinY : CGFloat = -100
    let userCarMaxY : CGFloat = 100
    
    var scoreText = SKLabelNode()
    var score = 0
    
    var gameEnded = false
    
   
    
    
    
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        setUp()
        Timer.scheduledTimer(timeInterval: TimeInterval(0.1), target: self, selector: #selector(GameScene.HighwayLanes), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: TimeInterval(Helper().randomBetweenTwoNumbers(firstNumber: 0, secondNumber: 1.8)), target: self, selector: #selector(GameScene.Traffic), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: TimeInterval(2), target: self, selector: #selector(GameScene.removeOut), userInfo: nil, repeats: true)
        let deadTime = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: deadTime){
            Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(GameScene.increaseScore), userInfo: nil, repeats: true)
        }
        
    }
    
    
  
    
    
    func setUp(){
        userCar = self.childNode(withName: "userCar") as! SKSpriteNode
        userCar.physicsBody?.categoryBitMask = ColliderType.CAR_COLLIDER
        userCar.physicsBody?.contactTestBitMask = ColliderType.ITEM_COLLIDER
        userCar.physicsBody?.collisionBitMask = 0
        userCar.physicsBody?.isDynamic = true
        
        scoreText.name = "score"
        scoreText.fontName = "AvenirNext-Bold"
        scoreText.text = "0"
        scoreText.fontColor = SKColor.black
        scoreText.position = CGPoint(x:-self.size.width/2 + 160, y:self.size.height/2 - 110)
        scoreText.fontSize = 50
        scoreText.zPosition = 4
        addChild(scoreText)
    
        
    }
    
        
    override func update(_ currentTime: TimeInterval) {
        if canMove == true {
            move(up:userCarUp)
        }
        highwayLanesMove()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        if contact.bodyA.node?.name == "userCar"{
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
            
        }
        firstBody.node?.removeFromParent()
        gameEnded = true
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        if userCarDown{
            userCarDown = false
            userCarUp = true
                    
        }else{
            userCarDown = true
            userCarUp = false
        }
        canMove = true
    }
    
    
   
    
    @objc func HighwayLanes(){
        let highwayLane = SKShapeNode(rectOf: CGSize(width: 40, height: 10))
        highwayLane.strokeColor = SKColor.white
        highwayLane.fillColor = SKColor.white
        highwayLane.alpha = 0.4
        highwayLane.name = "highwayLane"
        highwayLane.zPosition = 0
        highwayLane.position.x = 325
        highwayLane.position.y = 0
        addChild(highwayLane)
        
        
        
    }
    
    func highwayLanesMove(){
        enumerateChildNodes(withName: "highwayLane", using: { (highwayLanes, stop) in
            let lane = highwayLanes as! SKShapeNode
            lane.position.x -= 30
        })
        
        enumerateChildNodes(withName: "minivanF", using: { (userCar, stop) in
            let car = userCar as! SKSpriteNode
            car.position.x -= 10
        })
        
        
    }
    
    
    func move(up:Bool){
        if up{
            userCar.position.y -= 200
            if userCar.position.y < userCarMinY{
                userCar.position.y = userCarMinY
            }
            
        }else{
            userCar.position.y += 200
            if userCar.position.y > userCarMaxY{
                userCar.position.y = userCarMaxY
            }
        }
        
    }
    
    @objc func removeOut(){
        for child in children{
            if child.position.x < -self.size.width - 105{
                child.removeFromParent()
            }
        }
    }
    
    @objc func Traffic(){
        let trafficItem : SKSpriteNode!
        let randomNumber = Helper().randomBetweenTwoNumbers(firstNumber: 1, secondNumber: 2)
        switch Int(randomNumber){
        case 1...4:
            trafficItem = SKSpriteNode(imageNamed: "minivanF")
            trafficItem.name = "minivanF"
            break
        case 5...8:
            trafficItem = SKSpriteNode(imageNamed: "minivanF")
            trafficItem.name = "minivanF"
            break
        default:
            trafficItem = SKSpriteNode(imageNamed: "minivanF")
            trafficItem.name = "minivanF"
        }
        trafficItem.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        trafficItem.zPosition = 10
        let randomNum = Helper().randomBetweenTwoNumbers(firstNumber: 1, secondNumber: 10)
        switch Int(randomNum){
        case 1...4:
            trafficItem.position.x = 240
            trafficItem.position.y = 100
            break
        case 5...10:
            trafficItem.position.x = 240
            trafficItem.position.y = -100
            break
        default:
            trafficItem.position.x = 200
            trafficItem.position.y = -100
            
            
        }
        trafficItem.physicsBody = SKPhysicsBody(circleOfRadius: trafficItem.size.height/2)
        trafficItem.physicsBody?.categoryBitMask = ColliderType.ITEM_COLLIDER
        trafficItem.physicsBody?.collisionBitMask = 0
        trafficItem.physicsBody?.affectedByGravity = false
        trafficItem.physicsBody?.isDynamic = true
       
        addChild(trafficItem)
    }
    
    @objc func increaseScore(){
        if gameEnded == false{
            score += 1
            scoreText.text = String(score)
        }
    }
    
}


