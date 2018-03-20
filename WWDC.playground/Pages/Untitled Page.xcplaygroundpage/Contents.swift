//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

public class ParticleController {
    private var layer: CALayer
    private var particle: CAEmitterLayer?
    
    init(layer: CALayer) {
        self.layer = layer
    }
    
    func startParticleAnimation(forEventType eventType: EventType, andEndAfterTime delay: Double) {
        if particle != nil {
            particle?.removeFromSuperlayer()
        }
        particle = getEmitter(forEventType: eventType)
        if let particle = particle {
            particle.beginTime = CACurrentMediaTime()
            layer.addSublayer(particle)
            stopParticleAnimation(stopDeleay: delay)
        }
    }
    
    private func stopParticleAnimation(stopDeleay: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + stopDeleay) {
            if let particle = self.particle {
                particle.birthRate = 0.0
                
                let lifetimes = particle.emitterCells?.map({ (cell) -> Float in
                    return cell.lifetime
                })
                if let maxLifeTime = lifetimes?.max() {
                    print(maxLifeTime)
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(maxLifeTime), execute: {
                        particle.removeFromSuperlayer()
                        self.particle = nil
                    })
                }
            }
            
        }
//        let lifetimes = particle.emitterCells?.map({ (cell) -> Float in
//            return cell.lifetime
//        })
//        if let maxLifeTime = lifetimes?.max() {
//            print(maxLifeTime)
//            DispatchQueue.main.asyncAfter(deadline: .now() + Double(maxLifeTime), execute: {
//                self.particle.removeFromSuperlayer()
//            })
//        }
    }
    
    func getEmitter(forEventType eventType: EventType) -> CAEmitterLayer {
        let emitter = CAEmitterLayer()
        emitter.emitterPosition = CGPoint(x: 320.0/2.0, y: 100)
        emitter.emitterShape = kCAEmitterLayerLine
        emitter.emitterSize = CGSize(width: 300, height: 30)
        
        var cells: [CAEmitterCell] = []
        
        for index in 0..<3 {
            let cell = CAEmitterCell()
            
            let intensity = Float(0.3)
            
//            cell.birthRate = 1.5
            cell.birthRate = 5
            cell.lifetime = 10
            cell.lifetimeRange = 0
            cell.velocity = CGFloat(350.0 * intensity)
            cell.velocityRange = CGFloat(80.0 * intensity)
            cell.emissionLongitude = CGFloat.pi
            cell.emissionRange = CGFloat.pi/4
            cell.spin = CGFloat(3.5 * intensity)
            cell.spinRange = CGFloat(4.0 * intensity)
            cell.scaleRange = CGFloat(intensity)
            cell.scaleSpeed = CGFloat(-0.1 * intensity)
            
            cell.redRange = 200
            cell.greenRange = 200
            cell.alphaRange = 1
            cell.alphaSpeed = 1
            
            switch index%3 {
            case 0: cell.contents = UIImage(named: "confetti_1.png")!.cgImage
            case 1: cell.contents = UIImage(named: "confetti_2.png")!.cgImage
            case 2: cell.contents = UIImage(named: "confetti_3.png")!.cgImage
            default:
                break
            }
            
            cells.append(cell)
        }
        
        emitter.emitterCells = cells
        
        return emitter
    }
}


struct Event {
    var title: String
    var startDate: Date
    var endDate: Date
    var type: EventType
    var isFullTime: Bool
    
    func getDatesBetweenStartAndEnd() -> [Date] {
        if let durationInDays = Calendar.current.dateComponents([.day], from: startDate, to: endDate).day {
            var days: [Date] = []
            for dayDuration in 0...durationInDays {
                if let day = Calendar.current.date(byAdding: .day, value: dayDuration, to: startDate) {
                    days.append(day)
                }
            }
            return days
        }
        return []
    }
    
    func isOneDayEvent() -> Bool {
        return Calendar.current.isDate(startDate, inSameDayAs: endDate)
    }
    
