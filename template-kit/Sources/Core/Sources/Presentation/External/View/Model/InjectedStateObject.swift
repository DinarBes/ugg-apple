//
//  InjectedStateObject.swift
//  template-kit
//
//  Created by Archibbald on 16.04.2026.
//

import Combine
import SwiftUI
import Swinject

@MainActor
@propertyWrapper
public struct InjectedStateObject<ObjectType: ObservableObject>: @MainActor DynamicProperty {
    @StateObject var wrapper = Wrapper()
    
    @Environment(\.di) var di
    
    public init() { }
    
    public var wrappedValue: ObjectType {
        wrapper.viewModel
    }
    
    public var projectedValue: ObservedObject<ObjectType>.Wrapper {
        ObservedObject(wrappedValue: wrapper.viewModel).projectedValue
    }
    
    public mutating func update() {
        let viewModel = wrapper.viewModel ?? di.resolve(ObjectType.self)
        
        guard let viewModel else { fatalError("\(ObjectType.self) not injected") }
        
        wrapper.viewModel = viewModel
    }
    
    @MainActor
    final class Wrapper: ObservableObject {
        var viewModel: ObjectType! {
            didSet {
                viewModel?.objectWillChange
                    .receive(on: RunLoop.main)
                    .sink { [weak self] _ in
                        self?.objectWillChange.send()
                    }
                    .store(in: &cancellable)
            }
        }
        
        private var cancellable: Set<AnyCancellable> = []
    }
}
