class TurokFEGame extends GameInfo
    native
    config(Game)
    hidecategories(Navigation,Movement,Collision);

event PreBeginPlay()
{
    Class'Engine.TurokOnlineDashboard'.static.Instance().SetBusyScreenEnabled(true);
    // End:0x65
    if(Class'Engine.TurokOnlineDashboard'.static.Instance().GetSignedInProfile() == none)
    {
        Class'TurokEngine.TurokUI'.static.GetEngine().GamePlayers[0].UnLockControllerPort();
    }
    //return;    
}

event PostBeginPlay()
{
    //return;    
}

event GameEnding()
{
    Class'Engine.TurokOnlineDashboard'.static.Instance().SetBusyScreenEnabled(false);
    super.GameEnding();
    //return;    
}

event Destroyed()
{
    //return;    
}

function Reset()
{
    //return;    
}

event InitGame(string Options, out string ErrorMessage)
{
    WorldInfo.NotifyMatchStarted();
    //return;    
}

event PreLogin(string Options, string Address, out string ErrorMessage, out string FailCode)
{
    ErrorMessage = "NotSupported";
    //return;    
}

event @NULL Login(@NULL NewPlayerId, string Portal, string Options, out string ErrorMessage)
{
    ErrorMessage = "NotSupported";
    return none;
    //return ReturnValue;    
}

event PostLogin(@NULL NewPlayer)
{
    //return;    
}

defaultproperties
{
    bRestartLevel=false
    bDelayedStart=false
    bWaitingToStartMatch=true
    HUDType=none
    PlayerControllerClass=none
}