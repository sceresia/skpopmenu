//
//  GameViewController.swift
//  SKPopMenuExample
//
//  Created by Stephen on 2016-07-30.
//  Copyright (c) 2016 Stephen Ceresia. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    // Configure the view.
    let skView = self.view as! SKView
    
    if (skView.scene == nil) {
      skView.showsFPS = true
      skView.showsNodeCount = true
      /* Sprite Kit applies additional optimizations to improve rendering performance */
      skView.ignoresSiblingOrder = true
      
      let scene = GameScene(size: skView.bounds.size)
      /* Set the scale mode to scale to fit the window */
      scene.scaleMode = .AspectFill
      skView.presentScene(scene)
      
    }
    
  }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
