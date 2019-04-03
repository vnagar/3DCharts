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
  
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
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
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.frame = CGRect.zero
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        
        // Create a bottom space constraint
        var constraint = NSLayoutConstraint (item: tableView!,
                                             attribute: NSLayoutConstraint.Attribute.bottom,
                                             relatedBy: NSLayoutConstraint.Relation.equal,
                                             toItem: self.view,
                                             attribute: NSLayoutConstraint.Attribute.bottom,
                                             multiplier: 1,
                                             constant: 0)
        self.view.addConstraint(constraint)
        // Create a top space constraint
        constraint = NSLayoutConstraint (item: tableView!,
                                         attribute: NSLayoutConstraint.Attribute.top,
                                         relatedBy: NSLayoutConstraint.Relation.equal,
                                         toItem: self.view,
                                         attribute: NSLayoutConstraint.Attribute.top,
                                         multiplier: 1,
                                         constant: 0)
        self.view.addConstraint(constraint)
        // Create a right space constraint
        constraint = NSLayoutConstraint (item: tableView!,
                                         attribute: NSLayoutConstraint.Attribute.right,
                                         relatedBy: NSLayoutConstraint.Relation.equal,
                                         toItem: self.view,
                                         attribute: NSLayoutConstraint.Attribute.right,
                                         multiplier: 1,
                                         constant: 0)
        self.view.addConstraint(constraint)
        // Create a left space constraint
        constraint = NSLayoutConstraint (item: tableView!,
                                         attribute: NSLayoutConstraint.Attribute.left,
                                         relatedBy: NSLayoutConstraint.Relation.equal,
                                         toItem: self.view,
                                         attribute: NSLayoutConstraint.Attribute.left,
                                         multiplier: 1,
                                         constant: 0)
        self.view.addConstraint(constraint)
        
        cylinderChartSceneController = SceneViewController(type:ChartType.cylinder)
        cubeChartSceneController = SceneViewController(type:ChartType.cube)
        pieChartSceneController = SceneViewController(type:ChartType.pie)
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chartTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CellIdentifier = "CellIdentifier"
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: CellIdentifier)
        
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        
        let cellText = chartTypes[(indexPath as NSIndexPath).row]
        cell.textLabel!.text = cellText
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if((indexPath as NSIndexPath).row == 0) {
            self.navigationController?.pushViewController(cylinderChartSceneController, animated: false)
        } else if((indexPath as NSIndexPath).row == 1) {
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

