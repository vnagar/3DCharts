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
    case cylinder = 0, cube, pie
}

class SceneViewController : UIViewController, SCNSceneRendererDelegate {
    var chartType : ChartType = ChartType.cylinder
    var scnView:SCNView!
    var scene:SCNScene!
    var chartNode:SCNNode!
    var cameraNode:SCNNode!
    let data = ExampleData()
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
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
        scnView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(scnView)
        
        // Create a bottom space constraint
        var constraint = NSLayoutConstraint (item: scnView!,
                                             attribute: NSLayoutConstraint.Attribute.bottom,
                                             relatedBy: NSLayoutConstraint.Relation.equal,
                                             toItem: self.view,
                                             attribute: NSLayoutConstraint.Attribute.bottom,
                                             multiplier: 1,
                                             constant: 0)
        self.view.addConstraint(constraint)
        // Create a top space constraint
        constraint = NSLayoutConstraint (item: scnView!,
                                         attribute: NSLayoutConstraint.Attribute.top,
                                         relatedBy: NSLayoutConstraint.Relation.equal,
                                         toItem: self.view,
                                         attribute: NSLayoutConstraint.Attribute.top,
                                         multiplier: 1,
                                         constant: 0)
        self.view.addConstraint(constraint)
        
        // Create a right space constraint
        constraint = NSLayoutConstraint (item: scnView!,
                                         attribute: NSLayoutConstraint.Attribute.right,
                                         relatedBy: NSLayoutConstraint.Relation.equal,
                                         toItem: self.view,
                                         attribute: NSLayoutConstraint.Attribute.right,
                                         multiplier: 1,
                                         constant: 0)
        self.view.addConstraint(constraint)
        // Create a left space constraint
        constraint = NSLayoutConstraint (item: scnView!,
                                         attribute: NSLayoutConstraint.Attribute.left,
                                         relatedBy: NSLayoutConstraint.Relation.equal,
                                         toItem: self.view,
                                         attribute: NSLayoutConstraint.Attribute.left,
                                         multiplier: 1,
                                         constant: 0)
        self.view.addConstraint(constraint)

        scnView.delegate = self
        
        // create a new scene
        scene = SCNScene()
        
