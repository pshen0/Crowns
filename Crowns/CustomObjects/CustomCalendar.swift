import FSCalendar
import UIKit

final class CustomCalendar: FSCalendar {
    
    private var markedDates: [Date] = []
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    private let markedDateColor = Colors.yellow.withAlphaComponent(0.5)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCalendar()
        updateMarkedDates()
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
        appearance.weekdayFont = UIFont.boldSystemFont(ofSize: 17)
        appearance.titleFont = UIFont.boldSystemFont(ofSize: 17)
        appearance.headerDateFormat = "MMMM yyyy"
        appearance.headerTitleColor = Colors.white
        appearance.weekdayTextColor = Colors.yellow
        appearance.titleDefaultColor = Colors.white
        appearance.todayColor = .clear

        delegate = self
        dataSource = self
    }
    
    func updateMarkedDates() {
        self.markedDates = CoreDataDatesStack.shared.fetchAllDates()
        self.markedDates.sort()
        reloadData()
    }

    private func isDateMarked(_ date: Date) -> Bool {
        let calendar = Calendar.current
        return markedDates.contains { markedDate in
            calendar.isDate(markedDate, inSameDayAs: date)
        }
    }
}

extension CustomCalendar: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        if isDateMarked(date) {
            return markedDateColor
        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return false
    }
}
