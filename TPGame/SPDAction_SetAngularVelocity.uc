//***********************************************************************
// Class:		SPDAction_SetAngularVelocity
// Description: 
// Created By:  Asim Naseer, Spark Unlimited 2005
// integrated from Pandora to TP by Doug Kuppinger 8/25/06
//***********************************************************************
class SPDAction_SetAngularVelocity extends SPDAction
	native
	editinlinenew
	NotPlaceable;


//***********************************************************************
// VARIABLE DECLARATIONS
//***********************************************************************

var (SPDAction)	float DegreesPerSecond;
var (SPDAction) vector AxisOfRotation;

//***********************************************************************
// CPP TEXT
//***********************************************************************

// (cpptext)
// (cpptext)
// (cpptext)

//***********************************************************************
// NATIVE FUNCTION DECLARATIONS
//***********************************************************************

//***********************************************************************
// FUNCTIONS/STATES
//***********************************************************************

//-----------------------------------------------------------------------
// Function:   
// Description:	
//-----------------------------------------------------------------------
event SPDActionState Run( float elapsedTime, Actor actor, SPDProcessManager manager, SPDDamage DamageInfo )
{
	local MeshComponent MeshComp;
	local float radians;
	local vector w;

	MeshComp = actor.GetSkeletalMeshComponent();
	if ( MeshComp == None )
		MeshComp = actor.GetStaticMeshComponent();
	if ( MeshComp != None )
	{
		radians = DegreesPerSecond * 3.141592653589 / 180.0;
		w = Normal(AxisOfRotation);
		w = w * radians;
		MeshComp.SetRBAngularVelocity( w );
		MeshComp.SetRBLinearVelocity( actor.Velocity );
	}
	return SPDActionState_Done;
}                   

//***********************************************************************
// Default Properties
//***********************************************************************

