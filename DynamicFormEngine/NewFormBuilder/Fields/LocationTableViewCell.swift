//
//  LocationTableViewCell.swift
//  CHECK
//
//  Created by Yasser Osama on 06/02/2022.
//

import UIKit
import MapKit


class LocationTableViewCell: ParentFieldTableViewCell {
    
    @IBOutlet weak var labelView: LabelView!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationsNamesStackView: UIStackView!
    @IBOutlet weak var mapOuterView: UIView!
    @IBOutlet weak var mapKitView: MKMapView!
    @IBOutlet weak var zipCodeView: UIView!
    @IBOutlet weak var zipCodeLabel: UILabel!
    @IBOutlet weak var addLocationView: UIView!
    @IBOutlet weak var attachmentNoteView: AttachmentNoteView!

    var item: FormViewModelItem! {
        didSet {
            if let item = item as? FormViewModelLocationItem {
                labelView.item = item
                labelView.required = item.required
                attachmentNoteView.item = item
                places.removeAll()
                allShown = item.allShown
                if let value = (item.answer as? LocationAnswer)?.value {
                    places = value
                }
                handlePlacesData()
            }
        }
    }
    
    var isEditable: Bool! = true {
        didSet {
            attachmentNoteView.isEditable = isEditable
            labelView.isEditable = isEditable
            if let item = item as? FormViewModelInteractiveItem {
                handleHideAttachment(isEditable, item: item)
            }
            if !isEditable {
                addLocationView.isHidden = true
                if places.count == 0 {
                    locationView.isHidden = true
                }
            }
        }
    }
    
    var places = [Place]()
    var valueChanged: ((LocationAnswer) -> ())?
    var allShownChanged: ((Bool) -> ())?
    var allShown = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        super.attachmentView = attachmentNoteView
        
        setupUI()
    }
    
    func setupUI() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(openMap))
        locationView.addGestureRecognizer(tap)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(openMap))
        addLocationView.addGestureRecognizer(tap2)
        
//        addLocationView.addCornerRadius(5)
//        mapKitView.addCornerRadius(5)
    }
    
    @objc func openMap(isView: Bool = false) {
//        let mapVC = Utilities.instantiateVCWithId("mapVC") as! MapViewController
//        mapVC.delegate = self
//        if isView {
//            mapVC.addMode = false
//            mapVC.places = places
//        }
//        mapVC.isDetails = !isEditable
//        let navController = UINavigationController(rootViewController: mapVC)
//        self.parentContainerViewController()?.present(navController, animated: true, completion: nil)
    }
    
    func handlePlacesData() {
        if places.count > 0 {
            locationsNamesStackView.isHidden = false
            locationView.isHidden = true
            addLocationView.isHidden = false
            mapOuterView.isHidden = false
            handleLocationNames()
        } else {
            locationsNamesStackView.isHidden = true
            locationView.isHidden = false
            addLocationView.isHidden = true
            mapOuterView.isHidden = true
        }
    }
    
    func handleLocationNames() {
        for view in locationsNamesStackView.subviews {
            view.removeFromSuperview()
        }
        mapKitView.removeAnnotations(mapKitView.annotations)
        for place in places {
            if let lat = place.lat, let lng = place.lng {
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                mapKitView.addAnnotation(annotation)
            }
        }
        for (i, place) in places.enumerated() {
            let locationNameView = LocationNameView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 50))
            locationNameView.locationNameLabel.text = place.address
            locationsNamesStackView.addArrangedSubview(locationNameView)
            if !allShown, i == 1 {
                break
            }
        }
        
        if places.count > 2 {
            var title = ""
            if allShown {
                title = "Show less"
            } else {
                title = "Show more #count locations".replacingOccurrences(of: "#count", with: "\(places.count - 2)")
            }
            let showMoreView = ShowMoreView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 40))
            showMoreView.showMoreButton.setTitle(title, for: .normal)
            showMoreView.showMoreButton.addTarget(self, action: #selector(showMoreAction(_:)), for: .touchUpInside)
            UIView.animate(withDuration: 0.1, animations: {
                self.locationsNamesStackView.addArrangedSubview(showMoreView)
            }, completion: nil)
        }
        self.locationsNamesStackView.translatesAutoresizingMaskIntoConstraints = false
        mapKitView.showAnnotations(mapKitView.annotations, animated: true)
    }
    
    @IBAction func fullScreenAction(_ sender: UIButton) {
        openMap(isView: true)
    }
    
    @objc func showMoreAction(_ sender: UIButton) {
        allShown.toggle()
        allShownChanged?(allShown)
    }
    
    func reloadCell() {
        handlePlacesData()
    }
}

//extension LocationTableViewCell: MapVCDelegate {
//    func userSelectedLocation(place: Place) {
//        places.append(place)
//        valueChanged?(LocationAnswer(val: places))
//    }
//    
//    func userClearedLocation() {
//        locationLabel.text = "Click to pin location".localized
//    }
//    
//    func userUpdatedLocations(places: [Place]) {
//        self.places = places
//        valueChanged?(LocationAnswer(val: self.places))
//    }
//}
