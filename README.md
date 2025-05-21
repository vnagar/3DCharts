# 3DCharts

A Swift project demonstrating the creation of interactive 3D charts using SceneKit. This project showcases how to create beautiful and interactive 3D cylindrical bars, cube bars, and pie charts with modern Swift.

## Features

- **Multiple Chart Types:**
  - 3D Cylindrical Bar Charts
  - 3D Cube Bar Charts
  - 3D Pie Charts

- **Interactive Visualization:**
  - Full camera control for viewing charts from any angle
  - Dynamic lighting and shadows
  - Smooth animations and transitions

- **Rich Data Visualization:**
  - Automatic scaling and positioning
  - Dynamic color gradients based on data values
  - Axis labels and legends
  - Support for multiple data series

- **Modern Implementation:**
  - Written in Swift
  - Uses SceneKit for 3D rendering
  - SpriteKit integration for overlay UI
  - Auto Layout support for responsive design

## Requirements

- iOS 13.0+
- Xcode 12.0+
- Swift 3.0+

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/3DCharts.git
```

2. Open the project in Xcode:
```bash
cd 3DCharts
open 3DCharts.xcodeproj
```

3. Build and run the project in Xcode (⌘+R)

## Usage

### Basic Implementation

1. Import the required frameworks:
```swift
import SceneKit
import QuartzCore
```

2. Implement the `SceneViewDataSource` protocol for your data:
```swift
class YourDataSource: SceneViewDataSource {
    func numberOfRows() -> Int
    func numberOfColums() -> Int
    func legendForRow(_ row: Int) -> String
    func legendForColumn(_ column: Int) -> String
    func maxValueForData() -> Float
    func valueForIndexPath(row: Int, column: Int) -> Float
    func colorForIndexPath(row: Int, column: Int) -> UIColor
}
```

3. Create a chart view controller:
```swift
let chartViewController = SceneViewController(type: .cylinder)
// or .cube or .pie for different chart types
```

### Example Data Format

The project includes an example implementation showing revenue data for major tech companies:
```swift
let gValsRevenue:[Float] = [
    25.3, 28.37, 32.19, // Microsoft
    5.36, 4.74, 6.21,   // Apple
    0.0, 0.43951, 1.47  // Google
]
```

## Project Structure

- `SceneViewController.swift`: Main 3D chart renderer
- `SceneViewDataSource.swift`: Protocol for chart data
- `ViewController.swift`: Main app view controller
- `ExampleData.swift`: Sample data implementation
- `OverlayScene.swift`: UI overlay implementation

## Features in Detail

### Chart Types

1. **Cylindrical Bars**
   - Smooth rounded bars
   - Perfect for continuous data visualization

2. **Cube Bars**
   - Sharp, precise bars
   - Ideal for discrete data points

3. **Pie Charts**
   - 3D circular visualization
   - Great for showing proportions

### Interaction Features

- Rotate the chart with touch gestures
- Zoom in/out with pinch gestures
- Pan across the visualization
- Automatic camera positioning

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Created by Vivek Nagar
- Built with SceneKit and Swift
- Example data features historical revenue figures from Microsoft, Apple, and Google

## Contact

For questions and feedback, please open an issue in the GitHub repository.
