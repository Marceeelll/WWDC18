//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport




let name = "Marcel Hagmann"
let day = 26
let month = 03
let year = 2000


let birthdayCtrl = BirthdayController()
var userBirthdayEvents: [Event] = []
if let person = birthdayCtrl.createPerson(name: name, birthdayDay: day, birthdayMonth: month, birthdayYear: year) {
    userBirthdayEvents = birthdayCtrl.addPersonToCalendar(person: person)
}




class ViewController: UIViewController {
    var calendarView: UICalendarView = UICalendarView()
    var calenderDayOverviewTableView = UICalendarDayOverviewTableView()
    
    var eventCtrl: EventController!
    var particleCtrl: ParticleController!
    
    var menuButton = MenuButton(frame: CGRect.zero)
    var expandingMenuButton1 = UIButton()
    var expandingMenuButton2 = UIButton()
    
    var eventFilters: [EventType] = EventType.allEventTypes
    var userBirthdayEvents: [Event] = []
    
    var calendarRepresentation: CalendarRepresentation = .calendar
    
    var calendarTopConstraint: NSLayoutConstraint!
    
    var selectedDate: Date = Date()

    var dataSource: UICalendarViewDataSource! {
        didSet {
            dataSource.datesWithEvent = eventCtrl.getDates(forFilter: eventFilters)
            calendarView.dataSource = dataSource
        }
    }
    
    init(userBirthdayEvents: [Event]) {
        self.userBirthdayEvents = userBirthdayEvents
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventCtrl = EventController(filter: eventFilters, events: userBirthdayEvents)
        
        particleCtrl = ParticleController(layer: self.view.layer)
        calenderDayOverviewTableView.register(UICalendarDayOverviewTableViewCell.self, forCellReuseIdentifier: "cell")
        
        navigationController?.navigationBar.tintColor = AppColor.Theme.main
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Today", style: .plain, target: self, action: #selector(selectToday))

        self.view.backgroundColor = UIColor.white
        
        selectToday()
        calenderDayOverviewTableView.overViewDelegate = self
        
        self.view.addSubview(calenderDayOverviewTableView)
        self.view.addSubview(calendarView)
        
        calendarView.layer.shadowRadius = 2.0
        calendarView.layer.shadowOpacity = 1.0
        calendarView.layer.shadowColor = UIColor.lightGray.cgColor
        calendarView.layer.shadowOffset = CGSize(width: 0, height: 1)

        setupConstraints()

        dataSource = UICalendarViewDataSource()
        calendarView.delegate = self
        calendarView.drawCalendar()
        
        setup()
    }
    
