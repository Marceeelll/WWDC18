import UIKit

public protocol FilterEventTypesDelegate {
    func receiveNew(filterSelection: [EventType])
}

public class FilterEventTypesViewController: UITableViewController {
    public var selectedFilter: [EventType]!
    
    public var filterDelegate: FilterEventTypesDelegate?
    
    override public func viewDidLoad() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        filterDelegate?.receiveNew(filterSelection: selectedFilter)
    }
    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EventType.allEventTypes.count
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let eventType = getEventType(atIndexPath: indexPath)
        cell.textLabel?.text = "\(eventType.symbol)\(eventType.name)"
        cell.accessoryType = isSelected(eventType: eventType) ? .checkmark : .none
        return cell
    }
    
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
