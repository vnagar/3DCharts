//
//  ViewController.swift
//  3DCharts
//
//  Created by Vivek Nagar on 8/23/14.
//  Copyright (c) 2014 Vivek Nagar. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var tableView: UITableView!
    var cylinderChartSceneController:SceneViewController!
    var cubeChartSceneController:SceneViewController!
    var pieChartSceneController:SceneViewController!
    
    let chartTypes:[String] = ["Cylinder Charts", "Cube Charts", "Pie Charts"]
  
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "Chart Types"
        tableView = UITableView()
        tableView.frame = CGRectZero
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        
        
        layout(tableView) { tableView in
            tableView.top == tableView.superview!.top
            tableView.left == tableView.superview!.left
            tableView.right == tableView.superview!.right
            tableView.bottom == tableView.superview!.bottom
        }
        
        cylinderChartSceneController = SceneViewController(type:ChartType.Cylinder)
        cubeChartSceneController = SceneViewController(type:ChartType.Cube)
        pieChartSceneController = SceneViewController(type:ChartType.Pie)
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chartTypes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let CellIdentifier = "CellIdentifier"
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: CellIdentifier)
        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        let cellText = chartTypes[indexPath.row]
        cell.textLabel!.text = cellText
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let sceneViewController = SceneViewController()
        if(indexPath.row == 0) {
            self.navigationController?.pushViewController(cylinderChartSceneController, animated: false)
        } else if(indexPath.row == 1) {
            self.navigationController?.pushViewController(cubeChartSceneController, animated:false)
        } else {
            self.navigationController?.pushViewController(pieChartSceneController, animated:false)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

