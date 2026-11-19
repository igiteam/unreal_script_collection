/**
 * Pacifier Bot Grab Hand Weapon
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoWeap_Pacifier_GrabHand extends NanoWeap_Pacifier_Base;

var SkelControlSingleBone GrabHandCtrl;
var SkelControlSpline	  GrabHandSplineCtrl;
var AnimNodeBlendList	  GrabAnimNode;
var NanoPawn_RebelsBase	  InHandRebel;

/** Damage to do each second player is being squeezed in hand */
var() config int	DamagePerSqueezeTick;
/** Delay before arm pulls back to bot after grabbing player */
var() config float	DelayBeforeRetractOnGrab;
/** Delay before squeeze damage starts after grabbing player */
var() config float	DelayBeforeSqueezeDamage;
/** Delay before player is realease after grab */
var() config float	DelayBeforeReleaseGrab;
/** Lateral speed imparted to player when released from the hand */
var() config float	ReleaseThrowBackSpeed;
/** Vertical speed imparted to player when released from the hand */
var() config float	ReleaseThrowBackZSpeed;
/** Time into throw anim to release rebel */
var()		 float  ReleaseFromThrowTime;

/** Amount of time it takes to play grab start */
var() config float	GrabTellDuration;
/** Amount of time it takes for arm to extend */
var() config float	GrabExtendDuration;
/** Amount of time it takes for arm to retract on grab */
var() config float	GrabRetractDuration;
/** Amount of time it takes for arm to play ow anim */
var()		 float	GrabHurtDuration;
/** Amount of time it takes to play arm densed start */
var()		 float	DensedStartDuration;
/** Amount of time it takes to play arm densed end */
var()		 float	DensedEndDuration;



// EFFECTS //
var	protected const ParticleSystem		PS_GrabTeslaEffect;
var transient NanoEmitter				GrabTeslaEmitter;

// SOUNDS //
var protected SoundCue	GrabStartSound;
var protected SoundCue	ExtendStartSound;
var protected SoundCue	ExtendImpactSound;
var protected SoundCue	RetractStartSound;
var protected SoundCue	RetractImpactSound;
var protected SoundCue	TaserStartSound;
var protected transient AudioComponent AC_TaserLoop;
var protected SoundCue	TaserLoopCue;
var protected SoundCue	TaserBurstSound;
var protected SoundCue	TaserEndSound;
var protected SoundCue	ThrowRebel;
var protected SoundCue	DensedTargetImpactSound;



simulated function Destroyed()
{
	Super.Destroyed();

	// Clean up trail if spawned
	if( GrabTeslaEmitter != None )
	{
		GrabTeslaEmitter.Destroy();
		GrabTeslaEmitter = None;
	}

	FinishedRetractGrabHand();

	AC_TaserLoop.Stop();
}
	
function InitWeapon( Pacifier_LimbBase L, Pawn NewInstigator )
{
	local float AnimRate;

	Super.InitWeapon( L, NewInstigator );

	GrabHandCtrl = SkelControlSingleBone(Instigator.Mesh.FindSkelControl( 'GrabHandCtrl' ));
	GrabHandCtrl.SetSkelControlActive( TRUE );
	GrabHandCtrl.SetSkelControlStrength( 0.f, 0.f );
	GrabHandSplineCtrl = SkelControlSpline(Instigator.Mesh.FindSkelControl( 'GrabHandSplineCtrl' ));
	GrabHandSplineCtrl.SetSkelControlActive( TRUE );
	GrabHandSplineCtrl.SetSkelControlStrength( 0.f, 0.f );

	GrabAnimNode = AnimNodeBlendList(Instigator.Mesh.FindAnimNode( 'GrabArmNode' ));
	if( GrabAnimNode != None )
	{
		GrabAnimNode.SetActiveChild( 0, 0.f );

		AnimRate = Instigator.Mesh.GetAnimLength( 'Grab_Start' ) / GrabTellDuration;
		AnimNodeSequence(GrabAnimNode.Children[1].Anim).Rate = AnimRate;
		AnimRate = Instigator.Mesh.GetAnimLength( 'Grab_Extend' ) / GrabExtendDuration;
		AnimNodeSequence(GrabAnimNode.Children[2].Anim).Rate = AnimRate;
	}

	GrabHurtDuration = Instigator.Mesh.GetAnimLength( 'Grab_Ow' );
	DensedStartDuration = Instigator.Mesh.GetAnimLength( 'Hand_Densed_Start' );
	DensedEndDuration = Instigator.Mesh.GetAnimLength('Hand_Densed_End');
	ReleaseFromThrowTime = 0.85f; // taken from location of notify in anim
}

