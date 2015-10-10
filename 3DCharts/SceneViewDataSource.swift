//
//  SceneViewDataSource.swift
//  3DCharts
//
//  Created by Vivek Nagar on 8/23/14.
//  Copyright (c) 2014 Vivek Nagar. All rights reserved.
//

import SceneKit

protocol SceneViewDataSource {
    func numberOfRows() -> Int
    func numberOfColums() -> Int
    func legendForRow(row:Int) -> String
    func legendForColumn(column:Int) -> String
    func maxValueForData() -> Float
    func valueForIndexPath(row row:Int, column:Int) -> Float
    func colorForIndexPath(row row:Int, column:Int) -> UIColor
}