    func setup() {
        // Expandable Menu
        expandingMenuButton1.setImage(calendarRepresentation.opositeImage, for: .normal)
        expandingMenuButton2.setImage(UIImage(named: "icon_filter_white.png"), for: .normal)
        
        expandingMenuButton1.addTarget(self, action: #selector(switchCalendarRepresentation), for: .touchUpInside)
        expandingMenuButton2.addTarget(self, action: #selector(showFilterScreen), for: .touchUpInside)
        
        menuButton.append(expandingView: expandingMenuButton1)
        menuButton.append(expandingView: expandingMenuButton2)
        
        let menuButtonHeight: CGFloat = 50.0
        
        menuButton.frame = CGRect(x: 0, y: 0,
                                  width: menuButtonHeight, height: menuButtonHeight)
        menuButton.center = CGPoint(x: 330, y: 630)
        menuButton.addTarget(self, action: #selector(toggleButtonMenu(_:)), for: .touchUpInside)
        menuButton.titleLabel?.adjustsFontSizeToFitWidth = true
        menuButton.titleLabel?.font = UIFont(name: "Helvetica", size: 31.0)
        menuButton.setTitle("+", for: .normal)
        menuButton.backgroundColor = UIColor.black
        menuButton.layer.cornerRadius = menuButton.frame.width/2
        menuButton.expandingDirection = .degree(225)
        self.view.addSubview(menuButton)
    }

    func setupConstraints() {
        // Set Calendar Constraints
        let constraintBuilder = ConstraintBuilder(subview: calendarView, superview: self.view)
        constraintBuilder.constraint(subviewAttribute: .left, superviewAttribute: .left, multiplier: 1.0, constant: 0.0)
            .constraint(subviewAttribute: .right, superviewAttribute: .right, multiplier: 1.0, constant: 0.0)
            .constraint(subviewAttribute: .height, multiplier: 1.0, constant: 300.0)
            .buildAndApplyConstrains()
        
        calendarTopConstraint = NSLayoutConstraint(item: calendarView,
                                                   attribute: .top, relatedBy: .equal,
                                                   toItem: self.view, attribute: .top,
                                                   multiplier: 1.0, constant: 44.0)
        self.view.addConstraint(calendarTopConstraint)
        
        ConstraintAssistant.addConstraints(on: calenderDayOverviewTableView,
                                           inSuperView: self.view,
                                           withTopView: calendarView)
    }
    
    @objc func selectToday() {
        let today = Date()
        selectedDate = today
        reloadWith(date: today)
    }
    
    func reloadWith(date: Date) {
        calenderDayOverviewTableView.data = eventCtrl.getEvents(forDate: date, andFilters: eventFilters)
        calenderDayOverviewTableView.selectedDate = date
        calenderDayOverviewTableView.reloadData()
        dataSource = UICalendarViewDataSource(date: date)
        calendarView.delegate = self
        calendarView.drawCalendar()
    }
    
    @objc func toggleButtonMenu(_ sender: MenuButton? = nil) {
        menuButton.toggle(onView: view)
    }
    
    @objc func switchCalendarRepresentation() {
        if !menuButton.isRunningAnimation {
            toggleButtonMenu()
            toggleCalendarRepresentation()
            adjustCalendarConstraintForRepresentationMode()
        }
    }
    
    func toggleCalendarRepresentation() {
        switch calendarRepresentation {
        case .calendar: calendarRepresentation = .list
        case .list: calendarRepresentation = .calendar
        }
        self.expandingMenuButton1.setImage(self.calendarRepresentation.opositeImage, for: .normal)
    }
    
    func adjustCalendarConstraintForRepresentationMode() {
        var calendarTopSpace: CGFloat
        switch calendarRepresentation {
        case .list:
            calendarTopSpace = -300
        case .calendar:
            calendarTopSpace = 44.0
        }
        calendarTopConstraint.constant = calendarTopSpace
        UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func showFilterScreen() {
        if !menuButton.isRunningAnimation {
            toggleButtonMenu()
            let filterVCtrl = FilterEventTypesViewController()
            filterVCtrl.selectedFilter = eventFilters
            filterVCtrl.filterDelegate = self
            navigationController?.pushViewController(filterVCtrl, animated: true)
        }
    }
    
    enum CalendarRepresentation {
        case list
        case calendar
        
        var image: UIImage? {
            switch self {
            case .list: return UIImage(named: "icon_list_white.png")
            case .calendar: return UIImage(named: "icon_calendar_white.png")
            }
        }
        
        var opositeImage: UIImage? {
            switch self {
            case .list: return  UIImage(named: "icon_calendar_white.png")
            case .calendar: return UIImage(named: "icon_list_white.png")
            }
        }
    }
}


extension ViewController: UICalendarViewDelegateProtocol {
    func calendarView(_ calendarView: UICalendarView, didSelectedDate selectedDate: Date) {
        self.selectedDate = selectedDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        self.title = dateFormatter.string(from: selectedDate)
        let eventsOnSelectedDay = eventCtrl.getEvents(forDate: selectedDate, andFilters: eventFilters)
        calenderDayOverviewTableView.data = eventsOnSelectedDay
        calenderDayOverviewTableView.selectedDate = selectedDate
        calenderDayOverviewTableView.reloadData()
    }
    
    func calenderView(_ calendarView: UICalendarView, touchedNextMonthButton: UIButton) {
    }

    func calenderView(_ calendarView: UICalendarView, touchedPreviousMonthButton: UIButton) {
    }
}


extension ViewController: UICalendarDayOverviewTableViewDelegate {
    func overviewTableView(_ tableView: UICalendarDayOverviewTableView, didSelectedEvent event: Event) {
        particleCtrl.startParticleAnimation(forEventType: event.type)
    }
}

extension ViewController: FilterEventTypesDelegate {
    func receiveNew(filterSelection: [EventType]) {
        eventFilters = filterSelection
        reloadWith(date: selectedDate)
    }
}

protocol FilterEventTypesDelegate {
    func receiveNew(filterSelection: [EventType])
}

class FilterEventTypesViewController: UITableViewController {
    var selectedFilter: [EventType]!
    
    var filterDelegate: FilterEventTypesDelegate?
    
    override func viewDidLoad() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        filterDelegate?.receiveNew(filterSelection: selectedFilter)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EventType.allEventTypes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let eventType = getEventType(atIndexPath: indexPath)
        cell.textLabel?.text = "\(eventType.symbol)\(eventType.name)"
        cell.accessoryType = isSelected(eventType: eventType) ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedEventType = getEventType(atIndexPath: indexPath)
        if selectedFilter.contains(selectedEventType) {
            remove(selectedEventType: selectedEventType)
        } else {
            selectedFilter.append(selectedEventType)
        }
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func getEventType(atIndexPath indexPath: IndexPath) -> EventType {
        return EventType.allEventTypes[indexPath.row]
    }
    
    func isSelected(eventType: EventType) -> Bool {
        return selectedFilter.contains(eventType)
    }
    
    func remove(selectedEventType: EventType) {
        for index in 0..<selectedFilter.count {
            let eventType = selectedFilter[index]
            if eventType == selectedEventType {
                selectedFilter.remove(at: index)
                break
            }
        }
    }
}


let vCtrl = ViewController(userBirthdayEvents: userBirthdayEvents)
let navCtrl = UINavigationController(rootViewController: vCtrl)

PlaygroundPage.current.liveView = navCtrl









