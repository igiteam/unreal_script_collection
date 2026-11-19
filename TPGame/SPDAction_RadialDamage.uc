//***********************************************************************
// Class:		SPDAction_RadialDamage
// Description: 
// Created By:  Asim Naseer, Spark Unlimited 2005
//***********************************************************************
class SPDAction_RadialDamage extends SPDAction
	editinlinenew
	NotPlaceable;


var	() class<TPDamageType>	DamageType; // problem? was PandoraDamageType
var () float Radius;
var () float Damage;
	

//***********************************************************************
// FUNCTIONS/STATES
//***********************************************************************

//-----------------------------------------------------------------------
// Function:   
// Description:	
//-----------------------------------------------------------------------
event SPDActionState Run( float elapsedTime, Actor Actor, SPDProcessManager manager, SPDDamage DamageInfo )
{
	manager.HurtRadius( Damage, Radius, DamageType, 0, DamageInfo.Location); 
	return SPDActionState_Done;
}

//***********************************************************************
// Default Properties
//***********************************************************************

