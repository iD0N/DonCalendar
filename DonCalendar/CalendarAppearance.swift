//
//  CalendarAppearance.swift
//  DonCalendar
//
//  Created by Don on 9/17/19.
//  Copyright © 2019 Don. All rights reserved.
//

import Foundation
import UIKit
import SwiftDate


public class CalendarAppearance {
	
	public var font: UIFont
	public var headerFont: UIFont
	public var unavailableFont: UIFont
	public var priceFont: UIFont
	public var selectedFont: UIFont
	public var headerColor: UIColor
	public var availableColor: UIColor
	public var unavailableColor: UIColor
	public var selectedColor: UIColor
	public var holidayColor: UIColor
	public var weekendColor: UIColor
	public var calendar: Calendar
	public var locale: Locale
	public var region: Region
	public var startOfWeek: WeekDay
	public var strikeOverPastDays: Bool
	public var shouldShowPrice: Bool
	
	init(font: UIFont
		,headerFont: UIFont
		,unavailableFont: UIFont
		,priceFont: UIFont
		,selectedFont: UIFont
		,headerColor: UIColor
		,availableColor: UIColor
		,unavailableColor: UIColor
		,selectedColor: UIColor
		,holidayColor: UIColor
		,weekendColor: UIColor
		,calendar: Calendar
		,locale: Locale
		,region: Region
		,startOfWeek: WeekDay
		,strikeOverPastDays: Bool
		,shouldShowPrice: Bool) {
		
		self.font = font
		self.headerFont = headerFont
		self.unavailableFont = unavailableFont
		self.priceFont = priceFont
		self.selectedFont = selectedFont
		self.headerColor = headerColor
		self.availableColor = availableColor
		self.unavailableColor = unavailableColor
		self.selectedColor = selectedColor
		self.holidayColor = holidayColor
		self.weekendColor = weekendColor
		self.calendar = calendar
		self.locale = locale
		self.region = region
		self.startOfWeek = startOfWeek
		self.strikeOverPastDays = strikeOverPastDays
		self.shouldShowPrice = shouldShowPrice
	}
	init() {
		
		self.font = UIFont.systemFont(ofSize: 14)
		self.headerFont = UIFont.systemFont(ofSize: 14)
		self.unavailableFont = UIFont.systemFont(ofSize: 14)
		self.priceFont = UIFont.systemFont(ofSize: 12)
		self.selectedFont = UIFont.systemFont(ofSize: 14)
		self.headerColor = .blue
		self.availableColor = .black
		self.unavailableColor = .lightGray
		self.selectedColor = .blue
		self.holidayColor = .red
		self.weekendColor = .red
		self.calendar = .persian
		self.locale = .persian
		self.region = .iran
		self.startOfWeek = .saturday
		self.strikeOverPastDays = true
		self.shouldShowPrice = false
		
	}
}


