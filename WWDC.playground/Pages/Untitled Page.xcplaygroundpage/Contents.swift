//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

var str = "Hello, playground"

struct Event {
    var title: String
    var startDate: Date
    var endDate: Date
    var type: EventType
    var isFullTime: Bool
}

enum EventType {
    case birthday
    case christmas
    case wwdc
    case newYear
    case holiday
    case important
    
    var symbol: String {
        switch self {
        case .birthday: return "🎂"
        case .christmas: return "🎅"
        case .wwdc: return "👨‍💻"
        case .newYear: return "🎊"
        case .holiday: return "🌴"
        case .important: return "⚠️"
        }
    }
    
    var color: UIColor {
        switch self {
        case .birthday: return UIColor.purple
        case .christmas: return UIColor.red
        case .wwdc: return UIColor.orange
        case .newYear: return UIColor.cyan
        case .holiday: return UIColor.green
        case .important: return UIColor.yellow
        }
    }
}

class UICalendarDayOverviewTableViewCell: UITableViewCell {
    private var timeStackView = UIStackView()
    var startTimeLabel = UILabel()
    var endTimeLabel = UILabel()
    var descriptionLabel = UILabel()
    var eventImageView = UILabel()
    private var seperatorView = UIView()
    
    let borderSpace: CGFloat = 8.0
    
    let fontTest = UIFont(name: "Helvetica", size: 12.0)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        setupConstraints()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup() {
        timeStackView.addArrangedSubview(startTimeLabel)
        timeStackView.addArrangedSubview(endTimeLabel)
        timeStackView.alignment = .fill
        timeStackView.distribution = .fillEqually
        timeStackView.axis = .vertical
        self.addSubview(timeStackView)
        
//        startTimeLabel.backgroundColor = UIColor.orange
        startTimeLabel.font = fontTest
        startTimeLabel.textAlignment = .right
//        endTimeLabel.backgroundColor = UIColor.lightGray
        endTimeLabel.font = fontTest
        endTimeLabel.textAlignment = .right
        
        seperatorView.backgroundColor = UIColor.blue
        self.addSubview(seperatorView)
        
//        descriptionLabel.backgroundColor = UIColor.green
        self.addSubview(descriptionLabel)
    }
    
    func setupConstraints() {
        let stackViewCB = ConstraintBuilder(subview: timeStackView, superview: self)
        stackViewCB.constraint(subviewAttribute: .left, superviewAttribute: .left, constant: borderSpace)
            .constraint(subviewAttribute: .top, superviewAttribute: .top, constant: borderSpace)
            .constraint(subviewAttribute: .bottom, superviewAttribute: .bottom, constant: -borderSpace)
            .constraint(subviewAttribute: .width, constant: 55.0)
            .buildAndApplyConstrains()
        
        let seperatorViewCB = ConstraintBuilder(subview: seperatorView, superview: self)
        seperatorViewCB.constraint(subviewAttribute: .top, superviewAttribute: .top, constant: borderSpace)
            .constraint(subviewAttribute: .left, anotherView: timeStackView, anotherAttribute: .right, constant: borderSpace/2)
            .constraint(subviewAttribute: .bottom, superviewAttribute: .bottom, constant: -borderSpace)
            .constraint(subviewAttribute: .width, constant: 2.0)
            .buildAndApplyConstrains()
        
        let descLabelCB = ConstraintBuilder(subview: descriptionLabel, superview: self)
        descLabelCB.constraint(subviewAttribute: .top, superviewAttribute: .top, constant: borderSpace)
            .constraint(subviewAttribute: .left, anotherView: seperatorView, anotherAttribute: .right, multiplier: 1.0, constant: borderSpace/2)
            .constraint(subviewAttribute: .bottom, superviewAttribute: .bottom, constant: -borderSpace)
            .constraint(subviewAttribute: .right, superviewAttribute: .right, constant: -borderSpace)
            .buildAndApplyConstrains()
    }
    
}

