//
//  DateTimeRangePickerTVcell.swift
//  GAZT
//
//  Created by iSlam AbdelAziz on 12/08/2021.
//  Copyright © 2021 Youxel. All rights reserved.
//

import UIKit

class DateTimeRangePickerTVcell: ControlTVcell {
    
    @IBOutlet weak var dateFromContainerView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dateFromValueTF: UITextField!
    
    @IBOutlet weak var timeFromContainerView: UIView!
    @IBOutlet weak var dateToContainerView: UIView!
    @IBOutlet weak var dateToValueTF: UITextField!
    
    @IBOutlet weak var timeToContainerView: UIView!
    @IBOutlet weak var timeFromValueTF: UITextField!
    @IBOutlet weak var timeToValueTF: UITextField!
    
    @IBOutlet weak var numOfDaysTF: UITextField!

    var didTapDate:((Bool)->())? // if true -> From date else To date
    var didTapTime:((Bool)->())? // if true -> From Time else To time
    
    var formatter = DateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        dateFromValueTF.addIconView(img: UIImage(named: "callenadrr")!, isRight: true)
//        dateFromValueTF.addIconView(img: UIImage())
//        
//        dateToValueTF.addIconView(img: UIImage(named: "callenadrr")!, isRight: true)
//        dateToValueTF.addIconView(img: UIImage())
        
//        timeFromValueTF.addIconView(img: UIImage(named: "clock (2) 1")!, isRight: true)
//        timeFromValueTF.addIconView(img: UIImage())
//        
//        timeToValueTF.addIconView(img: UIImage(named: "clock (2) 1")!, isRight: true)
//        timeToValueTF.addIconView(img: UIImage())
        
//        numOfDaysTF.addIconView(img: UIImage(named: "callenadrr")!, isRight: true)
//        numOfDaysTF.addIconView(img: UIImage())
        numOfDaysTF.placeholder = "Days Number".localized
        
        formatter.timeZone = currentTimeZoneCerqel //TimeZone.current//
        formatter.locale = dateFormatterLocal_en_USCerqel

        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func configure(control: ModelControlCerqel) {
        self.titleLbl.text = control.label
        self.descriptionLbl.text = control.description ?? ""
        //        fromValueTF.placeholder = control.placeHolder
        //        toValueTF.placeholder = control.placeHolder
        self.controlData = control
        
        if let val = control.value as? [String]{
            if val.count >= 1{
                
                formatter.dateFormat = control.format ?? ""
                
                if let dt = formatter.date(from: val[0]){
                    formatter.dateFormat = control.dateFormat ?? ""
                    dateFromValueTF.text = formatter.string(from: dt)
                    
                    formatter.dateFormat = control.timeFormat ?? ""
                    timeFromValueTF.text = formatter.string(from: dt)

                }else{
                    dateFromValueTF.text = ""
                    timeFromValueTF.text = ""

                }
                
                if val.count > 2, val[2] != ""{
                    numOfDaysTF.text = "\(val[2]) \("days".localized)"
                }else{
                    numOfDaysTF.text = ""
                }
                
            }
            
            if val.count >= 2{
//                dateToValueTF.text = val[1]
                formatter.dateFormat = control.format ?? ""
                
                if let dt = formatter.date(from: val[1]){
                    formatter.dateFormat = control.dateFormat ?? ""
                    dateToValueTF.text = formatter.string(from: dt)
                    
                    formatter.dateFormat = control.timeFormat ?? ""
                    timeToValueTF.text = formatter.string(from: dt)

                }

            }else{
                dateToValueTF.text = ""
                timeToValueTF.text = ""
            }
        }else{
            dateFromValueTF.text = ""
            dateToValueTF.text = ""
            timeFromValueTF.text = ""
            timeToValueTF.text = ""
        }
        
        if let fromPlaceholder = control.dateFromPlaceholder{
            dateFromValueTF.placeholder = fromPlaceholder
        }
        
        if let toPlaceholder = control.dateToPlaceholder{
            dateToValueTF.placeholder = toPlaceholder
        }
        
        if let fromPlaceholder = control.timeFromPlaceholder{
            timeFromValueTF.placeholder = fromPlaceholder
        }
        
        if let toPlaceholder = control.timeToPlaceholder{
            timeToValueTF.placeholder = toPlaceholder
        }
        
        if !control.isValid, let _ = control.notValidType{
            dateFromContainerView.borderColorV = .red
            dateToContainerView.borderColorV = .red
            timeFromContainerView.borderColorV = .red
            timeToContainerView.borderColorV = .red

        }else{
            dateFromContainerView.borderColorV = .veryLightPink
            dateToContainerView.borderColorV = .veryLightPink
            timeFromContainerView.borderColorV = .veryLightPink
            timeToContainerView.borderColorV = .veryLightPink
        }
        
        if control.readOnly ?? false{
            dateFromValueTF.backgroundColor = .veryLightPink
            dateToValueTF.backgroundColor = .veryLightPink
            timeFromValueTF.backgroundColor = .veryLightPink
            timeToValueTF.backgroundColor = .veryLightPink
        }else{
            dateFromValueTF.backgroundColor = .white
            dateToValueTF.backgroundColor = .white
            timeFromValueTF.backgroundColor = .white
            timeToValueTF.backgroundColor = .white
        }
    }
    
    @IBAction func didTapFromDateBtn(){
        didTapDate?(true)
    }
    
    @IBAction func didTapToDateBtn(){
        didTapDate?(false)
    }
    
    @IBAction func didTapFromTimeBtn(){
        didTapTime?(true)
    }
    
    @IBAction func didTapToTimeBtn(){
        didTapTime?(false)
    }
    

}
