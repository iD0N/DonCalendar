//
//  CalendarView.swift
//  Chamedonam
//
//  Created by Don on 7/18/19.
//  Copyright © 2019 Arvin Alizadeh. All rights reserved.
//

import UIKit
import SwiftDate

@IBDesignable
public class CalendarView: UIView, UIGestureRecognizerDelegate {
	
	@IBOutlet var contentView: UIView!
	@IBOutlet var headerCollection: UICollectionView!
	@IBOutlet var mainCollection: UICollectionView!
	@IBOutlet public var monthLabel: UILabel!
	@IBOutlet var splitter: UIView!
	@IBOutlet var previousMonthView: UIView!
	@IBOutlet var nextMonthView: UIView!
	@IBOutlet var monthSwitchView: UIStackView!
	public var priceTag = 0
	public var holidayTag = 0
	public var weekendTag = 0
	public var appearance: CalendarAppearance = CalendarAppearance()
	public var selection = Selection()
	public var advanceInMonths = 0
	
	var lastSelectedCell = IndexPath()

	@IBInspectable public var isChangingMonthEnabled = true {
		didSet {
			monthSwitchView.isHidden = !isChangingMonthEnabled
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	@objc func nextMonthTapped(sender : UITapGestureRecognizer) {
		advanceInMonths += 1
		updateLabels()
	}
	
	@objc func PreviousMonthTapped(sender : UITapGestureRecognizer) {
		advanceInMonths = max(0, advanceInMonths - 1)
		updateLabels()
	}
	func setupCollectionView() {
		mainCollection.canCancelContentTouches = false
		let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan(toSelectCells:)))
		panGesture.delegate = self
		mainCollection.addGestureRecognizer(panGesture)
	}

	func selectCell(_ indexPath: IndexPath, selected: Bool) {
		if let _ = mainCollection.cellForItem(at: indexPath) {
			let day = getDayFromIndex(index: indexPath.row)
			selectDay(day: day)
		}
	}

	@objc func didPan(toSelectCells panGesture: UIPanGestureRecognizer) {
		
		guard selection.style == SelectionStyle.rangeSelection || selection.style == SelectionStyle.multipleSelection
		else {
			return
		}
		if panGesture.state == .began {
			mainCollection?.isUserInteractionEnabled = false
			mainCollection?.isScrollEnabled = false
		}
		else if panGesture.state == .changed {
			let location: CGPoint = panGesture.location(in: mainCollection)
			if let indexPath: IndexPath = mainCollection?.indexPathForItem(at: location) {
				if indexPath != lastSelectedCell {
					print(indexPath.row)
					self.selectCell(indexPath, selected: true)
					lastSelectedCell = indexPath
				}
			}
		} else if panGesture.state == .ended {
			mainCollection?.isUserInteractionEnabled = true
		}

	}

