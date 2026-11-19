/**
 * This component manages the state of a player interacting with it.  So you can just add this guy to an Actor
 * and the the NanoInterface_Interact will utilize it.
 *
 * So that each class doesn't have to manage all of the interacting state.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class InteractableComponent extends CylinderComponent
	hidecategories( Object, Rendering, Physics, Collision, Lighting, PrimitiveComponent );


/** Whether this guys is enabled at all **/
var() bool bEnabled;

/** Whether or not to show effectst when absorbing **/
var() bool bShowEffects;

/** How close you must be to object to interact with it */
var() float InteractDistance;
/** Whether you can quickly grab object (destroys it) */
var() bool bCanGrab;
/** Whether you can slowly absorb object by holding button */
var() bool bCanAbsorb;
/** How long it takes to absorb */
var() float AbsorbTime;

/** If this actor is touched (by player) then it will complete the interaction. **/
var() bool bAutoAcquireOnTouch;

/** For some objects we want the player to be able to keep absorbing over time and not have it reset **/
var() bool bMaintainAbsorbTimeOnEndBeingAbsorbed;

/** If being absorbed, who is currently doing it */
var transient   NanoPawn    BeingAbsorbedBy;
/** Current time spent absorbing */
var transient   float       TimeSpentAbsorbing;
/** If this object has been absorbed */
var transient   bool        bHasBeenAbsorbed;

/** Whether the object should be destroyed on absorption **/
var bool bShouldDestroyOnAbsorb;

/** Amount of time we will delay the destruction of this object by **/
var float DelayDestructionOfInteractionObjectByTime;


/** This is the reward that we give out for this InteractableComponent **/
var RewardDatum Reward;



/** Particles for the Absorb effects **/
var private ParticleSystem PS_AbsorbBeam;
var private transient ParticleSystemComponent PSC_AbsorbBeam;
var private ParticleSystem PS_AbsorbParticles;
var private transient ParticleSystemComponent PSC_AbsorbParticles;

var private name AbsorbEffectsSocketName;
/** The "act" of absorbing something sound. **/
var private SoundCue AbsorbSound;


//// TEARS  PerProperty config on these so we can .ini balance/tweak them?




// need to add:
//
// - sound
// - anim / special move



simulated function bool CanInteract(NanoPawn NP, ENanoInteractType Type)
{
	//	`log( self @ `showvar(bHasBeenAbsorbed) @ `showvar(VSize(NP.Location - Owner.Location)) @ `showvar(Type) @ `showvar(bCanGrab) @ `showvar(bCanAbsorb) );
	if( bEnabled == FALSE )
	{
		return FALSE;
	}

	// If too far, or already gone - can't interact
	if(bHasBeenAbsorbed || VSize(NP.Location - Owner.Location) > InteractDistance)
	{
		return FALSE;
	}

	// if the NP is doing a special move of any type then disallow
	if( NP.IsDoingASpecialMove() == TRUE )
	{
		return FALSE;
	}

	// If trying to grab, and we can, do it
	if((Type == ENIT_Default) && bCanGrab)
	{
		return TRUE;
	}

	// If trying to absorb, and we can, and not already done, ok
	if(Type == ENIT_AbsorbBegin && bCanAbsorb)
	{
		return TRUE;
	}

	// if we are doing a touch interact and we are allowed to, ok
	if(Type == ENIT_TouchInteract && bAutoAcquireOnTouch)
	{
		return TRUE;
	}


	// otherwise nothing to do
	return FALSE;
}


simulated function BeginBeingAbsorbedBy(NanoPawn NP)
{
	BeingAbsorbedBy = NP;
    //`log( GetFuncName() @ `showvar(NP) @ `showvar(Outer) @ `showvar(BeingAbsorbedBy) );
	NanoPC(BeingAbsorbedBy.Controller).CurrentlyAbsorbingObjects.AddItem( Outer );

	Owner.TriggerEventClass( class'SeqEvt_InteractionWithActor', NP, 2 );  

	if( bShowEffects == TRUE )
	{
		StartEffects();
	}
}