    func isDateBetweenStartAndEndDate(dateToCheck date: Date) -> Bool {
        return Calendar.current.isDate(date, inSameDayAs: min(max(startDate, date), endDate))
    }
    
    func getTimes(forDate date: Date) -> (startTime: String, endTime: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        
        if isFullTime {
            return ("all-day", "")
        } else if isOneDayEvent() {
            let startTime = dateFormatter.string(from: startDate)
            let endTime = dateFormatter.string(from: endDate)
            return (startTime, endTime)
        } else if Calendar.current.isDate(startDate, inSameDayAs: date) {
            let startTime = dateFormatter.string(from: startDate)
            return (startTime, "")
        } else if !Calendar.current.isDate(endDate, inSameDayAs: date) {
            return ("all-day", "")
        } else {
            let endTime = dateFormatter.string(from: endDate)
            return ("End", endTime)
        }
    }
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

class EventController {
    var events: [Event] = []
    var dates: [Date] = []
    
    func createDemonstrationEvents() {
        events = [Event(title: "Denise Hagmann's Birthday (Sister)",
                        startDate: Date(timeIntervalSince1970: 1523523600),
                        endDate: Date(timeIntervalSince1970: 1523527200),
                        type: .birthday, isFullTime: true),
                  Event(title: "Marcel Hagmann's Birthday (Me)",
                        startDate: Date(timeIntervalSince1970: 1538384400),
                        endDate: Date(timeIntervalSince1970: 1538388000),
                        type: .birthday, isFullTime: true),
                  Event(title: "WWDC Scholarship Result",
                        startDate: Date(timeIntervalSince1970: 1524225600),
                        endDate: Date(timeIntervalSince1970: 1524240000),
                        type: .important, isFullTime: false),
                  Event(title: "WWDC Submission",
                        startDate: Date(timeIntervalSince1970: 1522054800),
                        endDate: Date(timeIntervalSince1970: 1522558800),
                        type: .important, isFullTime: false),
                  Event(title: "WWDC Submission Deadline",
                        startDate: Date(timeIntervalSince1970: 1522555200),
                        endDate: Date(timeIntervalSince1970: 1522558800),
                        type: .important, isFullTime: true),
                  Event(title: "WWDC 2018",
                        startDate: Date(timeIntervalSince1970: 1528108860),
                        endDate: Date(timeIntervalSince1970: 1528480800),
                        type: .wwdc, isFullTime: false),
                  Event(title: "New Year 2017",
                        startDate: Date(timeIntervalSince1970: 1483261200),
                        endDate: Date(timeIntervalSince1970: 1483264800),
                        type: .newYear, isFullTime: true),
                  Event(title: "New Year 2018",
                        startDate: Date(timeIntervalSince1970: 1514797200),
                        endDate: Date(timeIntervalSince1970: 1514800800),
                        type: .newYear, isFullTime: true),
                  Event(title: "Independence Day",
                        startDate: Date(timeIntervalSince1970: 1530694800),
                        endDate: Date(timeIntervalSince1970: 1530698400),
                        type: .holiday, isFullTime: true),
                  Event(title: "Martin Luther King Jr. Day",
                        startDate: Date(timeIntervalSince1970: 1516006800),
                        endDate: Date(timeIntervalSince1970: 1516010400),
                        type: .holiday, isFullTime: true),
                  Event(title: "Memorial Day",
                        startDate: Date(timeIntervalSince1970: 1527498000),
                        endDate: Date(timeIntervalSince1970: 1527501600),
                        type: .holiday, isFullTime: true),
                  Event(title: "Thanksgiving",
                        startDate: Date(timeIntervalSince1970: 1542877200),
                        endDate: Date(timeIntervalSince1970: 1542880800),
                        type: .holiday, isFullTime: true),
                  Event(title: "Black Friday",
                        startDate: Date(timeIntervalSince1970: 1542963600),
                        endDate: Date(timeIntervalSince1970: 1543003200),
                        type: .important, isFullTime: false)]
        
        var dateSet: Set<Date> = []
        for event in events {
            for date in event.getDatesBetweenStartAndEnd() {
                dateSet.insert(date)
            }
        }
        dates = Array(dateSet)
    }
    
