class SPLocalPlayer extends LocalPlayer within Engine
    transient
    native
    config(Engine);

// Export USPLocalPlayer::execSpawnPlayActor(FFrame&, void* const)
native function bool SpawnPlayActor(string URL, out string OutError);
