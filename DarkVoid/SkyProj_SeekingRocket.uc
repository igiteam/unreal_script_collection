class SkyProj_SeekingRocket extends SkyProj_MagneticAirProj;

var Actor Seeking;
var Vector InitialDir;
var float SeekUpdate;

replication
{
    // Pos:0x000
    if(bNetInitial && int(Role) == int(ROLE_Authority)
        InitialDir, Seeking;
}

simulated function float TrackingStrength(Vector ForceDir)
{
    //return ReturnValue;    
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    //return;    
}
