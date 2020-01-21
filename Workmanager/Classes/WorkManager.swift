import BackgroundTasks
import SwiftyBeaver

let log = SwiftyBeaver.self

public class WorkManager {
    
    public static let identifier = "me.coi.workmanager"

    // MARK: Properties

    internal let scheduler = WorkScheduler()
    internal var scheduledTasks: Set<ScheduledTask> = []

    // MARK: Initialization

    public static let shared = WorkManager()
    private init() {}

    // MARK: Registering
    
    public static func registerTask(withIdentifier identifier: String, onTrigger: @escaping (BGTask) -> ()) -> Bool {
        return registerTask(withIdentifier: identifier, using: nil, onTrigger: onTrigger)
    }
    
    public static func registerTask(withIdentifier identifier: String, using queue: DispatchQueue?, onTrigger: @escaping (BGTask) -> ()) -> Bool {
        guard let permittedTaskIdentifiers = Bundle.main.object(forInfoDictionaryKey: "BGTaskSchedulerPermittedIdentifiers") as? [String] else {
            preconditionFailure("Could not find key 'BGTaskSchedulerPermittedIdentifiers' in your application Info.plist.")
        }
        
        if !permittedTaskIdentifiers.contains(identifier) {
            preconditionFailure("Could not find requested background task identifier: '\(identifier)'. Please check 'BGTaskSchedulerPermittedIdentifiers' in your application Info.plist.")
        }
        
        return BGTaskScheduler.shared.register(forTaskWithIdentifier: identifier, using: queue) { task in
            onTrigger(task)
        }
    }

    // MARK: Scheduling

    public func schedule(task: Task) throws {
        log.info("enter 'schedule(task:)'")
        if let existingWorkPolicy = task.existingWorkPolicy,
            let _ = getScheduledTask(withIdentifier: task.identifier) {

            switch existingWorkPolicy {
            case .keep:
                return
            case .replace:
                cancelTask(withIdentifier: task.identifier)
            }
        }

        log.debug("scheduledTasks.count: \(scheduledTasks.count)")
        try scheduler.scheduleTask(task) { request in
            scheduledTasks.insert(ScheduledTask(task: task, request: request))
            log.debug("scheduledTasks.count: \(scheduledTasks.count)")
        }
    }

    // MARK: Callbacks

    public func finish(task: BGTask, success: Bool) throws {
        DispatchQueue.main.async {
            log.info("enter 'finish(task:success:)'")

            log.debug("scheduledTasks.count: \(self.scheduledTasks.count)")
            log.debug("scheduledTasks.first?.task.identifier: \(String(describing: self.scheduledTasks.first?.task.identifier))")
            log.debug("task.identifier: \(task.identifier)")
        }
        let scheduledTask = getScheduledTask(forCompletedTask: task)

        guard success else {
            try handleError(withScheduledTask: scheduledTask!)
            task.setTaskCompleted(success: success)
            return
        }

        try handleSuccess(withScheduledTask: scheduledTask!)
        task.setTaskCompleted(success: success)
    }

    // MARK: Success handlers

    private func handleSuccess(withScheduledTask scheduledTask: ScheduledTask) throws {
        log.info("enter 'handleSuccess(withScheduledTask scheduledTask:)'")
        if scheduledTask.task.isPeriodic {
            log.info("processing periodic task")
            let task = scheduledTask.task
            try schedule(task: task)

        } else {
            log.info("processing non periodic task")
            removeScheduledTask(scheduledTask)
        }
    }

    // MARK: Error handlers

    private func handleError(withScheduledTask scheduledTask: ScheduledTask) throws {
        var task = scheduledTask.task
        guard let backoffPolicy = task.backoffPolicy else { return }

        var delay = 0.0

        switch backoffPolicy {
            case .linear:
                delay = task.initialDelay + task.backoffPolicyDelay
            case .exponential:
                if task.initialDelay == 0.0 {
                    delay = task.backoffPolicyDelay
                } else {
                    delay = pow(task.initialDelay, 2)
            }
        }

        task.initialDelay = delay
        try schedule(task: task)
    }
}
