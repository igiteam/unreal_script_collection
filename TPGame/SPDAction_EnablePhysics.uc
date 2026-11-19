//***********************************************************************
// Class:		SPDAction_SpawnPHAT
// Description: 
// Created By:  Asim Naseer, Spark Unlimited 2005
// integrated from Pandora to TP by Doug Kuppinger 8/25/06
//***********************************************************************
class SPDAction_EnablePhysics extends SPDAction
	native
	editinlinenew
	NotPlaceable;


//***********************************************************************
// VARIABLE DECLARATIONS
//***********************************************************************

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
	local SkeletalMeshComponent SkeletalMesh;                     
	local StaticMeshComponent StaticMesh;

	if ( actor == None ) 
		return SPDActionState_Done;
						 
	SkeletalMesh = actor.GetSkeletalMeshComponent();
	if ( SkeletalMesh != None && SkeletalMesh.PhysicsAsset != None ) 
	{
		actor.SetPhysics(PHYS_RigidBody);
		InitPhysics( SkeletalMesh, SkeletalMesh.GetPhysicsWeight() );
		SkeletalMesh.WakeRigidBody();
	}
	else
	{
		StaticMesh = actor.GetStaticMeshComponent();
		if ( StaticMesh != None )
		{
			actor.SetPhysics(PHYS_RigidBody);
			StaticMesh.WakeRigidBody();
		}
	}
	return SPDActionState_Done;
}

//***********************************************************************
// Default Properties
//***********************************************************************

