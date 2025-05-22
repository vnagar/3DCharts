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
    private var cameraButton: SKSpriteNode?
    
    override init(size: CGSize) {
        super.init(size: size)
        
        self.scaleMode = .aspectFill
        self.backgroundColor = .clear
        
        setupCameraButton(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if let size = scene?.size {
            setupCameraButton(size: size)
        }
    }
    
    private func setupCameraButton(size: CGSize) {
        // Create camera button with a fallback shape if image is not available
        let cameraButton: SKSpriteNode
        if let image = UIImage(named: "video_camera") {
            cameraButton = SKSpriteNode(texture: SKTexture(image: image))
            cameraButton.setScale(0.5)
        } else {
            // Fallback to a visible shape if image is missing
            cameraButton = SKSpriteNode(color: .white, size: CGSize(width: 44, height: 44))
        }
        
        // Configure button
        cameraButton.name = "cameraButton"
        cameraButton.position = CGPoint(x: size.width - 50, y: size.height - 125)
        
        // Make sure the button has a reasonable size for touch interaction
        if cameraButton.size.width < 44 || cameraButton.size.height < 44 {
            cameraButton.size = CGSize(width: 44, height: 44)
        }
        
        // Add localized tooltip
        let tooltip = SKLabelNode(text: NSLocalizedString("Camera", comment: "Camera button tooltip"))
        tooltip.fontSize = 12
        tooltip.fontName = "Helvetica-Bold"
        tooltip.position = CGPoint(x: 0, y: -30)
        cameraButton.addChild(tooltip)
        
        self.addChild(cameraButton)
        self.cameraButton = cameraButton
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        // Use nodes(at:) instead of atPoint for better touch detection
        let touchedNodes = nodes(at: location)
        
        // Check if any of the touched nodes is our camera button or its children
        for node in touchedNodes {
            if node.name == "cameraButton" || node.parent?.name == "cameraButton" {
                // Provide visual feedback
                cameraButton?.alpha = 0.5
                return
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        // Reset visual feedback
        cameraButton?.alpha = 1.0
        
        // Use nodes(at:) for better touch detection
        let touchedNodes = nodes(at: location)
        
        // Check if any of the touched nodes is our camera button or its children
        for node in touchedNodes {
            if node.name == "cameraButton" || node.parent?.name == "cameraButton" {
                cameraButtonHandler?()
                return
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Reset visual feedback if touch is cancelled
        cameraButton?.alpha = 1.0
    }
}
