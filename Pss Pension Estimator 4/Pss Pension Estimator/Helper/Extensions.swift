//
//  Extensions.swift
//  Pss Pension Estimator
//
//  Created by Israel Mayor on 7/6/20.
//  Copyright © 2020 David Graham. All rights reserved.
//

import UIKit

extension String {
	
    var doubleValue: Double {
			return Double(self) ?? 0
    }
	
	func toDate(dateString: String) -> Date {
		let formatter = DateFormatter()
		formatter.dateStyle = .short
		formatter.dateFormat = "yyyy-MM-dd"
		return formatter.date(from: dateString) ?? Date()
		}
}

extension Date {
	
  func toString(format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

extension Int {
    func of(_ name: String) -> String {
        guard self != 1 else { return "\(self) \(name)" }
        return "\(self) \(name)s"
    }
}

extension Double {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}

extension UIViewController {

	func getPensionTable() -> [PensionTable] {
	return [PensionTable(age: 60, pf: 11.0),
		 PensionTable(age: 61, pf: 10.8),
		 PensionTable(age: 62, pf: 10.6),
		 PensionTable(age: 63, pf: 10.4),
		 PensionTable(age: 64, pf: 10.2),
		 PensionTable(age: 65, pf: 10.0),
		 PensionTable(age: 66, pf: 9.8),
		 PensionTable(age: 67, pf: 9.6),
		 PensionTable(age: 68, pf: 9.4),
		 PensionTable(age: 69, pf: 9.2),
		 PensionTable(age: 70, pf: 9.0),
		 PensionTable(age: 71, pf: 8.8),
		 PensionTable(age: 72, pf: 8.6),
		 PensionTable(age: 73, pf: 8.4),
		 PensionTable(age: 74, pf: 8.2),
		 PensionTable(age: 75, pf: 8.0)
		]
	}
	
}
