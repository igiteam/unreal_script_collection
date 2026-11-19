class TPFOVVolume extends PhysicsVolume
							hidecategories(PhysicsVolume);

var() float FOVInVolume;
var() float OriginalFOV;
var TPPlayerController TPC;

// @optimization This may become expensive if many, many actors are
// touching/untouching this volume frequently for some reason
simulated event Touch(Actor Other, PrimitiveComponent OtherComponent, vector HitLocation, vector HitNormal)
{
	local Pawn P;
	if (TPC == none && Other.IsA('Pawn'))
	{
		P = Pawn(Other);
		
		if (TPPlayerController(P.Controller) != none)
		{
			TPC = TPPlayerController(P.Controller);
			TPC.DesiredFOV = FOVInVolume;
			OriginalFOV = TPC.FOVAngle;
		}
	}
}

event Untouch(Actor Other)
{
	if (TPC != none && Other.IsA('Pawn'))
	{
		if (Pawn(Other) == TPC.Pawn)
		{
			TPC.DesiredFOV = OriginalFOV;
			TPC = none;
		}
	}
}

