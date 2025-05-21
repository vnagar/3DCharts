//
//  OverlayScene.swift
//  3DCharts
//
//  Created by Vivek Nagar on 8/23/14.
//  Copyright (c) 2014 Vivek Nagar. All rights reserved.
//

import SpriteKit

class OverlayScene: SKScene {
    var cameraButtonHandler: (() -> Void)?
    
    override init(size: CGSize) {
        super.init(size: size)
        
        self.scaleMode = .aspectFill
        self.backgroundColor = .clear
        
        // Create camera button
        /*
        let image = UIImage(named: "video_camera")
        let texture = SKTexture(image: image!)
        let cameraButton = SKSpriteNode(texture: texture)
         */
        let cameraButton = SKSpriteNode(imageNamed: "video_camera")
        cameraButton.name = "cameraButton"
        cameraButton.position = CGPoint(x: size.width - 50, y: size.height - 100)
        cameraButton.isUserInteractionEnabled = true
        
        // Add localized tooltip
        let tooltip = SKLabelNode(text: NSLocalizedString("Camera", comment: "Camera button tooltip"))
        tooltip.fontSize = 12
        tooltip.position = CGPoint(x: 0, y: -30)
        cameraButton.addChild(tooltip)
        
        self.addChild(cameraButton)
        
        /*
        // Create reset view button
        let resetButton = SKSpriteNode(imageNamed: "")
        resetButton.name = "resetButton"
        resetButton.position = CGPoint(x: size.width - 50, y: size.height - 100)
        resetButton.isUserInteractionEnabled = true
        
        // Add localized tooltip
        let resetTooltip = SKLabelNode(text: NSLocalizedString("Reset View", comment: "Reset view button tooltip"))
        resetTooltip.fontSize = 12
        resetTooltip.position = CGPoint(x: 0, y: -20)
        resetButton.addChild(resetTooltip)
        
        self.addChild(resetButton)
         */
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let node = self.atPoint(location)
            
            if node.name == "cameraButton" {
                cameraButtonHandler?()
            }
        }
    }
}
