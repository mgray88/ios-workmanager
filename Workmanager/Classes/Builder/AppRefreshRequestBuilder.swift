//
//  AppRefreshRequestBuilder.swift
//  Workmanager
//
//  Created by Frank Gregor on 28.11.19.
//

import Foundation
import BackgroundTasks

class AppRefreshRequestBuilder {
    
    // MARK: Private properties

    private let request: BGAppRefreshTaskRequest

    // MARK: Init

    init(identifier: String) {
        request = BGAppRefreshTaskRequest(identifier: identifier)
    }

    // MARK: Building blocks

    func appendInitialDelay(_ initialDelay: TimeInterval) -> AppRefreshRequestBuilder {
        request.earliestBeginDate = Date(timeIntervalSinceNow: initialDelay)
        return self
    }

    func build() -> BGAppRefreshTaskRequest {
        return request
    }

}
