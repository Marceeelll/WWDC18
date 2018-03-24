import UIKit

/**
 An object that displays a month looking similar to a real world calendar.
 */
public class UICalendarView: UIView {
    // MARK: - Instance Variable
    public var showMonthInHeader = true
    public var showHeader = true
    public var showYearInHeader = true
    
    private var headerHeight: CGFloat = 30.0
    private var headerWithMonthHeight: CGFloat = 80.0
    private var headerButtonWidth: CGFloat = 50.0
    
    private(set) var headerMonthLabel: UILabel!
    private(set) var calendarMonthCollectionView: UICollectionView! {
        didSet {
            calendarMonthDataSource = UICalendarMonthCollectionViewDataSource(calendarView: self)
            calendarMonthDelegate = UICalendarMonthCollectionViewDelegate()
            calendarMonthCollectionView.delegate = calendarMonthDelegate
            calendarMonthCollectionView.dataSource = calendarMonthDataSource
        }
    }
    
    private weak var lastSelectedCell: UICalendarViewCell?
    
    
    // MARK: - Delegates
    public weak var dataSource: UICalendarViewDataSource?
    public weak var delegate: UICalendarViewDelegateProtocol?
    private var calendarMonthDataSource: UICalendarMonthCollectionViewDataSource!
    private var calendarMonthDelegate: UICalendarMonthCollectionViewDelegate!
    
    
    // MARK: - Initializer
    deinit {
        let nc = NotificationCenter.default
        nc.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    
    // MARK: - Instance Methods
    /**
     Has to be called to draw the calendar.
     */
    public func drawCalendar() {
        // Header View
        let headerView = createHeader()
        self.addSubview(headerView)
        
        let constraintBuilder = ConstraintBuilder(subview: headerView, superview: self)
        constraintBuilder.constraint(subviewAttribute: .left, superviewAttribute: .left)
            .constraint(subviewAttribute: .top, superviewAttribute: .top)
            .constraint(subviewAttribute: .right, superviewAttribute: .right)
            .buildAndApplyConstrains()
        let heightConstraint = NSLayoutConstraint(item: headerView,
                                                  attribute: .height, relatedBy: .equal,
                                                  toItem: self, attribute: .height,
                                                  multiplier: 0.25, constant: 0.0)
        self.addConstraint(heightConstraint)
        
        // Calendar Month View
        let calendarMonthCollectionView = createCalendarMonthCollectionView()
        self.calendarMonthCollectionView = calendarMonthCollectionView
        self.addSubview(calendarMonthCollectionView)
        
        // Device Orientation Did Change - Notification
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(didRotate), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        ConstraintAssistant.addConstraints(on: calendarMonthCollectionView, inSuperView: self, withTopView: headerView)
    }
    
    private func createHeader() -> UIView {
        // headerView
        //  -- headerMonthView
        //  -- headerWeekdayViewStackView
        let headerView = UIView()
        
        // Month Header
        let headerMonthStackView = createMonthHeader(in: headerView)
        headerView.addSubview(headerMonthStackView)
//        if showMonthInHeader {
//            let monthHeaderHeight = headerWithMonthHeight - headerHeight
//            ConstraintAssistant.addConstraints(on: headerMonthStackView, withSuperView: headerView, withHeightConstant: monthHeaderHeight, attachToTop: true)
//        }
        
        let constraintBuilder = ConstraintBuilder(subview: headerMonthStackView, superview: headerView)
        constraintBuilder.constraint(subviewAttribute: .left, superviewAttribute: .left)
            .constraint(subviewAttribute: .top, superviewAttribute: .top)
            .constraint(subviewAttribute: .right, superviewAttribute: .right)
            .buildAndApplyConstrains()
        let heightConstraint = NSLayoutConstraint(item: headerMonthStackView,
                                                  attribute: .height, relatedBy: .equal,
                                                  toItem: headerView, attribute: .height,
                                                  multiplier: 0.6, constant: 0.0)
        headerView.addConstraint(heightConstraint)
        
        // Weekday Header
        let headerWeekdayStackView = createWeekdayHeaderStackView(in: headerView)
        ConstraintAssistant.addConstraints(on: headerWeekdayStackView, inSuperView: headerView, withTopView: headerMonthStackView)
        
        return headerView
    }
    
    public func createMonthHeader(in headerView: UIView) -> UIStackView {
        let headerMonthStackView = UIStackView()
        
        // previous month button - left side
        let previousMonthButton = UIButton(type: .custom)
        previousMonthButton.setTitle("<", for: .normal)
        previousMonthButton.setTitleColor(AppColor.Theme.main, for: .normal)
        previousMonthButton.addTarget(self, action: #selector(pressedPreviousMonth(button:)), for: .touchUpInside)
        previousMonthButton.backgroundColor = AppColor.Calendar.headerButton
        previousMonthButton.clipsToBounds = true
        
        // month label - in the middle
        let monthLabel = UILabel()
        monthLabel.backgroundColor = AppColor.Calendar.headerMonth
        monthLabel.text = "November"
        monthLabel.textAlignment = .center
        headerMonthLabel = monthLabel
        updateDisplayingHeader()
        
        // next month button - right side
        let nextMonthButton = UIButton(type: .custom)
        nextMonthButton.setTitle(">", for: .normal)
        nextMonthButton.setTitleColor(AppColor.Theme.main, for: .normal)
        nextMonthButton.addTarget(self, action: #selector(pressedNextMonth(button:)), for: .touchUpInside)
        nextMonthButton.backgroundColor = AppColor.Calendar.headerButton
        nextMonthButton.clipsToBounds = true
        
        headerMonthStackView.addArrangedSubview(previousMonthButton)
        headerMonthStackView.addArrangedSubview(monthLabel)
        headerMonthStackView.addArrangedSubview(nextMonthButton)
        
        ConstraintAssistant.addWidth(on: previousMonthButton, inSuperview: headerMonthStackView, width: headerButtonWidth)
        ConstraintAssistant.addWidth(on: nextMonthButton, inSuperview: headerMonthStackView, width: headerButtonWidth)

        return headerMonthStackView
    }
    
    public func createWeekdayHeaderStackView(in headerView: UIView) -> UIStackView {
        guard let dataSource = dataSource else {
            return UIStackView()
        }
        
        let weekday = dataSource.startWeekOn
        let weekdaysNames = UICalendarWeekday.weekdays(beginnAt: weekday)
        
        let headerWeekdayStackView = UIStackView()
        headerWeekdayStackView.distribution = .fillEqually
        
        for weekday in weekdaysNames {
            let weekdayLabel = UILabel()
            weekdayLabel.adjustsFontSizeToFitWidth = true
            weekdayLabel.text = weekday
            weekdayLabel.textAlignment = .center
            weekdayLabel.backgroundColor = AppColor.Calendar.weekdayBar
            headerWeekdayStackView.addArrangedSubview(weekdayLabel)
        }
        
        headerView.addSubview(headerWeekdayStackView)
        return headerWeekdayStackView
    }
    
    public func createCalendarMonthCollectionView() -> UICollectionView {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 60, height: 60)
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "collectionViewCell")
        collectionView.isScrollEnabled = true
        
        return collectionView
    }
    
    public func createCalendarCellView() -> UIStackView {
        guard let dataSource = dataSource else {
            return UIStackView()
        }
        let numberOfWeeks = dataSource.numberOfWeeks
        let numberOfWeekdays = dataSource.numberOfWeekdays
        
        let calendarCellStackView = UIStackView()
        calendarCellStackView.distribution = .fillEqually
        calendarCellStackView.axis = .vertical
        for week in 0..<numberOfWeeks {
            let cellRowStackView = UIStackView()
            cellRowStackView.distribution = .fillEqually
            for day in 0..<numberOfWeekdays {
                let indexPath = IndexPath(day: day, week: week)
                let cell = dataSource.calendarView(cellForRowAt: indexPath)
                cell.delegate = self
                cellRowStackView.addArrangedSubview(cell)
            }
            calendarCellStackView.addArrangedSubview(cellRowStackView)
        }
        return calendarCellStackView
    }
    
    @objc func pressedPreviousMonth(button: UIButton) {
        dataSource?.previousMonth()
        delegate?.calenderView(self, touchedPreviousMonthButton: button)
        calendarMonthCollectionView.reloadData()
        updateDisplayingHeader()
    }
    
    @objc func pressedNextMonth(button: UIButton) {
        dataSource?.nextMonth()
        delegate?.calenderView(self, touchedNextMonthButton: button)
        calendarMonthCollectionView.reloadData()
        updateDisplayingHeader()
    }
    
    @objc private func didRotate() {
        calendarMonthCollectionView.reloadData()
    }
    
    public func updateDisplayingHeader() {
        var headerText = dataSource?.getCurrentMonth()
        if showYearInHeader {
            if let year = dataSource?.getCurrentYear() {
                headerText?.append(" \(year)")
            }
        }
        headerMonthLabel.text = headerText
    }
}

extension UICalendarView: UICalendarViewCellDelegate {
    public func calendarViewCell(_ didSelectedCalendarViewCell: UICalendarViewCell) {
        lastSelectedCell?.deselectCell()
        lastSelectedCell = didSelectedCalendarViewCell
        
        let selectedDate = didSelectedCalendarViewCell.date!
        delegate?.calendarView(self, didSelectedDate: selectedDate)
    }
}
