//
//  Extensions.swift
//  DonCalendar
//
//  Created by Don on 9/17/19.
//  Copyright © 2019 Don. All rights reserved.
//

import Foundation
import SwiftDate

extension Locale
{
	@nonobjc static public var persian: Locale {
		get
		{
			return Locale(identifier: "fa_IR")
		}
	}
}

extension Calendar
{
	@nonobjc static public var persian: Calendar {
		get
		{
			return Calendar(identifier: .persian)
		}
	}
}

extension Region
{
	
	@nonobjc static public var iran: Region {
		get
		{
			return Region(calendar: Calendars.persian, zone: Zones.asiaTehran, locale: Locale.current)
		}
	}
}