simulated function InitEffects()
{
	if( GrabTeslaEmitter == None )
	{
		GrabTeslaEmitter = Spawn(class'SpawnedNanoEmitter', self);
		if( GrabTeslaEmitter != None )
		{
			GrabTeslaEmitter.LifeSpan = 0.0f;
			GrabTeslaEmitter.bPostUpdateTickGroup = TRUE;
			GrabTeslaEmitter.SetTemplate(PS_GrabTeslaEffect, FALSE );
			GrabTeslaEmitter.SetBase( Instigator,, Instigator.Mesh, Limb.SocketName );
		}
	}
}

simulated function PlayGrabEffects()
{
	InitEffects();
	if( GrabTeslaEmitter != None )
	{
		GrabTeslaEmitter.ParticleSystemComponent.ActivateSystem();
	}

	PlaySound( GrabStartSound );
}

simulated function StopGrabEffects()
{
	if( GrabTeslaEmitter != None )
	{
		GrabTeslaEmitter.ParticleSystemComponent.DeactivateSystem();
	}
}

simulated function PlayImpactEffects()
{
	ClearTimer( nameof(PlayImpactEffects) );
	PlaySound( ExtendImpactSound );
}

simulated function PlayRetractEffects()
{
	PlaySound( RetractStartSound );

	if( InHandRebel != None )
	{
		PlaySound( TaserStartSound );

		if( AC_TaserLoop == None )
		{
			AC_TaserLoop = new(self) class'AudioComponent';
			AttachComponent( AC_TaserLoop );
			AC_TaserLoop.bStopWhenOwnerDestroyed = TRUE;
			AC_TaserLoop.SoundCue = TaserLoopCue;
		}
		AC_TaserLoop.FadeIn( 1.f, 1.0f );
	}
}

simulated function GrabRebelScum( NanoPawn_RebelsBase Rebel )
{
	PlayImpactEffects();

	if( Rebel.IsDensed() )
	{
		// Hand hit a densed target... take damage from it
		Limb.TakeDamage( Rebel.WallSlamDamage, Rebel.Controller, Limb.Location, vect(0,0,0), class'NanoGame.NDT_Tackled' );
		// Retract immediately and play ow animation
		RetractGrabHandHurt();
		return;
	}
	if( Rebel.IsDusted() )
	{
		return;
	}

	// Disable the Rebel
	InHandRebel = Rebel;
	InHandRebel.SetPhysics( PHYS_None );
	InHandRebel.bIgnoreBaseRotation = TRUE;
	InHandRebel.SetBase( Limb );
	InHandRebel.SetRelativeLocation( vect(0,0,0) );

	// Stop bot from turning to face target in hand and stop current motion
	AIController.Focus = None;
	AIController.MoveTimer = -1.f;

	// Stop hand where it is
	GrabHandCtrl.SetSkelControlStrength( GrabHandCtrl.ControlStrength, 0.f );

	// Setup all the timers 
	SetTimer( DelayBeforeRetractOnGrab, FALSE, nameof(RetractGrabHand) );
	SetTimer( DelayBeforeSqueezeDamage + GrabRetractDuration, FALSE, nameof(StartSqueezeDamage) );
	SetTimer( DelayBeforeReleaseGrab + GrabRetractDuration, FALSE, nameof(ThrowRebelScum) );

	// Kill timer that would take us back to active state
	ClearTimer( nameof(RefireCheckTimer) );
}

