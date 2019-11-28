//
//  RequestBuilder.swift
//  Workmanager
//
//  Created by Frank Gregor on 28.11.19.
//

import Foundation
import BackgroundTasks

protocol RequestBuilder {
    var request: BGTaskRequest { get set }
    
    init(identifier: String)
    func build() -> BGTaskRequest
}
