//
//  CustomCalendar.swift
//  Crowns
//
//  Created by Анна Сазонова on 24.02.2025.
//

import FSCalendar
import UIKit


final class CustomCalendar: FSCalendar, FSCalendarDelegate, FSCalendarDataSource {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCalendar()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureCalendar()
    }
    
    
    private func configureCalendar() {
        backgroundColor = Colors.lightGray
        
        layer.cornerRadius = 10
        clipsToBounds = true
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowRadius = 2
        layer.masksToBounds = false
        
        appearance.headerMinimumDissolvedAlpha = 0
        appearance.headerTitleFont = UIFont(name: Text.fontIrishGrover, size: 25)
        appearance.weekdayFont = UIFont(name: Text.fontIrishGrover, size: 17)
        appearance.titleFont = UIFont(name: Text.fontIrishGrover, size: 17)
        appearance.headerDateFormat = "MMMM yyyy"
        appearance.headerTitleColor = Colors.white
        appearance.weekdayTextColor = Colors.yellow
        appearance.titleDefaultColor = Colors.white
        appearance.todayColor = Colors.yellow.withAlphaComponent(0.3)
        appearance.selectionColor = .clear
    }
}

