//***********************************************************************
// Class:		SPDKAsset
// Description: 
// Created By:  Asim Naseer, Spark Unlimited 2005
// integrated from Pandora to TP by Doug Kuppinger 8/25/06
//***********************************************************************

class SPDKAsset extends SPKAsset
	deprecated
	placeable
	native;

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
// (cpptext)

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

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	SkeletalMeshComponent.SetPhysicsWeight(1.0f);
}
		
//***********************************************************************
// Default Properties
//***********************************************************************
