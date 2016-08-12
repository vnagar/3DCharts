//
//  3DViewController.swift
//  3DCharts
//
//  Created by Vivek Nagar on 8/23/14.
//  Copyright (c) 2014 Vivek Nagar. All rights reserved.
//

import SceneKit
import QuartzCore

enum ChartType : Int {
    case Cylinder = 0, Cube, Pie
}

class SceneViewController : UIViewController, SCNSceneRendererDelegate {
    var chartType : ChartType = ChartType.Cylinder
    var scnView:SCNView!
    var scene:SCNScene!
    var chartNode:SCNNode!
    var cameraNode:SCNNode!
    let data = ExampleData()
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }

    init(type:ChartType) {
        super.init(nibName:nil, bundle:nil)
        self.chartType = type
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scnView = SCNView(frame:self.view.frame)
        self.view.addSubview(scnView)
        layout(scnView) { scnView in
            scnView.top == scnView.superview!.top
            scnView.left == scnView.superview!.left
            scnView.right == scnView.superview!.right
            scnView.bottom == scnView.superview!.bottom
        }
        
        scnView.delegate = self
        
        // create a new scene
        scene = SCNScene()
        
        // create and add a camera to the scene
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 40, z: 70)
        cameraNode.rotation = SCNVector4(x: 1, y: 0, z: 0, w: Float(-M_PI_4*0.25))
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = SCNLightTypeOmni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 15)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light?.type = SCNLightTypeAmbient
        ambientLightNode.light?.color = UIColor.darkGrayColor()
        scene.rootNode.addChildNode(ambientLightNode)

        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        //scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.blackColor()
        
        //setup overlay
        let overlayScene:OverlayScene = OverlayScene(size: scnView.bounds.size);
        scnView.overlaySKScene = overlayScene;
        overlayScene.cameraButtonHandler = handleCameraButtonPressed
        
        showData()

        let tap = UITapGestureRecognizer(target: self, action: #selector(SceneViewController.handleTap(_:)))
        view.addGestureRecognizer(tap)
    }
    
    func showData() {
        chartNode = SCNNode()
        if(self.chartType == .Cylinder) {
            chartNode = createChart(self.chartType)
        } else if(self.chartType == .Cube) {
            chartNode = createChart(self.chartType)
        } else {
            chartNode = createPieChart()
        }
        
        scene.rootNode.addChildNode(chartNode)
        
        chartNode.rotation = SCNVector4(x: 1, y: 0, z: 0, w: Float(-M_PI_2))
    }
    

    func createChart(type:ChartType) -> SCNNode {
        let gridSize:CGFloat = 3.0
        let numRows = data.numberOfRows()
        let numColumns = data.numberOfColums()
        let height = CGFloat(numRows)*gridSize
        let width = CGFloat(numColumns)*gridSize
        
        let node = SCNNode()
        let base = SCNNode(geometry: SCNPlane(width: width, height: height))
        node.addChildNode(base)
        
        var min:SCNVector3 = SCNVector3(x: 0, y: 0, z: 0)
        var max:SCNVector3 = SCNVector3(x: 0, y: 0, z: 0)
        
        base.getBoundingBoxMin(&min, max: &max)
        
        //println("bounds is \(min.x), \(min.y), \(min.z), \(max.x), \(max.y), \(max.z)")
        
        
        for idx in 0 ..< numRows {
            let txt = SCNText(string: data.legendForRow(idx), extrusionDepth: 0.0)
            txt.font = UIFont(name: "MarkerFelt-Thin", size: 2.0)
            let txtNode = SCNNode(geometry: txt)
            let posX = min.x - 10.0
            let posY = min.y + Float(idx+1) * Float(gridSize)
            txtNode.position = SCNVector3(x: posX, y: posY, z: 0.0)
            node.addChildNode(txtNode)
        }
        
        for idx in 0 ..< numColumns {
            let txt = SCNText(string: data.legendForColumn(idx), extrusionDepth: 0.0)
            txt.font = UIFont(name: "MarkerFelt-Thin", size: 2.0)
            let txtNode = SCNNode(geometry: txt)
            let posX = min.x + Float(idx+1) * Float(gridSize)
            let posY = min.y - 2.0
            txtNode.position = SCNVector3(x: posX, y: posY, z: 0.0)
            txtNode.rotation = SCNVector4(x: 0, y: 0, z: 1, w: Float(-M_PI_2))
            node.addChildNode(txtNode)
        }

        for i in 0 ..< numRows {
            for j in 0 ..< numColumns {
                let val = data.valueForIndexPath(row:i, column: j) / 3.0
                var aNode = SCNNode()
                if(type == .Cylinder) {
                    aNode = SCNNode(geometry: SCNCylinder(radius: 1.0, height: CGFloat(val)))
                } else {
                    aNode = SCNNode(geometry: SCNBox(width: 1.0, height: CGFloat(val), length: 1.0, chamferRadius: 0))
                }
            
                let posX = min.x + Float(j) * Float(gridSize) + Float(gridSize/2)
                let posY = min.y + Float(i) * Float(gridSize) + Float(gridSize/2)
                aNode.position = SCNVector3(x: posX, y:posY , z: val/2)
                aNode.rotation = SCNVector4(x: 1, y: 0, z: 0, w: Float(-M_PI_2))
                aNode.geometry?.firstMaterial?.diffuse.contents = data.colorForIndexPath(row: i, column: j)
                node.addChildNode(aNode)
                
            }
        }
        
        return node
    }
    
    
    func createPieChart() -> SCNNode {
        let aNode = SCNNode()
        var total:Float = 0.0
        //let numRows = data.numberOfRows()
        let numColumns = data.numberOfColums()
        
        let i = 0
        for j in 0 ..< numColumns {
            let val = data.valueForIndexPath(row:i, column: j)
            total = total + val
        }
        
        var startDeg:Float = 0.0
        var startRad:Float = 0.0
        for j in 0 ..< numColumns {
            let val = data.valueForIndexPath(row:i, column: j)
            let pct = val*360.0/total
            startRad = Float(startDeg) * Float(M_PI) / Float(180.0)
            let endDeg = startDeg + pct - 1.0
            let endRad:Float = Float(endDeg) * Float(M_PI) / Float(180.0)
            let circlePath = UIBezierPath()
            circlePath.moveToPoint(CGPointZero)
            circlePath.addArcWithCenter(CGPointZero, radius: 20.0, startAngle:CGFloat(startRad), endAngle: CGFloat(endRad), clockwise: true)
            startDeg = endDeg + 1
            let node = SCNNode(geometry: SCNShape(path:circlePath, extrusionDepth: 5.0))
            node.geometry?.firstMaterial?.diffuse.contents = data.colorForIndexPath(row: i, column: j)
            aNode.addChildNode(node)
            
        }
        
        return aNode
    }
    
    func renderer(aRenderer: SCNSceneRenderer, updateAtTime time: NSTimeInterval) {
    }
    
    //Definition of closure
    func handleCameraButtonPressed() {
        scnView.pointOfView = cameraNode

        turnCameraAroundNode(chartNode, radius: 70)
    }
    
    func turnCameraAroundNode(node:SCNNode, radius:Float)
    {
        let animation = CAKeyframeAnimation(keyPath:"transform")
        animation.duration = 15.0
        animation.fillMode = kCAFillModeForwards
        animation.removedOnCompletion = false
        
        var animValues = [NSValue]()
        for var index = 0; index <= 360; index += 1 {
            let hAngle = Double(index) * M_PI / 180.0
            let vAngle = Double(-45) * 0.25 * M_PI / 180.0
            let val = NSValue(CATransform3D: transformationToRotateAroundPosition(node.position, radius:radius, horizontalAngle:Float(hAngle), verticalAngle:Float(vAngle)))
            animValues.append(val)
        }
        
        animation.values = animValues
        animation.timingFunction = CAMediaTimingFunction (name: kCAMediaTimingFunctionEaseInEaseOut)
        cameraNode.addAnimation(animation, forKey:"animation");
        
    }
    
    func transformationToRotateAroundPosition(center:SCNVector3 ,radius:Float, horizontalAngle:Float, verticalAngle:Float) -> CATransform3D
    {
        var pos:SCNVector3 = SCNVector3Make(0, 0, 0)
        pos.x = center.x + radius * cos(verticalAngle) * sin(horizontalAngle)
        pos.y = cameraNode.position.y
        pos.z = center.z + radius * cos(verticalAngle) * cos(horizontalAngle)
        
        let rotX = CATransform3DMakeRotation(CGFloat(verticalAngle), 1, 0, 0)
        let rotY = CATransform3DMakeRotation(CGFloat(horizontalAngle), 0, 1, 0)
        let rotation = CATransform3DConcat(rotX, rotY)
        
        let translate = CATransform3DMakeTranslation(CGFloat(pos.x), CGFloat(pos.y), CGFloat(pos.z))
        let transform = CATransform3DConcat(rotation,translate)
        
        return transform
    }

    func handleTap(gesture: UITapGestureRecognizer) {
        
        // check what nodes are tapped
        let p = gesture.locationInView(scnView)
        let hitResults = scnView.hitTest(p, options: nil)
        
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result: AnyObject! = hitResults[0]
            
            //_ = result.node! as SCNNode
            
            // get its material
            let material = result.node!.geometry?.firstMaterial
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.setAnimationDuration(0.5)
            
            // on completion - unhighlight
            SCNTransaction.setCompletionBlock {
                SCNTransaction.begin()
                SCNTransaction.setAnimationDuration(0.5)
                
                material?.emission.contents = UIColor.blackColor()
                
                SCNTransaction.commit()
            }
            
            material?.emission.contents = UIColor.blueColor()
            
            SCNTransaction.commit()
        }

    }

}
