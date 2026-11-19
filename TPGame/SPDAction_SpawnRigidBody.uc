//***********************************************************************
// Class:		SPDAction_SpawnRigidBody
// Description:
// Created By:  Asim Naseer, Spark Unlimited 2005
//***********************************************************************

class SPDAction_SpawnRigidBody extends SPDAction_SpawnActor
	editinlinenew
	NotPlaceable;

//***********************************************************************
// VARIABLE DECLARATIONS
//***********************************************************************

var (SPDAction) StaticMesh 	Mesh;
var (SPDAction) float		PhysicsWeight;
var (SPDAction) bool		PhysicsEnable;
var (SPDAction)	bool		bNoEncroachCheck;
var (SPDAction) float		Buoyancy;

//***********************************************************************
// CPP TEXT
//***********************************************************************
// (cpptext)
// (cpptext)
// (cpptext)

//***********************************************************************
// FUNCTIONS/STATES
//***********************************************************************

//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
event SPDActionState Run( float elapsedTime, Actor Actor, SPDProcessManager manager, SPDDamage DamageInfo )
{
	local SPDRigidBody newActor;

	newActor = SPDRigidBody( CreateActor( manager, actor, DamageInfo ) );
	if ( newActor != None )
	{
		newActor.Buoyancy = Buoyancy;
		newActor.StaticMeshComponent.SetStaticMesh(Mesh);
		FindBestSpotForSpawnLocation(newActor);

		if ( PhysicsEnable )
		{
			newActor.SetPhysics(PHYS_RigidBody);
			newActor.StaticMeshComponent.WakeRigidBody();
		}

		/* problem? not needed, can't use path blocking code
		newActor.DisablePathBlocking(newActor.m_pathBlockInfo, bDisablePathBlocking);
		*/
	}
	return SPDActionState_Done;
}

//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
function Actor CreateActor( SPDProcessManager manager, Actor actor, SPDDamage DamageInfo )
{
	local Actor newActor;

	newActor = super.CreateActor(manager, actor, DamageInfo);
	if ( newActor != None )
	{
		newActor.bNoEncroachCheck = bNoEncroachCheck;
	}

	return newActor;
}

//***********************************************************************
// Default Properties
//***********************************************************************

