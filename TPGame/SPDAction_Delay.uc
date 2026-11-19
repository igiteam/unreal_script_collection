//***********************************************************************
// Class:		SPDAction_Delay
// Description: 
// Created By:  Asim Naseer, Spark Unlimited 2005
//***********************************************************************

class SPDAction_Delay extends SPDAction_Latent
	editinlinenew
	NotPlaceable;


//***********************************************************************
// VARIABLE DECLARATIONS
//***********************************************************************
var (SPDAction) float DelayInSeconds;
var float counter;

//***********************************************************************
// FUNCTIONS/STATES
//***********************************************************************

//-----------------------------------------------------------------------
// Function:   
// Description:	
//-----------------------------------------------------------------------
event PushData( SPDProcessManager manager ) 
{
	manager.PushFloat( counter );
}

//-----------------------------------------------------------------------
// Function:   
// Description:	
//-----------------------------------------------------------------------
event PopData( SPDProcessManager manager ) 
{
	counter = manager.PopFloat();
}

//-----------------------------------------------------------------------
// Function:   
// Description:	
//-----------------------------------------------------------------------
event SPDActionState Enter( float elapsedTime, Actor Actor, SPDProcessManager manager, SPDDamage DamageInfo )  
{
	if ( DelayInSeconds <= 0 )
		return SPDActionState_Done;
		
	counter = DelayInSeconds;
	return SPDActionState_InProgress;
}

//-----------------------------------------------------------------------
// Function:   
// Description:	
//-----------------------------------------------------------------------
event SPDActionState Run( float elapsedTime, Actor Actor, SPDProcessManager manager, SPDDamage DamageInfo )  
{
	counter -= elapsedTime;
	if ( counter > 0.0 )
		return SPDActionState_InProgress;
	else
		return SPDActionState_Done;
}

//-----------------------------------------------------------------------
// Function:   
// Description:	
//-----------------------------------------------------------------------
event Exit( Actor Actor, SPDProcessManager manager, SPDDamage DamageInfo )  
{
}

//***********************************************************************
// Default Properties
//***********************************************************************

