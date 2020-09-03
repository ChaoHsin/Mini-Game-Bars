//
//  GameScene.swift
//  Bars
//
//  Created by Chao-Hsin Chien on 5/24/20.
//  Copyright © 2020 Chao-Hsin Chien. All rights reserved.
//

//
//  GameScene.swift
//  Bars
//
//  Created by Chao-Hsin Chien on 5/23/20.
//  Copyright © 2020 Chao-Hsin Chien. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var start: SKSpriteNode!
    var record: SKLabelNode!
    var gamelogo: SKLabelNode!
    var bars1: SKShapeNode! //I don't have a graph editor with me or I can use SKSpriteNodes
    var bars2: SKShapeNode!
    var bars3: SKShapeNode!
    var game: GameManager!
    var Easy: SKSpriteNode!
    var Adapt: SKSpriteNode!
    var Hard: SKSpriteNode!
    var Customb: SKSpriteNode!
    var returntm: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        initializedMenu()
        game = GameManager()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            let touchedNode = self.nodes(at: location)
            for node in touchedNode {
                if node.name == "start" {
                    selectdiff()
                }
                if node.name == "record" {
                    selectdiff()
                }
                if node.name == "Easy" {
                    togame(diff:3)
                }
                if node.name == "Hard" {
                    togame(diff:8)
                }
                if node.name == "Adapt" {
                    togame(diff:5)
                }
                if node.name == "Custom" {
                    togame(diff:0)
                }
                if node.name == "returntm" {
                    lastpage()
                }
            }
        }
    }
    
    private func togame(diff: intmax_t){
        guard let scene = Barsc(fileNamed: "Barsc") else { return }
        guard let customscene = Custom(fileNamed: "Custom") else {return}
        print("in_game")
        if diff == 0 {
            self.view?.presentScene(customscene, transition: SKTransition.fade(withDuration:(0.5)))
        } else {
            UserDefaults.standard.set(diff, forKey: "numbar")
            self.view?.presentScene(scene, transition: SKTransition.fade(withDuration:(0.5)))
        }
    }
    
    private func lastpage() {
        Easy.run(SKAction.scale(to: 0, duration: 0.3)){
            self.Easy.isHidden = true
        }
        Adapt.run(SKAction.scale(to: 0, duration: 0.3)){
            self.Adapt.isHidden = true
        }
        Hard.run(SKAction.scale(to: 0, duration: 0.3)){
            self.Hard.isHidden = true
        }
        Customb.run(SKAction.scale(to: 0, duration: 0.3)){
            self.Customb.isHidden = true
        }
        returntm.run(SKAction.scale(to: 0, duration: 0.3)){
            self.returntm.isHidden = true
        }
        start.isHidden = false
        record.isHidden = false
        gamelogo.isHidden = false
        bars1.isHidden = false
        bars2.isHidden = false
        bars3.isHidden = false
        start.run(SKAction.move(to: CGPoint(x:0, y:(frame.size.height / 2)-1000), duration: 0.5))
        record.run(SKAction.move(to: CGPoint(x:0, y:(frame.size.height / 2)-650), duration: 0.5))
        gamelogo.run(SKAction.move(to: CGPoint(x:0, y:(frame.size.height/2) - 200), duration: 0.5))
        bars1.run(SKAction.scale(to: 1, duration: 0.3))
        bars2.run(SKAction.scale(to: 1, duration: 0.3))
        bars3.run(SKAction.scale(to: 1, duration: 0.3))
    }
    
    private func selectdiff(){
        print("please select")
        start.run(SKAction.move(by: CGVector(dx:750, dy:0), duration: 0.75)){
            self.start.isHidden = true
        }
        record.run(SKAction.move(by: CGVector(dx:-750, dy:0), duration: 0.75)){
            self.record.isHidden = true
        }
        gamelogo.run(SKAction.move(by: CGVector(dx:-750, dy:0), duration: 0.75)){
            self.gamelogo.isHidden = true
        }
        bars1.run(SKAction.scale(to: 0, duration: 0.3)){
            self.bars1.isHidden = true
        }
        bars2.run(SKAction.scale(to: 0, duration: 0.3)){
            self.bars2.isHidden = true
        }
        bars3.run(SKAction.scale(to: 0, duration: 0.3)){
            self.bars3.isHidden = true
        }
        selectdiffnext()
    }
    
    private func selectdiffnext(){
        self.Easy.isHidden = false
        Easy.run(SKAction.scale(to: 1, duration: 0.3))
        self.Hard.isHidden = false
        Hard.run(SKAction.scale(to: 1, duration: 0.3))
        self.Adapt.isHidden = false
        Adapt.run(SKAction.scale(to: 1.2, duration: 0.3))
        self.Customb.isHidden = false
        Customb.run(SKAction.scale(to: 1, duration: 0.3))
        self.returntm.isHidden = false
        returntm.run(SKAction.scale(to:1, duration: 0.3))
    }
    
    private func initializedMenu() {
        start = SKSpriteNode(imageNamed: "START")
        start.zPosition = 1
        start.name = "start"
        start.position = CGPoint(x:0, y:(frame.size.height / 2)-1000)
        start.setScale(1.5)
        self.addChild(start)
        record = SKLabelNode(fontNamed: "DINAlternate-Bold")
        record.zPosition = 1
        record.fontSize = 45
        record.name = "record"
        record.text = "Best Score: " + String(UserDefaults.standard.double(forKey: "BestScore"))
        record.position = CGPoint(x:0, y:(frame.size.height / 2)-650)
        self.addChild(record)
        gamelogo = SKLabelNode(fontNamed: "DINAlternate-Bold")
        gamelogo.zPosition = 1
        gamelogo.position = CGPoint(x:0, y:(frame.size.height/2) - 200)
        gamelogo.fontSize = 100
        gamelogo.text = "BAR"
        gamelogo.fontColor = SKColor.white
        self.addChild(gamelogo)
        bars1 = SKShapeNode(rectOf: CGSize(width:75, height: 200))
        bars1.name = "bars1"
        bars1.zPosition = 1
        bars1.position = CGPoint(x:0, y:(frame.size.height/2) - 500)
        bars1.fillColor = SKColor.cyan
        self.addChild(bars1)
        bars2 = SKShapeNode(rectOf: CGSize(width:75, height: 170))
        bars2.name = "bars2"
        bars2.zPosition = 1
        bars2.position = CGPoint(x:-100, y:(frame.size.height/2) - 515)
        bars2.fillColor = SKColor.cyan
        self.addChild(bars2)
        bars3 = SKShapeNode(rectOf: CGSize(width:75, height: 170))
        bars3.name = "bars3"
        bars3.zPosition = 1
        bars3.position = CGPoint(x:100, y:(frame.size.height/2) - 515)
        bars3.fillColor = SKColor.cyan
        self.addChild(bars3)
        Easy = SKSpriteNode(imageNamed: "EASY")
        Easy.name = "Easy"
        Easy.zPosition = 1
        Easy.setScale(0)
        Easy.position = CGPoint(x:0, y:(frame.size.height / 2)-500)
        Easy.isHidden = true
        self.addChild(Easy)
        Adapt = SKSpriteNode(imageNamed: "ADAPT")
        Adapt.zPosition = 1
        Adapt.name = "Adapt"
        Adapt.setScale(0)
        Adapt.position = CGPoint(x:0, y:(frame.size.height / 2)-600)
        Adapt.isHidden = true
        self.addChild(Adapt)
        Hard = SKSpriteNode(imageNamed: "HARD")
        Hard.zPosition = 1
        Hard.name = "Hard"
        Hard.setScale(0)
        Hard.position = CGPoint(x:0, y:(frame.size.height / 2)-700)
        Hard.isHidden = true
        self.addChild(Hard)
        Customb = SKSpriteNode(imageNamed: "CUSTOM")
        Customb.zPosition = 1
        Customb.setScale(0)
        Customb.name = "Custom"
        Customb.position = CGPoint(x:0, y:(frame.size.height / 2)-800)
        Customb.isHidden = true
        self.addChild(Customb)
        returntm = SKSpriteNode(imageNamed: "RETURNTM")
        returntm.zPosition = 1
        returntm.setScale(0)
        returntm.name = "returntm"
        returntm.position = CGPoint(x: -320, y:(frame.size.height/2)-50)
        returntm.isHidden = true
        self.addChild(returntm)
    }
}
