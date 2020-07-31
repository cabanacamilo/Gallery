//
//  CostumizeAlert.swift
//  Gallery
//
//  Created by Camilo Cabana on 31/07/20.
//  Copyright © 2020 Camilo Cabana. All rights reserved.
//

import UIKit

class CostumizeAlert {
    static let costumizeAlert = CostumizeAlert()
    
    func alert(_ vc: UIViewController, title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        vc.present(alert, animated: true)
    }
}
