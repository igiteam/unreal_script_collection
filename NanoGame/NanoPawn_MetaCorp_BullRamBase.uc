/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoPawn_MetaCorp_BullRamBase extends NanoPawn_MetaCorp_MechsBase
	implements( NanoInterface_StabMantle )
    native(Pawn)
	abstract;


var StaticMeshComponent	VehicleMeshComponent;
var() Vector StabAttachPos;

var TeslaCoil HornLeft;
var TeslaCoil HornRight;

/** How long the pawn can stay on the back before the bull kicks them off **/
var config float TimeBeforeKickRiderOff;
var transient NanoPawn RidingPawn;

/** When the ram hits you head on this is how much damage it will do do you **/
var config float RammingDamage;

/** When you drive the ram into an enemy this is how much damage it does **/
var config float RammingDamageAgainstAIWhenDriven;

var config float RammingVelocity;
var config float RammingVelocityUp;


var()   ParticleSystem  DeathEffect;
var transient ParticleSystemComponent PSC_DeathEffect;


//// damage effects
var transient bool bDidLightDamageEffects;
var transient bool bDidMediumDamageEffects;
var transient bool bDidHeavyDamageEffects;


var name DamageLightSocket;
var name DamageMediumSocket;
var name DamageHeavySocket;
var name DamageSparksSocket;

var ParticleSystem PS_Damaged_Light;
var ParticleSystem PS_Damaged_Medium;
var ParticleSystem PS_Damaged_Heavy;
var ParticleSystem PS_Damaged_Sparks;

var SoundCue DamagedAndOnFireSound;
var transient AudioComponent AC_DamagedAndOnFireSound;


var SoundCue SpawnRoar;

var SoundCue StartMovingSound;

var SoundCue BumpIntoSomethingRoar;

var transient float LastRoarSound;




simulated event PostBeginPlay()
{
	super.PostBeginPlay();
}

function PossessedBy(Controller C, bool bVehicleTransition)
{
	Super.PossessedBy(C, bVehicleTransition);

	PlaySound( SpawnRoar );

   // HornLeft = SetUpTeslaHorns( FALSE );
   // HornRight = SetUpTeslaHorns( TRUE );
}

native function bool ReachedDestination(Actor Goal);


/** Will create a tesla horn **/
simulated function TeslaCoil SetUpTeslaHorns( bool bIsRightSide )
{
	local Vector AttachPos;
	local TeslaCoil TC;

	TC = Spawn( class'TeslaCoil',,, Location+vect(0,0,200) );
	TC.LifeSpan = 0.0f;
	TC.RegisterAIThatCares( NanoAI(Controller) );

	// Calc local space attach pos
	AttachPos = GetStabAttachOffset();

	if( bIsRightSide == FALSE )
	{
		AttachPos.X *= -1.f;
	}

	// transform into world space
	AttachPos = Location + (AttachPos >> Rotation);

	TC.SetLocation( AttachPos );

	TC.SetHardAttach( TRUE );
	TC.SetBase( self );

	return TC;
}

simulated function vector GetStabAttachOffset()
{
	return StabAttachPos;
}

simulated function float GetTargetDistanceScaling()
{
	return 1.f;
}

simulated function NotifySomeoneAttached( NanoPawn InRider )
{
	// deprecated
	//RidingPawn = InRider;
	//SetTimer( TimeBeforeKickRiderOff, FALSE, nameof(KickRiderOff) );
}


simulated function NotifyFinishedStabMantle( NanoPawn Rider, optional bool bViaLanding )
{
	local NanoPC NPC;
	local rotator PCRot;

	Rider.SetPhysics(PHYS_Interpolating);
	Rider.SetHardAttach(TRUE);
	Rider.SetBase(self);

	NPC = NanoPC(Rider.Controller);
	if(NPC != None)
	{
		PCRot = Rotation;
		PCRot.Roll = 0;
		NPC.SetRotation(PCRot);
	}
}


simulated function bool IsValidStabMantleTarget(optional bool bIsLandingCheck)
{
	return FALSE; // Health > 0;
}

simulated function name GetStabMantleApproachAnim()
{
	return 'Car_Stab_Mantle_Fly';
}

simulated function name GetStabMantleAnim( bool bRightSide )
{
	return bRightSide ? 'Car_Stab_Mantle_Up_B' : 'Car_Stab_Mantle_Up';
}

simulated function float GetStabMantleAnimRate()
{
	return 1.5f;
}

