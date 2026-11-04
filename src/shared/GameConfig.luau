local GameConfig = {
	SchemaVersion = 1,
	DataStoreName = "OverclockSimulator_Dev_v1",
	StartingCompute = 0,
	StartingCores = 1,
	StartingCache = 1,
	ComputePerCorePerSecond = 1,
	CapacityPerCache = 50,
	OfflineAccrualLimitSeconds = 4 * 60 * 60,
	SaveIntervalSeconds = 60,
}

return GameConfig
