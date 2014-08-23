//
//  3DViewController.swift
//  3DCharts
//
//  Created by Vivek Nagar on 8/23/14.
//  Copyright (c) 2014 Vivek Nagar. All rights reserved.
//

import SceneKit

enum ChartType : Int {
    case Cylinder = 0, Cube, Pie
}

class SceneViewController : UIViewController, SCNSceneRendererDelegate {
    var chartType : ChartType = ChartType.Cylinder
    var scnView:SCNView!
    var scene:SCNScene!
    let data = ExampleData()
    
    override init() {
        super.init()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder:aDecoder)
    }

    init(type:ChartType) {
        super.init()
        self.chartType = type
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scnView = SCNView(frame:self.view.frame)
        self.view.addSubview(scnView)
        
        scnView.delegate = self
        
        // create a new scene
        scene = SCNScene()
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 40, z: 70)
        cameraNode.rotation = SCNVector4(x: 1, y: 0, z: 0, w: Float(-M_PI_4*0.25))
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light.type = SCNLightTypeOmni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 15)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light.type = SCNLightTypeAmbient
        ambientLightNode.light.color = UIColor.darkGrayColor()
        scene.rootNode.addChildNode(ambientLightNode)

        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.blackColor()
        
        showData()


    }
    
    func showData() {
        var node = SCNNode()
        if(self.chartType == .Cylinder) {
            node = createChart(self.chartType)
        } else if(self.chartType == .Cube) {
            node = createChart(self.chartType)
        } else {
            node = createPieChart()
        }
        
        scene.rootNode.addChildNode(node)
        
        node.rotation = SCNVector4(x: 1, y: 0, z: 0, w: Float(-M_PI_2))
    }
    

    func createChart(type:ChartType) -> SCNNode {
        let gridSize:CGFloat = 3.0
        let numRows = data.numberOfRows()
        let numColumns = data.numberOfColums()
        let height = CGFloat(numRows)*gridSize
        let width = CGFloat(numColumns)*gridSize
        
        var node = SCNNode()
        let base = SCNNode(geometry: SCNPlane(width: width, height: height))
        node.addChildNode(base)
        
        var min:SCNVector3 = SCNVector3(x: 0, y: 0, z: 0)
        var max:SCNVector3 = SCNVector3(x: 0, y: 0, z: 0)
        base.getBoundingBoxMin(&min, max: &max)
        
        //println("bounds is \(min.x), \(min.y), \(min.z), \(max.x), \(max.y), \(max.z)")
        
        
        for (var idx = 0; idx < numRows; ++idx) {
            let txt = SCNText(string: data.legendForRow(idx), extrusionDepth: 0.0)
            txt.font = UIFont(name: "MarkerFelt-Thin", size: 2.0)
            let txtNode = SCNNode(geometry: txt)
            var posX = min.x - 10.0
            var posY = min.y + Float(idx+1) * Float(gridSize)
            txtNode.position = SCNVector3(x: posX, y: posY, z: 0.0)
            node.addChildNode(txtNode)
        }
        
        for (var idx = 0; idx < numColumns; ++idx) {
            let txt = SCNText(string: data.legendForColumn(idx), extrusionDepth: 0.0)
            txt.font = UIFont(name: "MarkerFelt-Thin", size: 2.0)
            let txtNode = SCNNode(geometry: txt)
            var posX = min.x + Float(idx+1) * Float(gridSize)
            var posY = min.y - 2.0
            txtNode.position = SCNVector3(x: posX, y: posY, z: 0.0)
            txtNode.rotation = SCNVector4(x: 0, y: 0, z: 1, w: Float(-M_PI_2))
            node.addChildNode(txtNode)
        }

        for( var i = 0; i < numRows ; ++i) {
            for (var j = 0; j < numColumns; j++) {
                let val = data.valueForIndexPath(row:i, column: j) / 3.0
                var aNode = SCNNode()
                if(type == .Cylinder) {
                    aNode = SCNNode(geometry: SCNCylinder(radius: 1.0, height: CGFloat(val)))
                } else {
                    aNode = SCNNode(geometry: SCNBox(width: 1.0, height: CGFloat(val), length: 1.0, chamferRadius: 0))
                }
            
                var posX = min.x + Float(j) * Float(gridSize) + Float(gridSize/2)
                var posY = min.y + Float(i) * Float(gridSize) + Float(gridSize/2)
                aNode.position = SCNVector3(x: posX, y:posY , z: val/2)
                aNode.rotation = SCNVector4(x: 1, y: 0, z: 0, w: Float(-M_PI_2))
                aNode.geometry.firstMaterial.diffuse.contents = data.colorForIndexPath(row: i, column: j)
                node.addChildNode(aNode)
                
            }
        }
        
        return node
    }
    
    
    func createPieChart() -> SCNNode {
        var aNode = SCNNode()
        var total:Float = 0.0
        let numRows = data.numberOfRows()
        let numColumns = data.numberOfColums()
        
        let i = 0
        for (var j = 0; j < numColumns; j++) {
            let val = data.valueForIndexPath(row:i, column: j)
            total = total + val
        }
        
        var startDeg:Float = 0.0
        var startRad:Float = 0.0
        for (var j = 0; j < numColumns; j++) {
            let val = data.valueForIndexPath(row:i, column: j)
            var pct = val*360.0/total
            startRad = Float(startDeg) * Float(M_PI) / Float(180.0)
            var endDeg = startDeg + pct - 1.0
            var endRad:Float = Float(endDeg) * Float(M_PI) / Float(180.0)
            var circlePath = UIBezierPath()
            circlePath.moveToPoint(CGPointZero)
            circlePath.addArcWithCenter(CGPointZero, radius: 20.0, startAngle:CGFloat(startRad), endAngle: CGFloat(endRad), clockwise: true)
            startDeg = endDeg + 1
            var node = SCNNode(geometry: SCNShape(path:circlePath, extrusionDepth: 5.0))
            node.geometry.firstMaterial.diffuse.contents = data.colorForIndexPath(row: i, column: j)
            aNode.addChildNode(node)
            
            
        }
        
        return aNode
    }
    
    func renderer(aRenderer: SCNSceneRenderer!, updateAtTime time: NSTimeInterval) {

    }
    
}
