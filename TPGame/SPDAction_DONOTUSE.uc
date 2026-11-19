//***********************************************************************
// Class:		SPDAction_DONOTUSE
// Description: 
// Created By:  Asim Naseer, Spark Unlimited 2005
// integrated from Pandora to TP by Doug Kuppinger 8/25/06
//***********************************************************************
class SPDAction_DONOTUSE extends SPDAction
	editinlinenew
	native
	NotPlaceable;

//***********************************************************************
// FUNCTIONS/STATES
//***********************************************************************

native function DebugIt( float elapsedTime, Actor Actor, SPDProcessManager manager, SPDDamage DamageInfo );

//-----------------------------------------------------------------------
// Function:   
// Description:	
//-----------------------------------------------------------------------
event SPDActionState Run( float elapsedTime, Actor Actor, SPDProcessManager manager, SPDDamage DamageInfo )
{
	DebugIt( elapsedTime, actor, manager, DamageInfo );
	return SPDActionState_Done;
}

//***********************************************************************
// Default Properties
//***********************************************************************

