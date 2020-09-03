//
//  Custom.swift
//  Bars
//
//  Created by Chao-Hsin Chien on 5/24/20.
//  Copyright © 2020 Chao-Hsin Chien. All rights reserved.
//

import SpriteKit
import GameplayKit

var game2: GameManager!

class Custom: SKScene, UITextFieldDelegate{
    var asknum: SKSpriteNode!
    var stepsTextField: UITextField!
    var text: Int!
    var tri1: SKSpriteNode!
    var tri2: SKSpriteNode!
    var go: SKSpriteNode!
    var num: SKLabelNode!
    var numbarlocal: Int = 4
    
    override func didMove(to view: SKView) {
        initializedGame()
        game2 = GameManager()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        /*if(numbarlocal>9){
            tri1.isHidden = true
        } else if(numbarlocal<1){
            tri2.isHidden = true
        } else {
            tri1.isHidden = false
            tri2.isHidden = false
        } */
        for touch in touches{
            let location = touch.location(in: self)
            let touchedNode = self.nodes(at: location)
            for node in touchedNode {
                if node.name == "tri1" {
                  numbarlocal+=1
                  num.text = String(numbarlocal);
                    if(numbarlocal >= 10){
                        tri1.isHidden = true
                    }
                    if(numbarlocal > 1){
                        tri2.isHidden = false
                    }
                }
                if node.name == "tri2"{
                    numbarlocal-=1
                    num.text = String(numbarlocal);
                    if(numbarlocal <= 1){
                        tri2.isHidden = true
                    }
                    if(numbarlocal <= 10){
                        tri1.isHidden = false
                    }
                }
                if node.name == "GO"{
                    UserDefaults.standard.set(numbarlocal, forKey: "numbar")
                    guard let scene = Barsc(fileNamed: "Barsc") else { return }
                    self.view?.presentScene(scene, transition: SKTransition.fade(withDuration:(0.5)))
                }
            }
        }
    }
    private func initializedGame(){
        print("customin")
        self.backgroundColor = #colorLiteral(red: 0.1475267163, green: 0.1475267163, blue: 0.1475267163, alpha: 1)
        asknum = SKSpriteNode(imageNamed: "ASKNUMBAR")
        asknum.zPosition = 1
        asknum.name = "asknum"
        asknum.setScale(0.5)
        asknum.position = CGPoint(x:0, y:(frame.size.height / 2)-200)
        self.addChild(asknum)
        tri1 = SKSpriteNode(imageNamed: "Triangle")
        tri1.zPosition = 1
        tri1.name = "tri1"
        tri1.position = CGPoint(x:50, y:(frame.size.height / 2)-300)
        tri1.setScale(0.05)
        tri1.zRotation = 0.5
        self.addChild(tri1)
        tri2 = SKSpriteNode(imageNamed: "Triangle")
        tri2.zPosition = 1
        tri2.name = "tri2"
        tri2.position = CGPoint(x:-50, y:(frame.size.height / 2)-300)
        tri2.setScale(0.05)
        tri2.zRotation = -0.5
        self.addChild(tri2)
        num = SKLabelNode(fontNamed: "DINAlternate-Bold")
        num.zPosition = 1
        num.position = CGPoint(x:0, y:(frame.size.height/2) - 325)
        num.fontSize = 70
        num.text = String(numbarlocal);
        num.fontColor = SKColor.white
        self.addChild(num)
        go = SKSpriteNode(imageNamed: "GO")
        go.zPosition = 1
        go.name = "GO"
        go.setScale(0.5)
        go.position = CGPoint(x:0, y:(frame.size.height / 2)-450)
        self.addChild(go)
        /* Could not "enter" the number in real device. Sealed
        stepsTextField = UITextField(frame: CGRect(x: 50, y: 300
            , width: 300, height: 40))
        stepsTextField.placeholder = "Number of bars"
        stepsTextField.font = UIFont.systemFont(ofSize: 15)
        stepsTextField.borderStyle = UITextField.BorderStyle.roundedRect
        stepsTextField.autocorrectionType = UITextAutocorrectionType.no
        stepsTextField.keyboardType = .numberPad
        stepsTextField.clearButtonMode = UITextField.ViewMode.whileEditing;
        stepsTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        self.view?.addSubview(stepsTextField)
        stepsTextField.delegate = self
        */
    }
    /* The textfield didn't work. Sealed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if stepsTextField.text == nil {
            return true
        }
        UserDefaults.standard.set(Int(stepsTextField.text!)!, forKey: "numbar")
        stepsTextField.isHidden = true
        guard let scene = Barsc(fileNamed: "Barsc") else { return true}
        self.view?.presentScene(scene, transition: SKTransition.fade(withDuration:(0.5)))
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }
    */
    
}
