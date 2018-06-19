//
//  DetailTableViewController.swift
//  IndoorwayApp
//
//  Created by Mateusz Matejczyk on 14.05.2018.
//  Copyright © 2018 Matejczyk. All rights reserved.
//

import UIKit
import MapKit

class DetailTableViewController: UITableViewController {

    @IBOutlet var detailTableView: UITableView!
    let cellIds = ["TitleCell", "MapCell", "DetailCell", "Detail2Cell", "Back"]
    var countryData = [Country]()

    
    // TITLE CELL
    @IBOutlet weak var titleCell: UITableViewCell!
    @IBOutlet weak var bcgTitleView: UIView!
    @IBOutlet weak var nameLabelTitleView: UILabel!
    
    
    // MAP CELL
    @IBOutlet weak var mapCell: UITableViewCell!
    @IBOutlet weak var bcgMapCell: UIView!
    @IBOutlet weak var mapViewMapCell: MKMapView!
    
    
    // Detail CELL
    @IBOutlet weak var detailCell: UITableViewCell!
    @IBOutlet weak var bcgDetailCell: UIView!
    @IBOutlet weak var capitalLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    @IBOutlet weak var bordersHeaderLabel: UILabel!
    @IBOutlet weak var bordersListLabel: UILabel!
    
    
    // Detail2 CELL
    @IBOutlet weak var detail2Cell: UITableViewCell!
    @IBOutlet weak var nativeNameLabel: UILabel!
    @IBOutlet weak var timezonesLabel: UILabel!
    @IBOutlet weak var callingCodesLabel: UILabel!
    @IBOutlet weak var bcgDetail2Cell: UIView!
    
    
    // Back Cell
    @IBOutlet weak var backCell: UITableViewCell!
    @IBOutlet weak var bcgBackCell: UIView!
    @IBOutlet weak var backButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.statusBarStyle = .default
        
        // tableview
        detailTableView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        
        // titleCell
        setTitleCell()
 
        
        // Back Cell
        setBackCell()
        
        // mapCell
        setMapCell()
        
        //setMapView()
        mapShowCountry()
        
        // detailCell
        setDetailCell()
        
        // detail2Cell
        setDetail2Cell()
        
        //Blur Status Bar
        createStatusBarBlur()
    }
    
    func setBackCell()
    {
        backCell.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
    }
    
    func setTitleCell()
    {
        titleCell.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        bcgTitleView.layer.cornerRadius = 15.0
        bcgTitleView.backgroundColor = UIColor.white
        nameLabelTitleView.text = countryData.first?.name
    }
    
    func setMapCell()
    {
        mapCell.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        bcgMapCell.layer.cornerRadius = 15.0
        bcgMapCell.backgroundColor = UIColor.white
        mapViewMapCell.layer.cornerRadius = 15.0
    }
    
    func setDetailCell()
    {
        let data = countryData.first
        detailCell.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        bcgDetailCell.layer.cornerRadius = 15.0
        bcgDetailCell.backgroundColor = UIColor.white
        capitalLabel.text?.append(" \(data?.capital ?? "error 404")")
        regionLabel.text?.append(" \(data?.region ?? "error 404")")
        areaLabel.text?.append(" \(data?.area ?? 0) km²")
        populationLabel.text?.append(" \(data?.population ?? 0)")
        bordersListLabel.text = ""
        
        
        for border in (data?.borders)!
        {
            bordersListLabel.text?.append(contentsOf: " \(border) ")
        }
        
        if (bordersListLabel.text == "")
        {
            bordersListLabel.text = "Does not border with any other country"
        }
    }
    
    func setDetail2Cell()
    {
        let data = countryData.first
        detail2Cell.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        bcgDetail2Cell.layer.cornerRadius = 15.0
        bcgDetail2Cell.backgroundColor = UIColor.white
        nativeNameLabel.text?.append(" \(data?.nativeName ?? "error 404")")
        if ((data?.timezones)?.count)! > 1
        {
            timezonesLabel.text?.append(contentsOf: " \(data!.timezones!.first!) to")
            timezonesLabel.text?.append(contentsOf: " \(data!.timezones!.last!)")
        }
        else
        {
            timezonesLabel.text?.append(contentsOf: " \(data!.timezones!.first!)")
        }
        
        for code in (data?.callingCodes)!
        {
            callingCodesLabel.text?.append(contentsOf: " +\(code) ")
        }
    }
    
    func createStatusBarBlur()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blurEffectView)
        blurEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        blurEffectView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        blurEffectView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        blurEffectView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
    
    override func viewDidLayoutSubviews() {
        bcgTitleView.setCardViewShadow()
        bcgMapCell.setCardViewShadow()
        bcgDetailCell.setCardViewShadow()
        bcgDetail2Cell.setCardViewShadow()
        bcgBackCell.setCardViewShadow()
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        viewDidLayoutSubviews()
    }
    
    func mapShowCountry()
    {
        let location2D = CLLocationCoordinate2D(latitude: CLLocationDegrees((countryData.first?.latlng![0])!), longitude: CLLocationDegrees((countryData.first?.latlng![1])!))
        let sqrtArea = sqrt((countryData.first?.area)!) * 1.5 * 1000
        let region = MKCoordinateRegionMakeWithDistance(location2D, sqrtArea, sqrtArea)
        mapViewMapCell.setRegion(region, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellIds.count
    }
}

extension UIView
{
    func setCardViewShadow()
    {
         let cornerRadius: CGFloat = 15
        
         let shadowOffsetWidth: Int = 0
         let shadowOffsetHeight: Int = 3
        let shadowColor: UIColor? = UIColor.black
         let shadowOpacity: Float = 0.5
        
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
    }
}
