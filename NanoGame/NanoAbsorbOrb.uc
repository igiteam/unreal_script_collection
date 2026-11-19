/** 
 * This code is basically duplicated from NanoAcquireTarget :-(
 *
 * NanoAcquireTarget should probably just spawn one of these with the correct params.
 * We need to make this a spawnable object as there will be a number of dynamically spawned gameplay objects that 
 * can be absorbed
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAbsorbOrb extends Actor
	abstract
	implements( NanoInterface_Interact, NanoInterface_Objective )
	config(Game);


var InteractableComponent InteractableComp;


/** Our UIIconComponent for easy access. **/
var UIIconComponent UIComponent;

/** Vars for overriding the Orb color **/
var name ColorParamName;
var vector ColorForOrb;
var ParticleSystemComponent PSC_AbsorbOrbInWorld;


//// SOOOOOOO we need to do some dirtiness here as we need to modify a component

/** This is the amount of currency gained from absorbing this orb **/
var() config int CurrencyGained;

/** This is the amount of nano power buckets gained from absorbing this orb **/
var() config int NanoPowerBucketsGained;

/** This is the amount of nano power buckets gained from absorbing this orb **/
var() config int NanoPowerForgeCoreBucketsGained;

/** This is the amount of rebel mind share gained from absorbing this orb **/
var() config int RebelMindShareGained;

/** This is the amount of XP gained from absorbing this orb **/
var() config int XPGained;





////





/** This is the actor that this orb is based on **/
var transient Actor ActorThisBelongsTo;


//// TODO need to move into InteractableComp


/** Particles for the Absorb effects **/
var ParticleSystem PS_AbsorbBeam;
var transient ParticleSystemComponent PSC_AbsorbBeam;
var ParticleSystem PS_AbsorbParticles;
var transient ParticleSystemComponent PSC_AbsorbParticles;
var ParticleSystem PS_AbsorbOrbInWorld;

var name AbsorbEffectsSocketName;
/** The "act" of absorbing something sound. **/
var SoundCue AbsorbSound;


/** Whether or not this orb should auto move towards the player **/
var bool bShouldMoveToPlayer;

var config float SpeedToMoveToPlayer;

/** An orb must be this close to the player before it starts moving to them **/
var config float MinDistToStartMovingToPlayer;

/** Once we start moving don't stop. **/
var transient bool bStartedMovingToPlayer;


simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	// if we have an overridden color use it
	if( VSize(ColorForOrb) > 0.0f )
	{
		PSC_AbsorbOrbInWorld.SetVectorParameter( ColorParamName, ColorForOrb );
	}

	PSC_AbsorbOrbInWorld.ActivateSystem();

	// update our various rewards
	InteractableComp.Reward.CurrencyGained = CurrencyGained;
	InteractableComp.Reward.NanoPowerBucketsGained = NanoPowerBucketsGained;
	InteractableComp.Reward.NanoPowerForgeCoreBucketsGained = NanoPowerForgeCoreBucketsGained;
	InteractableComp.Reward.RebelMindShareGained = RebelMindShareGained;
	InteractableComp.Reward.XPGained = XPGained;
}



/////// NanoInterface_Interact
simulated function string GetInteractToolTip( NanoPawn NP, out Texture2D out_TextureButtonToPrefix )
{
	if( InteractableComp.BeingAbsorbedBy != None)
	{
		return "Absorbing!";
	}

	out_TextureButtonToPrefix = Texture2D'UI_Common.button_B';

	if(InteractableComp.bCanGrab)
	{
		if(InteractableComp.bCanAbsorb)
		{
			return "to pick up or to absorb";
		}
		else
		{
			return "to pick up";
		}
	}
	else
	{
		if(InteractableComp.bCanAbsorb)
		{
			return "to absorb";
		}
		else
		{
			return "Cannot interact";
		}	
	}
}


/** Returns the UI component which we will then act upon. **/
simulated function InteractableComponent GetInteractableComponent()
{
	return InteractableComp;
}


