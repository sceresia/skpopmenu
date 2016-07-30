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
  
  override func didMoveToView(view: SKView) {
    self.backgroundColor = SKColor.blackColor()
    displayPopMenu()
    
    let button = SKLabelNode()
    button.text = "show/hide menu"
    button.position = CGPoint(x: CGRectGetMidX(self.frame), y:CGRectGetMaxY(self.frame) - button.frame.size.height*2)
    button.name = "tapMe"
    self.addChild(button)
    
  }
  
  func displayPopMenu() {
    
    pop = SKPopMenu(numberOfSections:5, sceneFrame: self.frame)
    pop.setSectionColor(1, color: SKColor.redColor())
    pop.setSectionColor(2, color: SKColor.magentaColor())
    pop.setSectionColor(3, color: SKColor.purpleColor())
    pop.setSectionColor(4, color: SKColor.blueColor())
    pop.setSectionColor(5, color: SKColor.darkGrayColor())
    pop.popMenuDelegate = self
    self.addChild(pop)
    
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    
    for touch in touches {
      let location = touch.locationInNode(self)
      
      let nodes = self.nodesAtPoint(location)
      
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
  
  override func update(currentTime: CFTimeInterval) {
    /* Called before each frame is rendered */
  }
  
  // Delegate
  func sectionTapped(index:Int, name:String) {
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

