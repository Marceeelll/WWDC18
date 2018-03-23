import UIKit

public protocol UIEmitterCellsOverviewDelegate {
    func editEmitterCell(atIndexPath indexPath: IndexPath)
}

public class UIEmitterCellsOverviewTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    public var emitter: CAEmitterLayer!
    
    public var overviewDelegate: UIEmitterCellsOverviewDelegate?
    
    override public init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        dataSource = self
        delegate = self
    }
    
    
    // MARK: - UITableViewDataSource
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emitter.emitterCells?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basic_apple_cell", for: indexPath)
        
        cell.textLabel?.text = "Emitter Cell Nr. \(indexPath.row+1)"
        
        if let emitterCell = getEmitterCell(atIndexPath: indexPath) {
            let cgImage = emitterCell.contents as! CGImage
            let particleImage = UIImage(cgImage: cgImage)
            cell.imageView?.image = particleImage
            cell.imageView?.dyeImage(imageColor: UIColor.red)
        }
        
        return cell
    }
    
    public func getEmitterCell(atIndexPath indexPath: IndexPath) -> CAEmitterCell? {
        return emitter.emitterCells?[indexPath.row]
    }
    
    
    // MARK: - UITableViewDelegate
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.overviewDelegate?.editEmitterCell(atIndexPath: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { (rowAction, indexPath) in
            self.emitter.emitterCells?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            let cellsToReload = self.cellIndexPaths(afterIndexPath: indexPath)
            tableView.reloadRows(at: cellsToReload, with: .none)
        }
        deleteAction.backgroundColor = UIColor.red
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (rowAction, indexPath) in
            self.overviewDelegate?.editEmitterCell(atIndexPath: indexPath)
        }
        editAction.backgroundColor = UIColor.orange
        
        return [deleteAction, editAction]
    }
    
    func cellIndexPaths(afterIndexPath indexPath: IndexPath) -> [IndexPath] {
        let startCell = self.cellForRow(at: indexPath)
        var indexPaths: [IndexPath] = []
        var foundCell = false
        for index in 0..<self.visibleCells.count {
            let cell = self.visibleCells[index]
            if cell == startCell {
                foundCell = true
            }
            if foundCell {
                if let cellIndexPath = self.indexPath(for: cell) {
                    let indexPath = IndexPath(row: index, section: cellIndexPath.section)
                    indexPaths.append(indexPath)
                }
            }
        }
        return indexPaths
    }
}