simulated function ThrowRebelScum()
{
	StopSqueezeDamage();

	if( InHandRebel == None )
		return;

	GrabAnimNode.SetActiveChild( 9, 0.25f );
	InHandRebel.FullBodySlot.PlayCustomAnim('Grab_Throw',1.f,0.1,0.1,FALSE,TRUE);
	SetTimer( ReleaseFromThrowTime, FALSE, nameof(ReleaseRebelScum) );
}

simulated function ReleaseRebelScum()
{
	StopSqueezeDamage();

	if( InHandRebel == None )
		return;

	// Clear base and set velocity/physics
	InHandRebel.bIgnoreBaseRotation = InHandRebel.default.bIgnoreBaseRotation;
	InHandRebel.SetBase( None );
	InHandRebel.SetPhysics( PHYS_Falling );
	InHandRebel.Velocity = (Vector(Instigator.Rotation) * ReleaseThrowBackSpeed) + (vect(0,0,1) * ReleaseThrowBackZSpeed);
	
	// Clear all unused timers/vars
	InHandRebel = None;
	ClearTimer( nameof(ReleaseRebelScum) );
	ClearTimer( nameof(RetractGrabHand) );
	ClearTimer( nameof(ThrowRebelScum) );

	// Tell weapon to go back to active state
	RefireCheckTimer();

	PlaySound( ThrowRebel );
	PlaySound( TaserEndSound );
	AC_TaserLoop.Stop();
}

simulated function RetractGrabHand()
{
	GrabAnimNode.SetActiveChild( 0, 0.25f );
	GrabHandCtrl.SetSkelControlStrength( 0.f, GrabRetractDuration );	
	SetTimer( GrabRetractDuration, FALSE, nameof(FinishedRetractGrabHand) );
	ClearTimer( nameof(RetractGrabHand) );
	
	if( InHandRebel != None )
	{
//		InHandRebel.FullBodySlot.PlayCustomAnim('Grab_Retract',1.f,0.1,0.1,FALSE,TRUE);
		InHandRebel.FullBodySlot.PlayCustomAnimByDuration('Grab_Retract', GrabRetractDuration+DelayBeforeSqueezeDamage, 0.1f, 0.1f, FALSE, TRUE );
	}

	PlayRetractEffects();
}

simulated function RetractGrabHandHurt()
{
	// Play ow animation
	GrabAnimNode.SetActiveChild( 3, 0.1f );
	// Scale out hand control over length of anim
	GrabHandCtrl.SetSkelControlStrength( 0.f, 0.25 );	
	// Set timer for completion of attack
	SetTimer( GrabHurtDuration, FALSE, nameof(FinishedRetractGrabHand) );
	ClearTimer( nameof(RetractGrabHand) );

	PlaySound( DensedTargetImpactSound );

	PlayRetractEffects();
}

simulated function RetractGrabHandDensed()
{
	// Play hand lift anim
	GrabAnimNode.SetActiveChild( 6, 0.1f );
	// Scale out hand control over length of anim
	GrabHandCtrl.SetSkelControlStrength( 0.f, 0.25 );	
	// Set timer for completion of attack
	SetTimer( DensedEndDuration, FALSE, nameof(FinishedRetractGrabHand) );
	SetTimer( DensedEndDuration + 0.2f, FALSE, nameof(HandleFinishedFiring) );
	ClearTimer( nameof(RetractGrabHand) );

	PlayRetractEffects();
}

simulated function FinishedRetractGrabHand()
{
	ClearTimer( nameof(FinishedRetractGrabHand) );

	PlaySound( RetractImpactSound );
	GrabHandSplineCtrl.SetSkelControlStrength( 0.f, 0.25f );	
}

simulated function StartSqueezeDamage()
{
	// Play both Grab_Shock_Start anims on bot and rebel
	GrabAnimNode.SetActiveChild( 7, 0.1f );
	InHandRebel.FullBodySlot.PlayCustomAnim('Grab_Shock_Start',1.f,0.1,0.1,FALSE,TRUE);

	SetTimer( 1.f, FALSE, nameof(LoopSqueezeAnim) );
	SetTimer( 1.f, TRUE, nameof(DoSqueezeDamage) );
}

