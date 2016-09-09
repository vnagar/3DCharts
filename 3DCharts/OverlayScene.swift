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
    
    private func setup () {
        self.scaleMode = SKSceneScaleMode.resizeFill
        
        //add the camera button
        cameraNode = SKSpriteNode(imageNamed:"art.scnassets/video_camera.png")
        cameraNode.position = CGPoint(x: size.width * 0.85, y: size.height*0.85)
        cameraNode.name = "cameraNode"
        cameraNode.xScale = 0.4
        cameraNode.yScale = 0.4
        self.addChild(cameraNode)

    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        cameraNode?.position = CGPoint(x: self.frame.size.width * 0.85, y: self.frame.size.height*0.85)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch = touches.first! as UITouch
        let location:CGPoint = touch.location(in: scene!)
        let node:SKNode = scene!.atPoint(location)
        if let _ = node.name { // Check if node name is not nil
            // Call closure defined in SceneViewController
            if let handler = cameraButtonHandler {
                handler()
            }
        }
    }
        

}
