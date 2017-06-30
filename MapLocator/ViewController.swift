//
//  ViewController.swift
//  MapLocator
//
//  Created by User01 on 30/06/17.
//  Copyright © 2017 User01. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, UISearchBarDelegate {

    
    @IBOutlet weak var mapView: MKMapView!
    
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
    //For pins and annotations placed in the map
    var pointAnnotation: MKPointAnnotation!
    var pinAnnotationView: MKPinAnnotationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 34.03, longitude: 118.14)
        let span = MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 80)
        let region = MKCoordinateRegionMake(coordinate, span)
        self.mapView.setRegion(region, animated: true)
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //Dismisses the presented search controller over the search bar
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        //If there are any previous annotation views, removes it
        if self.mapView.annotations.count != 0 {
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
        //Transforms search bar into natural language query in order to look for addresses and points of interest
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
            //If the API returns a valid coordinate, instantiates a 2D point and draws it
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = searchBar.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude: localSearchResponse!.boundingRegion.center.longitude)
            
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
        }
    }

}

