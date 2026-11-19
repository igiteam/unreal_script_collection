class MatineeActor extends Actor
    native
    nativereplication
    notplaceable
    hidecategories(lighting);

var const SeqAct_Interp InterpAction;
var bool bIsPlaying;
var bool bReversePlayback;
var float Position;

replication
{
    // Pos:0x000
    if(bNetInitial && int(Role) == int(ROLE_Authority))
        InterpAction;

    // Pos:0x018
    if(bNetDirty && int(Role) == int(ROLE_Authority))
        Position, bIsPlaying, 
        bReversePlayback;
}

event Update()
{
    bIsPlaying = InterpAction.bIsPlaying;
    bReversePlayback = InterpAction.bReversePlayback;
    Position = InterpAction.Position;
    NetUpdateTime = WorldInfo.TimeSeconds - 1.0000000;
    return;
}

defaultproperties
{
    Position=-1.0000000
    bAlwaysRelevant=true
    bReplicateMovement=false
    bSkipActorPropertyReplication=true
    bOnlyDirtyReplication=true
    RemoteRole=1
    NetUpdateFrequency=1.0000000
    NetPriority=2.7000000
}