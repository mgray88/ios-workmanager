public struct Task: TaskRepresentable, Hashable {

    public var identifier: String
    public var name: String?
    public var type: TaskType
    public var initialDelay: TimeInterval
    public var backoffPolicyDelay: TimeInterval
    public var tag: String?
    public var existingWorkPolicy: ExistingWorkPolicy?
    public var constraints: [Constraints]?
    public var backoffPolicy: BackoffPolicy?
    public var inputData: String?
    public var frequency: TimeInterval?
    public var isPeriodic: Bool {
        guard let frequency = self.frequency else { return false}
        return frequency > 0
    }

    public init(identifier: String,
                name: String?,
                type: TaskType,
                initialDelay: TimeInterval = 0.0,
                backoffPolicyDelay: TimeInterval = 900.0,
                tag: String? = nil,
                frequency: TimeInterval? = nil,
                existingWorkPolicy: ExistingWorkPolicy = .replace,
                constraints: [Constraints]? = nil,
                backoffPolicy: BackoffPolicy? = nil,
                inputData: String? = nil) {
        self.identifier = identifier
        self.name = name
        self.type = type
        self.initialDelay = initialDelay
        self.backoffPolicyDelay = backoffPolicyDelay
        self.tag = tag
        self.frequency = frequency
        self.existingWorkPolicy = existingWorkPolicy
        self.constraints = constraints
        self.backoffPolicy = backoffPolicy
        self.inputData = inputData
    }
    
    /// Creates and returns a default Task object dedicated for being executed only once.
    /// - Parameters:
    ///   - identifier: A unique identifier which must be registered by setting BGTaskSchedulerPermittedIdentifiers in your Info.plist.
    ///   - name: A name for the task.
    ///   - type: A value which describes the type of your task. There are only two allowed values: `.processing` for long running tasks and `.refresh` for short running tasks (max. 30 seconds). Default value is `.refresh`.
    ///
    /// - Returns: An preconfigured instance of `Task` which is ready for use.
    public init(oneOffTaskWithIdentifier identifier: String, name: String? = nil, type: TaskType = .refresh) {
        self.init(identifier: identifier, name: name, type: type, frequency: 0.0)
    }
    
    /// Creates and returns a default Task object dedicated for scheduling with a given frequency.
    /// - Parameters:
    ///   - identifier: A unique identifier which must be registered by setting BGTaskSchedulerPermittedIdentifiers in your Info.plist.
    ///   - name: A name for the task.
    ///   - frequency: A value in seconds your task should be scheduled. Default value is 900 seconds (15 minutes).
    ///   - type: A value which describes the type of your task. There are only two allowed values: `.processing` for long running tasks and `.refresh` for short running tasks (max. 30 seconds). Default value is `.refresh`.
    ///
    /// - Returns: An preconfigured instance of `Task` which is ready for use.
    public init(periodicTaskWithIdentifier identifier: String, name: String? = nil, type: TaskType = .refresh, frequency: TimeInterval = 15 * 60.0) {
        self.init(identifier: identifier, name: name, type: type, frequency: frequency)
    }

}
