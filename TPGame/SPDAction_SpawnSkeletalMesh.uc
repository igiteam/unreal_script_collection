//***********************************************************************
// Class:		SPDAction_SpawnSkeletalMesh
// Description:
// Created By:  Asim Naseer, Spark Unlimited 2005
//***********************************************************************

class SPDAction_SpawnSkeletalMesh extends SPDAction_SpawnActor
	editinlinenew
	NotPlaceable;


//***********************************************************************
// VARIABLE DECLARATIONS
//***********************************************************************

var(SPDAction) SkeletalMesh		SkelMesh;
var(SPDAction) bool				MatchBoneOrientationOfOriginal;


//***********************************************************************
// FUNCTIONS/STATES
//***********************************************************************

//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
event SPDActionState Run( float elapsedTime, Actor actor, SPDProcessManager manager, SPDDamage DamageInfo )
{
	local SPDSkeletalMesh  newActor;

	newActor = SPDSkeletalMesh( CreateActor( manager, actor, DamageInfo ) );
	if ( newActor != None )
	{
		newActor.SkeletalMeshComponent.SetPhysicsWeight( 1.0f );
		newActor.SkeletalMeshComponent.SetPhysicsAsset(None);
		newActor.SkeletalMeshComponent.SetSkeletalMesh(SkelMesh);

		FindBestSpotForSpawnLocation(newActor);

		if ( MatchBoneOrientationOfOriginal )
		{
			MatchActorBoneOrientations( actor, newActor );
		}

		/* problem? not needed, cant use path blocking code
		newActor.DisablePathBlocking(newActor.m_pathBlockInfo, bDisablePathBlocking);
		*/
	}
	return SPDActionState_Done;
}

//***********************************************************************
// Default Properties
//***********************************************************************

