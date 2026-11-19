/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/

class Emit_Camera_Ghost extends Emit_NanoCameraLensEffectBase;


/** Current value of the PSCs's Opacity parameter. */
var protected transient float CurrOpacityVal;
var protected transient float GoalOpacityVal;


simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	GoalOpacityVal = 1.0f; 
}



function Tick( float DeltaTime )
{
	super.Tick( DeltaTime );

	if( CurrOpacityVal != GoalOpacityVal )
	{
		CurrOpacityVal = FInterpTo( CurrOpacityVal, GoalOpacityVal, DeltaTime, 10 );
		ParticleSystemComponent.SetFloatParameter( 'Opacity', CurrOpacityVal );
	}

	// we're done
	if( CurrOpacityVal <= 0.0f )
	{
		//`log( self @ "Destroying" );
		Destroy();
	}

}


/** Called when this emitter is re-triggered, for bAllowMultipleInstances=FALSE emitters. */
function NotifyRetriggered()
{
	local NanoPawn NP;
	NP = NanoPawn(Owner);
	if (NP != None)
	{
		GoalOpacityVal = NP.GetActiveSkill(class'NanoSkill_Ghost') == None ? 0.f : 1.f;
	}
	else
	{
		if( GoalOpacityVal == 0.0f )
		{
			GoalOpacityVal = 1.0f;
		}
		else
		{
			GoalOpacityVal = 0.0f;
		}
	}

	//`log( self @ "NotifyRetriggered" @ GoalDensityVal );
}



defaultproperties
{
	DistFromCamera=30

	// Scalar param Opacity parameter that should be ramped from 0 to 1 in .2 secs both in and out
	PS_CameraEffect=ParticleSystem'Nano_Effects_Ghost.Effects.P_FX_GhostOverlay'
	PS_CameraEffectNonExtremeContent=ParticleSystem'Nano_Effects_Ghost.Effects.P_FX_GhostOverlay'

	LifeSpan=0.0f		// live until explicitly destroyed

}
