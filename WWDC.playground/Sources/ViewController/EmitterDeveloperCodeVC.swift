import UIKit

public class EmitterDeveloperCodeViewController: UIViewController {
    public var emitter: CAEmitterLayer!
    var codeTextView = UITextView()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(codeTextView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareCode))
        
        let code = emitter.developerDescription()
        codeTextView.text = code
        
        ConstraintAssistant.addConstraints(on: codeTextView, andMatchTheSameSizeAsView: self.view)
    }
    
    @objc func shareCode() {
        let code = emitter.developerDescription()
        let shareActivity = UIActivityViewController(activityItems: [code], applicationActivities: nil)
        present(shareActivity, animated: true)
    }
}
