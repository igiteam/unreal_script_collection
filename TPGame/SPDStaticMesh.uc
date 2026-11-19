//***********************************************************************
// Class:		SPDStaticMesh
// Description: 
// Created By:  Asim Naseer, Spark Unlimited 2005
// integrated from Pandora to TP by Doug Kuppinger 8/25/06
//***********************************************************************

class SPDStaticMesh extends KynapseStaticMeshActor
	native
	placeable;


//***********************************************************************
// VARIABLE DECLARATIONS
//***********************************************************************

var(DestructComponent) const editconst SPActorDestructComponent	DestructComponent;
var	DrawSphereComponent	RenderComponent;
var	DrawSphereComponent	PreviewSphere;
/* problem? not needed, can't use path blocking code
var(Collision) PathBlockingInfo m_pathBlockInfo;
*/
var() const editconst LightEnvironmentComponent LightEnvironment;

//***********************************************************************
// CPP TEXT
//***********************************************************************
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

//-----------------------------------------------------------------------
// Function: PostBeginPlay    
// Description:	
//-----------------------------------------------------------------------
// this function doesn't seem to be called
simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	if (bHidden == true)
	{
		SetHiddenFlag(bHidden);
	}

	/* problem? not needed, can't use path blocking code
	CheckForBlockedNavigation(m_pathBlockInfo);
	*/
}

//-----------------------------------------------------------------------
// Function: 
// Description:	
//-----------------------------------------------------------------------
event Landed(vector HitNormal, Actor FloorActor)
{
	TakeFallingDamage();
}

//-----------------------------------------------------------------------
// Function: 
// Description:	
//-----------------------------------------------------------------------
function TakeFallingDamage()
{
	local int damage;
	
	// kill ourselves
	
	damage = DestructComponent.SpeedToDamage( Velocity.Z );
	if (damage > 0)
		TakeDamage( damage, None, Location, vect(0,0,0), class'DmgType_Fell');
}

//***********************************************************************
// Default Properties
//***********************************************************************

