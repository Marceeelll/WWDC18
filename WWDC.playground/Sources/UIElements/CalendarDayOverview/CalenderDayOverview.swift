import UIKit


public protocol UICalendarDayOverviewTableViewDelegate {
    func overviewTableView(_ tableView: UICalendarDayOverviewTableView, didSelectedEvent event: Event)
}

public class UICalendarDayOverviewTableView: UITableView {
    public var data: [Event] = []
    public var selectedDate: Date?
    
    public var overViewDelegate: UICalendarDayOverviewTableViewDelegate?
    
    public override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        self.dataSource = self
        self.delegate = self
    }
    
}

extension UICalendarDayOverviewTableView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UICalendarDayOverviewTableViewCell
        let event = getEvent(atIndexPath: indexPath)
        cell.descriptionLabel.text = "\(event.type.symbol)\(event.title)"
        cell.descriptionLabel.adjustsFontSizeToFitWidth = true
        if let selectedDate = selectedDate {
            let times = event.getTimes(forDate: selectedDate)
            cell.startTimeLabel.text = times.startTime
            cell.endTimeLabel.text = times.endTime
        }
        
        cell.flipCell()
        cell.seperatorView.backgroundColor = event.type.color
        return cell
    }
    
    public func getEvent(atIndexPath indexPath: IndexPath) -> Event {
        return  data[indexPath.row]
    }
}

extension UICalendarDayOverviewTableView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedEvent = getEvent(atIndexPath: indexPath)
        overViewDelegate?.overviewTableView(self, didSelectedEvent: selectedEvent)
    }
}



// START -- UICalendarDayOverviewTableViewCell

public class UICalendarDayOverviewTableViewCell: UITableViewCell {
    private var timeStackView = UIStackView()
    public var startTimeLabel = UILabel()
    public var endTimeLabel = UILabel()
    public var descriptionLabel = UILabel()
    public var eventImageView = UILabel()
    public var seperatorView = UIView()
    
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
    
    func flipCell() {
        UIView.transition(with: self, duration: AnimationDuration.normal, options: .transitionFlipFromTop, animations: {})
    }
    
}
