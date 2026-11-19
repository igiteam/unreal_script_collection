//***********************************************************************
// Class:		SPDAction_SpawnStaticMesh
// Description:
// Created By:  Asim Naseer, Spark Unlimited 2005
//***********************************************************************

class SPDAction_SpawnStaticMesh extends SPDAction_SpawnActor
	editinlinenew
	NotPlaceable;

//***********************************************************************
// VARIABLE DECLARATIONS
//***********************************************************************

var (SPDAction) StaticMesh 	Mesh;

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
	local SPDStaticMesh newActor;

	newActor = SPDStaticMesh( CreateActor( manager, actor, DamageInfo ) );
	if ( newActor != None )
	{
		newActor.StaticMeshComponent.SetStaticMesh(Mesh);
		FindBestSpotForSpawnLocation(newActor);

		/* problem? not needed, cant use path blocking code
		if (bDisablePathBlocking)
		{
			newActor.DisablePathBlocking(newActor.m_pathBlockInfo, bDisablePathBlocking);
		}
		else
		{
			// deal with the following quirk:  when something is placed in the editor and spawned, in the call to PostBeginPlay (which
			// calls CheckForBlockedNavigation) everything works fine.  However, if the thing is spawned via kismet, then in te PostBeginPlay
			// the static mesh hasn't been set up yet so it can't do an accurate bounds check.  Thus we must undo whatever the
			// CheckForBlockedNavigation did and then redo it here.
			newActor.ClearBlockedNavigation(newActor.m_pathBlockInfo);
			newActor.CheckForBlockedNavigation(newActor.m_pathBlockInfo);
		}
		*/
	}
	return SPDActionState_Done;
}

//***********************************************************************
// Default Properties
//***********************************************************************

