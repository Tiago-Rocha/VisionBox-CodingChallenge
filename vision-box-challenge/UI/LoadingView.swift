import UIKit
import KVNProgress

class LoadingView {
    static let backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
    
    enum Style {
        case fullScreen
        case indicatorOnly
        
        func getConfig() -> KVNProgressConfiguration {
            let config = KVNProgressConfiguration()
            config.successColor = UIColor.green
            config.errorColor = UIColor.red
            config.statusColor = UIColor.lightGray
            config.backgroundTintColor = backgroundColor
            
            switch self {
            case .fullScreen:
                config.isFullScreen = true
                config.doesAllowUserInteraction = false
                config.circleStrokeForegroundColor = UIColor.lightGray
            case .indicatorOnly:
                config.doesAllowUserInteraction = false
                config.isFullScreen = false
                config.circleStrokeForegroundColor = UIColor.lightGray
            }
            return config
        }
    }
    
    /**
     Show translucent view
     
     - parameter title: text to be presented
     - parameter style: style of loading view
     */
    static func show(withTitle title: String?, style: Style) {
        KVNProgress.setConfiguration(style.getConfig())
        KVNProgress.show(withStatus: title)
    }
    static func showSuccess(withTitle title: String?, style: Style, completionBlock: ((Void) -> Void)? = nil) {
        KVNProgress.setConfiguration(style.getConfig())
        KVNProgress.showSuccess(withStatus: title, completion: completionBlock)
    }
    static func showError(withTitle title: String?, style: Style) {
        KVNProgress.setConfiguration(style.getConfig())
        KVNProgress.showError(withStatus: title)
    }
    
    /**
     dismiss view controller
     
     - parameter completionBlock: execute after loading view dismiss
     */
    static func dismiss(_ completionBlock: ((Void) -> Void)? = nil) {
        KVNProgress.dismiss(completion: completionBlock)
    }
}

