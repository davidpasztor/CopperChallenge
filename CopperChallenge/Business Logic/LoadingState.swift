//
//  LoadingState.swift
//  CopperChallenge
//
//  Created by David Pasztor on 19/02/2022.
//

/// Represents the current state of a long running task (such as a network request)
public enum LoadingState {
    /// Loading was not yet initiated
    case initial
    /// Data couldn't be loaded due to an error
    case error(Error)
    /// Data was successfully loaded
    case loaded
    /// Loading in progress
    case loading
}