simulated function LoopSqueezeAnim()
{
	// Play both Grab_Shock_Loop anims on bot and rebel
	GrabAnimNode.SetActiveChild( 8, 0.1f );
	InHandRebel.FullBodySlot.PlayCustomAnim('Grab_Shock_Loop',1.f,0.0,0.1,TRUE,TRUE);
}

simulated function StopSqueezeDamage()
{
	ClearTimer( nameof(DoSqueezeDamage) );
	ClearTimer( nameof(StartSqueezeDamage) );
	ClearTimer( nameof(LoopSqueezeAnim) );
}

function DoSqueezeDamage();

simulated state WeaponFiring
{
	simulated event BeginState( Name PreviousStateName )
	{
		PlayGrabEffects();
		GrabAnimNode.SetActiveChild( 1, 0.1f );
		SetTimer( GrabTellDuration, FALSE, nameof(WarmupTimeExpired) );
	}
	
	simulated function EndState( Name NextStateName )
	{
		ClearTimer( nameof(WarmupTimeExpired) );

		Super.EndState( NextStateName );

		ReleaseRebelScum();
		RetractGrabHand();
		StopGrabEffects();
	}

	simulated function WarmupTimeExpired()
	{
		FireAmmunition();
		TimeWeaponFiring( CurrentFireMode );
	}

	// Extension happened without grabbing - just go back to active state
	simulated function RefireCheckTimer()
	{
		local float DelayFinish;

		DelayFinish = GetDelayFinishFiringTime();
		if( DelayFinish <= 0 )
		{
			HandleFinishedFiring();
		}
		else
		{
			ClearTimer(nameof(RefireCheckTimer));
			ClearTimer(nameof(DelayedBurstFire));
			SetTimer( DelayFinish, FALSE, nameof(DelayFinishedFiring) );
		}
	}

	simulated function CustomFire()
	{
		local vector			StartTrace;
		local Rotator			FireDir;
		local Actor				TargetActor;

		Limb.GetWeaponFireInfo( StartTrace, FireDir, TargetActor );
		GrabHandCtrl.BoneTranslation = TargetActor.Location;
		GrabHandCtrl.SetSkelControlStrength( 1.f, GrabExtendDuration );
		GrabHandSplineCtrl.SetSkelControlStrength( 1.f, 0.2f );
		GrabAnimNode.SetActiveChild( 2, 0.1f );
		
		WeaponFired(CurrentFireMode);

		PlaySound( ExtendStartSound );
		SetTimer( GrabExtendDuration, FALSE, nameof(PlayImpactEffects) );
	}

	simulated function HandleTouch( Actor Other, PrimitiveComponent OtherComp )
	{
		local NanoPawn_RebelsBase Rebel;

		// If already have a target in hand, or we are retracting... skip grab
		if( InHandRebel != None || GrabHandCtrl.StrengthTarget == 0.f )
		{
			return;
		}

		Rebel = NanoPawn_RebelsBase(Other);
		if( Rebel != None )
		{
			GrabRebelScum( Rebel );
		}
	}

	function DoSqueezeDamage()
	{
		if( InHandRebel == None )
		{
			ClearTimer( nameof(DoSqueezeDamage) );
		}
		else
		{
			PlaySound( TaserBurstSound );
			InHandRebel.TakeDamage( DamagePerSqueezeTick, Instigator.Controller, InHandRebel.Location, vect(0,0,0), class'NDT_TeslaCoil',, Limb.Bot );
		}
	}
}

