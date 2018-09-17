//
//  ViewController.swift
//  IndoorwayApp
//
//  Created by Mateusz Matejczyk on 10.05.2018.
//  Copyright © 2018 Matejczyk. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    // IBOutlets
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var nameAppLabel: UILabel!
    
    // Globals
    var spinnerIndicator = SpinnerActivityIndicatorView()
    var countriesData = [Country]()
    var filtredCountriesData = [Country]()
    var loaded: Bool = false
    var layer = CALayer()
    var refresher = UIRefreshControl()
    
    // TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return filtredCountriesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CountryTableViewCell
        
        if (loaded == true)
        {
            let country = filtredCountriesData[indexPath.row]
            cell.nameLabel.text = country.name
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let secondVC: DetailTableViewController = storyBoard.instantiateViewController(withIdentifier: "DetailTableView") as! DetailTableViewController
        secondVC.countryData = [filtredCountriesData[indexPath.row]]
        self.present(secondVC, animated: true, completion: nil)
    }
    
    //SearchBar
    
    func isFilteringData() -> Bool
    {
        if (searchBar.text?.isEmpty == true)
        {
            return false
        }
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        guard isFilteringData() == true else
        {
            filtredCountriesData = countriesData
            tableView.reloadData()
            return
        }
        
        filtredCountriesData = countriesData.filter({ (country) -> Bool in
            guard let searchBarText = searchBar.text?.lowercased() else { return false}
            // contains or starts??
            return country.name.lowercased().starts(with: searchBarText) || country.nativeName!.lowercased().starts(with: searchBarText)
        })
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
        filtredCountriesData = countriesData
        self.tableView.reloadData()
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        UIApplication.shared.statusBarStyle = .lightContent
        tableView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        
        
        // UIRefreshControl
        setRefresher()
        
        
        // SearchBar
        setSearchBar()
        
        
        // SpinnerIndicator
        spinnerIndicator.draw(CGRect(x: 0, y: 0, width: 80, height: 80))
        spinnerIndicator.center = view.center
        view.addSubview(spinnerIndicator)
        
        
        // TopView
        setTopView()
        
        
        // LoadingData
        //removeUrlCache()  -> for testing
        filtredCountriesData = countriesData
        tableView.reloadData()
        
        GetCountriesData()
        viewDidLayoutSubviews()
    }
    
    func setSearchBar()
    {
        searchBar.delegate = self
        searchBar.showsScopeBar = false
        searchBar.placeholder = "Search here..."
        searchBar.searchBarStyle  = UISearchBarStyle.prominent
        searchBar.tintColor = UIColor.white
        searchBar.barTintColor = UIColor.clear
        searchBar.backgroundImage = UIImage()
        
        searchBar.tintColor = UIColor.white
        
        searchBar.subviews[0].subviews.compactMap(){ $0 as? UITextField }.first?.tintColor = UIColor.blue
    }
    
    func setRefresher()
    {
        refresher.attributedTitle = NSAttributedString(string: "Pull to get data")
        refresher.addTarget(self, action: #selector(ViewController.GetCountriesData), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresher)
    }
    
    func setTopView()
    {
        let firstGradientColor = UIColor(red: 2/255, green: 178/255, blue: 240/255, alpha: 1.0)
        let secondGradientColor = UIColor(red: 3/255, green: 235/255, blue: 190/255, alpha: 1.0)
        layer = createGradientLayer(firstColor: secondGradientColor, secondColor: firstGradientColor, frame: topView.frame, cornerRadiatus: 0.0)
        topView.layer.insertSublayer(layer, at: 0)
        layer.frame = topView.bounds
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        layer.frame = topView.bounds
        tableView.layoutSubviews()
        tableView.layoutIfNeeded()
        
        switch UIApplication.shared.statusBarOrientation {
        case .portrait:
            nameAppLabel.isHidden = false
            break
        case .portraitUpsideDown:
            nameAppLabel.isHidden = false
            break
        case .landscapeLeft:
            nameAppLabel.isHidden = true
            break
        case .landscapeRight:
            nameAppLabel.isHidden = true
            break
        case .unknown:
            break
        }
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        tableView.layoutSubviews()
        tableView.layoutIfNeeded()
    }
    
    func GetCountryData(name: String)
    {
        spinnerIndicator.start()
        do
        {
            try Country.GetCountryInformation(about: name, completion: { (result: [Country]?) in
                if let country = result
                {
                    DispatchQueue.main.async
                    {
                        self.tableView.reloadData()
                    }
                    self.countriesData = country
                    self.filtredCountriesData = self.countriesData
                    self.loaded = true
                    self.spinnerIndicator.stop()
                }
            })
        }
        catch let error
        {
            print(error)
        }
    }
    
    
    @objc func GetCountriesData()
    {
        if (refresher.isRefreshing ==  false)
        {
            spinnerIndicator.start()
        }
        do
        {
            try NetworkingLayer.sharedInstance.GetData(Url: "all", completionHandler: { (result: Wrapper<Country>) in
                let result = result
                result.status! ? print("success") : print(result.exceptionMessage)
                if let countries = result.returnedData {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    self.countriesData = countries
                    self.filtredCountriesData = countries
                    self.loaded = true
                    
                    DispatchQueue.main.sync {
                        if (self.refresher.isRefreshing ==  false) {
                            self.spinnerIndicator.stop()
                        } else {
                            self.refresher.endRefreshing()
                        }
                        self.animateTable()
                    }
                }
            })
        }
        catch let error
        {
            print(error, "error get()")
        }
        
        if (loaded == false)
        {
            self.spinnerIndicator.stop()
            showNoInternetAlert(controller: self)
        }
    }
    
    func removeUrlCache()
    {
        URLCache.shared.removeAllCachedResponses()
    }
    
    func showNoInternetAlert(controller: UIViewController)
    {
        let alert = UIAlertController(title: "Something went wrong", message: "Check the internet connection then pull the table to download data.", preferredStyle: .alert)
            
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            if self.refresher.isRefreshing
            {
                self.refresher.endRefreshing()
                self.tableView.reloadData()
            }
        }))
        controller.present(alert, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.tableView.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func animateTable()
    {
        DispatchQueue.main.async
            {
                let cells = self.tableView.visibleCells
                
                print("\n\n animation for cell.count: \(cells.count) \n\n")
                
                let tableViewHeight = self.tableView.bounds.size.height
                
                for cell in cells
                {
                    cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
                }
                
                var delayCounter = 0
                
                for cell in cells
                {
                    UIView.animate(withDuration: 1.0, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                        cell.transform = CGAffineTransform.identity
                    }, completion: nil)
                    delayCounter += 1
                }
            if cells.count == 0 {self.tableView.reloadData()}
        }
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

