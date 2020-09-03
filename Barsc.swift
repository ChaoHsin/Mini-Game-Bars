//
//  Barsc.swift
//  Bars
//
//  Created by Chao-Hsin Chien on 5/24/20.
//  Copyright © 2020 Chao-Hsin Chien. All rights reserved.
//

import SpriteKit
import GameplayKit
import Foundation

var game: GameManager!

public class linkedshape {
    var shape: SKShapeNode!
    var next: linkedshape?
    var droprate: Int!
}

public struct linkedshapelist {
    let head: linkedshape
    init(node: linkedshape) {
        self.head = node
    }
    func addshape(node: linkedshape) {
        var current: linkedshape = self.head
        while current.next != nil {
            current = current.next!
        }
        current.next = node
    }
    func gethead()->linkedshape{
        return head
    }
}

public class linkedbutton {
    var shape: SKShapeNode!
    var next: linkedbutton?
    var code: Int!
}

class Barsc: SKScene, SKPhysicsContactDelegate{
    var firstshape: linkedshape!
    var shapelist: linkedshapelist!
    var firstbutton: linkedbutton!
    var width: CGFloat!
    var numgap: Int!
    var barosition: Int!
    var leftbond: CGFloat!
    var intleft: Int!
    var timer = Timer()
    var ropetimer = Timer()
    var numofbar = UserDefaults.standard.integer(forKey: "numbar")
    var rope: SKShapeNode!
    var rope2: SKShapeNode!
    var gameoverl: SKLabelNode!
    var mainmenu: SKSpriteNode!
    var timem: Double = 0
    var timemer = Timer()
    var score: SKLabelNode!
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        initializedGame()
        game = GameManager()
        createbars(n: UserDefaults.standard.integer(forKey: "numbar"))
        timerfunc()
    }
    
    func timerfunc(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(dropping), userInfo: nil, repeats: true)
        ropetimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(ropedropping), userInfo: nil, repeats: true)
        timemer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerecord), userInfo: nil, repeats: true)
    }
    
    @objc private func timerecord(){
        timem = timem+0.1
    }
    
    @objc private func dropping(){
        var temp: linkedshape!
        temp = shapelist.gethead()
        while temp.shape != nil {
            temp.shape.run(SKAction.move(by: CGVector(dx:0, dy:temp.droprate), duration: 1))
            temp = temp.next
        }
    }
    
    @objc private func ropedropping(){
        var framebase: Int!
        framebase = Int(frame.size.height / 2)
        let randomgoal = Int.random(in: framebase-400...framebase-175)
        rope.run(SKAction.move(to: CGPoint(x:0, y:randomgoal), duration: 3))
        rope2.run(SKAction.move(to: CGPoint(x:0, y:randomgoal+250), duration: 3))
    }
    
    private func getbutton(s: String?) -> Int {
        var temp: linkedbutton!
        temp = firstbutton
        while temp.shape != nil {
            if(temp.shape.name == s) {
                //print(temp.shape.name!)
                return temp.code
            }
            temp = temp.next
        }
        return 0
    }
    
    private func getbar(n: Int) -> SKShapeNode{
        var temp: linkedshape!
        temp = shapelist.gethead()
        var i = 1
        while n>i {
            temp = temp.next
            i = i+1
        }
        print(temp.shape.name!)
        print("once")
        return temp.shape
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
       for touch in touches{
            let location = touch.location(in: self)
            let touchedNode = self.nodes(at: location)
            for node in touchedNode {
                let arr = node.name!.prefix(1)
                if arr=="b" {
                    getbar(n: getbutton(s: node.name)).run(SKAction.move(by: CGVector(dx:0, dy:70), duration: 0.75)) // 100 1
                }
                if node.name == "mainmenu" {
                    guard let scene = GameScene(fileNamed: "GameScene") else { return }
                    scene.scaleMode = .aspectFill
                    self.view?.presentScene(scene, transition: SKTransition.fade(withDuration:(0.5)))
                }
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.node?.name == "rope2" || contact.bodyB.node?.name == "rope2") {
            print("game_over")
            gameover()
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        if (contact.bodyA.node?.name == "rope" || contact.bodyB.node?.name == "rope") {
            print("game_over_2")
            gameover()
        }
    }
    
    private func gameover() {
        timer.invalidate()
        ropetimer.invalidate()
        timemer.invalidate()
        let x = Double(round(10*timem)/10)
        print(x)
        rope.name = "end"
        rope2.name = "end"
        rope.run(SKAction.scale(to: 0, duration: 0.3))
        //rope.physicsBody?.affectedByGravity = true
        //rope2.physicsBody?.affectedByGravity = true
        rope2.run(SKAction.scale(to: 0, duration: 0.3))
        var temp: linkedshape!
        temp = shapelist.gethead()
        var i = 0
        while UserDefaults.standard.integer(forKey: "numbar")>i {
            temp.shape.physicsBody?.affectedByGravity = true
            temp = temp.next
            i = i+1
        }
        var temp2: linkedbutton!
        temp2 = firstbutton
        i = 0
        while UserDefaults.standard.integer(forKey: "numbar")>i {
            temp2.shape.run(SKAction.scale(to: 0, duration: 0.3))
            temp2 = temp2.next
            i = i+1
        }
        gameoverl = SKLabelNode(fontNamed: "DINAlternate-Bold")
        gameoverl.zPosition = 1
        gameoverl.position = CGPoint(x:0, y:(frame.size.height/2) - 200)
        gameoverl.fontSize = 60
        gameoverl.text = "GAMEOVER"
        gameoverl.fontColor = SKColor.white
        score = SKLabelNode(fontNamed: "DINAlternate-Bold")
        score.zPosition = 1
        score.position = CGPoint(x:0, y:(frame.size.height/2) - 255)
        score.fontSize = 20
        let scored: Double = x*Double(UserDefaults.standard.integer(forKey: "numbar"))
        score.text = "Score: " + String(scored)
        if(UserDefaults.standard.double(forKey: "BestScore") < scored){
            UserDefaults.standard.set(scored, forKey: "BestScore")
        }
        score.fontColor = SKColor.white
        mainmenu = SKSpriteNode(imageNamed: "MAINMENU")
        mainmenu.name = "mainmenu"
        mainmenu.setScale(0.75)
        mainmenu.zPosition = 1
        mainmenu.position = CGPoint(x:400, y:(frame.size.height / 2)-400)
        mainmenu.run(SKAction.move(to: CGPoint(x:0, y:(frame.size.height / 2)-400), duration: 2.5))
        self.addChild(score)
        self.addChild(mainmenu)
        self.addChild(gameoverl)
    }
    
    private func initializedGame(){
        self.backgroundColor = #colorLiteral(red: 0.1475267163, green: 0.1475267163, blue: 0.1475267163, alpha: 1)
    }
    
    private func createbars(n: Int) {
        let lowerbondCat: UInt32 = 1 << 1
        let barcat: UInt32 = 1 << 2
        rope = SKShapeNode()
        rope = SKShapeNode(rectOf: CGSize(width:500, height: 5))
        rope.name = "rope"
        rope.position = CGPoint(x:(0), y:(Int(frame.size.height)/2) - 400)
        rope.fillColor = SKColor.yellow
        rope.zPosition = 1
        rope.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width:500, height: 5))
        rope.physicsBody?.affectedByGravity = false
        rope.physicsBody?.allowsRotation = false
        rope.physicsBody?.categoryBitMask = lowerbondCat
        rope.physicsBody?.collisionBitMask = 0
        rope.physicsBody?.contactTestBitMask = barcat
        rope2 = SKShapeNode()
        rope2 = SKShapeNode(rectOf: CGSize(width:500, height: 5))
        rope2.name = "rope2"
        rope2.position = CGPoint(x:(0), y:(Int(frame.size.height)/2) - 150)
        rope2.fillColor = SKColor.yellow
        rope2.zPosition = 1
        rope2.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width:500, height: 5))
        rope2.physicsBody?.affectedByGravity = false
        rope2.physicsBody?.allowsRotation = false
        rope2.physicsBody?.categoryBitMask = lowerbondCat
        rope2.physicsBody?.collisionBitMask = 0
        rope2.physicsBody?.contactTestBitMask = barcat
        self.addChild(rope2)
        self.addChild(rope)
        numgap = n+1
        width = (UIScreen.main.bounds.size.width-(CGFloat(numgap)*20))/(CGFloat(n))
        if(width>75){
            width = 75
        }
        let full: Int = Int(UIScreen.main.bounds.size.width)-Int(width)*n
        let gapsize: Int = full/numgap
        leftbond = UIScreen.main.bounds.size.width/2
        intleft = Int(leftbond)
        //barosition = Int(20+(width/2)) - intleft
        barosition = gapsize+Int(width/2) - intleft
        var shapetemp: linkedshape!
        var buttontemp: linkedbutton!
        buttontemp = linkedbutton()
        shapetemp = linkedshape()
        shapelist = linkedshapelist.init(node: shapetemp)
        firstbutton = buttontemp
        for i in 1...n {
            shapetemp.shape = SKShapeNode()
            shapetemp.shape = SKShapeNode(rectOf: CGSize(width:width, height: 800))
            shapetemp.shape.name = "Bar_" + String(i)
            shapetemp.shape.zPosition = 0
            shapetemp.shape.position = CGPoint(x:(barosition), y:(Int(frame.size.height)/2) - 650)
            shapetemp.shape.fillColor = SKColor.cyan
            shapetemp.shape.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width:width, height: 800))
            shapetemp.shape.physicsBody?.affectedByGravity = false
            shapetemp.shape.physicsBody?.allowsRotation = false
            shapetemp.shape.physicsBody?.categoryBitMask = barcat
            shapetemp.shape.physicsBody?.contactTestBitMask = lowerbondCat
            shapetemp.shape.physicsBody?.collisionBitMask = 0
            shapelist.addshape(node: linkedshape())
            shapetemp.droprate = (-45)-(Int.random(in: 0...3)*5)
            self.addChild(shapetemp.shape)
            shapetemp = shapetemp.next
            let overlimitso: Int = 666-(Int(width)/2)
            buttontemp.shape = SKShapeNode()
            buttontemp.shape = SKShapeNode(rectOf: CGSize(width:width, height: width))
            buttontemp.shape.name = "button_" + String(i)
            buttontemp.shape.zPosition = 1
            buttontemp.shape.position = CGPoint(x:(barosition), y:(Int(frame.size.height)/2) - overlimitso) //630
            buttontemp.shape.fillColor = SKColor.red
            buttontemp.next = linkedbutton()
            buttontemp.code = i
            self.addChild(buttontemp.shape)
            //barosition += Int(20+width)
            barosition += Int(width)+gapsize
            buttontemp = buttontemp.next
        }
    }
    
}
