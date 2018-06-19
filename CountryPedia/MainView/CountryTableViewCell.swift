//
//  CountryTableViewCell.swift
//  IndoorwayApp
//
//  Created by Mateusz Matejczyk on 12.05.2018.
//  Copyright © 2018 Matejczyk. All rights reserved.
//

import UIKit

class CountryTableViewCell: UITableViewCell {

    
    @IBOutlet weak var bcgView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        self.bcgView.backgroundColor = UIColor.white
        self.bcgView?.layer.cornerRadius = 15.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        self.contentView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        self.bcgView.backgroundColor = UIColor.white
        self.bcgView?.layer.cornerRadius = 15.0
    }
    
    func createGradientLayer(firstColor: UIColor, secondColor: UIColor, frame: CGRect, cornerRadiatus: CGFloat) -> CAGradientLayer
    {
        let gradient = CAGradientLayer()
        gradient.colors = [firstColor.cgColor, secondColor.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.8, y: 1.0)
        gradient.frame = frame
        gradient.cornerRadius = cornerRadiatus
        return gradient
    }
}