/** Called when a NanoPawn attaches - to track our rider */
event Attach(Actor Other)
{
	local NanoPawn NP;

	//`log( "AttachAttachAttachAttachAttachAttachAttachAttachAttachAttachAttach" @ Other );
	NP = NanoPawn(Other);
	if(NP != none)
	{
		// Check if there is already someone riding
		if(RidingPawn != None)
		{
			// TODO: Handle this better - kick of old pawn? Don't allow new attachment?
			`warn("NanoPawn_MetaCorp_BullRamBase.Attach - Already a RidingPawn!");
		}
	
		RidingPawn = NP;

		HornLeft.AddIgnoreDamage( RidingPawn );
		HornRight.AddIgnoreDamage( RidingPawn );

		SetTimer( TimeBeforeKickRiderOff, FALSE, nameof(KickRiderOff) );

		class'NanoAICmd_BullRam_BeingRidden'.static.BeingRidden( NanoAI_BullRam(Controller), NanoPC(RidingPawn.Controller) );
	}
}

/** Called when pawn stops being attached to the car */
event Detach(Actor Other)
{
	//`log( "DetachDetachDetachDetachDetachDetachDetachDetachDetach" @ Other );

	if((Other != none) && (Other == RidingPawn))
	{
		if( HornLeft != none )
		{
		    HornLeft.RemoveIgnoreDamage( RidingPawn );
		}
		
        if( HornRight != none )
		{
		    HornRight.RemoveIgnoreDamage( RidingPawn );
		}
		RidingPawn = none;
	}
}


/** If an AI registeres with an tesla coil it can receive a notification that the tesla was destroyed **/
function KickRiderOff( optional NanoPawn NP )
{
	local NanoPawn SavedRider;


	if( NP != none )
	{
		RidingPawn = NP;
	}

	// because the attach / detach doesn't seem to work we will jsut hack this up
	if( IsThereARiderOnMe( RidingPawn ) == TRUE )
	{
		SavedRider = RidingPawn;
		//`log( "CYA!!!" );
		Hack_TurnOffHornCollision();
		//SavedRider.SetCollision(FALSE,FALSE,FALSE);
   	    SavedRider.Knockback( vect(0,0,1500)+(Normal(Vector(Rotation))*750), FALSE, 'BullRamKnockOffMyBack' );
		SetTimer( 2.0f, FALSE, nameof(Hack_TurnOnHornCollision) );
	}
}

function Hack_TurnOffHornCollision()
{
	if( HornLeft != none )
	{
	    HornLeft.SetCollision( FALSE, FALSE );
	}
	if( HornRight != none )
	{
	    HornRight.SetCollision( FALSE, FALSE );
	}
}


function Hack_TurnOnHornCollision()
{
	if( HornLeft != none )
	{
	    HornLeft.SetCollision( TRUE, TRUE );
	}
	if( HornRight != none )
	{
	    HornRight.SetCollision( TRUE, TRUE );
	}
}



simulated function bool IsThereARiderOnMe(NanoPawn InRidingPawn )
{
  	local vector StartTrace, EndTrace, HitNorm, HitLoc, Extent;
	local Actor HitActor;

	StartTrace = InRidingPawn.Location;
	EndTrace = StartTrace - vect(0,0,200);
	Extent = vect(200,200,20);

	// trace from above us down into us
	HitActor = Trace( HitLoc, HitNorm, EndTrace, StartTrace, TRUE, Extent );
	DrawDebugLine( StartTrace, EndTrace, 255, 0, 0, TRUE );
	`log( "HitActor" @ HitActor );
	if( ( HitActor == self ) || ( HitActor == HornLeft ) || ( HitActor == HornRight ) || ( NanoPawn_RebelsBase(HitActor) != none ) )
	{
		return TRUE;
	}

	return FALSE;
}



/** Is this object currently targetable */
simulated function bool IsTargetable( optional ETargetQueryType QT )
{
	return TRUE;
}

simulated function bool ShouldIgnoreDistance()
{
	return FALSE;
}

/** Returns base priority for targeting this object. */
simulated function float GetBasePriority(NanoPC Askee, optional NanoPawn AskeePawn)
{
	if( !IsTargetable() )
	{
		return INDEX_NONE;
	}
	// ignore if same team
	else if (Askee != None && Askee.GetTeamNum() == GetTeamNum())
	{
		return INDEX_NONE;
	}
	else
	{
		// default priority
		//@todo - config property?
		return 10.f;
	}
}

/** Get location that target should be considered */
simulated event vector GetTargetedLocation()
{
	return Location;
}

/** Called when taget is struck by thrown sword */
simulated function NotifyImpaledBySword( NanoProj_ThrownSword Sword );
simulated function bool NotifyStruckByHook( NanoProj_RicochetMoonHook Hook );

/** Indicates this object can be dash-attacked with sword */
simulated function bool IsValidSwordDashTarget( NanoPawn Attacker )
{
	return FALSE;
}


simulated event Tick( float DeltaTime )
{
	local Actor BaseMost;
	Super.Tick( DeltaTime );

	BaseMost = GetBaseMost();

	// if we get stuck on something just smash it!
	if( NanoVehicleAgent(BaseMost) != None )
	{
		NanoVehicleAgent(BaseMost).SmashNanoVehicleAgent( vect(0,0,0), RammingVelocity, RammingVelocityUp, Controller, class'NDT_BullRamCharge' );
	}
}


event Bump( Actor Other, PrimitiveComponent OtherComp, Vector HitNormal )
{
	local float DamageToDo;

	Super.Bump( Other, OtherComp, HitNormal );


	//`log( "BUMP" @ `showvar(Other) );
	if( NanoPawn(Other) != none )
	{
		PlaySound( BumpIntoSomethingRoar );

		DamageToDo = RammingDamageAgainstAIWhenDriven;

		if( NanoPawn_RebelsBase(Other) != none )
		{
			DamageToDo = RammingDamage;
		}

		NanoPawn(Other).TakeDamage( DamageToDo, Controller, vect(0,0,0), vect(0,0,0), class'NDT_BullRamCharge', , self );
		NanoPawn(Other).Knockback( (vect(0,0,1)*RammingVelocityUp)+(-HitNormal*RammingVelocity), FALSE, 'BullRamKnockBack' );
		ClearTimer( nameof(KickRiderOff) );
	}


	// BullRams smash all Objects in there way!
	if( NanoSentryTurretBase(Other) != none )
	{
		Other.TakeDamage( 10000, Controller, vect(0,0,0), vect(0,0,0), class'NDT_BullRamCharge', , self );
	}

	if( NanoAttractMetaCorpTroopsBase(Other) != none )
	{
		Other.TakeDamage( 10000, Controller, vect(0,0,0), vect(0,0,0), class'NDT_BullRamCharge', , self );
	}


	if( ( RidingPawn != none ) && ( TeslaCoil(Other) != none ) )
	{
		TeslaCoil(Other).TakeDamage( 1000, RidingPawn.Controller, vect(0,0,0), vect(0,0,0), class'NDT_BullRamCharge' );
	}

	if( ( TeslaCoil(Other) != none ) || ( NanoPawn_MetaCorp_SentryBotBase(Other) != none ) )
	{
        Other.TakeDamage( 1000, RidingPawn.Controller, vect(0,0,0), vect(0,0,0), class'NDT_BullRamCharge' );
	}


	// if we hit a ped car we just SMASH IT UP
	if( NanoVehicleAgent(Other) != None )
	{
		PlaySound( BumpIntoSomethingRoar );

		NanoVehicleAgent(Other).SmashNanoVehicleAgent( HitNormal, RammingVelocity, RammingVelocityUp, Controller, class'NDT_BullRamCharge' );
	}

}


// should be promoted up 
function OnAIAssignDefensePoint(SeqAct_AIAssignDefensePoint Action)
{
	local Actor A;
	local NanoAI_BullRam NBR;

	NBR = NanoAI_BullRam(Controller);

	NBR.DefensePoints.Length = 0;

	foreach Action.DefensePoints(A)
	{
		NBR.DefensePoints.AddItem(A);
	}
}


/** Stop agent moving and pay death anim */
function PlayDeath()
{
	//local class<NanoAbsorbOrb> DroppedOrbClass;
	local SkeletalMeshComponent SkelComp;
	local ParticleSystemComponent PSC;

    KickRiderOff();

	SetPhysics(PHYS_RigidBody);
	
	if(DeathEffect != none)
	{
		PSC_DeathEffect = WorldInfo.MyEmitterPool.SpawnEmitter( DeathEffect, Location, Rotation, self );
		PSC_DeathEffect.SetScale( 3.0f );

		PSC_DeathEffect = WorldInfo.MyEmitterPool.SpawnEmitter( DeathEffect, Location+vect(0,0,128.0f), Rotation, self );
		PSC_DeathEffect.SetScale( 3.0f );

		PSC_DeathEffect = WorldInfo.MyEmitterPool.SpawnEmitter( DeathEffect, Location+vect(-128.0f,0,0), Rotation, self );
		PSC_DeathEffect.SetScale( 3.0f );

		PSC_DeathEffect = WorldInfo.MyEmitterPool.SpawnEmitter( DeathEffect, Location+vect(128.0f,0,0), Rotation, self );
		PSC_DeathEffect.SetScale( 3.0f );
	}

    if( HornLeft != none )
	{
        HornLeft.TakeDamage( 1000, Controller, vect(0,0,0), vect(0,0,0), class'NDT_BullRamCharge' );
	}

	if( HornRight != none )
	{
	    HornRight.TakeDamage( 1000, Controller, vect(0,0,0), vect(0,0,0), class'NDT_BullRamCharge' );
	}

// 	foreach DroppedOrbClasses( DroppedOrbClass )
// 	{
// 		Orbs.AddItem( NanoGRI(WorldInfo.GRI).SpawnANanoOrb( DroppedOrbClass, self, FALSE ) );
// 	}

	foreach AllOwnedComponents( class'SkeletalMeshComponent', SkelComp )
	{
		SkelComp.SetActorCollision( FALSE, FALSE, FALSE );
		SkelComp.SetHidden( TRUE );
	}

	// need to go over all of the comps and deactivate the PSCs (e.g. all of the "we are damaged" effects
	foreach AllOwnedComponents( class'ParticleSystemComponent', PSC )
	{
		PSC.DeactivateSystem();
	}

	SetCollision( FALSE, FALSE, FALSE );
	SetPhysics( PHYS_None );

}

simulated event Destroyed()
{
	local ParticleSystemComponent PSC;

	super.Destroyed();

	if( PSC_DeathEffect != none )
	{
		PSC_DeathEffect.DeactivateSystem();
	}

	if( AC_DamagedAndOnFireSound != None )
	{
		AC_DamagedAndOnFireSound.FadeOut( 0.5f, 0.0f );
		AC_DamagedAndOnFireSound = None;
	}

	// need to go over all of the comps and deactivate the PSCs
	foreach AllOwnedComponents( class'ParticleSystemComponent', PSC )
	{
		PSC.DeactivateSystem();
	}


}

event TakeDamage(int Damage, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);


	if( ( bDidHeavyDamageEffects == FALSE ) && ( Health < (DefaultHealth * 0.40f) ) )
	{
		DoHeavyDamageEffects();
	}
	else if( ( bDidMediumDamageEffects == FALSE ) && ( Health < (DefaultHealth * 0.60f) ) )
	{
		DoMediumDamageEffects();
	}
	else if( ( bDidLightDamageEffects == FALSE ) && ( Health < (DefaultHealth * 0.80f) ) )
	{
		DoLightDamageEffects();
	}
}


function DoLightDamageEffects()
{
	local SkeletalMeshComponent SMC;

	bDidLightDamageEffects = TRUE;

	foreach ComponentList( class'SkeletalMeshComponent', SMC )
	{
		DoPSCAttach( SMC, DamageLightSocket, PS_Damaged_Light );
	}

	foreach ComponentList( class'SkeletalMeshComponent', SMC )
	{
		DoPSCAttach( SMC, DamageSparksSocket, PS_Damaged_Sparks );
	}
}


function DoMediumDamageEffects()
{
	local SkeletalMeshComponent SMC;

	bDidMediumDamageEffects = TRUE;

	foreach ComponentList( class'SkeletalMeshComponent', SMC )
	{
		DoPSCAttach( SMC, DamageMediumSocket, PS_Damaged_Medium );
	}


	// make a damaged sound
	if( AC_DamagedAndOnFireSound == None )
	{
		AC_DamagedAndOnFireSound = new(self) class'AudioComponent';
		AC_DamagedAndOnFireSound.SoundCue = DamagedAndOnFireSound;
		AttachComponent( AC_DamagedAndOnFireSound );
		AC_DamagedAndOnFireSound.FadeIn( 0.5f, 1.0f );
	}

}


function DoHeavyDamageEffects()
{
	local SkeletalMeshComponent SMC;

	bDidHeavyDamageEffects = TRUE;

	foreach ComponentList( class'SkeletalMeshComponent', SMC )
	{
		DoPSCAttach( SMC, DamageHeavySocket, PS_Damaged_Heavy );
	}


}


/** This will create a PSC and attach it to the SMC at the socketname passed in. **/
private function DoPSCAttach( SkeletalMeshComponent SMC, name SocketName, ParticleSystem ThePS )
{
	WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment( ThePS, SMC, SocketName, TRUE );
}






function bool Died(Controller Killer, class<DamageType> DamageType, vector HitLocation)
{
	if( Super.Died(Killer,DamageType,HitLocation) )
	{
		if( NanoPC(Killer) != None )
		{
			if( NanoPC(Killer).CanGainEXP() == TRUE )
			{
				GetGRI().MCP.AddIntToLocalMCPDatum( class'NanoTypes'.static.GetLocalPlayerUserName(), class'NanoMCPKeys'.default.NumKills_Bullram, 1 );
				NanoGRI(WorldInfo.GRI).NCM.HandleChallengeEvent( ECET_KilledABullRam );
			}
		}


		PlayDeath();
		return TRUE;
	}

	return FALSE;
}

/** This will return the struct that holds all of the values for this specific pawn **/
simulated function NanoCausingChaosValueDatum GetDeathChaosValue()
{
	return class'NanoCausingChaosValues'.default.BullRamKilled;
}


function bool HasImpactOverride()
{
	return TRUE;
}


defaultproperties
{

}