simulated function StartEffects()
{
	local float AnimTimeForStartSummoning;
	local vector SpawnLoc;
	local Rotator SocketRot;
	local NanoPawn NP;

	NP = BeingAbsorbedBy;
	
	// play absorbing anim
	AnimTimeForStartSummoning = NP.PreAimFullBodySlot.PlayCustomAnim('NW_Summon_Generic_Start', 1.0f, 0.05f, 0.1f, FALSE, TRUE);
	NP.PreAimFullBodySlot.PlayCustomAnim('NW_Summon_Generic_Loop', 1.0f, AnimTimeForStartSummoning, 0.1f, TRUE, TRUE);


	//`log( `showvar(self) @ `showvar(AbsorbEffectsSocketName) @ `showvar(self.location) @ `showvar(NP.Location) );

	// spawn all of the absorbing effects
	PSC_AbsorbBeam = NP.WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment( PS_AbsorbBeam, NP.Mesh, AbsorbEffectsSocketName, TRUE );
	PSC_AbsorbBeam.SetActorParameter( 'Endpoint', Actor(Outer) );

	if( PS_AbsorbParticles != None )
	{
		NP.Mesh.GetSocketWorldLocationAndRotation( AbsorbEffectsSocketName, SpawnLoc, SocketRot );

		PSC_AbsorbParticles = NP.WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment( PS_AbsorbParticles, NP.Mesh, AbsorbEffectsSocketName, TRUE );
		PSC_AbsorbParticles.SetFloatParameter( 'SuckPower', 1.0f );
		PSC_AbsorbParticles.SetVectorParameter( 'SuckPoint', SpawnLoc );

		//`log( `showvar(SpawnLoc) ); 
	}

	NP.PlaySound( AbsorbSound );
}


simulated function TickEffects()
{
	local vector SpawnLoc;
	local Rotator SocketRot;

	// Update absorbing progress
	if( BeingAbsorbedBy != None )
	{
		if( PSC_AbsorbParticles != None )
		{
			BeingAbsorbedBy.Mesh.GetSocketWorldLocationAndRotation( AbsorbEffectsSocketName, SpawnLoc, SocketRot );
			PSC_AbsorbParticles.SetVectorParameter( 'SuckPoint', SpawnLoc );
		}
	}
}


simulated function StopEffects()
{
	// bit hacky - inform PC that interaction has ended
	if( BeingAbsorbedBy != None )
	{
		// stop absorbing anim
		BeingAbsorbedBy.PreAimFullBodySlot.StopCustomAnim( 0.1f );
	}

	// clean up the absorbing effects	
	if( PSC_AbsorbBeam != none )
	{
		PSC_AbsorbBeam.DeactivateSystem();
		PSC_AbsorbBeam = none;
	}

	if( PSC_AbsorbParticles != none )
	{
		PSC_AbsorbParticles.DeactivateSystem();
		PSC_AbsorbParticles = none;
	}
}



simulated function EndBeingAbsorbed( NanoPawn NP )
{
	//`log( GetFuncName() @ `showvar(BeingAbsorbedBy) @ `showvar(bHasBeenAbsorbed) );

	// bit hacky - inform PC that interaction has ended
	//`log( GetFuncName() @ `showvar(Outer) @ `showvar(BeingAbsorbedBy) );
	if(BeingAbsorbedBy != None)
	{
		NanoPC(BeingAbsorbedBy.Controller).CurrentlyAbsorbingObjects.RemoveItem( Outer );
	}

	// stop effects here as we clear BeingAbsorbedBy below
	StopEffects();

	if( bHasBeenAbsorbed == TRUE )
	{
		//`log( "EndBeingAbsorbed  DoAbsorbReward!!!" );
		DoAbsorbReward();

		Owner.TriggerEventClass( class'SeqEvt_InteractionWithActor', NP, 1 );  
		Owner.SetTimer( DelayDestructionOfInteractionObjectByTime, FALSE, nameof(DoDestroy), self );
	}
	// reset the time as we didn't complete
	else
	{
		Owner.TriggerEventClass( class'SeqEvt_InteractionWithActor', NP, 0 ); 

		if( bMaintainAbsorbTimeOnEndBeingAbsorbed == TRUE )
		{
			// don't reset the TimeSpentAbsorbing
			// TODO: start decaying here
		}
		else
		{
			TimeSpentAbsorbing = 0.0f;
		}

		BeingAbsorbedBy = None;
	}

	BeingAbsorbedBy = None;
}


