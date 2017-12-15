import Foundation

struct DependencyInjection {
    static let sharedInstance = DependencyInjection()
    fileprivate let depencyGraph: DependencyGraphProtocol
    
    fileprivate init() {
        self.depencyGraph = DependencyGraph()
    }
    
    func resolve<Service>(_ serviceType: Service.Type) -> Service {
        return self.depencyGraph.resolve(serviceType)!
    }
}
