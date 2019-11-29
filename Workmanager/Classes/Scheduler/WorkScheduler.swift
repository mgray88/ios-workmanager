import BackgroundTasks

class WorkScheduler {

    // MARK: Scheduling

    func scheduleTask(_ task: Task, onScheduled: (BGTaskRequest) -> Void) throws {
        var request: BGTaskRequest
        switch task.type {
            case .processing:
                request = ProcessingRequestBuilder(identifier: task.identifier)
                    .appendConstraints(task.constraints)
                    .appendInitialDelay(task.initialDelay)
                    .build()

            case .refresh:
                request = AppRefreshRequestBuilder(identifier: task.identifier)
                    .build()
        }

        try submitRequest(request)
        onScheduled(request)
    }

    // MARK: Submit

    private func submitRequest(_ request: BGTaskRequest) throws {
        try BGTaskScheduler.shared.submit(request)
    }
}