/** Called from input code when you interact with object */
simulated function DoInteract( NanoPawn NP, ENanoInteractType Type )
{
	//`log( GetFuncName() @ `showvar(NP) @ `showvar(Type) @ `showvar(BeingAbsorbedBy) );
	// Pressed grab button, and we can be grabbed
	if(bCanGrab && (Type == ENIT_Default))
	{
		Owner.TriggerEventClass( class'SeqEvt_InteractionWithActor', NP, 1 );  
		Owner.Destroy();
	}
	// Pressed absorb button, and we can be absorbed
	else if(bCanAbsorb && (Type == ENIT_AbsorbBegin))
	{
		BeginBeingAbsorbedBy(NP);
	}
	// Release the absorb button, and we are being absorbed by this person
	else if( (BeingAbsorbedBy == NP ) 
		&& (Type == ENIT_AbsorbEnd)
		)
	{
		EndBeingAbsorbed( NP );
	}
	// if we are touch pick up and we are a touch pick up interaction
	else if( (BeingAbsorbedBy == NP ) 
		&& ( Type == ENIT_TouchInteract )
		&& ( bAutoAcquireOnTouch == TRUE )
		)
	{
		//`log( "Sweet ENIT_TouchInteract " );
		bHasBeenAbsorbed = TRUE;
		EndBeingAbsorbed( NP );
	}
}
/////// End NanoInterface_Interact


/**
 * Allows subclasses to override what is going to occur for the reward.  We should have this call a delegate more than likely?
 *
 **/
simulated function DoAbsorbReward()
{
	//`log( GetFuncName() @ `showvar(BeingAbsorbedBy) @ `showvar(NanoPowerBucketsGained) @ `showvar(CurrencyGained) );

	if( BeingAbsorbedBy != None )
	{
		NanoGRI(BeingAbsorbedBy.WorldInfo.GRI).GiveReward( Reward, BeingAbsorbedBy );
	}
}


simulated function DoDestroy()
{
	// we have completed the interaction so tell our owner that we have
	NanoInterface_Interact(Owner).InteractionSuccessfullyCompleted();

	if( bShouldDestroyOnAbsorb == TRUE )
	{
		if( Owner != none )
		{
			Owner.Destroy(); 
		}
	}
}



simulated event Tick(float DeltaTime)
{
	//`log( self @ "TICK" @ `showvar(BeingAbsorbedBy) @ `showvar(TimeSpentAbsorbing) );
	// Update absorbing progress
	if( BeingAbsorbedBy != None )
	{
		TimeSpentAbsorbing += DeltaTime;

		// See if we are done - stop if so
		if( TimeSpentAbsorbing >= AbsorbTime )
		{
			bHasBeenAbsorbed = TRUE; // indicate that it was completed
			EndBeingAbsorbed( BeingAbsorbedBy );
		}

		// keep checking to see if we can absorb  (e.g. they might have run further away than InteractDistance
		if( CanInteract( BeingAbsorbedBy, ENIT_AbsorbBegin ) == FALSE )
		{
			EndBeingAbsorbed( BeingAbsorbedBy );
		}

		// tick after as we might have neded the absorb
		TickEffects();
	}
}




// need to move all of the particle effects over to this component




defaultproperties
{
	BlockNonZeroExtent=FALSE
	BlockZeroExtent=FALSE
	BlockActors=FALSE
	CollideActors=TRUE // this is needed to put into the octree
	BlockRigidBody=FALSE


	bEnabled=TRUE
	bShowEffects=TRUE
	InteractDistance=128.0f
	bCanGrab=FALSE
	bCanAbsorb=FALSE
	AbsorbTime=2.0f

	bAutoAcquireOnTouch=FALSE

	bShouldDestroyOnAbsorb=TRUE
	DelayDestructionOfInteractionObjectByTime=0.1f

	Reward=(CurrencyGained=0,NanoPowerBucketsGained=0,RebelMindShareGained=0,XPGained=0,DataPlan=None,bShouldUnlockPlan=FALSE)


	AbsorbEffectsSocketName="HandForge"

	PS_AbsorbBeam=ParticleSystem'MET_TechTick.Effects.P_MET_TechTick_Absorb_Beam' // Endpoint - actor name for endpoint of beam.  Beam's tangent at source is along X+, if needed I can add a strength parameter to it to increase length of separation between handforge and first bend in beam.

	PS_AbsorbParticles=None // ParticleSystem'Nano_Power_FX.Effects.P_FX_NanoPower_Body_Suck' //SuckPower (0-1) power of attraction to SuckPoint (vector) offset from particle system to be attracted to.  Range is 5000 units.

	//PS_AbsorbOrbInWorld=ParticleSystem'Nano_Power_FX.Effects.P_FX_NanoPower_Orb01'//floating sphere of 'nano' energy that could potentially be used.

	AbsorbSound=SoundCue'Gameplay_Audio.NanoAbsorb.Nano_AbsorbSingle_Stereo_01Cue'


}