simulated function DropToGround()
{
	local Actor HitActor;
	local Vector HitLocation, HitNormal, Extent;
	local float ColHeight, ColRadius;

	// Play hand drop to ground animation
	GrabAnimNode.SetActiveChild( 4, 0.1f );
	SetTimer( DensedStartDuration, FALSE, nameof(LoopDropToGround) );

	Limb.GetBoundingCylinder( ColRadius, ColHeight );
	Extent.X = ColRadius;
	Extent.Y = ColRadius;
	Extent.Z = ColHeight;
	HitActor = Limb.Trace( HitLocation, HitNormal, Limb.Location + vect(0,0,-512), Limb.Location, FALSE, Extent );
	if( HitActor != None )
	{
		GrabHandCtrl.BoneTranslation = HitLocation;
		GrabHandCtrl.SetSkelControlStrength( 1.f, 0.1f );
		GrabHandSplineCtrl.SetSkelControlStrength( 1.f, 0.1f );
	}
}

simulated function LoopDropToGround()
{
	// Play looping struggle animation
	GrabAnimNode.SetActiveChild( 5, 0.1f );
}

simulated function LimbNanoStateChanged( Pacifier_LimbBase L )
{
	if( L != Limb )
		return;

	if( Limb.CurrNanoState == ENS_Dense )
	{
		ReleaseRebelScum();
		DropToGround();
		ClearTimer( nameof(RefireCheckTimer) );
		ClearTimer( nameof(RetractGrabHand) );
	}
	else if( Limb.CurrNanoState == ENS_Dust )
	{
		ReleaseRebelScum();
		Limb.SetCollision( FALSE ); // turn off collision so it can't grab player		
	}
	else
	{
		Limb.SetCollision( TRUE );
		RetractGrabHandDensed();
	}
}

simulated function float GetFireInterval( byte FireModeNum )
{
	return GrabExtendDuration + 0.1f;
}

defaultproperties
{
	FiringStatesArray(0)=WeaponFiring
	WeaponFireTypes(0)=EWFT_Custom
	Spread(0)=0.05f
	WeaponProjectiles(0)=none
	InstantHitDamageTypes(0)=class'NDT_MP7'
	InstantHitDamage(0)=0.0f
	InstantHitMomentum(0)=0.0f
	FireInterval(0)=+2.0f


	// muzzle flash emitter
	Begin Object Name=PSC_WeaponMuzzleMuzFlashComp
		Template=ParticleSystem'Nano_WeaponFX.GEN.Effects.P_GEN_MP5_MuzzleEffect'
		Scale3D=(X=10.f,Y=10.f,Z=10.f)
	End Object
	MuzFlashEmitter=PSC_WeaponMuzzleMuzFlashComp

	FireSound=None
	PS_GrabTeslaEffect=ParticleSystem'MET_PacifierMechProto.Effects.P_FX_PacBot_Grabtell'

	GrabStartSound=SoundCue'Vehicle_PacBot.PacBot.PacBot_Arm_Raise_Cue'
	ExtendStartSound=SoundCue'Vehicle_PacBot.PacBot.PacBot_Arm_Extend_Start_Cue'
	ExtendImpactSound=SoundCue'Vehicle_PacBot.PacBot.PacBot_Arm_Extend_Impact_Cue'
	RetractStartSound=SoundCue'Vehicle_PacBot.PacBot.PacBot_Arm_Retract_Start_Cue'
	RetractImpactSound=SoundCue'Vehicle_PacBot.PacBot.PacBot_Arm_Retract_Impact_Cue'
	TaserStartSound=SoundCue'Vehicle_PacBot.PacBot.PacBot_Taser_Start_Cue'
	TaserLoopCue=SoundCue'Vehicle_PacBot.PacBot.PacBot_Taser_Loop_Cue'
	TaserBurstSound=SoundCue'Vehicle_PacBot.PacBot.PacBot_Taser_Burst_Cue'
	TaserEndSound=SoundCue'Vehicle_PacBot.PacBot.PacBot_Taser_Stop_Cue'
	ThrowRebel=SoundCue'Vehicle_PacBot.PacBot.PacBot_Arm_Throw_Cue'
	DensedTargetImpactSound=SoundCue'Vehicle_PacBot.PacBot.PacBot_Arm_Extend_ImpactDense_Cue'
}