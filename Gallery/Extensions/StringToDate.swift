//
//  StringToDate.swift
//  Gallery
//
//  Created by Camilo Cabana on 22/07/20.
//  Copyright © 2020 Camilo Cabana. All rights reserved.
//

import Foundation

extension String {
    func stringToDate() -> Date {
        let isoDate = self
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.date(from:isoDate)!
    }
}
