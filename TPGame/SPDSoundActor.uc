//***********************************************************************
// Class:		SPDSoundActor
// Description: 
// Created By:  Asim Naseer, Spark Unlimited 2005
//***********************************************************************

class SPDSoundActor extends Actor
	native
	NotPlaceable;


var RB_RadialImpulseComponent	ImpulseComponent;

var float 	delay;
var int 	damage;
var float 	damageRadius;
var class<DamageType> damageType;
	
//***********************************************************************
// STRUCT DECLARATIONS
//***********************************************************************

//***********************************************************************
// VARIABLE DECLARATIONS
//***********************************************************************

var transient AudioComponent	AudioComp;
						 
var SoundCue PlaySound;
var float ExtraDelay;
var transient float SoundDuration;
var	float	FadeInTime;
var	float	FadeOutTime;

var	DrawSphereComponent	RenderComponent;
var bool ShowDebug;

//***********************************************************************
// CPP TEXT
//***********************************************************************

//***********************************************************************
// NATIVE FUNCTION DECLARATIONS
//***********************************************************************

//***********************************************************************
// FUNCTIONS/STATES
//***********************************************************************
native function Init();


//-----------------------------------------------------------------------
// State:   Waiting
// Description:	
//-----------------------------------------------------------------------
auto state Startup
{
	Begin:
		Init();
		GotoState('Finished');
		
}

//-----------------------------------------------------------------------
// State:   Finished
// Description:	
//-----------------------------------------------------------------------
state Finished
{
	Begin:
		Sleep(SoundDuration);
		Destroy();
}


//***********************************************************************
// Default Properties
//***********************************************************************

