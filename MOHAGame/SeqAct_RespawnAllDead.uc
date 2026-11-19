class SeqAct_RespawnAllDead extends SeqAct_MultiplayerITPGameInfoBase
    native
    hidecategories(Object);

enum ERespawnAllDeadType
{
    ERADT_ALL,                      // 0
    ERADT_AXIS,                     // 1
    ERADT_ALLIED,                   // 2
    ERADT_ALLIED_AND_PRE_AXIS,      // 3
    ERADT_MAX                       // 4
};

var() SeqAct_RespawnAllDead.ERespawnAllDeadType RespawnAllDeadType;

event NotifyGameInfo()
{
    // End:0x6E
    if(GetWorldInfo() != none)
    {
        // End:0x6E
        if(int(GetWorldInfo().NetMode) != int(NM_Client))
        {
            // End:0x6E
            if(GetWorldInfo().Game.IsA('AirborneTeamGameInfo'))
            {
                AirborneTeamGameInfo(GetWorldInfo().Game).RespawnAllDead(RespawnAllDeadType);
            }
        }
    }
    //return;    
}

defaultproperties
{
    InputLinks[0]=(LinkDesc="Respawn",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000)
    ObjName="Respawn All Dead"
}