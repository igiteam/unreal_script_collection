//***********************************************************************
// Class:		SPDAction_Latent
// Description: 
// Created By:  Asim Naseer, Spark Unlimited 2005
// integrated from Pandora to TP by Doug Kuppinger 8/25/06
//***********************************************************************

class SPDAction_Latent extends SPDAction
	editinlinenew
	abstract
	native
	NotPlaceable;

//***********************************************************************
// NATIVE FUNCTION DECLARATIONS
//***********************************************************************
native function PushDataNative( SPDProcessManager manager );
native function PopDataNative( SPDProcessManager manager );

//***********************************************************************
// FUNCTIONS/STATES
//***********************************************************************

//-----------------------------------------------------------------------
// Function:   
// Description:	
//-----------------------------------------------------------------------
event PushData( SPDProcessManager manager ) 
{
	PushDataNative( manager );
}

//-----------------------------------------------------------------------
// Function:   
// Description:	
//-----------------------------------------------------------------------
event PopData( SPDProcessManager manager ) 
{
	PopDataNative( manager );
}

//-----------------------------------------------------------------------
// Function:   
// Description:	
//-----------------------------------------------------------------------
event SPDActionState Enter( float elapsedTime, Actor Actor, SPDProcessManager manager, SPDDamage DamageInfo ) 
{
	return SPDActionState_Done;
}

//-----------------------------------------------------------------------
// Function:   
// Description:	
//-----------------------------------------------------------------------
event Exit( Actor Actor, SPDProcessManager manager, SPDDamage DamageInfo ) 
{
}

//-----------------------------------------------------------------------
// Function:   
// Description:	
//-----------------------------------------------------------------------
event Abort( Actor Actor, SPDProcessManager manager, SPDDamage DamageInfo ) 
{
}

//-----------------------------------------------------------------------
// Function:   
// Description:	
//-----------------------------------------------------------------------
event SPDActionState Run( float elapsedTime, Actor Actor, SPDProcessManager manager, SPDDamage DamageInfo )
{
	return SPDActionState_Done;
}

//***********************************************************************
// Default Properties
//***********************************************************************

