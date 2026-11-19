class PainGFxMenuHudWrapper extends PainGFxHudWrapper
    transient
    config(Game)
    hidecategories(Navigation);

var const class<PKFrontEnd> FrontEndClass;
var PKFrontEnd FrontEnd;
var bool bStartedMovie;

simulated function PostBeginPlay()
{
    super(EvilGFxHudWrapper).PostBeginPlay();
    //return;    
}

event Destroyed()
{
    // End:0x39
    if(FrontEnd != none)
    {
        FrontEnd.Close();
        FrontEnd = none;
    }
    super.Destroyed();
    //return;    
}

function DrawHUD()
{
    // End:0xEF
    if((Class'Engine.Engine'.static.GetEngine().GamePlayers[0] == LocalPlayer(PlayerOwner.Player)) && !bStartedMovie)
    {
        // End:0xEF
        if((WorldInfo.GRI != none) || PKLocalPlayer(PlayerOwner.Player).bIsFirstFrontEndLoad)
        {
            InitializeFrontEnd();
            bStartedMovie = true;
        }
    }
    // End:0x126
    if(FrontEnd != none)
    {
        FrontEnd.Tick(RenderDelta);
    }
    //return;    
}

simulated function InitializeFrontEnd()
{
    // End:0x105
    if(((Class'Engine.Engine'.static.GetEngine().GamePlayers[0] == PlayerOwner.Player) && FrontEnd == none) && int(PlayerOwner.Role) == int(ROLE_Authority))
    {
        // End:0x105
        if(FrontEndClass != none)
        {
            FrontEnd = new FrontEndClass;
            FrontEnd.Init(LocalPlayer(PlayerOwner.Player));            
        }
    }
    //return;    
}

simulated function RestartFrontEnd(optional bool bRestartFrontEnd = true)
{
    // End:0x3E
    if(FrontEnd != none)
    {
        FrontEnd.Close();
        FrontEnd = none;
    }
    // End:0x78
    if(CreditsMovie != none)
    {
        CreditsMovie.Close();
        CreditsMovie = none;
    }
    PKLocalPlayer(PlayerOwner.Player).bIsFirstFrontEndLoad = bRestartFrontEnd;
    InitializeFrontEnd();
    //return;    
}

function TogglePauseMenu()
{
    //return;    
}

defaultproperties
{
    FrontEndClass=Class'PKFrontEnd'
}