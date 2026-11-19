//=============================================================================
// Scout used for path generation.
//=============================================================================

class SASScout extends SASPawn
	native
	notplaceable;

function PreBeginPlay()
{
	Destroy(); //scouts shouldn't exist during play
}


// Decompiled with UE Explorer.
defaultproperties
{
    bCanCrouch=false
    AccelRate=1.0000000
    bCollideActors=false
    bCollideWorld=false
    bBlockActors=false
    bBlockPlayers=false
    bProjTarget=false
    bPathColliding=true
}