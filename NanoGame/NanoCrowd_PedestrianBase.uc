/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoCrowd_PedestrianBase extends GameCrowdAgentSkeletal
	native
	implements( NanoInterface_Targetable )
	abstract;

var() array<Name>	PushReactionAnims;

var transient float	LastDodgeTime;
var	float			DodgeVel;

/** This is the current Chaos Zone this is in **/
var transient NanoVolume_ChaosZone CurrChaosZone;



/** Whether or not this crowd should spawn an AI when it is shot. **/
var() bool bShouldSpawnAnAIWhenShot;

/** This is the class that should be spawned when this crowd agent is shot. **/
var() class<NanoPawnBase> ClassToSpawnWhenShot;

/** Whether or not this crowd member should show up on the map. **/
var() bool bShouldShowOnMiniMap;

/** If this crowd member is displayed on the mini map, then use this color **/
var() Color MiniMapDotColor;

/** The crowd will say this line when shot at.  (e.g. useful for peds having bullets whiz by) **/
var() SoundCue SoundToPlayWhenDodging;

/** When the AI turned into an AI, it will say this line **/
var() SoundCue SoundToPlayWhenTransformingToAI;

/** 
 * When an enemy is first seen (or after some time of not being seen) we play this effect to show off iris "alerting" you.
 * eventually will have "threat" detection and such.  like terminators do!
 **/
var ParticleSystem PS_IRIS_FirstEncounter;
var transient ParticleSystemComponent PSC_IRIS_FirstEncounter;
var transient float TimeSpawnedFirstEncounterEffect;
var float DurationBeforeSpawningFirstEncounterEffects;
var name IRIS_FirstEncounterBoneName;


/** Whether or not the Crowd member should do a dodge when they take damage. **/
var bool bDoDodgeOnDamage;


simulated function Tick(float DeltaTime)
{
	local ChaosPacifismManager CM;

	Super.Tick(DeltaTime);

	// only if we are panicked do we start killing off the crowd  (also this is MEGA optimization as otherwise we are
	// constantly calling these functions to test every frame
	if( IsPanicked() )
	{
		CM = (GetChaosZone() != none) ? GetChaosZone().MyNanoChaosZoneInfo.ChaosManager : NanoGRI(class'WorldInfo'.static.GetWorldInfo().GRI).GetCurrentChaosManager();
		// Above tier 3, we start killing off the crowd
		if( ( CM != none ) && ( CM.GetChaosTier() >= ECT_Tier3 ) )
		{
			// Set timer if not active
			if(!IsTimerActive(nameof(PanicVanish)))
			{
				SetTimer(RandRange(2.0, 6.0), FALSE, nameof(PanicVanish));
			}
		}
	}

	if( bShouldSpawnAnAIWhenShot == TRUE )
	{
		PossiblySpawnIRIS_FirstEncounterEffect();
	}
}


simulated function PossiblySpawnIRIS_FirstEncounterEffect()
{
	if( bShouldSpawnAnAIWhenShot == FALSE )
	{
		return;
	}

	if( ( `TimeSince(LastRenderTime) < 0.200f )
		&& ( TimeSpawnedFirstEncounterEffect == 0.0f ) // for now
		//&& ( `TimeSince(TimeSpawnedFirstEncounterEffect) > DurationBeforeSpawningFirstEncounterEffects )
		)
	{
		SpawnIRIS_FirstEncounterEffect();
	}
}

simulated protected function SpawnIRIS_FirstEncounterEffect()
{
	PSC_IRIS_FirstEncounter = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment( PS_IRIS_FirstEncounter, SkeletalMeshComponent, IRIS_FirstEncounterBoneName );
	PSC_IRIS_FirstEncounter.SetDepthPriorityGroup( SDPG_Foreground );
	TimeSpawnedFirstEncounterEffect = WorldInfo.TimeSeconds;
}




function PlayPushedReactionAnim( EDirection Dir )
{  
	FullBodySlot.PlayCustomAnim( PushReactionAnims[Dir], 1.0, 0.1, 0.1, FALSE, TRUE ); 
	FullBodySlot.bEarlyAnimEndNotify = FALSE;
	FullBodySlot.SetRootBoneAxisOption(RBA_Translate, RBA_Translate, RBA_Translate);
	FullBodySlot.SetActorAnimEndNotification(TRUE);
	SkeletalMeshComponent.RootMotionMode = RMM_Translate;	
}


event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	Super.OnAnimEnd( SeqNode, PlayedTime, ExcessTime );

	if( (SeqNode != None) && PushReactionAnims.Find( SeqNode.AnimSeqName ) >= 0 )
	{
		SkeletalMeshComponent.RootMotionMode = default.SkeletalMeshComponent.RootMotionMode;
		FullBodySlot.SetRootBoneAxisOption( RBA_Default, RBA_Default, RBA_Default );
	}
}


