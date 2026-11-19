class SkyPawn_Naga extends SkyPawn_Watcher
    native
    config(Pawn);

var(Sounds) const editconst export editinline AudioComponent SlitherSound;
var() float SlitherSpeed;

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    SetTimer(5.0000000, false, 'RestoreCollision');
    //return;    
}

function RestoreCollision()
{
    // End:0x1C
    if(!bCollideActors)
    {
        SetCollision(true, bBlockActors, bIgnoreEncroachers);
    }
    //return;    
}
