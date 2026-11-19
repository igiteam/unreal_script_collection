//***********************************************************************
// Class:		SPDAction_Spawn
// Description: 
// Created By:  Asim Naseer, Spark Unlimited 2005
// integrated from Pandora to TP by Doug Kuppinger 8/25/06
//***********************************************************************

class SPDAction_SpawnActor extends SPDAction_Spawn
	dependson(SPActorDestructComponent)
	dependson(SPDestructibleProperties)
	native
	editinlinenew
	abstract
	NotPlaceable;

//***********************************************************************
// STRUCT DECLARATIONS
//***********************************************************************

//***********************************************************************
// VARIABLE DECLARATIONS
//***********************************************************************

var (SPDAction) float	LifeSpanLimit;
var (SPDAction) bool	bCollideActors;
var (SPDAction) bool	bBlockActors;
var (SPDAction) SPDestructibleProperties	Destructproperties;
var (SPDAction) int		HitPoints;
/* problem? not needed, can't use path blocking code
var (SPDAction) bool	bDisablePathBlocking;
*/
var (SPDAction) 	OverriddenLightingParams	Lighting;
var (SPDAction)	float	Scale;
var (SPDAction) bool	bUseLightEnvironmentComponentSetting;	//If this is set to true, use bLightEnvironmentComponentSetting, otherwise use baseActor's setting.
var (SPDAction) bool	bLightEnvironmentComponentSetting;
var (SPDAction) bool	bDynamicLightVisibility; //Set this to true if the spawned actor will move around

//***********************************************************************
// CPP TEXT
//***********************************************************************
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

//***********************************************************************
// FUNCTIONS/STATES
//***********************************************************************

native function SetCollisionFlags(Actor actor);
native function MatchBoneOrientations( SkeletalMeshComponent source, SkeletalMeshComponent destination );
native function SetLightingFlags( Actor newActor, Actor baseActor );
native function SetScaleValue( Actor newActor );

//-----------------------------------------------------------------------
// Function:   
// Description:	
//-----------------------------------------------------------------------
function MatchActorBoneOrientations( Actor SrcActor, Actor DestActor )
{
	local SkeletalMeshComponent SrcComponent;
	local SkeletalMeshComponent DestComponent;

	SrcComponent = SrcActor.GetSkeletalMeshComponent();
	DestComponent = DestActor.GetSkeletalMeshComponent();
	MatchBoneOrientations( SrcComponent, DestComponent );
}


//-----------------------------------------------------------------------
// Function:   
// Description:	
//-----------------------------------------------------------------------
function SetDestructComponent( Actor srcActor )
{
	local SPActorDestructComponent spComponent;

	spComponent = SPActorDestructComponent( srcActor.GetActorDestructComponent() );	
	if ( spComponent != None )
	{
		spComponent.HitPoints = HitPoints;

		if (Destructproperties != none)
		{
			spComponent.properties = Destructproperties;
			spComponent.MinCollisionVelocity = Destructproperties.MinCollisionVelocity;
			spComponent.MaxCollisionVelocity = Destructproperties.MaxCollisionVelocity;
		}
	}
}

//-----------------------------------------------------------------------
// Function:   
// Description:	
//-----------------------------------------------------------------------
function Actor CreateActorInternal( SPDProcessManager manager, vector SpawnLocation, rotator SpawnRotation, Actor BaseActor )
{
	local Actor newActor;

	newActor = manager.SPSpawn( NewActorClass ,BaseActor,, SpawnLocation, SpawnRotation );
	if ( newActor != None )
	{
		SetCollisionFlags( newActor );
		SetDestructComponent( newActor );
		newActor.LifeSpan = LifeSpanLimit;
		SetLightingFlags( newActor, BaseActor);
		SetScaleValue(newActor);
	}
	return newActor;
}

//-----------------------------------------------------------------------
// Function:   
// Description:	
//-----------------------------------------------------------------------


