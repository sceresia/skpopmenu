# SKPopMenu
Swift tile-based menu for SpriteKit

<img src="http://i.giphy.com/jxvaUdIF4NAGI.gif">

## Features

- Supports 1-6 menu items
- Customize each menu item with a color and a label or sprite.
 
## Installation

Drag and drop SKPopMenu.swift into your Xcode project
 
## Usage

In your SKScene, add the following:

```swift
let pop = SKPopMenu(numberOfSections:6, sceneFrame: self.frame)
self.addChild(pop)
```

<i>Note: If you choose an odd number of items, the top-most item will be fullscreen width.</i>

To set all sections to the same color:

```swift
pop.setColor(SKColor.magentaColor())
```

To set a specific color to section 1:

```swift
pop.setSectionColor(1, color: SKColor.magentaColor())
```

To change the text label of section 3:

```swift
let myLabel = SKLabelNode()
myLabel.text = “hello”
pop.setSectionLabel(3, label:label)
```

To add a sprite to section 5:

```swift
pop.setSectionSprite(5, sprite:SKSpriteNode(imageNamed:”pop”)
```

To change the name of section 6:

```swift
pop.setSectionName(6, text:”Contact”)
```

To show the menu:

```swift
pop.slideUp(0.2) // duration is NSTimeInterval
```

To hide the menu:

```swift
pop.slideDown(0.2) // duration is NSTimeInterval
```

Show/hide example:

```swift
override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
  if pop.isShowing {
    pop.slideDown(0.2)
  } else {
    pop.slideUp(0.2)
  }
}
```

## Delegate methods (optional)

Add the protocol to your SKScene’s class definition:

```swift
GameScene: SKScene, PopMenuDelegate {}
Remember to set pop.popMenuDelegate = self
```

To get notified when a section is tapped:

```swift
func sectionTapped(index:Int, name:String) {
  if pop.sections[index].name == "email" {
    // email section tapped
  }
}
```

To get notified when the menu has appeared/disappeared:

```swift
func popMenuDidAppear() {
  // pop menu appeared
}
 
func popMenuDidDisappear() {
  // pop menu... wait for it... disappeared 😱
}
```
