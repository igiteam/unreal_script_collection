//***********************************************************************
// Class:		SPDAction_AddImpulse
// Description: 
// Created By:  Asim Naseer, Spark Unlimited 2005
//***********************************************************************

class SPDAction_AddImpulse extends SPDAction
	editinlinenew
	NotPlaceable
	collapsecategories
	hidecategories(Object);


//***********************************************************************
// STRUCT DECLARATIONS
//***********************************************************************

//***********************************************************************
// VARIABLE DECLARATIONS
//***********************************************************************

var (SPDAction)	ERadialImpulseFalloff	ImpulseFalloff;
var (SPDAction) float 					ImpulseDamageDelay;
var (SPDAction) int 					ImpulseStrength;
var (SPDAction) int 					ImpulseDamage;
var	(SPDAction) class<TPDamageType>	ImpulseDamageType; // problem? was PandoraDamageType
var (SPDAction) float					ImpulseRadius;
var (SPDAction) vector					PositionOffset;

//***********************************************************************
// CPP TEXT
//***********************************************************************

//***********************************************************************
// FUNCTIONS/STATES
//***********************************************************************

//-----------------------------------------------------------------------
// Function:   
// Description:	
//-----------------------------------------------------------------------
event SPDActionState Run( float elapsedTime, Actor Actor, SPDProcessManager manager, SPDDamage DamageInfo )
{
	local SPDImpulseActor impulseActor;
	local vector pos;

	if (actor == None)
		pos = PositionOffset + DamageInfo.location;
	else
		pos = PositionOffset + actor.location;
	
	impulseActor = manager.Spawn( class'SPDImpulseActor' ,,, pos );
	impulseActor.ImpulseComponent.ImpulseFalloff = ImpulseFalloff;
	impulseActor.ImpulseComponent.ImpulseStrength = ImpulseStrength;
	impulseActor.ImpulseComponent.ImpulseRadius = ImpulseRadius;
	impulseActor.delay = ImpulseDamageDelay;
	impulseActor.damage = ImpulseDamage;
	impulseActor.damageRadius = ImpulseRadius;
	impulseActor.damageType = ImpulseDamageType;

	ImpulseActor.ShowDebug = DamageInfo.ShowDebug;
	return SPDActionState_Done;
}

//***********************************************************************
// Default Properties
//***********************************************************************

