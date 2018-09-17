//
//  Networking.swift
//  CountryPedia
//
//  Created by Mateusz Matejczyk on 17.09.2018.
//  Copyright © 2018 Matejczyk. All rights reserved.
//

import Foundation


class NetworkingLayer
{
    private init() {}
    static let sharedInstance: NetworkingLayer = {
        let instance = NetworkingLayer()
        return instance
    }()
    
    private var baseURL: String = "https://restcountries.eu/rest/v2/"
    private let session = URLSession.shared

    private enum NetworkingError: Error {
        case WrongURL(String)
        case MissingData(String)
        case DataTask(String)
        case ParseError(String)
    }
    
    
    func GetData<T: Codable>(Url: String, completionHandler: @escaping (Wrapper<T>) -> ()) throws {
        let requestUrlString = baseURL + Url
        let result: Wrapper = Wrapper<T>()
        
        guard let requestUrl = URL(string: requestUrlString) else {
            throw NetworkingError.WrongURL("404")
        }
        
        let dataTask = session.dataTask(with: requestUrl) { (data, response, error) in
            guard let data = data else {
                result.exceptionMessage = NetworkingError.MissingData("500").localizedDescription
                result.status = false
                return
            }
            
            guard error == nil else {
                result.exceptionMessage = NetworkingError.DataTask("error data task \(String(describing: error?.localizedDescription))").localizedDescription
                result.status = false
                return
            }
            
            do {
                let fetchedData = try JSONDecoder().decode([T].self, from: data)
                result.returnedData = fetchedData
                result.status = true
            } catch let parseError {
                result.exceptionMessage = NetworkingError.ParseError("Error during parsing data, \(parseError.localizedDescription)").localizedDescription
                result.status = false
            }
            completionHandler(result)
        }
        dataTask.resume()
    }
}

