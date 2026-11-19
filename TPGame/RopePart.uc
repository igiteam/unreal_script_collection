class RopePart extends KAsset;

event Touch(Actor Other, PrimitiveComponent OtherComponent, vector HitLocation, vector HitNormal)
{
	;
	if (Owner != none && Pawn(Other) != none)
	{
		Other.SetLocation(BaseDynaRope(Owner).FindClosestPoint(Other.Location));
		Other.SetPhysics(Phys_None);	
	}
}

event TakeDamage(int Damage, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
	;
}

