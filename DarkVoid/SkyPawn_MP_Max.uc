class SkyPawn_MP_Max extends SkyPawn_MP
    config(Game);

simulated function PostBeginPlay()
{
    super(SkyPawnCoverUser).PostBeginPlay();
    //return;    
}
