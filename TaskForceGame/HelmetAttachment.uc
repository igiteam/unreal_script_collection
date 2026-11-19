class HelmetAttachment extends GearAttachment;

var bool bOffPawn;

function KnockOff(Vector Direction)
{
	if(!bOffPawn)
	{
		Pawn.DetachFromBone(self);
		SetPhysics(PHYS_Falling);
		bCollideWorld = true;
		bBlockZeroExtentTraces=true;
		Velocity = Normal(Direction)*RandRange(225,250);
		Velocity.Z = RandRange(25,75);
		bBounce = True;
		bFixedRotationDir=true;
		bRotateToDesired=true;
		RandSpin(30000);
		bOffPawn=true;	
	}
}


// Decompiled with UE Explorer.
defaultproperties
{
    CollisionRadius=12.0000000
    CollisionHeight=8.0000000
    Mass=12.0000000
}