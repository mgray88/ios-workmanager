import BackgroundTasks

extension WorkManager {

    // MARK: CRUD

    internal func getScheduledTask(forCompletedTask completedTask: BGTask) -> ScheduledTask? {
        let scheduledTask = scheduledTasks.first { scheduledTask -> Bool in
            scheduledTask.task.identifier == completedTask.identifier
        }
        return scheduledTask
//        return scheduledTasks.first { $0.task.identifier == completedTask.identifier }
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
        if scheduledTasks.contains(scheduledTask) {
            log.info("removeScheduledTask(scheduledTask:)")
            scheduledTasks.remove(scheduledTask)
        }
    }

    internal func removeScheduledTask(withIdentifier identifier: String) {
        if let scheduledTask = getScheduledTask(withIdentifier: identifier) {
            log.info("removeScheduledTask(withIdentifier identifier:)")
            removeScheduledTask(scheduledTask)
        }
    }

    internal func removeScheduledTask(withTag tag: String) {
        if let scheduledTask = getScheduledTask(withTag: tag) {
            log.info("removeScheduledTask(withTag tag:)")
            removeScheduledTask(scheduledTask)
        }
    }
    
    internal func hasScheduledTask(withIdentifier identifier: String) -> Bool {
        return nil != getScheduledTask(withIdentifier: identifier)
    }

}
