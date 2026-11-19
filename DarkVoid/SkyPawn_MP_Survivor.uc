class SkyPawn_MP_Survivor extends SkyPawn_MP
    config(Game);

simulated function PostBeginPlay()
{
    super(SkyPawnCoverUser).PostBeginPlay();
    //return;    
}
