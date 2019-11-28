extension Task {
    
    /// Creates and returns a default Task instance dedicated for scheduling.
    /// - Parameters:
    ///   - identifier: A unique identifier which must be registered by setting BGTaskSchedulerPermittedIdentifiers in your Info.plist.
    ///   - name: A name for the task.
    ///   - type: A value which describes the type of your task. There are only two allowed values: `.processing` for long running tasks and `.refresh` for short running tasks (max. 30 seconds).
    ///
    /// - Returns: An preconfigured instance of `Task` which is ready for use.
    public static func defaultTask(identifier: String, name: String, type: TaskType = .refresh) -> Task {
        let task = Task(identifier: identifier,
                        name: name,
                        type: type,
                        initialDelay: 0.0,
                        backoffPolicyDelay: 900.0,
                        frequency: 0.0)
        return task
    }

    /// Creates and returns a default Task instance dedicated for scheduling.
    /// - Parameters:
    ///   - identifier: A unique identifier which must be registered by setting BGTaskSchedulerPermittedIdentifiers in your Info.plist.
    ///   - name: A name for the task.
    ///   - frequency: A value in seconds your task should be scheduled.
    ///   - type: A value which describes the type of your task. There are only two allowed values: `.processing` for long running tasks and `.refresh` for short running tasks (max. 30 seconds).
    ///
    /// - Returns: An preconfigured instance of `Task` which is ready for use.
    public static func defaultPeriodicTask(identifier: String, name: String, frequency: TimeInterval = 15 * 60.0, type: TaskType = .refresh) -> Task {
        var task = Task.defaultTask(identifier: identifier, name: name, type: type)
        task.frequency = frequency

        return task
    }

}
