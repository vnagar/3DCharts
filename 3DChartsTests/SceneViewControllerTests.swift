import XCTest
import SceneKit
@testable import _DCharts

class SceneViewControllerTests: XCTestCase {
    var viewController: SceneViewController!
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        viewController = nil
        super.tearDown()
    }
    
    func testInitWithChartType() {
        // Test cylinder type
        viewController = SceneViewController(type: .cylinder)
        XCTAssertEqual(viewController.chartType, .cylinder)
        
        // Test cube type
        viewController = SceneViewController(type: .cube)
        XCTAssertEqual(viewController.chartType, .cube)
        
        // Test pie type
        viewController = SceneViewController(type: .pie)
        XCTAssertEqual(viewController.chartType, .pie)
    }
    
    func testViewDidLoadSetup() {
        viewController = SceneViewController(type: .cylinder)
        viewController.loadView()
        viewController.viewDidLoad()
        
        // Test SceneKit view setup
        XCTAssertNotNil(viewController.scnView)
        XCTAssertTrue(viewController.scnView.allowsCameraControl)
        XCTAssertEqual(viewController.scnView.backgroundColor, .black)
        
        // Test scene setup
        XCTAssertNotNil(viewController.scene)
        
        // Test camera setup
        XCTAssertNotNil(viewController.cameraNode)
        XCTAssertNotNil(viewController.cameraNode.camera)
        
        // Test chart node setup
        XCTAssertNotNil(viewController.chartNode)
    }
    
    func testCreateChart() {
        viewController = SceneViewController(type: .cylinder)
        viewController.loadView()
        viewController.viewDidLoad()
        
        // Test cylinder chart
        var node = viewController.createChart(.cylinder)
        XCTAssertNotNil(node)
        XCTAssertTrue(node.childNodes.count > 0)
        
        // Test cube chart
        node = viewController.createChart(.cube)
        XCTAssertNotNil(node)
        XCTAssertTrue(node.childNodes.count > 0)
    }
    
    func testChartNodeRotation() {
        viewController = SceneViewController(type: .cylinder)
        viewController.loadView()
        viewController.viewDidLoad()
        
        // Test that chart node has correct rotation
        let rotation = viewController.chartNode.rotation
        XCTAssertEqual(rotation.x, 1)
        XCTAssertEqual(rotation.y, 0)
        XCTAssertEqual(rotation.z, 0)
        XCTAssertEqual(rotation.w, Float(-Double.pi / 2.0))
    }
    
    func testCameraPosition() {
        viewController = SceneViewController(type: .cylinder)
        viewController.loadView()
        viewController.viewDidLoad()
        
        let position = viewController.cameraNode.position
        XCTAssertEqual(position.x, 0)
        XCTAssertEqual(position.y, 40)
        XCTAssertEqual(position.z, 70)
    }
    
    func testSceneRendererDelegate() {
        viewController = SceneViewController(type: .cylinder)
        viewController.loadView()
        viewController.viewDidLoad()
        
        // Test that view controller is set as scene renderer delegate
        XCTAssertTrue(viewController.scnView.delegate === viewController)
    }
} 