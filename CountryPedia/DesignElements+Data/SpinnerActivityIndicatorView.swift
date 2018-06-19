//
//  SpinnerActivityIndicatorView.swift
//  IndoorwayApp
//
//  Created by Mateusz Matejczyk on 12.05.2018.
//  Copyright © 2018 Matejczyk. All rights reserved.
//

import UIKit

class SpinnerActivityIndicatorView: UIActivityIndicatorView {

    override func draw(_ rect: CGRect) {
        self.activityIndicatorViewStyle = .gray
        self.hidesWhenStopped = true
        self.isHidden = false
        self.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
    }
    
    func start()
    {
        startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func stop()
    {
        self.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}
