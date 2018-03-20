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
        if let selectedDate = selectedDate {
            let times = event.getTimes(forDate: selectedDate)
            cell.startTimeLabel.text = times.startTime
            cell.endTimeLabel.text = times.endTime
        }
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
