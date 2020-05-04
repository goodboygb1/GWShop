//
//  AllProductSoldInOneDayReportViewController.swift
//  GWShopReal
//
//  Created by PMJs on 4/5/2563 BE.
//  Copyright © 2563 PMJs. All rights reserved.
//

import UIKit

class AllProductSoldInOneDayReportViewController: UIViewController {
    
    var splitDate : [String] = []
    var dateString : String = ""
    
    @IBOutlet weak var datePickerLabel: UIDatePicker!
    
    @IBAction func datePicker(_ sender: UIDatePicker) {
        
        firstTimeSetDate()
        splitStringAndPackIntoArray()
        
    }
    
    
    @IBOutlet weak var showReportLable: UIButton!
    
    @IBAction func showReportButton(_ sender: UIButton) {
        performSegue(withIdentifier: K.segue.showAllProducrSellInOneDay, sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstTimeSetDate()
        splitStringAndPackIntoArray()
        showReportLable.layer.cornerRadius = showReportLable.frame.size.height/5
        
    }
    
    func firstTimeSetDate()  {                                  //set date if user don't slide picker
        let dateFormmater = DateFormatter()
        dateFormmater.dateFormat = "dd MM yyyy"
        dateString = dateFormmater.string(from: datePickerLabel.date)
    }
    
    func splitStringAndPackIntoArray()  {
        var splitArray = dateString.components(separatedBy: " ")    // split
        
        switch splitArray[1] {                                      // change month to alphabet
        case "01":
            splitArray[1] = "January"
        case "02":
            splitArray[1] = "Febuary"
        case "03":
            splitArray[1] = "March"
        case "04":
            splitArray[1] = "April"
        case "05":
            splitArray[1] = "May"
        case "06":
            splitArray[1] = "June"
        case "07":
            splitArray[1] = "July"
        case "08":
            splitArray[1] = "August"
        case "09":
            splitArray[1] = "September"
        case "10":
            splitArray[1] = "October"
        case "11":
            splitArray[1] = "November"
        case "12":
            splitArray[1] = "December"
        default:
            splitArray[1] = "empty"
        }
        
        splitDate = splitArray
        print(splitDate)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segue.showAllProducrSellInOneDay {
            let destinationVC =  segue.destination as! ShowAllProductViewController
            destinationVC.dateSplitArray = splitDate
        }
    }
    
}
