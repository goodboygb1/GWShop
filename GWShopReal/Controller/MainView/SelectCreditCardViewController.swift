//
//  SelectCreditCardViewController.swift
//  GWShopReal
//
//  Created by PMJs on 3/5/2563 BE.
//  Copyright © 2563 PMJs. All rights reserved.
//

import UIKit

protocol changeCreditCardDelegate {
    func changeCreditCard(From : Card)
}

class SelectCreditCardViewController: UIViewController {

    var delegate : changeCreditCardDelegate? = nil
    
    var creditCard : [Card] = []
    @IBOutlet weak var selectedCreditCardTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        selectedCreditCardTableView.delegate = self
        selectedCreditCardTableView.dataSource = self
    }
    
}

extension SelectCreditCardViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creditCard.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let creditCardForCell = creditCard[indexPath.row]
        let cell = selectedCreditCardTableView.dequeueReusableCell(withIdentifier: K.identifierForTableView.SelectedCreditCardCell) as! SelectCreditCardTableViewCell
        
        cell.cardNumber.text = creditCardForCell.cardNumber
        cell.holderNumber.text = creditCardForCell.cardName
        cell.expireDate.text = creditCardForCell.expiredDate
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        delegate?.changeCreditCard(From: creditCard[indexPath.row])
        navigationController?.popViewController(animated: true)
    }
    
    
    
    
    
    
}
