//
//  PinDetailsViewController.swift
//  MapLocator
//
//  Created by User01 on 30/06/17.
//  Copyright © 2017 User01. All rights reserved.
//

import UIKit
import MapKit

class PinDetailsViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var mapItemData: MKMapItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "cellIdentifier")
            if indexPath.row == 0 {
                cell.textLabel?.text = mapItemData.name
            }
            if indexPath.row == 1 {
                cell.textLabel?.text = mapItemData.placemark.country
                cell.detailTextLabel?.text = mapItemData.placemark.countryCode
            }
            if indexPath.row == 2 {
                cell.textLabel?.text = mapItemData.placemark.postalCode
            }
            if indexPath.row == 3 {
                cell.textLabel?.text = "Phone number"
                cell.detailTextLabel?.text = mapItemData.phoneNumber
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
