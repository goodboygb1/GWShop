//
//  SelectedAddressViewController.swift
//  GWShopReal
//
//  Created by PMJs on 3/5/2563 BE.
//  Copyright © 2563 PMJs. All rights reserved.
//

import UIKit

protocol changeAddressDelegate {
    func changeAddress(From : Address)
}

class SelectedAddressViewController: UIViewController {

    @IBOutlet weak var selectAddressTableView: UITableView!
    
    var addressForSelect : [Address]?
    
    var delegate : changeAddressDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        selectAddressTableView.delegate = self
        selectAddressTableView.dataSource = self
    }
}

//MARK: - extension for table view

extension SelectedAddressViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let addressForCell = addressForSelect![indexPath.row]
        let cell = selectAddressTableView.dequeueReusableCell(withIdentifier: K.identifierForTableView.SelectedAddressCell) as! SelectedAddressCell
        cell.recieveName.text = "\(addressForCell.firstName) \(addressForCell.lastName)"
        cell.phoneNumber.text = addressForCell.phoneNumber
        cell.addressDetailAndDistinc.text = "\(addressForCell.addressDetail) \(addressForCell.district)"
        cell.provinceAndPostCode.text = "\(addressForCell.province) \(addressForCell.postCode)"
        print("\(cell.provinceAndPostCode.text)")
       
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressForSelect!.count
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let addressSelectedByUser = addressForSelect![indexPath.row]
        print("User selected = \(addressSelectedByUser.firstName)")
        delegate!.changeAddress(From: addressSelectedByUser)
        navigationController?.popViewController(animated: true)
    }
    
    
    
}
