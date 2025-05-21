import XCTest
import SpriteKit
@testable import _DCharts

class OverlaySceneTests: XCTestCase {
    var overlayScene: OverlayScene!
    let testSize = CGSize(width: 500, height: 500)
    
    override func setUp() {
        super.setUp()
        overlayScene = OverlayScene(size: testSize)
    }
    
    override func tearDown() {
        overlayScene = nil
        super.tearDown()
    }
    
    func testInitialization() {
        XCTAssertNotNil(overlayScene)
        XCTAssertEqual(overlayScene.size, testSize)
    }
    
    func testCameraButtonSetup() {
        // Find camera button in the scene
        let cameraButton = overlayScene.childNode(withName: "cameraButton") as? SKSpriteNode
        XCTAssertNotNil(cameraButton, "Camera button should exist in the scene")
        
        if let button = cameraButton {
            // Test button position
            XCTAssertGreaterThan(button.position.x, 0)
            XCTAssertGreaterThan(button.position.y, 0)
            
            // Test button properties
            XCTAssertTrue(button.isUserInteractionEnabled)
        }
    }
    
    func testCameraButtonHandler() {
        var handlerCalled = false
        
        // Set up handler
        overlayScene.cameraButtonHandler = {
            handlerCalled = true
        }
        
        // Simulate button tap
        if let button = overlayScene.childNode(withName: "cameraButton") {
            overlayScene.touchesBegan([UITouch()], with: nil)
            overlayScene.touchesEnded([UITouch()], with: nil)
        }
        
        // Verify handler was called
        XCTAssertTrue(handlerCalled)
    }
    
    func testSceneScaleMode() {
        XCTAssertEqual(overlayScene.scaleMode, .aspectFill)
    }
    
    func testOverlayBackground() {
        // The overlay should be transparent
        XCTAssertEqual(overlayScene.backgroundColor, .clear)
    }
    
    func testButtonVisualProperties() {
        if let button = overlayScene.childNode(withName: "cameraButton") as? SKSpriteNode {
            // Test button size
            XCTAssertGreaterThan(button.size.width, 0)
            XCTAssertGreaterThan(button.size.height, 0)
            
            // Test button alpha
            XCTAssertEqual(button.alpha, 1.0)
            
            // Test button is visible
            XCTAssertFalse(button.isHidden)
        }
    }
    
    func testTouchHandling() {
        // Test touch outside button area
        let touchPoint = CGPoint(x: 0, y: 0)
        let touch = UITouch()
        
        overlayScene.touchesBegan([touch], with: nil)
        overlayScene.touchesEnded([touch], with: nil)
        
        // Touch outside button area should not trigger handler
        var handlerCalled = false
        overlayScene.cameraButtonHandler = {
            handlerCalled = true
        }
        
        XCTAssertFalse(handlerCalled)
    }
} 