simulated function bool CanInteract(NanoPawn NP, ENanoInteractType Type)
{
	//// we need to add some other constraints here:

	if( ( NP.GetNumEmptyNanoBuckets() == 0 )
		&& ( InteractableComp.Reward.NanoPowerBucketsGained > 0 )
		// prob need to do some extra checks here for orbs that combine lots of different rewards
		)
	{
		//`log( "CanInteract is FALSE!" @ `showvar(NP.GetNumEmptyNanoBuckets()) );
		return FALSE;
	}

	return InteractableComp.CanInteract( NP, Type );
}

/** Called from input code when you interact with object */
simulated function DoInteract( NanoPawn NP, ENanoInteractType Type )
{
	InteractableComp.DoInteract( NP, Type );
}

/** This is called when the interaction has completed successfully **/
simulated function InteractionSuccessfullyCompleted();

simulated function DoDestroy()
{
	Destroy();
}



// move to InteractableComponent
simulated function BeginBeingAbsorbedBy(NanoPawn NP)
{
//	local float AnimTimeForStartSummoning;
//	local vector SpawnLoc;
//	local Rotator SocketRot;

	return;

// 	BeingAbsorbedBy = NP;
// 
// 	if (Touching.Find(NP) != INDEX_None)
// 	{
// 		TimeSpentAbsorbing = AbsorbTime * 0.5f;
// 		BeingAbsorbedBy.ConsumeNanoBucket(-AbsorbTime*1.5f);
// 	}
// 
// 	// play absorbing anim
// 	AnimTimeForStartSummoning = NP.PreAimFullBodySlot.PlayCustomAnim('NW_Summon_Generic_Start', 1.0f, 0.05f, 0.1f, FALSE, TRUE);
// 	NP.PreAimFullBodySlot.PlayCustomAnim('NW_Summon_Generic_Loop', 1.0f, AnimTimeForStartSummoning, 0.1f, TRUE, TRUE);
// 
// 
// 	//`log( `showvar(self) @ `showvar(AbsorbEffectsSocketName) @ `showvar(self.location) @ `showvar(NP.Location) );
// 
//     // spawn all of the absorbing effects
// 	PSC_AbsorbBeam = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment( PS_AbsorbBeam, NP.Mesh, AbsorbEffectsSocketName, TRUE );
// 	PSC_AbsorbBeam.SetActorParameter( 'Endpoint', self );
// 
// 
// 	if( PS_AbsorbParticles != none )
// 	{
// 		NP.Mesh.GetSocketWorldLocationAndRotation( AbsorbEffectsSocketName, SpawnLoc, SocketRot );
// 
// 		PSC_AbsorbParticles = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment( PS_AbsorbParticles, NP.Mesh, AbsorbEffectsSocketName, TRUE );
// 		PSC_AbsorbParticles.SetFloatParameter( 'SuckPower', 1.0f );
// 		PSC_AbsorbParticles.SetVectorParameter( 'SuckPoint', SpawnLoc );
// 	
// 		//`log( `showvar(SpawnLoc) ); 
// 	
// 	}
// 
// 	BeingAbsorbedBy.PlaySound( AbsorbSound );

}


// move to InteractableComponent
simulated function EndBeingAbsorbed()
{
	return;

// 	// bit hacky - inform PC that interaction has ended
// 	if(BeingAbsorbedBy != none)
// 	{
// 		NanoPC(BeingAbsorbedBy.Controller).CurrentlyAbsorbingObjects.RemoveItem(self);
// 
// 		// stop absorbing anim
//         BeingAbsorbedBy.PreAimFullBodySlot.StopCustomAnim( 0.1f );
// 
// 		DoAbsorbReward();
// 	}
// 
// 
//     // clean up the absorbing effects	
// 	if( PSC_AbsorbBeam != none )
// 	{
// 		PSC_AbsorbBeam.DeactivateSystem();
// 		PSC_AbsorbBeam = none;
// 	}
// 
// 	if( PSC_AbsorbParticles != none )
// 	{
// 		PSC_AbsorbParticles.DeactivateSystem();
// 		PSC_AbsorbParticles = none;
// 	}
// 
// 	BeingAbsorbedBy = None;
// 	TimeSpentAbsorbing = 0.0;


	//SetTimer( DelayDestructionOfOrbByTime, FALSE, nameof(DoDestroy) );
}



