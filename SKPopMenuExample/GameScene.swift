//
//  GameScene.swift
//  SKPopMenuExample
//
//  Created by Stephen on 2016-07-30.
//  Copyright (c) 2016 Stephen Ceresia. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPopMenuDelegate {
  
  var pop: SKPopMenu!
  
  override func didMove(to view: SKView) {
    self.backgroundColor = SKColor.black
    displayPopMenu()
    
    let button = SKLabelNode()
    button.text = "show/hide menu"
    button.position = CGPoint(x: self.frame.midX, y:self.frame.maxY - button.frame.size.height*2)
    button.name = "tapMe"
    self.addChild(button)
    
  }
  
  func displayPopMenu() {
    
    pop = SKPopMenu(numberOfSections:5, sceneFrame: self.frame)
    pop.setSectionColor(1, color: SKColor.red)
    pop.setSectionColor(2, color: SKColor.magenta)
    pop.setSectionColor(3, color: SKColor.purple)
    pop.setSectionColor(4, color: SKColor.blue)
    pop.setSectionColor(5, color: SKColor.darkGray)
    pop.popMenuDelegate = self
    self.addChild(pop)
    
    //pop.setSectionSprite(4, sprite: SKSpriteNode(imageNamed: "img.png"))
    //pop.setSectionSprite(5, sprite: SKSpriteNode(imageNamed: "img.png"))

  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    for touch in touches {
      let location = touch.location(in: self)
      
      let nodes = self.nodes(at: location)
      
      for node in nodes {
        if let nodeName = node.name {
          if nodeName == "tapMe" {
            if pop.isShowing {
              pop.slideDown(0.2)
            } else {
              pop.slideUp(0.2)
            }
            
          }
        }
      }
    }
  }
  
  override func update(_ currentTime: TimeInterval) {
    /* Called before each frame is rendered */
  }
  
  // Delegate
  func sectionTapped(_ index:Int, name:String) {
    print("tapped: index " + "\(index)" + " " + name)
    if pop.sections[index].name == "email" {
      // email button tapped
    }
  }
  
  func popMenuDidDisappear() {
    print("did disappear")
  }
  
  func popMenuDidAppear() {
    print("did appear")
  }
  
}

