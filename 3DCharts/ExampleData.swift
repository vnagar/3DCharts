//
//  ExampleData.swift
//  3DCharts
//
//  Created by Vivek Nagar on 8/23/14.
//  Copyright (c) 2014 Vivek Nagar. All rights reserved.
//

import SpriteKit

class ExampleData : SceneViewDataSource {
    let gValsRevenue:[Float] = [
    25.3, 28.37, 32.19, 36.84, 39.79, 44.28, 51.12, 60.42, 58.44, 62.48, 69.94, 73.72, // MSFT
    5.36, 4.74, 6.21, 8.28, 13.93, 19.32, 24.01, 32.48, 36.54, 65.22, 108.25, 148.81, // AAPL
    0.0, 0.43951, 1.47, 3.19, 6.14, 10.6, 16.59, 21.8, 23.65, 29.32, 37.91, 43.16, // GOOG
    ]
    
    func numberOfRows() -> Int {
        return 3
    }
    
    func numberOfColums() -> Int {
        return 12
    }
    
    func legendForRow(_ row:Int) -> String {
        if (row == 0) {
            return "Microsoft"
        }
        else if (row == 1) {
            return "Apple"
        }
        else {
            return "Google"
        }
    }
    
    func legendForColumn(_ column:Int) -> String {
        return String(format:"%d", 2001 + column)
    }
    
    func maxValueForData() -> Float {
        return 150.0
    }
    
    func valueForIndexPath(row:Int, column:Int) -> Float {
        return gValsRevenue[row * 12 + column]
    }
    
    func colorForIndexPath(row:Int, column:Int) -> SKColor {
        let val:Float = self.valueForIndexPath(row:row, column:column)
        let max:Float = 150.0
        let value:Float = Float(val/max)
        let hue = 0.3 + Float(row) / 6.0
        let sat = 0.2 + value/1.25
        
        let color = UIColor(hue: CGFloat(hue), saturation: CGFloat(sat), brightness: 1.0, alpha: 1.0)
        return color;

    }
}
