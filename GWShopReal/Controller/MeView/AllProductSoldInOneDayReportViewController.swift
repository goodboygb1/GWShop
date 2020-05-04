//
//  AllProductSoldInOneDayReportViewController.swift
//  GWShopReal
//
//  Created by PMJs on 4/5/2563 BE.
//  Copyright © 2563 PMJs. All rights reserved.
//

import UIKit

class AllProductSoldInOneDayReportViewController: UIViewController {

    var dateFromPicker : date?
    var dateString : String = ""
    
    @IBOutlet weak var datePickerLabel: UIDatePicker!
    
    @IBAction func datePicker(_ sender: UIDatePicker) {
       
        let dateFormmater = DateFormatter()
        dateFormmater.dateFormat = "dd MM yyyy"
        dateString = dateFormmater.string(from: sender.date)
        
        
    }
    
    @IBAction func showRepotButton(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
           super.viewDidLoad()
            firstTimeSetDate()
           
       }
    
    func firstTimeSetDate()  {
         let dateFormmater = DateFormatter()
               dateFormmater.dateFormat = "dd MM yyyy"
               dateString = dateFormmater.string(from: datePickerLabel.date)
    }
    
}
