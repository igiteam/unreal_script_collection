class SkyAILandingZone extends Volume
    native;

var transient Vector TheCenter;

simulated event PostBeginPlay()
{
    Disable('Touch');
    TheCenter = CalcCenter();
    //return;    
}

event Destroyed()
{
    local SkyGame Info;

    // End:0x43
    if(WorldInfo != none)
    {
        Info = SkyGame(WorldInfo.Game);
        // End:0x43
        if(Info != none)
        {
            Info.AvailLandingZones.RemoveItem(self);
        }
    }
    super(Actor).Destroyed();
    //return;    
}
