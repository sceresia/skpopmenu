//
//  SKPopMenu.swift
//  SKPopMenuExample
//
//  Created by Stephen on 2016-07-28.
//  Copyright © 2016 Stephen Ceresia. All rights reserved.
//

import SpriteKit

@objc protocol SKPopMenuDelegate {
  @objc optional func sectionTapped(_ index:Int, name:String)
  @objc optional func popMenuDidDisappear() // called when the menu is completely dismissed
  @objc optional func popMenuDidAppear() // called when the menu is completed revealed
}

class SKPopMenu: SKNode, SKPopMenuDelegate {
  
  var popMenuDelegate: SKPopMenuDelegate?
  var numberOfSections: Int!
  var sections: [SKSpriteNode]!
  var sceneFrame: CGRect!
  let defaultColor = SKColor.cyan
  var isShowing = false
  
  convenience init(numberOfSections:Int, sceneFrame:CGRect) {
    self.init()
    
    if numberOfSections <= 0 || numberOfSections > 6 {
      print("PopMenu Error: PopMenu supports up to 6 sections. Please initalize numberOfSections with a number between 1 and 6.")
      return
    }
    
    self.popMenuDelegate = SKPopMenuDelegate?(self)
    self.isUserInteractionEnabled = true
    self.numberOfSections = numberOfSections
    self.sceneFrame = sceneFrame
    self.sections = [SKSpriteNode]()
    
    prepareMenu()
  }
  
  override init() {
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  fileprivate func prepareMenu() {
    
    for i in 0..<self.numberOfSections {
      
      let node = SKSpriteNode(color: defaultColor, size: CGSize(width: sceneFrame.size.width, height: sceneFrame.size.height/4))
      
      // SET X POSITION
      if i % 2 == 0 {
        // current section is even index; left side
        node.position.x = sceneFrame.minX + node.frame.size.width/2
        
        // check if it's the last item. if so, resize it to full width
        if i+1 == self.numberOfSections {
          node.size = CGSize(width: sceneFrame.size.width, height: sceneFrame.size.height/4)
          node.position.x = sceneFrame.minX + node.frame.size.width/2
        }
        
      } else {
        // current section is odd index; right side
        node.position.x = sceneFrame.midX + node.frame.size.width/2
      }
      
      // SET Y POSITION
      let amount = CGFloat(getRowForIndex(i)) + 0.5
      let distance = node.frame.size.height*(amount)
      node.position.y = distance
      node.name = "section " + "\(i)"
      
      // add default label
      let label = SKLabelNode()
      label.text = String(i)
      label.fontColor = SKColor.white
      label.horizontalAlignmentMode = .center
      label.verticalAlignmentMode = .center
      
      // re-center label for half-sized node; check if not a wide node
      if !((i % 2 == 0) && (i+1 == self.numberOfSections)) {
        label.position.x = label.position.x - node.frame.size.width/4
      }
      
      node.addChild(label)
      
      // add the node
      sections.append(node)
      self.addChild(node)
      
      slideDown(0)
    }
    
    
  }
  
  func setSectionName(_ section:Int, text:String) {
    let node = sections[section-1]
    node.name = text
  }
  
  func setColor(_ color:SKColor) {
    for node in sections {
      node.color = color
    }
  }
  
  func setSectionColor(_ section:Int, color:SKColor) {
    let node = sections[section-1]
    node.color = color
  }
  
  func setSectionLabel(_ section:Int, label:SKLabelNode) {
    let node = sections[section-1]
    node.removeAllChildren()
    label.horizontalAlignmentMode = .center
    label.verticalAlignmentMode = .center
    
    let i = section-1
    if !((i % 2 == 0) && (i+1 == self.numberOfSections)) {
      label.position.x = label.position.x - node.frame.size.width/4
    }
    
    node.addChild(label)
  }
  
  func setSectionSprite(_ section:Int, sprite:SKSpriteNode) {
    let node = sections[section-1]
    node.removeAllChildren()
    node.addChild(sprite)
    
    let i = section-1
    if !((i % 2 == 0) && (i+1 == self.numberOfSections)) {
      sprite.position.x = sprite.position.x - node.frame.size.width/4
    }
  }
  
  func slideDown(_ duration:TimeInterval) {
    isShowing = false
    
    for i in 0..<sections.count {
      let node = sections[i]
      let amount = CGFloat(getRowForIndex(i)) + 0.5
      let distance = -node.frame.size.height*(amount)
      let moveAction = (SKAction.move(to: CGPoint(x: node.position.x, y: distance), duration: duration))
      
      
      if i != 0 {
        node.run(moveAction)
      } else {
        // it's the first item; when it reaches the bottom, we call the delegate
        let block = SKAction.run({ 
          self.popMenuDelegate?.popMenuDidDisappear!()
        })
        node.run(SKAction.sequence([moveAction, block]))
      }
      
    }
  }
  
  func slideUp(_ duration:TimeInterval) {
    isShowing = true
    
    for i in 0..<sections.count {
      let node = sections[i]
      let amount = CGFloat(getRowForIndex(i)) + 0.5
      let distance = node.frame.size.height*(amount)
      let moveAction = (SKAction.move(to: CGPoint(x: node.position.x, y: distance), duration: duration))

      if i != sections.count-1 {
        node.run(moveAction)
      } else {
        // it's the last item; when it reaches the top, we call the delegate
        let block = SKAction.run({
          self.popMenuDelegate?.popMenuDidAppear!()
        })
        node.run(SKAction.sequence([moveAction, block]))
      }
      
    }
  }
  
  fileprivate func getRowForIndex(_ index:Int) -> Int {
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
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      for node in sections {
        if node.contains(touch.location(in: self)) {
          self.popMenuDelegate?.sectionTapped!(sections.index(of: node)!, name: node.name!)
        }
      }
    }
  }
  
  
}
