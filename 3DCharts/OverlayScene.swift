//
//  OverlayScene.swift
//  3DCharts
//
//  Created by Vivek Nagar on 8/24/14.
//  Copyright (c) 2014 Vivek Nagar. All rights reserved.
//

import SpriteKit

class OverlayScene : SKScene {
    // closure for handling camera button presses
    var cameraButtonHandler : (() -> ())?
    var cameraNode:SKSpriteNode!
    
    override init() {
        super.init()
        setup()
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup () {
        self.scaleMode = SKSceneScaleMode.ResizeFill
        
        //add the camera button
        cameraNode = SKSpriteNode(imageNamed:"art.scnassets/video_camera.png")
        cameraNode.position = CGPointMake(size.width * 0.85, size.height*0.85)
        cameraNode.name = "cameraNode"
        cameraNode.xScale = 0.4
        cameraNode.yScale = 0.4
        self.addChild(cameraNode)

    }
    
    override func didChangeSize(oldSize: CGSize) {
        cameraNode?.position = CGPointMake(self.frame.size.width * 0.85, self.frame.size.height*0.85)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch:UITouch = touches.first as! UITouch
        let location:CGPoint = touch.locationInNode(scene)
        let node:SKNode = scene!.nodeAtPoint(location)
        if let name = node.name { // Check if node name is not nil
            // Call closure defined in SceneViewController
            if let handler = cameraButtonHandler {
                handler()
            }
        }
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesMoved(touches as Set<NSObject>, withEvent: event)
    }
    
    

}