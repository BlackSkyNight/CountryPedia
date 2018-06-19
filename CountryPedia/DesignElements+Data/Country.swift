//
//  Country.swift
//  IndoorwayApp
//
//  Created by Mateusz Matejczyk on 10.05.2018.
//  Copyright © 2018 Matejczyk. All rights reserved.
//

import Foundation

struct Country: Codable
{
    static let baseCountrySearchURL = "https://restcountries.eu/rest/v2/name/"
    
    enum JSONError: Error
    {
        case missingData(String)
        case badName(String)
        case requestURLBuilding(String)
    }
    
    struct currencie: Codable
    {
        var code: String?
        var name: String?
        var symbol: String?
    }
    
    struct language: Codable
    {
        var iso639_1: String?
        var iso639_2: String?
        var name: String?
        var nativeName: String?
    }
    
    struct translation: Codable
    {
        var de: String?
        var es: String?
        var fr: String?
        var ja: String?
        var it: String?
        var br: String?
        var pt: String?
        var nl: String?
        var hl: String?
        var fa: String?
    }
    
    struct regionalBloc: Codable
    {
        var acronym: String?
        var name: String?
        var otherAcronyms: [String]?
        var otherNames: [String]?
    }
    
    var name: String
    var topLevelDomain: [String]?
    var alpha2Code: String?
    var alpha3Code: String?
    var callingCodes: [String]?
    var capital: String?
    var altSpellings: [String]?
    var region: String?
    var subregion: String?
    var population: Int64?
    var latlng: [Double]?
    var demonym: String?
    var area: Double?
    var gini: Double?
    var timezones: [String]?
    var borders: [String]?
    var nativeName: String?
    var numericCode: String?
    var currencies: [currencie]?
    var languages: [language]?
    var flag: String?
    var regionalBlocs: [regionalBloc]?
    var cioc: String?
 
    
    static func GetCountryInformation(about name: String, completion: @escaping ([Country]) -> ()) throws
    {
        let requestURLString = baseCountrySearchURL + name
        guard let request = URL(string: requestURLString) else
        {
            throw JSONError.requestURLBuilding("cannot build URLRequest")
        }
        
     
            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                
                guard error == nil else
                {
                    print("\(error?.localizedDescription ?? "error 404")")
                    return
                }
                
                guard let data = data else
                {
                    print("missing data")
                    return
                }
                
                var countryData = [Country]()
                
                do
                {
                    let countryJSONData = try JSONDecoder().decode([Country].self, from: data)
                    countryData = countryJSONData
                }
                catch let jsonError
                {
                    print("Error during parsing", jsonError)
                }
                completion(countryData)
            
            }
        dataTask.resume()
        }
    
    
    static func GetCountriesInformations(completion: @escaping ([Country]) -> ()) throws
    {
        let requestURLString = "https://restcountries.eu/rest/v2/all"
        guard let request = URL(string: requestURLString) else
        {
            throw JSONError.requestURLBuilding("cannot build URLRequest")
        }
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 10
        sessionConfig.timeoutIntervalForResource = 10
        
        let session = URLSession(configuration: sessionConfig)
    
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            
            
            guard error == nil else
            {
                print("\(error?.localizedDescription  ?? "error 404") URLSession error")
                return
            }
            
            guard let data = data else
            {
                print("missing data")
                return
            }
            
            var countryData = [Country]()
            
            do
            {
                let countryJSONData = try JSONDecoder().decode([Country].self, from: data)
                countryData = countryJSONData
            }
            catch let jsonError
            {
                print("Error during parsing -> ", jsonError)
            }
            completion(countryData)
        }
        dataTask.resume()
    }
    
}
