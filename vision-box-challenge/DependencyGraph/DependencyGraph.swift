import Foundation
import Swinject

struct DependencyGraph: DependencyGraphProtocol {
    fileprivate let dependencies: Resolver
    
    init() {
        let assembler = try! Assembler(assemblies: [RepositoryAssembly() as Assembly])
        self.dependencies = (assembler.resolver as! Container).synchronize()
    }
    
    func resolve<Service>(_ serviceType: Service.Type) -> Service? {
        return self.dependencies.resolve(serviceType)
    }
    class RepositoryAssembly: Assembly {
        func assemble(container: Container) {
            container.register(PlacesViewController.self) { r in
                PlacesViewController(viewModel: r.resolve(PlacesViewModel.self)!)
            }
            
            container.register(PlacesViewModel.self) { r in
                PlacesViewModel(repository: r.resolve(PlaceRepository.self)!)
            }
            
            container.register(PlaceRepository.self) { r in
                PlaceRepository(apiProvider: r.resolve(APIPlaceProvider.self)!)
                }.inObjectScope(.container)
            
            container.register(APIPlaceProvider.self) { r in
                APIPlaceProvider()
            }
        }
    }
}

