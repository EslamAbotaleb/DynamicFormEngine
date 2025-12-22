//
//  MapTableViewCell.swift
//  CHECK
//
//  Created by Yasser Osama on 01/02/2022.
//

import UIKit
import MapKit

class MapTableViewCell: UITableViewCell {

    @IBOutlet weak var labelView: LabelView!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var mapOuterView: UIView!
    @IBOutlet weak var mapKitView: MKMapView!
    @IBOutlet weak var zipCodeView: UIView!
    @IBOutlet weak var zipCodeLabel: UILabel!
    
    var item: FormViewModelItem! {
        didSet {
            if let item = item as? FormViewModelMapItem {
                labelView.item = item
                locationLabel.text = item.address
                if let lat = item.lat, let lng = item.lng {
                    self.lat = lat
                    self.lng = lng
                    mapOuterView.isHidden = false
                    setMapRegion(lat: lat, lng: lng, zoom: item.zoom)
                }
                zipCodeView.isHidden = true
                if let showZipCode = item.showPostalCode, showZipCode {
                    zipCodeView.isHidden = false
                    zipCodeLabel.text = "Zipcode" + ": \(item.postalCode ?? "")"
                }
            }
        }
    }
    
    var isEditable: Bool! = true {
        didSet {
            labelView.isEditable = isEditable
        }
    }
    
    var lat: Double?
    var lng: Double?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        zipCodeView.addCornerRadius(5)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(mapTapped))
        mapKitView.addGestureRecognizer(tap)
    }
    
    func setMapRegion(lat: Double, lng: Double, zoom: Int?) {
        var zoomLevel = 10
        if let zoom = zoom {
            zoomLevel = zoom
        }
        let coordinates = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        let span = MKCoordinateSpan(latitudeDelta: 0, longitudeDelta: 360 / pow(2, Double(zoomLevel)) * Double(self.frame.size.width) / 256)
        let region = MKCoordinateRegion(center: coordinates, span: span)
        mapKitView.setRegion(region, animated: true)
        mapKitView.removeAnnotations(mapKitView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        
        mapKitView.addAnnotation(annotation)
    }
    
    @objc func mapTapped() {
        if let lat = lat, let lng = lng {
            if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) {
//                UIApplication.shared.open(URL(string: Utilities.getGoogleMapsURL().replacingOccurrences(of: "#lat", with: "\(lat)").replacingOccurrences(of: "#lng", with: "\(lng)"))!, options: [:], completionHandler: nil)
            } else {
//                let alert = UIAlertController(title: "Alert", message: "Google Maps not installed", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "Done", style: .default))
//                self.parentContainerViewController()?.present(alert, animated: true, completion: nil)
            }
        }
    }
}
