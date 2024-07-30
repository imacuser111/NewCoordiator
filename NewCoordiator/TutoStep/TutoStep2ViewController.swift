import UIKit

protocol TutoStep2ViewControllerNavigation: AnyObject {
    // Add here functions to navigate away from this screen, to ask the Coordinator to show another screen
    func closeTutorial()
    
    func pushTreeCoordinator()
}

final class TutoStep2ViewController: BaseViewController {
    
    weak var coordinator: TutoStep2ViewControllerNavigation?
    
    // MARK: - Private Properties
    
    // MARK: - Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "step2"
        view.backgroundColor = .gray
        
        let btn = UIButton()
        btn.setTitle("close", for: .normal)
        btn.frame = .init(x: 100, y: 100, width: 50, height: 50)
        btn.addTarget(self, action: #selector(close), for: .touchUpInside)
        view.addSubview(btn)
        
        let btn2 = UIButton()
        btn2.setTitle("psuhTree", for: .normal)
        btn2.frame = .init(x: 200, y: 100, width: 50, height: 50)
        btn2.addTarget(self, action: #selector(pushTreeCoordinator), for: .touchUpInside)
        view.addSubview(btn2)
    }
    
    // MARK: - Internal Funcs
    @objc func close() {
        self.coordinator?.closeTutorial()
    }
    
    @objc func pushTreeCoordinator() {
        self.coordinator?.pushTreeCoordinator()
    }
}
