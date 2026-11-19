//***********************************************************************
// Class:		SPDSkeletalMesh
// Description: 
// Created By:  Asim Naseer, Spark Unlimited 2005
// integrated from Pandora to TP by Doug Kuppinger 8/25/06
//***********************************************************************

//class SPDSkeletalMesh extends SkeletalMeshActor
class SPDSkeletalMesh extends KynapseSkeletalMeshActor
	native
	placeable;


//***********************************************************************
// VARIABLE DECLARATIONS
//***********************************************************************

var(DestructComponent) const editconst SPActorDestructComponent	DestructComponent;
var	DrawSphereComponent	RenderComponent;
var	DrawSphereComponent	PreviewSphere;

//***********************************************************************
// CPP TEXT
//***********************************************************************
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

//-----------------------------------------------------------------------
// Function: PostBeginPlay    
// Description:	
//-----------------------------------------------------------------------
simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	SkeletalMeshComponent.SetPhysicsWeight(1.0f);

	if (bHidden == true)
	{
		SetHiddenFlag(bHidden);
	}
}

//***********************************************************************
// Default Properties
//***********************************************************************