/////// End NanoInterface_Interact

simulated function Touch(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal)
{
// 	local float Delta;
// 	if (Other == BeingAbsorbedBy)
// 	{
// 		Delta = FMax(0.f,AbsorbTime-TimeSpentAbsorbing);
// 		TimeSpentAbsorbing += Delta;
// 		BeingAbsorbedBy.ConsumeNanoBucket(-Delta*3.f);
// 	}
	if( InteractableComp.bAutoAcquireOnTouch == TRUE )
	{
		if( NanoPawn_RebelsBase(Other) != None )
		{
			if( CanInteract( NanoPawn(Other), ENIT_TouchInteract ) == TRUE )
			{
				InteractableComp.BeingAbsorbedBy = NanoPawn(Other);
				InteractableComp.DoInteract(  NanoPawn(Other), ENIT_TouchInteract );
			}
		}
	}


	Super.Touch(Other,OtherComp,HitLocation,HitNormal);
}


simulated event Tick(float DeltaTime)
{
//	local vector SpawnLoc;
//	local Rotator SocketRot;
	local NanoPawn PlayerPawn;
	local vector PlayerLocation;
	local float DistToPlayer;
	local vector DirToFly;


	Super.Tick(DeltaTime);

	InteractableComp.Tick( DeltaTime );

	if( bShouldMoveToPlayer == TRUE )
	{
		PlayerPawn = NanoPawn(NanoGRI(WorldInfo.GRI).GetNanoPC().Pawn);
		PlayerLocation = PlayerPawn.Location;

		// if the player can hold more NanoPower
		if( PlayerPawn.GetNumEmptyNanoBuckets() != 0 )
		{
			// if we have not started to move
			if( bStartedMovingToPlayer == FALSE )
			{
				// let's check to see if we should
				DistToPlayer = VSize(PlayerLocation - Location);
				if( DistToPlayer < MinDistToStartMovingToPlayer )
				{
					bStartedMovingToPlayer = TRUE;
				}

			}
			// keep on moving!
			else
			{
				DirToFly = Normal( PlayerLocation - Location);

				Acceleration = DirToFly * SpeedToMoveToPlayer;
			}
		}
		// stop our orb
		else
		{
			bStartedMovingToPlayer = FALSE;
			Velocity = vect(0,0,0);
			Acceleration = vect(0,0,0);
		}
	
	

		 //`log( "Acceleration" @ VSize(Acceleration) @ `showvar(Location) @ `showvar(VSize( NanoGRI(WorldInfo.GRI).GetNanoPC().Pawn.Location - Location)));
	}






	return;

// 	// Update absorbing progress
// 	if(BeingAbsorbedBy != none)
// 	{
// 		if( PSC_AbsorbParticles != None )
// 		{
// 			BeingAbsorbedBy.Mesh.GetSocketWorldLocationAndRotation( AbsorbEffectsSocketName, SpawnLoc, SocketRot );
// 			PSC_AbsorbParticles.SetVectorParameter( 'SuckPoint', SpawnLoc );
// 		}
// 
// 
// 		TimeSpentAbsorbing += DeltaTime;
// 		BeingAbsorbedBy.ConsumeNanoBucket(-DeltaTime*3.f);
// 		
// 		// See if we are done - stop if so
// 		if(TimeSpentAbsorbing > AbsorbTime)
// 		{
// 			TriggerEventClass( class'SeqEvt_GoodieGrabbed', BeingAbsorbedBy, 1 );
// 
// 			EndBeingAbsorbed();
// 			bHasBeenAbsorbed = true; // indicate that it was completed
// 		}
// 	}
}


function vector GetObjectiveLocation()
{
	return Location;
}


