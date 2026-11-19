class AdvGFxMenuHudWrapper extends AdvGFxHudWrapper
    transient
    config(Game)
    hidecategories(Navigation);

var const class<AdvFrontEnd> FrontEndClass;
var const class<AdvFrontEndParty> PartyFrontEndClass;
var AdvFrontEnd Frontend;
var bool bStartedMovie;

simulated function PostBeginPlay()
{
    super(EvilGFxHudWrapper).PostBeginPlay();
    //return;    
}

event Destroyed()
{
    // End:0x39
    if(Frontend != none)
    {
        Frontend.Close();
        Frontend = none;
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
        if((WorldInfo.GRI != none) || AdvLocalPlayer(PlayerOwner.Player).bIsFirstFrontEndLoad)
        {
            InitializeFrontEnd();
            bStartedMovie = true;
        }
    }
    // End:0x126
    if(Frontend != none)
    {
        Frontend.Tick(RenderDelta);
    }
    //return;    
}

simulated function InitializeFrontEnd()
{
    // End:0x105
    if(((Class'Engine.Engine'.static.GetEngine().GamePlayers[0] == PlayerOwner.Player) && Frontend == none) && int(PlayerOwner.Role) == int(ROLE_Authority))
    {
        // End:0x105
        if(FrontEndClass != none)
        {
            Frontend = new FrontEndClass;
            Frontend.Init(LocalPlayer(PlayerOwner.Player));            
        }
    }
    //return;    
}

simulated function InitializePartyFrontEnd()
{
    // End:0xDA
    if((Class'Engine.Engine'.static.GetEngine().GamePlayers[0] == PlayerOwner.Player) && Frontend == none)
    {
        // End:0xDA
        if(PartyFrontEndClass != none)
        {
            Frontend = new PartyFrontEndClass;
            Frontend.Init(LocalPlayer(PlayerOwner.Player));            
        }
    }
    //return;    
}

simulated function InitializeMigratedHostFrontEnd()
{
    // End:0xDA
    if((Class'Engine.Engine'.static.GetEngine().GamePlayers[0] == PlayerOwner.Player) && Frontend == none)
    {
        // End:0xDA
        if(PartyFrontEndClass != none)
        {
            Frontend = new PartyFrontEndClass;
            Frontend.InitAsMigratedHost(LocalPlayer(PlayerOwner.Player));            
        }
    }
    //return;    
}

simulated function RestartFrontEnd(optional bool bRestartFrontEnd = true)
{
    // End:0x3E
    if(Frontend != none)
    {
        Frontend.Close();
        Frontend = none;
    }
    // End:0x78
    if(CreditsMovie != none)
    {
        CreditsMovie.Close();
        CreditsMovie = none;
    }
    AdvLocalPlayer(PlayerOwner.Player).bIsFirstFrontEndLoad = bRestartFrontEnd;
    InitializeFrontEnd();
    //return;    
}

function TogglePauseMenu()
{
    //return;    
}

defaultproperties
{
    FrontEndClass=Class'AdvFrontEnd'
    PartyFrontEndClass=Class'AdvFrontEndParty'
    HUDClass=Class'AdvMenuGFxHud'
}