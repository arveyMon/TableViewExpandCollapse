//
//  ViewController.swift
//  TableViewExpandCollapse
//
//  Created by Agasthyam on 28/08/19.
//  Copyright © 2019 Agasthyam. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UITableViewController {
    
    // MARK: Global Variables
    var swiftyJson: JSON = JSON()
    var tableViewData = [celldata]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Parse JSON
        if let path = Bundle.main.path(forResource: "AllMenu", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                swiftyJson = JSON(jsonResult)
                loaddatamodel()
                self.tableView.reloadData()
            } catch {
                print(error)
            }
        }
        }
    
    
    // MARK: Load JSON file into tableViewData Object Array
    func loaddatamodel()
    {
        for i in 0..<swiftyJson.count
        {
            var tempSectionData = [String]()
            var tempSectionName = [String]()
            for j in 0..<swiftyJson[i]["sub_category"].count
            {
                tempSectionName.append(swiftyJson[i]["sub_category"][j]["name"].stringValue)
                tempSectionData.append(swiftyJson[i]["sub_category"][j]["display_name"].stringValue)
            }
            tableViewData.append(celldata(opened: false, title: swiftyJson[i]["name"].stringValue, sectionName: tempSectionName , sectionData: tempSectionData))
        }
    }
    
    
    
  // MARK: Tableview DataSource Methodsa
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewData[section].opened == true {
            return tableViewData[section].sectionData.count + 1
        }
        else{
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let dataIndex = indexPath.row-1
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReuseId", for: indexPath)
                cell.textLabel?.text = tableViewData[indexPath.section].title
                return cell
                }
            else{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReuseId", for: indexPath)
                cell.textLabel?.numberOfLines = 0
                cell.textLabel?.text = tableViewData[indexPath.section].sectionName[dataIndex] + "  : " + tableViewData[indexPath.section].sectionData[dataIndex]
                return cell
                
                
               
                }
    
    }
    
    // MARK: Tableview Delegate Methodsa
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if tableViewData[indexPath.section].opened == true{
                tableViewData[indexPath.section].opened = false
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            }
            else{
                tableViewData[indexPath.section].opened = true
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            }
        
    }

}
