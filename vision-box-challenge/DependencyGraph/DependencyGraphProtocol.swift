import Foundation

protocol DependencyGraphProtocol {
    func resolve<Service>(_ serviceType: Service.Type) -> Service?
}
