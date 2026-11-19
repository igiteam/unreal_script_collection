class GearAttachment extends InventoryAttachment
	native;

var()	bool	DropOnDeath;
var		Pawn	Pawn;

event Drop(Vector Direction)
{
	if(DropOnDeath)
	{
		Pawn.DetachFromBone(self);
		bCollideWorld = true;
		Velocity = Normal(Direction)*700;
		RandSpin(30000);
		SetPhysics(PHYS_Falling);
	}
}

simulated function HitWall( vector HitNormal, actor HitWall )
{
	local float Speed;
	
	if ( HitWall == Instigator)	return; 

	Velocity = 0.5*( ( Velocity dot HitNormal ) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
	
	RandSpin(30000);
	Speed = VSize(Velocity);
	
	if ( Speed < 20) 
	{
		SetPhysics(PHYS_None);
		bFixedRotationDir=false;
		bRotateToDesired=false;
	}
}

simulated function Landed( vector HitNormal )
{
	HitWall(HitNormal, None);
}

function KnockOff(Vector Direction)
{
	return;
}

simulated final function RandSpin(float spinRate)
{
	DesiredRotation = RotRand();
	RotationRate.Yaw = spinRate * 2 *FRand() - spinRate;
	RotationRate.Pitch = spinRate * 2 *FRand() - spinRate;
	RotationRate.Roll = spinRate * 2 *FRand() - spinRate;	
}

