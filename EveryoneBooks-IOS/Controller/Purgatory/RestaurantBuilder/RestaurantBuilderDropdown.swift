//
//  RestaurantBuilderDropdown.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 4/2/22.
//  Copyright © 2022 Michael Perrone. All rights reserved.
//

import Foundation
import UIKit

class RestaurantBuilderDropDown: GenericDropDown {
    
    var changeDelegate: RestaurantBuilderDelegate?
    
   override func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if data.count > 0 {
            self.selectedItem = data[row];
            changeDelegate?.changed(selected: data[row]);
        }
    }
}
