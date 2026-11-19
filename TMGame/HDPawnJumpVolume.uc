
class	HDPawnJumpVolume	extends PhysicsVolume;

var()	float	JumpScale;

simulated event PawnEnteredVolume(Pawn P)
{
	local HDPawn HDP;

	HDP = HDPawn(P);

	if ( HDP != none )
	{
		HDP.JumpZ = HDP.JumpZ * JumpScale;
	}
}


simulated event PawnLeavingVolume(Pawn P)
{
	local HDPawn HDP;

	HDP = HDPawn(P);

	if ( HDP != none )
	{
		HDP.JumpZ = HDP.Default.JumpZ;
	}
}