/** Returns the UI component which we will then act upon. **/
function UIIconComponent GetUIIconComponent()
{
	return UIComponent;
}


defaultproperties
{
	Physics=PHYS_Projectile

	Begin Object Class=CylinderComponent Name=CollisionCylinder
		CollisionRadius=32.0
		CollisionHeight=32.0
		BlockNonZeroExtent=FALSE
		BlockZeroExtent=FALSE
		BlockActors=FALSE
		CollideActors=TRUE
		BlockRigidBody=FALSE
	End Object
	CollisionComponent=CollisionCylinder
	Components.Add(CollisionCylinder)

	Begin Object Class=StaticMeshComponent Name=StaticMeshComponent0
        //StaticMesh=StaticMesh'Nano_WeaponFX.Caltrop.Meshes.S_Weapon_Caltrop'
		BlockNonZeroExtent=FALSE
		BlockZeroExtent=FALSE
		BlockActors=FALSE
		CollideActors=TRUE
		BlockRigidBody=FALSE
		bCastDynamicShadow=FALSE
		bUsePrecomputedShadows=TRUE
	End Object	
	//Components.Add(StaticMeshComponent0)

	// might be nice to have this on as a default to let the player "know" he can pick it up???
	Begin Object Class=NanoParticleSystemComponent Name=ParticleSystemComponent0
        Template=ParticleSystem'Nano_Power_FX.Effects.P_FX_NanoPower_Orb01' //floating sphere of 'nano' energy that could potentially be used.
		bAutoActivate=FALSE // the PS has an initial color that has a time of 0 to set it.  So we need to not auto activate this
	End Object
	PSC_AbsorbOrbInWorld=ParticleSystemComponent0
	//Components.Add(ParticleSystemComponent0)

	Begin Object Class=UIIconComponent Name=UIIconComponent0
	End Object
	UIComponent=UIIconComponent0
	Components.Add(UIIconComponent0)



	Begin Object Class=InteractableComponent Name=InteractableComponent0
	    InteractDistance=1024.0f
		bCanGrab=FALSE
		bCanAbsorb=FALSE
		AbsorbTime=0.0f
		DelayDestructionOfInteractionObjectByTime=0.1f
	End Object
	InteractableComp=InteractableComponent0
	Components.Add(InteractableComponent0)
	SupportedEvents.Add(class'SeqEvt_InteractionWithActor')
	

	bCollideActors=TRUE
	bPushedByEncroachers=FALSE
	bHardAttach=TRUE
	bNoEncroachCheck=TRUE

    // we probably should not need these here as the PSCs that are attached to these or the ticks should not update when moved but they do (working with scott on this)
	//TickFrequencyDecreaseDistanceStart=8000
	//TickFrequencyDecreaseDistanceEnd=10000
	//TickFrequencyAtEndDistance=0.1


	ColorParamName="OrbColor"

	AbsorbEffectsSocketName="HandForge"

	PS_AbsorbBeam=ParticleSystem'Nano_Power_FX.Effects.P_FX_NanoPower_SuckBeam' // Endpoint - actor name for endpoint of beam.  Beam's tangent at source is along X+, if needed I can add a strength parameter to it to increase length of separation between handforge and first bend in beam.

	PS_AbsorbParticles=ParticleSystem'Nano_Power_FX.Effects.P_FX_NanoPower_Body_Suck' //SuckPower (0-1) power of attraction to SuckPoint (vector) offset from particle system to be attracted to.  Range is 5000 units.

	//PS_AbsorbOrbInWorld=ParticleSystem'Nano_Power_FX.Effects.P_FX_NanoPower_Orb01'//floating sphere of 'nano' energy that could potentially be used.

	AbsorbSound=SoundCue'Gameplay_Audio.NanoAbsorb.Nano_AbsorbSingle_Stereo_01Cue'

	TickFrequencyDecreaseDistanceStart=4000
	TickFrequencyDecreaseDistanceEnd=8000
	TickFrequencyAtEndDistance=0.1
}



