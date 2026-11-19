class AdvGRI_MP extends AdvGRI
    config(Game)
    hidecategories(Navigation,Movement,Collision);

var repnotify bool bFocusHighlightsEnabled;

replication
{
    // Pos:0x000
    if(bNetDirty
        bFocusHighlightsEnabled;
}

simulated event ReplicatedEvent(name VarName)
{
    switch(VarName)
    {
        // End:0x2C
        case 'bFocusHighlightsEnabled':
            UpdateFocusHighlightsEnabled();
            // End:0x45
            break;
        // End:0xFFFF
        default:
            super.ReplicatedEvent(VarName);
            // End:0x45
            break;
            break;
    }
    //return;    
}

simulated function UpdateFocusHighlightsEnabled()
{
    local AdvPlayerControllerMP PC;

    // End:0x5E
    foreach WorldInfo.LocalPlayerControllers(Class'AdvPlayerControllerMP', PC)
    {
        PC.NotifyFocusModeChanged(bFocusHighlightsEnabled);        
    }    
    //return;    
}
