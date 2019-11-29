import BackgroundTasks

extension WorkManager {

    // MARK: CRUD

    internal func getScheduledTask(forCompletedTask completedTask: BGTask) -> ScheduledTask? {
        return scheduledTasks.first { $0.task.identifier == completedTask.identifier }
    }

    internal func getScheduledTask(withIdentifier identifier: String) -> ScheduledTask? {
        return scheduledTasks.first { $0.task.identifier == identifier }
    }

    internal func getScheduledTask(withTag tag: String) -> ScheduledTask? {
        return scheduledTasks.first { $0.task.tag == tag }
    }

    internal func getRequest(withTag tag: String) -> BGTaskRequest? {
        return getScheduledTask(withTag: tag)?.request
    }

    internal func removeScheduledTask(_ scheduledTask: ScheduledTask) {
        log.info("enter 'removeScheduledTask(scheduledTask:)'")
        if scheduledTasks.contains(scheduledTask) {
            scheduledTasks.remove(scheduledTask)
        }
    }

    internal func removeScheduledTask(withIdentifier identifier: String) {
        log.info("enter 'removeScheduledTask(withIdentifier identifier:)'")
        if let scheduledTask = getScheduledTask(withIdentifier: identifier) {
            removeScheduledTask(scheduledTask)
        }
    }

    internal func removeScheduledTask(withTag tag: String) {
        log.info("enter 'removeScheduledTask(withTag tag:)'")
        if let scheduledTask = getScheduledTask(withTag: tag) {
            removeScheduledTask(scheduledTask)
        }
    }
    
    internal func hasScheduledTask(withIdentifier identifier: String) -> Bool {
        return nil != getScheduledTask(withIdentifier: identifier)
    }

}
