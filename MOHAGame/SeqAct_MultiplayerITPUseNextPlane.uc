class SeqAct_MultiplayerITPUseNextPlane extends SeqAct_MultiplayerITPGameInfoBase
    hidecategories(Object);

var() int PlaneNumber;

event NotifyGameInfo()
{
    // End:0x48
    if(GetWorldInfo().Game.IsA('AirborneTeamGameInfo'))
    {
        AirborneTeamGameInfo(GetWorldInfo().Game).NewPlane(PlaneNumber);
    }
    //return;    
}

defaultproperties
{
    ObjName="Respawn In New Plane"
}