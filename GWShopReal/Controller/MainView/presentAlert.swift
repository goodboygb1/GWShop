//
//  presentAlert.swift
//  GWShopReal
//
//  Created by PMJs on 2/5/2563 BE.
//  Copyright © 2563 PMJs. All rights reserved.
//

import Foundation
import UIKit

class presentAlert: UIViewController {
    
    func presentAlert(title:String,message:String,actiontitle:String)  {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actiontitle, style: .default, handler: nil)
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

}
