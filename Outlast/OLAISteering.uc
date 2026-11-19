class OLAISteering extends Object
	within OLEnemyPawn
	abstract
	native(AI);

cpptext
{
	virtual FVector GetSteeringVector() { return FVector(0.f); }
}

defaultproperties
{
}