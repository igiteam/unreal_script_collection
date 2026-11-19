class TPActorFactoryAIParatrooper_Persistent extends TPActorFactoryAI
	config(Editor)
	hidecategories(NotUsedByBARPH)
	dependson(TPSpawnPoint)
	notplaceable
	abstract
	native;


var() vector DescentVelocity;		// If LandingTarget == none, then the pawn descends at this velocity
var() Actor LandingTarget;			// Overrides DescentVelocity.  New Descent Velocity is calculated based on where pawn spawns to the LandingTarget and Multiplies normal by the Abs(DescentVelocity.Z)
var() vector ParachuteOffset;		// Offset from where to base the parachute.
var() name ParachuteAnim;			// Parachute falling animation
var() byte DestroyTime;
var() class<ParachuteMesh_Persistent> MyParachuteClass;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