class UICalendarDayOverviewTableView: UITableView {
    var data: [String] = ["Hello", "World"]
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        print("SETUP")
        self.dataSource = self
        self.delegate = self
    }
    
}

extension UICalendarDayOverviewTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UICalendarDayOverviewTableViewCell
//        let eventName = getEvent(atIndexPath: indexPath)
//        cell.textLabel?.text = eventName
        cell.startTimeLabel.text = "08:45"
        cell.endTimeLabel.text = "09:15"
        cell.descriptionLabel.text = "🎂 Denise Hagmann’s Birthday"
        if indexPath.row % 2 == 0 {
            cell.descriptionLabel.text = "🎈 Denise Hagmann’s Birthday"
        }
        return cell
    }
    
    func getEvent(atIndexPath indexPath: IndexPath) -> String {
        return data[indexPath.row]
    }
}

extension UICalendarDayOverviewTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 55.0
//    }
}




class CreateEntryViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray
    }
}

class ViewController: UIViewController {
    var calendarView: UICalendarView = UICalendarView()
    var calenderDayOverviewTableView = UICalendarDayOverviewTableView()
    
    var events: [Event] = [Event(title: "Denise Hagmann's Birthday",
                                 startDate: Date(timeIntervalSinceNow: -86400*3),
                                 endDate: Date(timeIntervalSinceNow: -86400*3),
                                 type: .birthday, isFullTime: false),
                           Event(title: "WWDC Submission Deadline",
                                 startDate: Date(), endDate: Date(),
                                 type: .important, isFullTime: true),
                           Event(title: "WWDC 2018",
                                 startDate: Date(timeIntervalSinceNow: 86400*2),
                                 endDate: Date(),
                                 type: .birthday, isFullTime: false)]
    
    lazy var eventDates: [Date] = {
        return events.map({ (event) -> Date in
            return event.startDate
        })
    }()

    var dataSource: UICalendarViewDataSource! {
        didSet {
            dataSource.datesWithEvent = eventDates
            calendarView.dataSource = dataSource
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        calenderDayOverviewTableView.register(UICalendarDayOverviewTableViewCell.self, forCellReuseIdentifier: "cell")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddNewEntryViewController))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Today", style: .plain, target: self, action: nil)

        self.view.backgroundColor = UIColor.lightGray
        
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
    }

    func setupConstraints() {
        // Set Calendar Constraints
        let constraintBuilder = ConstraintBuilder(subview: calendarView, superview: self.view)
        constraintBuilder.constraint(subviewAttribute: .top, superviewAttribute: .top, multiplier: 1.0, constant: 44.0)
            .constraint(subviewAttribute: .left, superviewAttribute: .left, multiplier: 1.0, constant: 0.0)
            .constraint(subviewAttribute: .right, superviewAttribute: .right, multiplier: 1.0, constant: 0.0)
            .constraint(subviewAttribute: .height, multiplier: 1.0, constant: 300)
            .buildAndApplyConstrains()
        
        ConstraintAssistant.addConstraints(on: calenderDayOverviewTableView,
                                           inSuperView: self.view,
                                           withTopView: calendarView)
    }
    
    @objc func showAddNewEntryViewController() {
        let createEntryVCtrl = CreateEntryViewController()
        self.navigationController?.pushViewController(createEntryVCtrl, animated: true)
    }

}


extension ViewController: UICalendarViewDelegateProtocol {
    func calendarView(_ calendarView: UICalendarView, didSelectedDate selectedDate: Date) {
        print("selectedDate: \(selectedDate)")
    }

    func calenderView(_ calendarView: UICalendarView, touchedNextMonthButton: UIButton) {
        print("Next Button was touched")
    }

    func calenderView(_ calendarView: UICalendarView, touchedPreviousMonthButton: UIButton) {
        print("Previous Button was touched")
    }
}


let vCtrl = ViewController()
let navCtrl = UINavigationController(rootViewController: vCtrl)

PlaygroundPage.current.liveView = navCtrl






print(str)
