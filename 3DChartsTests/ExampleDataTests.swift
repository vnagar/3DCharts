import XCTest
@testable import _DCharts

class ExampleDataTests: XCTestCase {
    var exampleData: ExampleData!
    
    override func setUp() {
        super.setUp()
        exampleData = ExampleData()
    }
    
    override func tearDown() {
        exampleData = nil
        super.tearDown()
    }
    
    func testNumberOfRows() {
        XCTAssertEqual(exampleData.numberOfRows(), 3, "Should have 3 rows (Microsoft, Apple, Google)")
    }
    
    func testNumberOfColumns() {
        XCTAssertEqual(exampleData.numberOfColums(), 12, "Should have 12 columns (years 2001-2012)")
    }
    
    func testLegendForRow() {
        XCTAssertEqual(exampleData.legendForRow(0), "Microsoft", "First row should be Microsoft")
        XCTAssertEqual(exampleData.legendForRow(1), "Apple", "Second row should be Apple")
        XCTAssertEqual(exampleData.legendForRow(2), "Google", "Third row should be Google")
    }
    
    func testLegendForColumn() {
        XCTAssertEqual(exampleData.legendForColumn(0), "2001", "First column should be 2001")
        XCTAssertEqual(exampleData.legendForColumn(11), "2012", "Last column should be 2012")
    }
    
    func testMaxValueForData() {
        XCTAssertEqual(exampleData.maxValueForData(), 150.0, "Max value should be 150.0")
    }
    
    func testValueForIndexPath() {
        // Test Microsoft's first value
        XCTAssertEqual(exampleData.valueForIndexPath(row: 0, column: 0), 25.3, accuracy: 0.001)
        
        // Test Apple's second value
        XCTAssertEqual(exampleData.valueForIndexPath(row: 1, column: 1), 4.74, accuracy: 0.001)
        
        // Test Google's third value
        XCTAssertEqual(exampleData.valueForIndexPath(row: 2, column: 2), 1.47, accuracy: 0.001)
    }
    
    func testColorForIndexPath() {
        // Test that colors are generated with different hues for different rows
        let color1 = exampleData.colorForIndexPath(row: 0, column: 0)
        let color2 = exampleData.colorForIndexPath(row: 1, column: 0)
        let color3 = exampleData.colorForIndexPath(row: 2, column: 0)
        
        // Convert colors to HSB to compare hues
        var hue1: CGFloat = 0
        var hue2: CGFloat = 0
        var hue3: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        color1.getHue(&hue1, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        color2.getHue(&hue2, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        color3.getHue(&hue3, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        XCTAssertNotEqual(hue1, hue2, "Different rows should have different hues")
        XCTAssertNotEqual(hue2, hue3, "Different rows should have different hues")
        XCTAssertNotEqual(hue1, hue3, "Different rows should have different hues")
    }
} 