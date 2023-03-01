//
//  PaginationCursor.swift
//  Breadfast_posts
//
//  Created by Andrey on 01/03/2023.
//

import Foundation
import DomainLayer

final class PaginationCursor {
    private enum State {
        case locked
        case unlocked
    }
    
    private var state: PaginationStateEntity?
    private var internalState: State = .unlocked
    
    var allowsToLoadNextPage: Bool { internalState != .locked }
    
    var nextPage: Int? {
        guard internalState == .unlocked else { return nil }
        guard let state = state else {
            internalState = .locked
            return 1
        }
        guard state.currentPage < state.totalPages else { return nil }
        internalState = .locked
        return state.currentPage + 1
    }
    
    func reset() {
        internalState = .unlocked
        state = nil
    }
    
    func update(_ newState: PaginationStateEntity) {
        internalState = .unlocked
        self.state = newState
    }
}
