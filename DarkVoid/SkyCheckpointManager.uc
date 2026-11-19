class SkyCheckpointManager extends CheckpointManager
    native
    config(Engine);

// Export USkyCheckpointManager::execTriggerCheckpoint(FFrame&, void* const)
native function TriggerCheckpoint(name CheckpointName);

// Export USkyCheckpointManager::execTriggerCheckpointQuickSave(FFrame&, void* const)
native function TriggerCheckpointQuickSave(name CheckpointName);
