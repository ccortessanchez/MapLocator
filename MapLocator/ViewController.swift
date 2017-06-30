//
//  ViewController.swift
//  MapLocator
//
//  Created by User01 on 30/06/17.
//  Copyright © 2017 User01. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate, MKMapViewDelegate {

    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var showOptionsBtn: UIBarButtonItem!
    
    // Manages the presentation of the search bar
    var searchController: UISearchController!
    // Manages and references any drawn annotation on the map
    var annotation: MKAnnotation!
    // In order to search an adress, a localSearchRequest object is passed to localSearch,
    // and the result is stored in localSearchResponse
    var localSearchRequest: MKLocalSearchRequest!
    var localSearch: MKLocalSearch!
    var localSearchResponse: MKLocalSearchResponse!
    var error: NSError!
    // For pins and annotations placed in the map
    var pointAnnotation: MKPointAnnotation!
    var pinAnnotationView: MKPinAnnotationView!
    
    // Handles the pop up content and embeds a UITableView,
    // with a segmented control and a switch object to show/hide POI
    var contentController: UITableViewController!
    var tableMapOptions: UITableView!
    var mapType: UISegmentedControl!
    var showPointsOfInterest: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 34.03, longitude: 118.14)
        let span = MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 80)
        let region = MKCoordinateRegionMake(coordinate, span)
        self.mapView.setRegion(region, animated: true)
        tableMapOptions = UITableView()
        tableMapOptions.dataSource = self
        contentController = UITableViewController()
        contentController.tableView = tableMapOptions
        mapView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showSearchBar(_ sender: Any) {
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    
    @IBAction func showMapOptions(_ sender: Any) {
        // Setting presentation style -- POP OVER
        contentController.modalPresentationStyle = UIModalPresentationStyle.popover
        // popPC object manages the displayed pop over content
        let popPC: UIPopoverPresentationController = contentController.popoverPresentationController!
        popPC.barButtonItem = showOptionsBtn
        popPC.permittedArrowDirections = UIPopoverArrowDirection.any
        popPC.delegate = self
        present(contentController, animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Dismisses the presented search controller over the search bar
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        //If there are any previous annotation views, removes it
        if self.mapView.annotations.count != 0 {
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
        // Transforms search bar into natural language query in order to look for addresses and points of interest
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (localSearchResponse, error) in
            if localSearchResponse == nil {
                let alertController = UIAlertController(title: nil, message: "Place not found", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            // If the API returns a valid coordinate, instantiates a 2D point and draws it
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = searchBar.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude: localSearchResponse!.boundingRegion.center.longitude)
            
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "cellIdentifier")
            if indexPath.row == 0 {
                mapType = UISegmentedControl(items: ["Standard", "Satellite", "Hybrid"])
                mapType.center = cell.center
            }
            if indexPath.row == 1 {
                showPointsOfInterest = UISwitch()
                cell.textLabel?.text = "Show Points of Interest"
                cell.accessoryView = showPointsOfInterest
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .fullScreen
    }
    
    func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        let navController: UINavigationController = UINavigationController(rootViewController: controller.presentedViewController)
        controller.presentedViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(ViewController.done))
        return navController
    }
    
    func done() {
        presentedViewController?.dismiss(animated: true, completion: nil)
        
        if showPointsOfInterest.isOn {
            mapView.showsPointsOfInterest = true
        } else {
            mapView.showsPointsOfInterest = false
        }
        
        if mapType.selectedSegmentIndex == 0 {
            mapView.mapType = MKMapType.standard
        } else if mapType.selectedSegmentIndex == 1 {
            mapView.mapType = MKMapType.satellite
        } else if mapType.selectedSegmentIndex == 2 {
            mapView.mapType = MKMapType.hybrid
        }
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        done()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        self.pinAnnotationView.rightCalloutAccessoryView = UIButton(type: UIButtonType.infoLight)
        self.pinAnnotationView.canShowCallout = true
        return self.pinAnnotationView
    }

}

