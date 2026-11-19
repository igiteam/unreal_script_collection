class OLAISteeringAvoidance extends OLAISteering
	within OLEnemyPawn
	native(AI);

cpptext
{
	virtual FVector GetSteeringVector();
}

defaultproperties
{
}