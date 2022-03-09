import UIKit

public enum RouterBack {
    case auto
    case toViewController(_ controllerType: UIViewController.Type)
}

// MARK: - Route back
public extension Router {
    
    /**
     可选:
     auto: 回到上一层 (pop / dismiss)
     to: 回到某一层(pop to viewController, pop N controllers, pop to controller with UIViewController.Type)
     
     toViewController(_ UIViewController.Type)
     */
    
    @discardableResult static func back(_ back: RouterBack = .auto, animated: Bool = true, defer: (() -> Void)? = nil) -> Bool {
        self.provider.back(back, animated: animated, defer: `defer`)
    }
}