    func getEvents(forDate date: Date) -> [Event] {
        var result: [Event] = []
        for event in events {
            if event.isDateBetweenStartAndEndDate(dateToCheck: date) {
                result.append(event)
            }
        }
        return result
    }
}

class UICalendarDayOverviewTableViewCell: UITableViewCell {
    private var timeStackView = UIStackView()
    var startTimeLabel = UILabel()
    var endTimeLabel = UILabel()
    var descriptionLabel = UILabel()
    var eventImageView = UILabel()
    var seperatorView = UIView()
    
    private let borderSpace: CGFloat = 8.0
    
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
        
        startTimeLabel.font = fontTest
        startTimeLabel.textAlignment = .right
        endTimeLabel.font = fontTest
        endTimeLabel.textAlignment = .right
        
        seperatorView.backgroundColor = UIColor.blue
        self.addSubview(seperatorView)
        
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
    var data: [Event] = []
    var selectedDate: Date?
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
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
        let event = getEvent(atIndexPath: indexPath)
        cell.descriptionLabel.text = "\(event.type.symbol)\(event.title)"
        if let selectedDate = selectedDate {
            let times = event.getTimes(forDate: selectedDate)
            cell.startTimeLabel.text = times.startTime
            cell.endTimeLabel.text = times.endTime
        }
        cell.seperatorView.backgroundColor = event.type.color
        return cell
    }
    
    func getEvent(atIndexPath indexPath: IndexPath) -> Event {
        return  data[indexPath.row]
    }
}

extension UICalendarDayOverviewTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
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
    
    let eventCtrl = EventController()
    var particleCtrl: ParticleController!

    var dataSource: UICalendarViewDataSource! {
        didSet {
            dataSource.datesWithEvent = eventCtrl.dates
            calendarView.dataSource = dataSource
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventCtrl.createDemonstrationEvents()
        
        particleCtrl = ParticleController(layer: self.view.layer)
        calenderDayOverviewTableView.register(UICalendarDayOverviewTableViewCell.self, forCellReuseIdentifier: "cell")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddNewEntryViewController))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Today", style: .plain, target: self, action: #selector(selectToday))

        self.view.backgroundColor = UIColor.lightGray
        
        let today = Date()
        calenderDayOverviewTableView.data = eventCtrl.getEvents(forDate: today)
        calenderDayOverviewTableView.selectedDate = today
        
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
    
    @objc func selectToday() {
        let today = Date()
        calenderDayOverviewTableView.data = eventCtrl.getEvents(forDate: today)
        calenderDayOverviewTableView.selectedDate = today
        calenderDayOverviewTableView.reloadData()
        dataSource = UICalendarViewDataSource()
        calendarView.delegate = self
        calendarView.drawCalendar()
    }

}


extension ViewController: UICalendarViewDelegateProtocol {
    func calendarView(_ calendarView: UICalendarView, didSelectedDate selectedDate: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        self.title = dateFormatter.string(from: selectedDate)
        let eventsOnSelectedDay = eventCtrl.getEvents(forDate: selectedDate)
        calenderDayOverviewTableView.data = eventsOnSelectedDay
        calenderDayOverviewTableView.selectedDate = selectedDate
        calenderDayOverviewTableView.reloadData()
        
        if !eventsOnSelectedDay.isEmpty {
            particleCtrl.startParticleAnimation(forEventType: .birthday, andEndAfterTime: 5.0)
        }
    }

    func calenderView(_ calendarView: UICalendarView, touchedNextMonthButton: UIButton) {
    }

    func calenderView(_ calendarView: UICalendarView, touchedPreviousMonthButton: UIButton) {
    }
}


let vCtrl = ViewController()
let navCtrl = UINavigationController(rootViewController: vCtrl)

PlaygroundPage.current.liveView = navCtrl






