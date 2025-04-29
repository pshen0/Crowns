import FSCalendar
import UIKit

// MARK: - CustomCalendar class
final class CustomCalendar: FSCalendar {
    
    // MARK: - Properties
    private var markedDates: [Date] = []
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.dateFormatter
        return formatter
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCalendar()
        updateMarkedDates()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureCalendar()
    }
    
    // MARK: - Funcs
    func updateMarkedDates() {
        self.markedDates = CoreDataDatesStack.shared.fetchAllDates()
        self.markedDates.sort()
        reloadData()
    }
    
    // MARK: - Private funcs
    private func configureCalendar() {
        backgroundColor = Colors.lightGray
        
        layer.cornerRadius = Constants.calendarRadius
        clipsToBounds = true
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = Constants.calendarShadowOpacity
        layer.shadowOffset = CGSize(width: Constants.calendarShadowOffset.0, height: Constants.calendarShadowOffset.1)
        layer.shadowRadius = Constants.calendarShadowRadius
        layer.masksToBounds = false
        
        appearance.headerMinimumDissolvedAlpha = 0
        appearance.headerTitleFont = UIFont(name: Fonts.IrishGrover, size: Constants.headerTextSize)
        appearance.weekdayFont = UIFont.boldSystemFont(ofSize: Constants.weekdayTextSize)
        appearance.titleFont = UIFont.boldSystemFont(ofSize: Constants.titleTextSize)
        appearance.headerDateFormat = Constants.headerFormatter
        appearance.headerTitleColor = Colors.white
        appearance.weekdayTextColor = Colors.yellow
        appearance.titleDefaultColor = Colors.white
        appearance.todayColor = Colors.white.withAlphaComponent(Constants.todayColorAlpha)

        delegate = self
        dataSource = self
    }

    private func isDateMarked(_ date: Date) -> Bool {
        let calendar = Calendar.current
        return markedDates.contains { markedDate in
            calendar.isDate(markedDate, inSameDayAs: date)
        }
    }
    
    // MARK: - Constants
    private enum Constants {
        static let dateFormatter = "yyyy-MM-dd"
        static let headerFormatter = "MMMM yyyy"
        
        static let headerTextSize = 25.0
        static let weekdayTextSize = 17.0
        static let titleTextSize = 17.0
        
        static let calendarRadius = 10.0
        static let calendarShadowOpacity = Float(0.4)
        static let calendarShadowOffset = (0.0, 5.0)
        static let calendarShadowRadius = 2.0
        static let todayColorAlpha = 0.3
        
        static let markedDateColor = Colors.yellow.withAlphaComponent(0.5)
    }
}

// MARK: - Extensions
extension CustomCalendar: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        if isDateMarked(date) {
            return Constants.markedDateColor
        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return false
    }
}
