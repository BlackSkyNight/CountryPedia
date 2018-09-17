//
//  Wrapper.swift
//  CountryPedia
//
//  Created by Mateusz Matejczyk on 17.09.2018.
//  Copyright © 2018 Matejczyk. All rights reserved.
//

import Foundation

class Wrapper<T> {
    var status: Bool?
    var message: String?
    var exceptionMessage: String?
    var returnedData: [T]?
}
