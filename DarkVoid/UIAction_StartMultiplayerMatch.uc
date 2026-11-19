class UIAction_StartMultiplayerMatch extends UIAction;

event Activated()
{
    local WorldInfo WI;

    WI = GetWorldInfo();
    // End:0x68
    if(((WI != none) && WI.Game != none) && int(WI.NetMode) != int(NM_Client))
    {
        WI.Game.RestartGame();
    }
    //return;    
}

event bool IsValidLevelSequenceObject()
{
    return true;
    //return ReturnValue;    
}
