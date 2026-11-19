class TurokSeqAct_EventReplicator extends SequenceAction
    native
    hidecategories(Object);

// Export UTurokSeqAct_EventReplicator::execRemoteActivated(FFrame&, void* const)
native simulated function RemoteActivated();

private final simulated event bool BroadcastEvent()
{
    local @NULL TGRI;

    TGRI = TurokMPGameReplicationInfo(GetWorldInfo().GRI);
    // End:0x27
    if(TGRI == none)
    {
        return false;
    }
    TGRI.BroadcastKismetEvent(self);
    return true;
    //return ReturnValue;    
}

defaultproperties
{
    bAutoActivateOutputLinks=false
    VariableLinks=none
    ObjName="Client Event Broadcast"
    ObjCategory="Turok Multiplayer"
}