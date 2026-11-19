/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoPickup_Tick extends NanoAbsorbOrb
	implements( NanoInterface_PingAffectable )
	placeable;

/** The amount of exp given by this pickup */
var() int Amount;

var string PickUpName;


var SkeletalMeshComponent TickMesh;

var StaticMeshComponent PlumeMesh;

/** Always on effect that is a distortion field **/
var ParticleSystemComponent PSC_Cloak;

var ParticleSystemComponent PSC_PowerEffect;

var ParticleSystemComponent PSC_OverpowerEffect;


/** MI for the derez effect **/
var MaterialInterface MI_Derez;
var transient MaterialInstanceTimeVarying MITV_Derez;

var transient  MaterialInstanceConstant MIC_Shell;


/** Whether or not this orb can be picked up by just touching. **/
var() bool bCanBeTouchPickedUp;

/** Whether or not this tick is visible and thus can be picked up **/
var transient bool bIsVisible;

/** Always playing this sound **/
var SoundCue LoopingTickSound;
var transient AudioComponent AC_LoopingTickSound;

/** When the tick gets AR Pinged we play this "omg!!" tick tick tick sound!**/
var SoundCue ActiveReloadPingSound;

/** When the tick is picked up / absorbed play this sound **/
var SoundCue PickupSound;

/** Ping effect interp to curr and goal values **/
var transient float DoingPingEffectsCurrValue;
var transient float DoingPingEffectsGoalValue;

/** Interp values for the tick's material when it is sitting there fading in and out **/
var transient float FadingInOutCurrValue;
var transient float FadingInOutGoalValue;


simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	if( bCanBeTouchPickedUp == FALSE )
	{
		CollisionComponent = none;
	}

	PlumeMesh.SetHidden( TRUE );
	//PSC_PowerEffect.DeactivateSystem();

	MIC_Shell = new(self) class'MaterialInstanceConstant';
	MIC_Shell.SetParent( MI_Derez );
	TickMesh.SetMaterial( 0, MIC_Shell );
	MIC_Shell.SetScalarParameterValue( 'Derez', 0.0f );
	//DrawDebugLine( Location, Location+( (vect(0,0,1) >> Rotation) * 2000 ), 255, 0, 0, TRUE );
	SetTimer( 10.0f, FALSE, nameof(ChooseRandomFadingInOutValue) );

	AC_LoopingTickSound = new(self) class'AudioComponent';
	if( AC_LoopingTickSound != none )
	{
		AC_LoopingTickSound.SoundCue = LoopingTickSound;
		AC_LoopingTickSound.FadeIn( 1.0f, 1.0f );
		AttachComponent( AC_LoopingTickSound );
	}

}


simulated function BeginBeingAbsorbedBy(NanoPawn NP)
{
	local vector SpawnLoc;
	local Rotator SocketRot;

	Super.BeginBeingAbsorbedBy( NP );

	PSC_Cloak.DeactivateSystem();
	PSC_OverpowerEffect.DeactivateSystem();

	NP.Mesh.GetSocketWorldLocationAndRotation( AbsorbEffectsSocketName, SpawnLoc, SocketRot );

	PSC_PowerEffect.SetFloatParameter( 'SuckPower', 1.0f );
	//DrawDebugLine( Location, SpawnLoc, 255, 0, 0, TRUE );
	PSC_PowerEffect.SetVectorParameter( 'SuckPoint', SpawnLoc );


	MITV_Derez = new(self) class'MaterialInstanceTimeVarying';
	MITV_Derez.SetParent( MI_Derez );
	TickMesh.SetMaterial( 0, MITV_Derez );
	MITV_Derez.SetDuration( 1.0f );

	if( AC_LoopingTickSound != none )
	{
		AC_LoopingTickSound.FadeOut( 0.5f, 0.0f );
	}
}


simulated event Destroyed()
{
	Super.Destroyed();

	if( AC_LoopingTickSound != none )
	{
		AC_LoopingTickSound.FadeOut( 0.5f, 0.0f );
	}
}



simulated function EndBeingAbsorbed()
{
	Super.EndBeingAbsorbed();

	PSC_PowerEffect.DeactivateSystem();
	PlumeMesh.SetHidden( TRUE );
	TickMesh.SetHidden( TRUE );
}


simulated function DoDestroy()
{
	Super.DoDestroy();
}


