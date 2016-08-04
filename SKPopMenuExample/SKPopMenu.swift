//
//  SKPopMenu.swift
//  SKPopMenuExample
//
//  Created by Stephen on 2016-07-28.
//  Copyright © 2016 Stephen Ceresia. All rights reserved.
//

import SpriteKit

@objc protocol SKPopMenuDelegate {
  optional func sectionTapped(index:Int, name:String)
  optional func popMenuDidDisappear() // called when the menu is completely dismissed
  optional func popMenuDidAppear() // called when the menu is completed revealed
}

class SKPopMenu: SKNode {
  
  var popMenuDelegate: SKPopMenuDelegate?
  var numberOfSections: Int!
  var sections: [SKShapeNode]!
  var sceneFrame: CGRect!
  let defaultColor = SKColor.cyanColor()
  var isShowing = false
  
  convenience init(numberOfSections:Int, sceneFrame:CGRect) {
    self.init()
    
    if numberOfSections <= 0 || numberOfSections > 6 {
      print("PopMenu Error: PopMenu supports up to 6 sections. Please initalize numberOfSections with a number between 1 and 6.")
      return
    }
    
    self.popMenuDelegate = SKPopMenuDelegate?()
    self.userInteractionEnabled = true
    self.numberOfSections = numberOfSections
    self.sceneFrame = sceneFrame
    self.sections = [SKShapeNode]()
    
    prepareMenu()
  }
  
  override init() {
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func prepareMenu() {
    
    for i in 0..<self.numberOfSections {
      
      var node = SKShapeNode(rectOfSize: CGSize(width: sceneFrame.size.width/2, height: sceneFrame.size.height/4))
      
      // SET X POSITION
      if i % 2 == 0 {
        // current section is even index; left side
        node.position.x = CGRectGetMinX(sceneFrame) + node.frame.size.width/2
        node.fillColor = defaultColor
        
        // check if it's the last item. if so, resize it to full width
        if i+1 == self.numberOfSections {
          node = SKShapeNode(rectOfSize: CGSize(width: sceneFrame.size.width, height: sceneFrame.size.height/4))
          node.position.x = CGRectGetMinX(sceneFrame) + node.frame.size.width/2
          node.fillColor = defaultColor
        }
        
      } else {
        // current section is odd index; right side
        node.position.x = CGRectGetMidX(sceneFrame) + node.frame.size.width/2
        node.fillColor = defaultColor
      }
      
      // SET Y POSITION
      let amount = CGFloat(getRowForIndex(i)) + 0.5
      let distance = node.frame.size.height*(amount)
      node.position.y = distance
      
      node.lineWidth = CGFloat(0)
      node.name = "section " + "\(i)"
      
      // add default label
      let label = SKLabelNode()
      label.text = String(i)
      label.fontColor = SKColor.whiteColor()
      label.position.y = label.position.y - label.frame.size.height/2
      node.addChild(label)
      
      // add the node
      sections.append(node)
      self.addChild(node)
      
      slideDown(0)
    }
    
    
  }
  
  func setSectionName(section:Int, text:String) {
    let node = sections[section-1]
    node.name = text
  }
  
  func setColor(color:SKColor) {
    for node in sections {
      node.fillColor = color
    }
  }
  
  func setSectionColor(section:Int, color:SKColor) {
    let node = sections[section-1]
    node.fillColor = color
  }
  
  func setSectionLabel(section:Int, label:SKLabelNode) {
    let node = sections[section-1]
    node.removeAllChildren()
    node.addChild(label)
    label.position.y = label.position.y - label.frame.size.height/2
  }
  
  func setSectionSprite(section:Int, sprite:SKSpriteNode) {
    let node = sections[section-1]
    node.removeAllChildren()
    node.addChild(sprite)
  }
  
  func slideDown(duration:NSTimeInterval) {
    isShowing = false
    
    for i in 0..<sections.count {
      let node = sections[i]
      let amount = CGFloat(getRowForIndex(i)) + 0.5
      let distance = -node.frame.size.height*(amount)
      let moveAction = (SKAction.moveTo(CGPointMake(node.position.x, distance), duration: duration))
      
      
      if i != 0 {
        node.runAction(moveAction)
      } else {
        // it's the first item; when it reaches the bottom, we call the delegate
        let block = SKAction.runBlock({ 
          self.popMenuDelegate?.popMenuDidDisappear!()
        })
        node.runAction(SKAction.sequence([moveAction, block]))
      }
      
    }
  }
  
  func slideUp(duration:NSTimeInterval) {
    isShowing = true
    
    for i in 0..<sections.count {
      let node = sections[i]
      let amount = CGFloat(getRowForIndex(i)) + 0.5
      let distance = node.frame.size.height*(amount)
      let moveAction = (SKAction.moveTo(CGPointMake(node.position.x, distance), duration: duration))

      if i != sections.count-1 {
        node.runAction(moveAction)
      } else {
        // it's the last item; when it reaches the top, we call the delegate
        let block = SKAction.runBlock({
          self.popMenuDelegate?.popMenuDidAppear!()
        })
        node.runAction(SKAction.sequence([moveAction, block]))
      }
      
    }
  }
  
  private func getRowForIndex(index:Int) -> Int {
    if index < 2 {
     return 0
    } else if index == 2 || index == 3 && index/2 == 1 {
      return 1
    } else if index == 4 || index == 5 && index/2 == 2 {
      return 2
    }
    
    print("PopMenu Error: Unable to determine row.")
    return 0 // FAIL
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    for touch in touches {
      for node in sections {
        if node.containsPoint(touch.locationInNode(self)) {
          self.popMenuDelegate?.sectionTapped!(sections.indexOf(node)!, name: node.name!)
        }
      }
    }
  }
  
  
}