	func setupTables() {
		
		let gesturePrevious = UITapGestureRecognizer(target: self, action:  #selector(self.PreviousMonthTapped))
		self.previousMonthView.addGestureRecognizer(gesturePrevious)
		let gestureNext = UITapGestureRecognizer(target: self, action:  #selector(self.nextMonthTapped))
		self.nextMonthView.addGestureRecognizer(gestureNext)
		
		
		
		mainCollection.isScrollEnabled = false
		mainCollection.delegate = self
		mainCollection.dataSource = self
		mainCollection.register(UINib(nibName: "CalendarCell", bundle: Bundle(for: CalendarCell.self)), forCellWithReuseIdentifier: "Cell")
		headerCollection.delegate = self
		headerCollection.dataSource = self
		headerCollection.register(UINib(nibName: "CalendarCell", bundle: Bundle(for: CalendarCell.self)), forCellWithReuseIdentifier: "Cell")
		
		updateLabels()
	}
	func updateLabels()
	{
		let date = (Date() - 1.days + advanceInMonths.months).convertTo(region: appearance.region)
		
		monthLabel.text = "\(date.toFormat("MMMM", locale: Locales.persianIran))"
		mainCollection.reloadData()
		headerCollection.reloadData()
	}
	public override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		mainCollection.reloadData()
		headerCollection.reloadData()
	}
	public override var intrinsicContentSize: CGSize {
		let width = super.intrinsicContentSize.width
		return CGSize(width: width, height: width + (isChangingMonthEnabled ? 120 : 0))
	}
	private func commonInit()
	{
		
		guard let view = loadViewFromNib() else { return }
		view.frame = bounds
		view.autoresizingMask =
			[.flexibleWidth, .flexibleHeight]
		addSubview(view)
		contentView = view
		setupTables()
		//setupCollectionView()
	}
	func loadViewFromNib() -> UIView? {
		let bundle = Bundle(for: type(of: self))
		let nib = UINib(nibName: "CalendarView", bundle: bundle)
		return nib.instantiate(
			withOwner: self,
			options: nil).first as? UIView
	}
	func getCellSize(for style: SelectionStyle) -> CGSize {
		switch style {
		case .multipleSelection, .rangeSelection:
			let size = mainCollection.frame.width/7.0
			return CGSize(width: size, height: size)
		default:
			let size = (mainCollection.frame.width - 80)/7.0
			return CGSize(width: size, height: size)
		}
	}
	func getCellDistance(for style: SelectionStyle) -> CGFloat {
		switch style {
		case .multipleSelection, .rangeSelection:
			return .leastNonzeroMagnitude
		default:
			return 10.0
		}
	}
	public func setAvailableDays(days: [Date]) {
		self.selection.availableDays = days
		self.mainCollection.reloadData()
	}
	public func setBusyDays(days: [Date]) {
		self.selection.busyDays = days
		self.mainCollection.reloadData()
	}
	public func setSelectedDays(days: [Date]) {
		self.selection.selectedDays = days
		self.mainCollection.reloadData()
	}
	
}

extension CalendarView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
	public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		if collectionView == headerCollection
		{
			let size = mainCollection.frame.width/7.0
			return CGSize(width: size, height: size)
		}
		return getCellSize(for: selection.style)
	}
	public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		
		return 10
	}
	public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		
		if collectionView == headerCollection
		{
			return .leastNonzeroMagnitude
		}
		return getCellDistance(for: selection.style)
	}
	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		switch collectionView {
		case mainCollection:
			return 6*7
		default:
			return 7
		}
	}
	func isValidDayInMonth(day: Int) -> Bool {
		let date = (Date() - 1.days + advanceInMonths.months).convertTo(region: .iran)
		let monthDayCount = date.monthDays
		
		return day > 0 && day <= monthDayCount
		
	}
	func getDayFromIndex(index: Int) -> Int {
		
		let firstWeekday = (Date() - 1.days + advanceInMonths.months).convertTo(region: .iran).dateAtStartOf(.month).weekday
		
		let day = (index + 1) - firstWeekday
		return day
	}
	func getDateFromDay(day: Int) -> DateInRegion {
		
		return (Date() - 1.days + advanceInMonths.months).convertTo(region: .iran).dateAtStartOf(.month) + (day - 1).days
	}
	public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CalendarCell
		
		switch collectionView {
		case headerCollection:
			let weekday = WeekDay.saturday.add(days: indexPath.row).name(style: .veryShort, locale: Locales.persian)
			cell.configureHeaderCell(tag: weekday, appearance: appearance)
			
			return cell
		default:
			
			let day = getDayFromIndex(index: indexPath.row)
			guard isValidDayInMonth(day: day) == true
				else {
					cell.prepareForReuse()
					return cell
			}
			let date = getDateFromDay(day: day)
			let state = selection.selectedState(date: date)
			
			if !appearance.strikeOverPastDays && state == .unAvailable
			{
				cell.configureCell(type: .available, day: day, appearance: appearance, isHoliday: selection.isHoliday(day: date.date), isWeekend: selection.isEndofTheWeek(index: indexPath.row))
			}
			else
			{
				cell.configureCell(type: state, day: day, appearance: appearance, isHoliday: selection.isHoliday(day: date.date), isWeekend: selection.isEndofTheWeek(index: indexPath.row), price: (selection.isHoliday(day: date.date)) ? holidayTag : (selection.isEndofTheWeek(index: indexPath.row)) ? weekendTag : priceTag)
				
			}
			return cell
		}
	}
	public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		guard collectionView == mainCollection else
		{
			return
		}
		let day = getDayFromIndex(index: indexPath.row)
		
		selectDay(day: day)
	}
	func selectDay(day: Int) {
		
		
		guard isValidDayInMonth(day: day) == true
			else {
				return
		}
		let date = getDateFromDay(day: day)
		
		if selection.selectDay(date: date)
		{
			self.mainCollection.reloadData()
		}
	}
}