/** See if this object can be interacted with by this Pawn */
simulated function bool CanInteract(NanoPawn NP, ENanoInteractType Type)
{
	local NanoPC PC;
	local Vector Loc;
	local Rotator Rot;
	local vector CanSeeOffset;

	// grab camera location/rotation
	PC = NanoPC(NP.Controller);
	PC.GetPlayerViewPoint( Loc, Rot );

	CanSeeOffset = (vect(0,0,1) >> Rotation) * 32;  // push out the can see point to be in the middle of the tick
	//`log( "CanSeeByPoints" @ PC.CanSeeByPoints( Loc, (Location+CanSeeOffset), Rot ) );


	if( ( IsInState( 'Disabled' ) == FALSE )
		//&& ( bIsVisible == TRUE )
		&& ( InteractableComp.bHasBeenAbsorbed == FALSE )
		&& ( VSize(NP.Location - Location) < InteractableComp.InteractDistance )
		&& ( PC.CanSeeByPoints( Loc, (Location+CanSeeOffset), Rot ) == TRUE )
		)
	{
		// here we can probably just have some bone control update and point toward the player
		// right now if we just set the rotation we can get our lil bug stuck in walls as he is not constantly
		// repositioning himself

	    return TRUE;
	}

	return FALSE;
}


/** Get tooltip for interacting */
simulated function string GetInteractToolTip( NanoPawn NP, out Texture2D out_TextureButtonToPrefix )
{
	if( InteractableComp.BeingAbsorbedBy != None)
	{
		return "Absorbing!";
	}

	out_TextureButtonToPrefix = Texture2D'UI_Common.button_B';
	return "to absorb for exp!";
}


/** Allows subclasses to override what is going to occur for the reward **/
simulated function DoAbsorbReward()
{
	local NanoPRI PRI;

	if( InteractableComp.bHasBeenAbsorbed == TRUE )
	{
		return;
	}

	PRI = InteractableComp.BeingAbsorbedBy.GetPRI();
	PRI.AwardCurrency( Amount, PickUpName );
	PRI.AwardTickAbsorbed( 1, "Tick Absorbed" );

	InteractableComp.BeingAbsorbedBy.PlaySound( PickupSound );

	//if (++PRI.TicksAbsorbed == 10)
	//{
	//	InteractableComp.BeingAbsorbedBy.GetSkill(class'NanoSkill_Bamf').SetSkillLevel(TRUE,1);
	//}

	TriggerEventClass( class'SeqEvt_TickAbsorbed', InteractableComp.BeingAbsorbedBy ); // alert kismet

	InteractableComp.bHasBeenAbsorbed = TRUE;
}


simulated event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	if( ( bCanBeTouchPickedUp == TRUE ) && ( NanoPawn_RebelsBase(Other) != none ) )
	{
		InteractableComp.BeingAbsorbedBy = NanoPawn_RebelsBase(Other);
		DoAbsorbReward();
	}
}


/** Called when the ping has affected this object.  The object should now do some sweet effects! **/
function DoPingEffects( bool bActiveReloadPing )
{
	bIsVisible = TRUE;
    DoingPingEffectsGoalValue = 3.0f;

	//PlumeMesh.SetHidden( FALSE );
	PlumeMesh.SetScale3D( vect(2.0f,2.0f,1.0f) );
	PlumeMesh.SetTranslation( vect(0.0f,0.0f,-300.0f) );

	//MIC_Shell.SetScalarParameterValue( 'Derez', 0.0f );
	//PSC_PowerEffect.ActivateSystem();

	PSC_PowerEffect.SetVectorParameter( 'PingScale', vect(3,1,1) );
	PSC_Cloak.DeactivateSystem();

	if( bActiveReloadPing == TRUE )
	{
		PSC_OverpowerEffect.ActivateSystem();
		PlaySound( ActiveReloadPingSound );
	}

	SetTimer( class'NanoSkill_Ping'.default.DurationOfPingEffectsOnAffectedActors * 2.0f, FALSE, nameof(RestoreFromPingAffected) );
}


/** Helper function to fix up the effects from being affected by the ping **/
function RestoreFromPingAffected()
{
	bIsVisible = FALSE;
    DoingPingEffectsGoalValue = 1.0f;

	PlumeMesh.SetHidden( TRUE );
	PlumeMesh.SetTranslation( vect(0.0f,0.0f,-100.0f) );
	PlumeMesh.SetScale3D( vect(1.0f,1.0f,0.25f) );
	//MIC_Shell.SetScalarParameterValue( 'Derez', 1.0f );

	//PSC_PowerEffect.DeactivateSystem();
	PSC_OverpowerEffect.DeactivateSystem();
	//PSC_PowerEffect.SetVectorParameter( 'PingScale', vect(1,1,1) );

	PSC_Cloak.ActivateSystem();
}


