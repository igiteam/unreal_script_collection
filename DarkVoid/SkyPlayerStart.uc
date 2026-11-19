class SkyPlayerStart extends PlayerStart
    native;

var(PlayerStart) byte TeamNumber;
var(PlayerStart) SkyCameraTree CamTree;
var(PlayerStart) bool bStartInRocketpackThrust;

event PreBeginPlay()
{
    super(Actor).PreBeginPlay();
    // End:0x4C
    if(PlayerArchetype == none)
    {
        PlayerArchetype = Pawn(DynamicLoadObject("ch_max_valenti.arch.ar_max_valenti", Class'Engine.Pawn'));
    }
    //return;    
}
