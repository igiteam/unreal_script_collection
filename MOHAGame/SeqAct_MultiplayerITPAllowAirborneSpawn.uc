class SeqAct_MultiplayerITPAllowAirborneSpawn extends SeqAct_MultiplayerITPGameInfoBase
    native
    hidecategories(Object);

var() bool bAllowSpawningInPlane;

event NotifyGameInfo()
{
    // End:0x49
    if(GetWorldInfo().Game.IsA('AirborneTeamGameInfo'))
    {
        AirborneTeamGameInfo(GetWorldInfo().Game).AllowInAirSpawns(bAllowSpawningInPlane);
    }
    //return;    
}

defaultproperties
{
    bAllowSpawningInPlane=true
    ObjName="Allow Spawning in the Plane"
}