simulated function Tick( float DeltaTime )
{
    Super.Tick( DeltaTime );

	if( DoingPingEffectsCurrValue != DoingPingEffectsGoalValue )
	{
        DoingPingEffectsCurrValue = FInterpTo( DoingPingEffectsCurrValue, DoingPingEffectsGoalValue, DeltaTime, 2.0f );
		PSC_PowerEffect.SetVectorParameter( 'PingScale', vect(0,1,1) + (vect(1,0,0) * DoingPingEffectsCurrValue) );
	}


    if( FadingInOutCurrValue != FadingInOutGoalValue )
	{
        FadingInOutCurrValue = FInterpTo( FadingInOutCurrValue, FadingInOutGoalValue, DeltaTime, 2.0f );
		MIC_Shell.SetScalarParameterValue( 'Derez', FadingInOutCurrValue );

		 if( FadingInOutCurrValue == FadingInOutGoalValue )
		 {
			SetTimer( 10.0f, FALSE, nameof(ChooseRandomFadingInOutValue) );
		 }
	}
}


function ChooseRandomFadingInOutValue()
{
	FadingInOutGoalValue = ( FRand() * 0.5f );
}



defaultproperties
{
	bCanBeTouchPickedUp=FALSE

    DoingPingEffectsCurrValue=1.0f
    DoingPingEffectsGoalValue=1.0f
	FadingInOutCurrValue=0.0f
	FadingInOutGoalValue=0.0f

	Amount=50
	PickUpName="Orb Pickup"

	PS_AbsorbBeam=ParticleSystem'MET_TechTick.Effects.P_MET_TechTick_Absorb_Beam'
	PS_AbsorbParticles=none

    PickupSound=SoundCue'Enemy_TechTick.TechTick.TechTick_Absorbed_Cue'

	LoopingTickSound=SoundCue'Enemy_TechTick.TechTick.TechTick_Base_Cue'
	ActiveReloadPingSound=SoundCue'Enemy_TechTick.TechTick.TechTick_Pinged_Cue'

	MI_Derez=MaterialInstanceTimeVarying'MET_TechTick.M_MET_TechTick01_DeRez_MITV'  // DeRez is param name 0 rez  1 fully derezed

	Begin Object Class=SkeletalMeshComponent Name=TickMeshComp
	    SkeletalMesh=SkeletalMesh'MET_TechTick.SK_MET_TechTick'
		CollideActors=TRUE
		CastShadow=FALSE
		bCastDynamicShadow=FALSE
		MaxDrawDistance=50000 // probably too much
		bUpdateSkelWhenNotRendered=FALSE
		bTickAnimNodesWhenNotRendered=FALSE
	End Object
	TickMesh=TickMeshComp
	CollisionComponent=TickMeshComp
	Components.Add(TickMeshComp)

	// so here we need to make it so that the psc does not start immediately especially on cars

	Begin Object Class=NanoParticleSystemComponent Name=PowerEffectComp
		Template=ParticleSystem'MET_TechTick.Effects.P_MET_TechTick_PowerEffect' // PowerEffect has a PingScale that you should set from 1,1,1 to 3,1,1 when a non 'active reload' ping hits it.  x is all that matters on the ping scale 
		MaxDrawDistance=50000 // probably too much
		//bAutoActivate=TRUE
	End Object
	PSC_PowerEffect=PowerEffectComp
	Components.Add(PowerEffectComp)

	Begin Object Class=NanoParticleSystemComponent Name=CloakEffectComp
		Template=ParticleSystem'MET_TechTick.Effects.P_MET_TechTick_Cloaked'  // distortion pattern with a small little sparkly (so we can now hide the ticks until we ping them!!) 
		MaxDrawDistance=50000 // probably too much
		Scale=2.5f
	End Object
	PSC_Cloak=CloakEffectComp
	Components.Add(CloakEffectComp)


	Begin Object Class=NanoParticleSystemComponent Name=OverpowerComp
		Template=ParticleSystem'MET_TechTick.Effects.P_MET_TechTick_Overpower' 
		MaxDrawDistance=50000 // probably too much
		bAutoActivate=FALSE
		Scale=2.5f
	End Object
	PSC_OverpowerEffect=OverpowerComp
	Components.Add(OverpowerComp)


	Begin Object Class=StaticMeshComponent Name=PlumeMeshComp
		StaticMesh=StaticMesh'Nano_Proto_CTF.Meshes.S_GatherOrbPlume'
		//Rotation=(Pitch=16384)
		Translation=(Z=-100.0)
		//Scale=4.0
		Scale3D=(X=1.0,Y=1.0,Z=0.25)
		CollideActors=FALSE
		bAcceptsLights=FALSE
		CastShadow=FALSE
		bCastDynamicShadow=FALSE
		MaxDrawDistance=50000 // probably too much
	End Object
	PlumeMesh=PlumeMeshComp
	Components.Add(PlumeMeshComp)

	SupportedEvents.Empty
	SupportedEvents(0)=class'SeqEvt_TickAbsorbed'

}

