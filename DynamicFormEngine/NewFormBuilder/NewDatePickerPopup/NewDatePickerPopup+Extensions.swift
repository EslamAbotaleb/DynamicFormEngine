//
//  NewDatePickerPopup+Extensions.swift
//  CERQEL
//
//  Created by Mohamed Nagi on 30/12/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import UIKit

extension NewDatePickerPopup: UIPickerViewDelegate, UIPickerViewDataSource {
  public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataArray.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (dataArray.count > 0) {
            selectedIndex = row
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let title = dataArray[row]
        return title
    }
}
