//
//  DonCalendarDelegate.swift
//  DonCalendar
//
//  Created by Don on 9/17/19.
//  Copyright © 2019 Don. All rights reserved.
//

import Foundation

public protocol DonCalendarDelegate {
	func didSelectDate(day: Date?)
	func didSelectRange(firstDay: Date?, lastDay: Date?)
	func didSelectDays(days: [Date])
}
