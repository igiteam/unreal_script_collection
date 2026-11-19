class GFxUIView extends GFxObject within GFxMoviePlayer;

var(Flags) bool bRequiresNetwork;

final function LocalPlayer GetPlayerOwner(optional int PlayerIndex = -1)
{
    return Outer.GetLP();
    //return ReturnValue;    
}

final function UDKPlayerController GetUDKPlayerOwner(optional int PlayerIndex = -1)
{
    return UDKPlayerController(Outer.GetPC());
    //return ReturnValue;    
}

static final function bool HasLinkConnection()
{
    return Class'Engine.UIInteraction'.static.HasLinkConnection();
    //return ReturnValue;    
}

function string GetPlayerName()
{
    return "Player";
    //return ReturnValue;    
}

event bool IsLoggedIn(optional int ControllerId = 255, optional bool bRequireOnlineLogin)
{
    // End:0x22
    if(ControllerId == 255)
    {
        ControllerId = 0;
    }
    return Class'Engine.UIInteraction'.static.IsLoggedIn(ControllerId, bRequireOnlineLogin);
    //return ReturnValue;    
}

function string GetCommonOptionsURL()
{
    local string URL;

    URL $= ("?name=" $ "Player");
    return URL;
    //return ReturnValue;    
}

function int GetPlayerIndex()
{
    local int PlayerIndex;
    local LocalPlayer LP;

    LP = GetPlayerOwner();
    // End:0x6E
    if(LP != none)
    {
        PlayerIndex = Class'Engine.UIInteraction'.static.GetPlayerIndex(LP.ControllerId);        
    }
    return PlayerIndex;
    //return ReturnValue;    
}

function int GetPlayerControllerId(int PlayerIndex)
{
    return Class'Engine.UIInteraction'.static.GetPlayerControllerId(PlayerIndex);
    //return ReturnValue;    
}

final function ConsoleCommand(string Cmd, optional bool bWriteToLog)
{
    // End:0x4E
    if(Outer.GetPC() != none)
    {
        Outer.ConsoleCommand(Cmd);
    }
    //return;    
}
