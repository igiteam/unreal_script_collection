//***********************************************************************
// Class:		SPDAction_SpawnPHAT
// Description:
// Created By:  Asim Naseer, Spark Unlimited 2005
// integrated from Pandora to TP by Doug Kuppinger 8/25/06
//***********************************************************************
class SPDAction_SpawnPHAT extends SPDAction_SpawnActor
	native
	editinlinenew
	NotPlaceable;


//***********************************************************************
// VARIABLE DECLARATIONS
//***********************************************************************

var(SPDAction) SkeletalMesh		SkelMesh;
var(SPDAction) PhysicsAsset		PhysAsset;
var(SPDAction) float			PhysicsWeight;
var(SPDAction) bool				PhysicsEnable;
var(SPDAction) bool				MatchBoneOrientationOfOriginal;
var(SPDAction) bool				bNoEncroachCheck;
var(SPDAction) float			Buoyancy;


//***********************************************************************
// CPP TEXT
//***********************************************************************

// (cpptext)
// (cpptext)
// (cpptext)

//***********************************************************************
// NATIVE FUNCTION DECLARATIONS
//***********************************************************************

native function bool InitPhysics(SkeletalMeshComponent SmComponent, float weight);

//***********************************************************************
// FUNCTIONS/STATES
//***********************************************************************

//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
event SPDActionState Run( float elapsedTime, Actor actor, SPDProcessManager manager, SPDDamage DamageInfo )
{
	local SPDPhysSkel  newActor;
	//local actor cactor;

	newActor = SPDPhysSkel( CreateActor( manager, actor, DamageInfo ) );
	if ( newActor != None )
	{
		newActor.Buoyancy = Buoyancy;
		newActor.SkeletalMeshComponent.SetPhysicsWeight( PhysicsWeight );

		newActor.InitSkeletalMesh	(	newActor.SkeletalMeshComponent,
										SkelMesh,
										PhysAsset,
										vect(0.0f, 0.0f, 0.0f),	//Initial Velocity
										vect(1.0f, 1.0f, 1.0f)	//DrawScale3D
									);

		//newActor.SkeletalMeshComponent.SetPhysicsAsset(PhysAsset);
		//newActor.SkeletalMeshComponent.SetSkeletalMesh(SkelMesh);

		FindBestSpotForSpawnLocation(newActor);

		// Debug code. Remove later. *********************************
		/*
		ForEach newActor.OverlappingActors(class'Actor', cactor, 100 )
		{
			Log(" WARNING >>>>>>>>>> On Spawn PHAT collision with " @cactor );
		}
		// End of debug code. Remove later. **************************
		*/

		if ( MatchBoneOrientationOfOriginal )
		{
			MatchActorBoneOrientations( actor, newActor );
		}

		if ( PhysicsEnable )
		{
			newActor.SetPhysics(PHYS_RigidBody);
			InitPhysics(newActor.SkeletalMeshComponent, PhysicsWeight);
			newActor.SkeletalMeshComponent.WakeRigidBody();
			AddVelocity( actor, newActor );
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

