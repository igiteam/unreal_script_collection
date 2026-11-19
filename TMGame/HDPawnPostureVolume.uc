

class	HDPawnPostureVolume	extends PhysicsVolume;

var () bool             bCanCrouch;
var () bool             bCanProne;
var () bool             bCanSprint;
var () float            GroundSpeed;
var () bool             bCanJump;

simulated event PawnEnteredVolume(Pawn P)
{
    local HDPawn HDP;
    HDP = HDPawn(P);
    if ( HDP != None )
        HDP.EnteredPostureVolume( self );
}

simulated event PawnLeavingVolume(Pawn P)
{
    local HDPawn HDP;
    HDP = HDPawn(P);
    if ( HDP != None )
        HDP.LeavingPostureVolume();

}

