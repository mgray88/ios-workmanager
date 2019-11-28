import BackgroundTasks

public class WorkManager {
    
    // MARK: Properties
    
    internal let scheduler = WorkScheduler()
    internal var scheduledTasks: Set<ScheduledTask> = []
    
    // MARK: Initialization
    
    public static let shared = WorkManager()
    private init() {}
    
    // MARK: Registering
    
    public func registerTask(withIdentifier identifier: String, onTrigger: @escaping (BGTask) -> ()) -> Bool {
        return BGTaskScheduler.shared.register(forTaskWithIdentifier: identifier, using: nil) { task in
            onTrigger(task)
        }
    }
    
    // MARK: Scheduling
    
    public func schedule(task: Task) throws {
        if let existingWorkPolicy = task.existingWorkPolicy,
            let _ = getScheduledTask(withIdentifier: task.identifier) {
            switch existingWorkPolicy {
            case .keep:
                return
            case .replace:
                cancelTask(withIdentifier: task.identifier)
            }
        }
        
        try scheduler.scheduleTask(task) { request in
            scheduledTasks.insert(ScheduledTask(task: task, request: request))
        }
    }
    
    // MARK: Callbacks
    
    public func taskDidFinish(_ task: BGTask, success: Bool) throws {
        task.setTaskCompleted(success: success)
        
        guard let scheduledTask = getScheduledTask(forCompletedTask: task) else {
            return
        }
        
        guard success else {
            try handleError(withScheduledTask: scheduledTask)
            return
        }
        
        try handleSuccess(withScheduledTask: scheduledTask)
    }
    
    // MARK: Success handlers
    
    private func handleSuccess(withScheduledTask scheduledTask: ScheduledTask) throws {
        if scheduledTask.task.isPeriodic {
            try handlePeriodicTaskSuccess(withScheduledTask: scheduledTask)
        } else {
            removeScheduledTask(scheduledTask)
        }
    }
    
    private func handlePeriodicTaskSuccess(withScheduledTask scheduledTask: ScheduledTask) throws {
        let previousTask = scheduledTask.task
        try schedule(task: previousTask)
    }
    
    // MARK: Error handlers
    
    private func handleError(withScheduledTask scheduledTask: ScheduledTask) throws {
        let previousTask = scheduledTask.task
        
        guard let backoffPolicy = previousTask.backoffPolicy else { return }
        
        var newTask = previousTask
        var delay = 0.0
        
        switch backoffPolicy {
            case .linear:
                delay = previousTask.initialDelay + previousTask.backoffPolicyDelay
            case .exponential:
                if previousTask.initialDelay == 0.0 {
                    delay = previousTask.backoffPolicyDelay
                } else {
                    delay = pow(previousTask.initialDelay, 2)
            }
        }
        
        newTask.initialDelay = delay
        try schedule(task: newTask)
    }
}
