//***********************************************************************
// Class:		SPDImpulseActor
// Description: 
// Created By:  Asim Naseer, Spark Unlimited 2005
//***********************************************************************

class SPDImpulseActor extends Actor
	native
	notplaceable;


//***********************************************************************
// STRUCT DECLARATIONS
//***********************************************************************

//***********************************************************************
// VARIABLE DECLARATIONS
//***********************************************************************

var RB_RadialImpulseComponent	ImpulseComponent;

var float 	delay;
var int 	damage;
var float 	damageRadius;
var class<DamageType> damageType;
var bool ShowDebug;

var	DrawSphereComponent	RenderComponent;

//***********************************************************************
// CPP TEXT
//***********************************************************************

//***********************************************************************
// NATIVE FUNCTION DECLARATIONS
//***********************************************************************

//***********************************************************************
// FUNCTIONS/STATES
//***********************************************************************
native function EnableDebug();


//-----------------------------------------------------------------------
// State:   Waiting
// Description:	
//-----------------------------------------------------------------------
auto state Waiting
{

	//-----------------------------------------------------------------------
	// Function:   
	// Description:	
	//-----------------------------------------------------------------------
	function DoDamage()
	{
		if (ImpulseComponent.ImpulseStrength > 0)
		{
			RenderComponent.SphereRadius = damageRadius;
			ImpulseComponent.FireImpulse( Location );
		}
		if (damage > 0)
			HurtRadius(damage, damageRadius, damageType, 1, Location);
		GotoState('Finished');
	}
			 
	Begin:

	EnableDebug();

	if ( delay > 0 )
		SetTimer(delay, false, 'DoDamage');
	else
		DoDamage();
}

//-----------------------------------------------------------------------
// State:   Finished
// Description:	
//-----------------------------------------------------------------------
state Finished
{
	Begin:

		Sleep(0.5);
		Destroy();
}


//***********************************************************************
// Default Properties
//***********************************************************************

