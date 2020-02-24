//
//  DaySelectionCalculation.swift
//  DonCalendar
//
//  Created by Don on 9/17/19.
//  Copyright © 2019 Don. All rights reserved.
//

import Foundation
import SwiftDate

public enum SelectionStyle: Int
{
	case normalBlack = 1
	case singleSelection
	case rangeSelection
	case multipleSelection
}

enum DateState: String
{
	case unAvailable
	case available
	case selectable
	case noBorderSelectable
	case selected
	case firstSelected
	case lastSelected
	case onlySelected
	case checkOutDay
}

public class Selection
{
	
	public var style: SelectionStyle!
	public var today: Date!
	public var selectedDays: [Date]!
	public var busyDays: [Date]!
	public var availableDays: [Date]!
	public var holidays: [Date]!
	public var alwaysAvailable: Bool!
	public var delegate: DonCalendarDelegate?
	
	required init() {
		
		self.style = .normalBlack
		selectedDays = []
		today = DateInRegion(Date(), region: .iran).dateAtStartOf(.day).date
		availableDays = []
		holidays = []
		self.busyDays = []
		self.alwaysAvailable = false
		self.delegate = nil
	}
	required init(style: SelectionStyle, alwaysAvailable: Bool, delegate: DonCalendarDelegate? = nil) {
		
		self.style = style
		selectedDays = []
		today = Date()
		availableDays = []
		holidays = []
		self.busyDays = []
		self.alwaysAvailable = alwaysAvailable
		self.delegate = delegate
	}
	func selectedState(date: DateInRegion) -> DateState {
		
		
		if isDayBeforeToday(day: date.date)
		{
			return .unAvailable
		}
		if !isDayAvailable(day:date.date) && !selectedDays.contains(date.date)
		{
			if availableDays.contains(date.date - 1.days) && style == .rangeSelection
			{
				return .checkOutDay
			}
			return .unAvailable
		}
		switch self.style {
			
		case .normalBlack?:
			
			return .available
			
		case .singleSelection?:
			
			return selectedDays.first?.compare(date.date) == .orderedSame ? .onlySelected : .selectable
			
			
		case .rangeSelection?:
			
			if selectedDays.first?.compare(date.date) == .orderedSame
			{
				return selectedDays.count == 1 ? .onlySelected : .firstSelected
			}
			else if selectedDays.last?.compare(date.date) == .orderedSame
			{
				return .lastSelected
			}
			else if selectedDays.first?.compare(date.date) == .orderedAscending && selectedDays.last?.compare(date.date) == .orderedDescending
			{
				return .selected
			}
			else
			{
				return .noBorderSelectable
			}
		case .multipleSelection?:
			if selectedDays.contains(date.date)
			{
				var state: DateState = .available
				if selectedDays.contains((date - 1.days).date)
				{
					state = .selected
				}
				else
				{
					state = .firstSelected
				}
				if !selectedDays.contains((date + 1.days).date)
				{
					state = (state == .firstSelected) ? .onlySelected : .lastSelected
				}
				return state
			}
			else
			{
				return .noBorderSelectable
			}
		default:
			return .unAvailable
		}
	}
	
	
	func selectDay(date: DateInRegion) -> Bool {
		print(date.date)
		print(today)
		if (style == .rangeSelection) && selectedDays.count > 0
		{
			if selectedDays[0].isBeforeDate(date.date, granularity: .day)
			{
				let increment = DateComponents.create {
					$0.day = 1
				}
				let dates = DateInRegion.enumerateDates(from: selectedDays![0].convertTo(region: .iran), to: date - 1.days, increment: increment)
				print(dates)
				for day in dates
				{
					if !isDayAvailable(day: day.date)
					{
						return false
					}
				}
			}
			else if selectedDays[0].isAfterDate(date.date, granularity: .day)
			{
				let increment = DateComponents.create {
					$0.day = 1
				}
				let dates = DateInRegion.enumerateDates(from: date, to: selectedDays![0].convertTo(region: .iran) - 1.days, increment: increment)
				print(dates)
				for day in dates
				{
					if !isDayAvailable(day: day.date)
					{
						return false
					}
				}
			}
		}
		else {
			guard isDayAvailable(day: date.date) == true else {
				
				
			return false
			}
		}
		
		switch style {
		case .multipleSelection?:
			if selectedDays.contains(date.date)
			{
				selectedDays = selectedDays.filter {$0 != date.date}
				delegate?.didSelectDays(days: selectedDays)
			}
			else
			{
				selectedDays.append(date.date)
				delegate?.didSelectDays(days: selectedDays)
			}
			return true
			
		case .rangeSelection?:
			if selectedDays.isEmpty
			{
				selectedDays.append(date.date)
				delegate?.didSelectRange(firstDay: date.date, lastDay: nil)
			}
			else if selectedDays.contains(date.date)
			{
				selectedDays.removeAll()
				delegate?.didSelectRange(firstDay: nil, lastDay: nil)
			}
			else if selectedDays.first?.compare(date.date) == ComparisonResult.orderedDescending
			{
				if selectedDays.count == 1
				{
					selectedDays.insert(date.date, at: 0)
					delegate?.didSelectRange(firstDay: selectedDays[0], lastDay: selectedDays[1])
				}
				else
				{
					selectedDays[0] = date.date
					delegate?.didSelectRange(firstDay: selectedDays[0], lastDay: selectedDays[1])
				}
			}
			else if selectedDays.first?.compare(date.date) == ComparisonResult.orderedAscending
			{
				if selectedDays.count == 1
				{
					selectedDays.append(date.date)
					delegate?.didSelectRange(firstDay: selectedDays[0], lastDay: selectedDays[1])
				}
				else
				{
					selectedDays[1] = date.date
					delegate?.didSelectRange(firstDay: selectedDays[0], lastDay: selectedDays[1])
				}
			}
			return true
		case .singleSelection?:
			if selectedDays.count == 1
			{
				selectedDays[0] = date.date
				delegate?.didSelectDate(day: date.date)
				
			}
			else
			{
				selectedDays.append(date.date)
				delegate?.didSelectDate(day: date.date)
			}
			
			
			return true
		default:
			return false
		}
	}
	func isDayBeforeToday(day: Date) -> Bool {
		//print(day)
		let compare = today.compare(toDate: day, granularity: .day)
		//print(compare.rawValue)
		return (compare == .orderedDescending)
		
	}
	func isDayAvailable(day: Date) -> Bool {
		
		guard !isDayBeforeToday(day: day) else
		{
			return false
		}
		if alwaysAvailable && busyDays.contains(day)
		{
			return false
		}
		return alwaysAvailable || availableDays.contains(day)
	}
	func isHoliday(day: Date) -> Bool {
		return holidays.contains(day)
	}
	func isEndofTheWeek(index: Int) -> Bool {
		return index % 7 == 6 || index % 7 == 5
	}
}