simulated function NanoVolume_ChaosZone GetChaosZone()
{
	return CurrChaosZone;
}

simulated function SetChaosZone( const NanoVolume_ChaosZone InChaosZone )
{
	CurrChaosZone = InChaosZone;
}


/** This will spawn an AI from this crowd member if applicable. **/
function PossiblySpawnAIFromCrowd();


/** Kills a crowd member when panic level is to high - TEMP: should run to a door instead of vanishing */
simulated function PanicVanish()
{
	KillAgent();
}


function SetPanic(actor PanicActor, bool bNewPanic)
{
	if ( !IsPanicked() && bNewPanic )
	{
		// about to start to panic
		//NanoGRI(WorldInfo.GRI).ModifyChaosLevel( GetChaosZone(), self, class'NanoCausingChaosValues'.default.ScaringCitizen );
	}
	super.SetPanic(PanicActor, bNewPanic);
}		


/** Make the agent move to the side and play anim */
simulated function DoDodge()
{
	local vector DodgeDir;
	local bool bDodgeLeft;
	local name DodgeAnimName;

	bDodgeLeft = FRand() > 0.5;

	// Dir to dodge right
	DodgeDir = vect(0,1,0) >> Rotation;

	// Invert to make to the left
	if(bDodgeLeft)
	{
		DodgeDir *= -1.0;
		DodgeAnimName = 'Evade_Lt';
	}
	else
	{
		DodgeAnimName = 'Evade_Rt';
	}

	// Play dodging anim
	FullBodySlot.PlayCustomAnim(DodgeAnimName, 1.0, 0.1, 0.2, FALSE, TRUE);	

	// Make agent move a bit
	Velocity += (DodgeVel * DodgeDir);


	if( SoundToPlayWhenDodging != None )
	{
		PlaySound( SoundToPlayWhenDodging );
	}
}


/** When civilians would normally take damage, they dodge */
simulated event TakeDamage(int DamageAmount, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{

	// if we are not dodging then we take normal damage
	if( bDoDodgeOnDamage == FALSE )
	{
		Super.TakeDamage(DamageAmount, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
		if( Health <= 0 )
		{
			NanoGRI(WorldInfo.GRI).ModifyChaosLevel( GetChaosZone(), self, class'NanoCausingChaosValues'.default.CitizenKilled );
		}
	}
	else
	{
		if(`TimeSince(LastDodgeTime) > 1.5)
		{
			DoDodge();
			LastDodgeTime = WorldInfo.TimeSeconds;
		}
	}
}


//// NanoInterface_Targetable

/** Is this object currently targetable */
simulated function bool IsTargetable( optional ETargetQueryType QT )
{
	return FALSE;
}

/** Returns the Targetable Octree component */
simulated function TargetableOctreeComponent GetTargetableOctreeComponent()
{
	local TargetableOctreeComponent TargetableComp;

	foreach AllOwnedComponents( class'TargetableOctreeComponent', TargetableComp )
	{
		return TargetableComp;
	}

	return None;
}

simulated function bool ShouldRateTarget()
{
	 // if we have not seen this actor for 2 second then don't allow targeting of it
	return ((WorldInfo.TimeSeconds - LastRenderTime) < 2.0f);
}

/** Should this targetable actor ignore distance checks in rating calculations (caution...use with care!) */
simulated function bool ShouldIgnoreDistance()
{
	return FALSE;
}

/** Returns base priority for targeting this object. */
simulated function float GetBasePriority(NanoPC Askee, optional NanoPawn AskeePawn)
{
	return -1.0f;
}

/** Get location that target should be considered */
simulated event vector GetTargetedLocation();

/** Rotation of the target.  Useful to see if they are facing some dir **/
simulated event rotator GetRotation()
{
	return Rotation;
}

/** How fast the target is currently moving **/
simulated event vector GetVelocity()
{
	return Velocity;
}

/** Pass in a struct and then have the interface fill in a ton of different firing targetable data **/
simulated function GetFiringTargetableDatum( out FiringTargetableDatum Out_FiringTargetableDatum );

/** Called when target is struck by thrown sword */
simulated function NotifyImpaledBySword( NanoProj_ThrownSword Sword );

/** Called when target struck by ricochet moon hook */
simulated function bool NotifyStruckByHook( NanoProj_RicochetMoonHook Hook );

/** Indicates this object can be dash-attacked with sword */
simulated function bool IsValidSwordDashTarget( NanoPawn Attacker );






defaultproperties
{
	MiniMapDotColor=(R=55,G=55,B=55,A=255)

	DurationBeforeSpawningFirstEncounterEffects=10.0f
	PS_IRIS_FirstEncounter=ParticleSystem'Nano_Iris_Proto.Effects.P_IrisTargeting_Initiate'
	IRIS_FirstEncounterBoneName="b_MF_Spine_03"

	bDoDodgeOnDamage=TRUE
}