        // create and add a camera to the scene
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 40, z: 70)
        cameraNode.rotation = SCNVector4(x: 1, y: 0, z: 0, w: Float(-Double.pi/4 * 0.25))
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = SCNLight.LightType.omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 15)
        scene.rootNode.addChildNode(lightNode)
        
        //create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light?.type = SCNLight.LightType.ambient
        ambientLightNode.light?.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)

        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        //scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.black
        
        //setup overlay
        let overlayScene:OverlayScene = OverlayScene(size: scnView.bounds.size);
        scnView.overlaySKScene = overlayScene;
        overlayScene.cameraButtonHandler = handleCameraButtonPressed
        
        showData()
    }
    
    func renderer(_ aRenderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
    }

    private func showData() {
        chartNode = SCNNode()
        if(self.chartType == .cylinder) {
            chartNode = createChart(self.chartType)
        } else if(self.chartType == .cube) {
            chartNode = createChart(self.chartType)
        } else {
            chartNode = createPieChart()
        }
        
        scene.rootNode.addChildNode(chartNode)
        
        chartNode.rotation = SCNVector4(x: 1, y: 0, z: 0, w: Float(-Double.pi / 2.0))
    }
    

    private func createChart(_ type:ChartType) -> SCNNode {
        let gridSize:CGFloat = 3.0
        let numRows = data.numberOfRows()
        let numColumns = data.numberOfColums()
        let height = CGFloat(numRows)*gridSize
        let width = CGFloat(numColumns)*gridSize
        
        let node = SCNNode()
        let base = SCNNode(geometry: SCNPlane(width: width, height: height))
        node.addChildNode(base)
        
        var min:SCNVector3 = SCNVector3(x: 0, y: 0, z: 0)
        
        (min, _) = base.boundingBox
        
        //println("bounds is \(min.x), \(min.y), \(min.z), \(max.x), \(max.y), \(max.z)")
        
        for idx in 0 ..< numRows {
            let txt = SCNText(string: data.legendForRow(idx), extrusionDepth: 0.0)
            txt.font = UIFont(name: "MarkerFelt-Thin", size: 2.0)
            let txtNode = SCNNode(geometry: txt)
            let posX = min.x - 10.0
            let posY = min.y + Float(idx) * Float(gridSize)
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
            txtNode.rotation = SCNVector4(x: 0, y: 0, z: 1, w: Float(-Double.pi / 2.0))
            node.addChildNode(txtNode)
        }

        for i in 0 ..< numRows {
            for j in 0 ..< numColumns {
                let val = data.valueForIndexPath(row:i, column: j) / 3.0
                var aNode = SCNNode()
                if(type == .cylinder) {
                    aNode = SCNNode(geometry: SCNCylinder(radius: 1.0, height: CGFloat(val)))
                } else {
                    aNode = SCNNode(geometry: SCNBox(width: 1.0, height: CGFloat(val), length: 1.0, chamferRadius: 0))
                }
            
                let posX = min.x + Float(j) * Float(gridSize) + Float(gridSize/2)
                let posY = min.y + Float(i) * Float(gridSize) + Float(gridSize/2)
                aNode.position = SCNVector3(x: posX, y:posY , z: val/2)
                aNode.rotation = SCNVector4(x: 1, y: 0, z: 0, w: Float(-Double.pi / 2.0))
                aNode.geometry?.firstMaterial?.diffuse.contents = data.colorForIndexPath(row: i, column: j)
                node.addChildNode(aNode)
            }
        }
        
        return node
    }
    
    
    private func createPieChart() -> SCNNode {
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
            startRad = Float(startDeg) * Float(Double.pi) / Float(180.0)
            let endDeg = startDeg + pct - 1.0
            let endRad:Float = Float(endDeg) * Float(Double.pi) / Float(180.0)
            let circlePath = UIBezierPath()
            circlePath.move(to: CGPoint.zero)
            circlePath.addArc(withCenter: CGPoint.zero, radius: 20.0, startAngle:CGFloat(startRad), endAngle: CGFloat(endRad), clockwise: true)
            startDeg = endDeg + 1
            let node = SCNNode(geometry: SCNShape(path:circlePath, extrusionDepth: 5.0))
            node.geometry?.firstMaterial?.diffuse.contents = data.colorForIndexPath(row: i, column: j)
            aNode.addChildNode(node)
            
        }
        
        return aNode
    }
    
    //Definition of closure
    private func handleCameraButtonPressed() {
        scnView.pointOfView = cameraNode

        turnCameraAroundNode(chartNode, radius: 70)
    }
    
    private func turnCameraAroundNode(_ node:SCNNode, radius:Float)
    {
        let animation = CAKeyframeAnimation(keyPath:"transform")
        animation.duration = 15.0
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        
        var animValues = [NSValue]()
        for index in 0 ..< 360 {
            let hAngle = Double(index) * Double.pi / 180.0
            let vAngle = Double(-45) * 0.25 * Double.pi / 180.0
            let val = NSValue(caTransform3D: transformationToRotateAroundPosition(node.position, radius:radius, horizontalAngle:Float(hAngle), verticalAngle:Float(vAngle)))
            animValues.append(val)
        }
        
        animation.values = animValues
        animation.timingFunction = CAMediaTimingFunction (name: CAMediaTimingFunctionName.easeInEaseOut)
        cameraNode.addAnimation(animation, forKey:"animation");
        
    }
    
    private func transformationToRotateAroundPosition(_ center:SCNVector3 ,radius:Float, horizontalAngle:Float, verticalAngle:Float) -> CATransform3D
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

}
