//***********************************************************************
// Class:		SPDAction_ChangePointLight
// Description: 
// Created By:  Asim Naseer, Spark Unlimited 2005
// integrated from Pandora to TP by Doug Kuppinger 8/25/06
//***********************************************************************

class SPDAction_ChangePointLight extends SPDAction_Latent
	editinlinenew
	native
	NotPlaceable;

//***********************************************************************
// STRUCT DECLARATIONS
//***********************************************************************

struct native BrighnessChangeType {
	var () float value;
	var () bool  bEnabled;
};

struct native ColorChangeType {
	var () color value;
	var () bool  bEnabled;
};

struct native RadiusChangeType {
	var () float value;
	var () bool  bEnabled;
};

struct native SPDAction_ChangePointLight_Transient
{
	var color	InitialColor;
	var float	InitialBrightness;
	var float	InitialRadius;
	var float	counter;
};


//***********************************************************************
// VARIABLE DECLARATIONS
//***********************************************************************
var (SPDAction)	BrighnessChangeType	Brightness;
var (SPDAction)	ColorChangeType	LightColor;
var (SPDAction)	RadiusChangeType	Radius;
var (SPDAction)	float TimeInSeconds;

var SPDAction_ChangePointLight_Transient data;

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
event SPDActionState Enter( float elapsedTime, Actor Actor, SPDProcessManager manager, SPDDamage DamageInfo )  
{
	local SPDLightActor lightActor;
	
	if ( TimeInSeconds <= 0 )
		return SPDActionState_Done;

	lightActor = SPDLightActor( Actor );
	if ( lightActor == None )
		return SPDActionState_Done;
	data.counter = TimeInSeconds;

	data.InitialBrightness = lightActor.GetBrightness();	
	data.InitialColor = lightActor.GetColor();
	data.InitialRadius = lightActor.GetRadius();
	
	return SPDActionState_InProgress;
}

//-----------------------------------------------------------------------
// Function:   
// Description:	
//-----------------------------------------------------------------------
event SPDActionState Run( float elapsedTime, Actor Actor, SPDProcessManager manager, SPDDamage DamageInfo )  
{
	local SPDLightActor lightActor;
	local color NewColor;
	local float NewRadius;
	local float NewBrightness;
	local float	alpha;
	
	data.counter -= elapsedTime;
	if ( data.counter > 0.0 )
	{
		alpha = data.counter / TimeInSeconds;
		lightActor = SPDLightActor( Actor );

		if ( Brightness.bEnabled ) 
		{
			NewBrightness = Brightness.value * ( 1.0 - alpha ) + data.InitialBrightness * alpha;
			lightActor.SetBrightness( NewBrightness );
		}
		if ( LightColor.bEnabled ) 
		{
			NewColor.R = LightColor.value.R * ( 1.0 - alpha ) + data.InitialColor.R * alpha;
			NewColor.G = LightColor.value.G * ( 1.0 - alpha ) + data.InitialColor.G * alpha;
			NewColor.B = LightColor.value.B * ( 1.0 - alpha ) + data.InitialColor.B * alpha;
			lightActor.SetColor( NewColor );
		}
		if ( Radius.bEnabled ) 
		{
			NewRadius = Radius.value * ( 1.0 - alpha ) + data.InitialRadius;
			lightActor.SetRadius( NewRadius );
		}
		return SPDActionState_InProgress;
	}
	else
	{
		return SPDActionState_Done;
	}
}

//-----------------------------------------------------------------------
// Function:   
// Description:	
//-----------------------------------------------------------------------
event Exit( Actor Actor, SPDProcessManager manager, SPDDamage DamageInfo )  
{
	local SPDLightActor lightActor;

	lightActor = SPDLightActor( Actor );
	if ( lightActor == None )
		return;

	if ( Brightness.bEnabled )
		lightActor.SetBrightness( Brightness.value );
	if ( LightColor.bEnabled )
		lightActor.SetColor( LightColor.value );
	if ( Radius.bEnabled )
		lightActor.SetRadius( radius.value );
}

//***********************************************************************
// Default Properties
//***********************************************************************

