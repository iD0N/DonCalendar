//
//  CalendarCell.swift
//  Chamedonam
//
//  Created by Don on 7/13/19.
//  Copyright © 2019 Arvin Alizadeh. All rights reserved.
//

import UIKit

class CalendarCell: UICollectionViewCell {
	
	@IBOutlet var notificationView: UIView!
	@IBOutlet var notificationCountLabel: UILabel!
	@IBOutlet var priceLabel: UILabel!
	@IBOutlet var dayLabel: UILabel!
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	override func prepareForReuse() {
		
		backgroundColor = .clear
		layer.borderWidth = 0.0
		let attr = NSMutableAttributedString(attributedString: dayLabel.attributedText ?? NSAttributedString())
		let originalRange = NSMakeRange(0, attr.length)
		attr.setAttributes([:], range: originalRange)
		dayLabel.attributedText = attr
		dayLabel.attributedText = NSAttributedString(string: "", attributes: [:])
		dayLabel.text = ""
		priceLabel.text = ""
		priceLabel.isHidden = true
	}
	func configureHeaderCell(tag: String, appearance: CalendarAppearance)
	{
		dayLabel.text = tag
		dayLabel.font = appearance.headerFont
		priceLabel.isHidden = true
		dayLabel.textColor = appearance.headerColor
		
	}
	override func layoutSubviews() {
		super.layoutSubviews()
		notificationView.layer.cornerRadius = 9.0
	}
	func configureCell(type: DateState, day: Int, appearance: CalendarAppearance, isHoliday: Bool = false, isWeekend: Bool = false, price: Int = 0, notificationCount: Int = 0, notificationColor: UIColor = .white)
	{
		
		notificationView.isHidden = (notificationCount == 0)
		priceLabel.isHidden = !appearance.shouldShowPrice && type != .checkOutDay
		notificationView.backgroundColor = notificationColor
		notificationCountLabel.text = "\(notificationCount)"
		dayLabel.text = "\(day)"
		priceLabel.text = "\(price)"
		dayLabel.font = appearance.font
		priceLabel.font = appearance.priceFont
		
		switch type
		{
			
		case .unAvailable:
			strikeOverCell(day: day)
			
		case .available:

			dayLabel.textColor = (isHoliday || isWeekend) ? appearance.weekendColor : appearance.availableColor
			
		case .selectable:

			dayLabel.textColor = appearance.selectedColor
			layer.cornerRadius = 15
			backgroundColor = .clear
			layer.borderColor = appearance.selectedColor.cgColor
			if #available(iOS 11.0, *) {
				layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner]
			} else {
				//
			}
			layer.borderWidth = 1.0
			
		case .checkOutDay:

			backgroundColor = .clear
			layer.cornerRadius = 0
			priceLabel.isHidden = true
			
		case .noBorderSelectable:

			dayLabel.textColor =  isHoliday ? appearance.holidayColor : appearance.availableColor
			priceLabel.textColor = isHoliday ? appearance.holidayColor : appearance.availableColor
			backgroundColor = .clear
			layer.cornerRadius = 0
			
		case .selected:

			dayLabel.textColor = .white
			priceLabel.textColor = .white
			backgroundColor = appearance.selectedColor
			layer.cornerRadius = 0
			
		case .firstSelected:

			dayLabel.textColor = .white
			priceLabel.textColor = .white
			backgroundColor = appearance.selectedColor
			layer.cornerRadius = 15
			if #available(iOS 11.0, *) {
				layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
			} else {
				
				let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomRight, .topRight], cornerRadii: CGSize(width: 15.0, height: 15.0))
				let mask = CAShapeLayer()
				mask.path = path.cgPath
				self.layer.mask = mask
			}
			
		case .lastSelected:

			dayLabel.textColor = .white
			priceLabel.textColor = .white
			backgroundColor = appearance.selectedColor
			layer.cornerRadius = 15
			if #available(iOS 11.0, *) {
				layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
			} else {
				let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: 15.0, height: 15.0))
				let mask = CAShapeLayer()
				mask.path = path.cgPath
				self.layer.mask = mask
			}
			
		case .onlySelected:

			dayLabel.textColor = .white
			priceLabel.textColor = .white
			backgroundColor = appearance.selectedColor
			layer.cornerRadius = 15
			if #available(iOS 11.0, *) {
				layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner]
			} else {
				// Fallback on earlier versions
			}
		}
	}

	func strikeOverCell(day: Int)
	{
		let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "\(day)")
		
		let strokeEffect: [NSAttributedString.Key : Any] = [
			.strikethroughStyle: NSUnderlineStyle.single.rawValue,
			.strikethroughColor: UIColor.gray]
		attributeString.addAttributes(strokeEffect, range: NSMakeRange(0, attributeString.length))
		dayLabel.attributedText = attributeString
		dayLabel.textColor = .gray
		backgroundColor = .clear
		layer.borderWidth = 0.0
		priceLabel.textColor = .gray
		priceLabel.isHidden = true
	}
}
