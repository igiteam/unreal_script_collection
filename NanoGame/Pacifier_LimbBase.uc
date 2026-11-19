/**
 * Pacifier Bot Limb
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class Pacifier_LimbBase extends Actor
	native
	implements( NanoInterface_Targetable, NanoInterface_PowerAffect, NanoInterface_ActiveAttacker, NanoInterface_OrbitalTarget )
	config(Pawn)
	abstract;

/** Ref back to AI/Bot */
var NanoAI_PacifierBot AI;
var NanoPawn_MetaCorp_PacifierBotBase Bot;
/** Material index used by this limb */
var int	MaterialIndex;
/** Material ref used to change appearance based on nano state */
var	MaterialInstanceConstant	LimbMIC;

/** Name of the socket this limb is attached to */
var Name SocketName;
/** Name of the socket this limbs muzzle flash comes from */
var Name MuzzleSocketName;
/** Static mesh component acting as collision for the limb */
var() StaticMeshComponent	StaticMeshComp;
/** Relative location of limb actor when attached to the bot */
var() Vector				RelLoc;

/** Whether limb is active or not */
var bool bEnabled;

/** Weapon class to spawn for this limb */
var class<NanoWeap_Pacifier_Base> DefaultWeaponClass;
/** Weapon associated with this limb, if any */
var NanoWeap_Pacifier_Base Weapon;
/** Next time limb weapon is allowed to fire */
var float NextAllowFireTime;
/** Actor this limb is targeting */
var Actor FireTarget;
var transient Vector FireTargetLocation;
/** Min/Max Range for selecting a fire target */
var config float	MinTargetDist;
var config float	MaxTargetDist;
/** Min target FOV for selecting a fire target */
var config float	MinTargetFOV;
/** Amount of delay before limb is allowed to attack again */
var config vector2D	NextRefireRange;

/** increased when weapon fires. 0 = not firing. 1 - 255 = firing */
var repnotify	byte	FlashCount;
/** tracks the number of consecutive shots. Note that this is not replicated, so it's not correct on remote clients. It's only updated when the pawn is relevant. */
var				int		ShotCount;

/** Amount of damage this limb can continue to take */
var() config	int Health;
/** The limb's current NanoState **/
var transient ENanoState CurrNanoState;
/** How long nano state lasts for */
var config float StateChangeAttackDuration;

/** These are the orbital attractors currently on this actor.  They get turned on and off by the NanoWeap_Orbitals_Base **/
var transient array<NxForceField> OrbitalsAttractList;

/** This limb has been juggled */
var transient bool bJuggled;

replication
{
	// sent to non owning clients
	if( bNetDirty && (!bNetOwner || bDemoRecording) && Role==Role_Authority )
		FlashCount;
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	GetGRI().RegisterTargetableActor(self);
}


// this is called when the pacifier bot dies off
simulated function Destroyed()
{
	local NxForceField FF;

	Super.Destroyed();

	foreach OrbitalsAttractList(FF)
	{
		FF.Destroy();
	}

	UnregisterAsAttacker();
}

simulated final function NanoGRI GetGRI()
{
	return NanoGRI(WorldInfo.GRI);
}

/** Check on various replicated data and act accordingly. */
simulated event ReplicatedEvent( name VarName )
{
	Super.ReplicatedEvent( VarName );

	if( VarName == 'FlashCount' )
	{
		FlashCountUpdated( true );
	}
}

function InitLimb( NanoAI_PacifierBot C )
{
	// Store ref to AI
	AI = C;
	Bot = NanoPawn_MetaCorp_PacifierBotBase(C.Pawn);

	// Attach to the owning pawn
	SetBase( Bot,, Bot.Mesh, SocketName );
	SetRelativeLocation(RelLoc);
	// Setup weapon class
	SpawnDefaultWeapon();

	LimbMIC = Bot.Mesh.CreateAndSetMaterialInstanceConstant(MaterialIndex);
	class'NanoTypes'.static.SetMaterialInstanceToDefault( LimbMIC );
}

simulated function UpdateMesh( float DeltaTime );
simulated function DetatchLimb();

function SpawnDefaultWeapon()
{
	if( DefaultWeaponClass != None )
	{
		Weapon = Spawn(DefaultWeaponClass,self);
	}
	if( Weapon != None )
	{
		Weapon.InitWeapon( self, Bot );
	}
}

function SetEnabled( bool bInEnabled )
{
	bEnabled = bInEnabled;
}

/** Can begin a new fire sequence */
function bool CanFire()
{
	if( !AbleToFire() )
	{
		return FALSE;
	}
	if( Weapon == None || Weapon.IsFiring() )
	{
		return FALSE;
	}
	if( NextAllowFireTime > WorldInfo.TimeSeconds )
	{
		return FALSE;
	}

	if( !AllowedToActivelyAttackTarget() )
	{
		return FALSE;
	}

	return TRUE;
}

/** Allowed to fire at all... */
simulated function bool AbleToFire()
{
	local Vector	FireStart;
	local Rotator	FireDir;
	local Actor		TargetActor;

	if( !bEnabled || Health <= 0 )
	{
		return FALSE;
	}

	if( FireTarget != None )
	{
		GetWeaponFireInfo( FireStart, FireDir, TargetActor );
		if( !AI.CanSeeByPoints( FireStart, TargetActor.Location, FireDir ) )
		{
			return FALSE;
		}
	}

	return TRUE;
}

function FireWeapon()
{
	RegisterAsActiveAttacker();

	Weapon.StartFire(0);
	NextAllowFireTime = WorldInfo.TimeSeconds + GetRefireDelay();

//	`log( self@GetFuncName()@FireTarget );
}

function StopFire()
{
//	`log( self@GetFuncName()@FireTarget );

	UnregisterAsActiveAttacker();
	Weapon.StopFire(0);
}

function float GetRefireDelay()
{
	return RandRange( NextRefireRange.X, NextRefireRange.Y );
}


function GetWeaponFireInfo( out Vector out_FireStart, out Rotator out_FireDir, optional out Actor out_Target )
{
	local Vector SocketLoc;
	local Rotator SocketRot;

	Bot.Mesh.GetSocketWorldLocationAndRotation( MuzzleSocketName, SocketLoc, SocketRot );
	out_FireStart	= SocketLoc;
	out_FireDir		= Rotator(FireTargetLocation-SocketLoc);
	out_Target		= FireTarget;
}

function float RateStimulusForFireTarget(int Index)
{
	return AI.RateStimulusForFireTarget(Index);
}

/** Select a target for this limb to shoot at from the stimuli collected by controlling AI */
function bool ChooseTarget()
{
	local StimulusQuery Query;
	local array<int> StimulusIndices;
	local int Idx, BestIdx;
	local float StimulusRating, BestStimulusRating;
	local Actor NewFireTarget;

	if( Weapon != None && !Weapon.IsFiring() )
	{
		Query.Visibility = QO_Allow;
		Query.bAllowFriendly = FALSE;
		Query.bAllowNonFriendly = TRUE;
		Query.MinFOV  = MinTargetFOV;
		Query.MinDist = MinTargetDist;
		Query.MaxDist = MaxTargetDist;

		AI.MultipleResultStimulusQuery(Query,StimulusIndices);
		BestIdx = -1;
		BestStimulusRating = 0.f;
		foreach StimulusIndices(Idx)
		{
			StimulusRating = RateStimulusForFireTarget(Idx);
			if( StimulusRating >= 0.f && (BestIdx == -1 || StimulusRating > BestStimulusRating) )
			{
				BestIdx = Idx;
				BestStimulusRating = StimulusRating;
			}
		}
		if( BestIdx != -1 )
		{
			NewFireTarget = AI.Stimuli[BestIdx].Actor;
		}
		else
		{
			NewFireTarget = None;
		}

	//	`log(self@GetFuncName()@"..."@FireTarget);

		if( FireTarget != NewFireTarget )
		{
			UnregisterAsAttacker();

			FireTarget = NewFireTarget;

			RegisterAsAttacker();
		}
	}

	return (FireTarget!=None);
}

simulated function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	if( !bJuggled && FireTarget != None )
	{
		FireTargetLocation = FireTarget.Location;
	}

	if( Bot.bCurrDistanceBasedPerformanceOn == FALSE )
	{
		if( ChooseTarget() && CanFire() )
		{
			FireWeapon();
		}
	}
}

/**
 * This function's responsibility is to signal clients that non-instant hit shot
 * has been fired. Call this on the server and local player.
 *
 * Network: Server and Local Player
 */
simulated function IncrementFlashCount( Weapon Who, byte FireModeNum )
{
	bForceNetUpdate = TRUE;	// Force replication
	FlashCount++;
	// Make sure it's not 0, because it means the weapon stopped firing!
	if( FlashCount == 0 )
	{
		FlashCount += 2;
	}

	// This weapon has fired.
	FlashCountUpdated(FALSE);
}

/**
 * Clear flashCount variable. and call WeaponStoppedFiring event.
 * Call this on the server and local player.
 *
 * Network: Server or Local Player
 */
simulated function ClearFlashCount(Weapon Who)
{
	if( FlashCount != 0 )
	{
		bForceNetUpdate = TRUE;	// Force replication
		FlashCount		= 0;

		// This weapon stopped firing
		FlashCountUpdated(FALSE);
	}
}

/**
 * Called when FlashCount has been updated.
 * Trigger appropritate events based on FlashCount's value.
 * = 0 means Weapon Stopped firing
 * > 0 means Weapon just fired
 *
 * Network: ALL
 */
simulated function FlashCountUpdated( bool bViaReplication )
{
	//`log( WorldInfo.TimeSeconds @ GetFuncName() @ "FlashCount:" @ FlashCount @ "bViaReplication:" @ bViaReplication );

	if( FlashCount > 0 )
	{
		WeaponFired( bViaReplication );
	}
	else
	{
		WeaponStoppedFiring( bViaReplication );
	}
}

/**
 * Called when a pawn's weapon has fired and is responsibile for
 * delegating the creation of all of the different effects.
 *
 * bViaReplication denotes if this call in as the result of the
 * flashcount being replicated. It's used filter out
 * when to make the effects.
 *
 * Network: ALL
 */
simulated function WeaponFired( bool bViaReplication, optional vector HitLocation )
{
	// increment number of consecutive shots.
	ShotCount++;

	// By default we just call PlayFireEffects on the weapon.
	if( Weapon != None )
	{
		Weapon.PlayFireEffects( 0, HitLocation );
	}
}


/**
 * Called when a pawn's weapon has stopped firing and is responsibile for
 * delegating the destruction of all of the different effects.
 *
 * bViaReplication denotes if this call in as the result of the
 * flashcount being replicated.
 *
 * Network: ALL
 */
simulated function WeaponStoppedFiring( bool bViaReplication )
{
	// reset number of consecutive shots fired.
	ShotCount = 0;

	if (Weapon != None)
	{
		Weapon.StopFireEffects( 0 );
	}
}

simulated function bool StopsProjectile(Projectile P)
{
	if( P.Instigator == Owner )
	{
		return FALSE;
	}

	return Super.StopsProjectile( P );
}

event TakeDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	local int Idx;
	local SeqEvent_TakeDamage dmgEvent;

	if( Health > 0 && InstigatedBy != Bot.Controller )
	{
		AdjustDamage(Damage, Momentum, InstigatedBy, HitLocation, DamageType, HitInfo, DamageCauser);

		Health -= Damage;
//		`log( self@`showvar(Damage)@`showvar(Health) );
		if( Health <= 0 )
		{
			Bot.Controller.NotifyTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum );
			NotifyLimbDestroyed();
		}
		else
		{
			// search for any damage events
			for( Idx = 0; Idx < Bot.GeneratedEvents.Length; Idx++ )
			{
				dmgEvent = SeqEvent_TakeDamage(Bot.GeneratedEvents[Idx]);
				if( dmgEvent != None )
				{
					// notify the event of the damage received
					dmgEvent.HandleDamage( Bot, InstigatedBy, DamageType, Damage );
				}
			}
		}
	}
}

function AdjustDamage(out int InDamage, out vector Momentum, Controller InstigatedBy, vector HitLocation, class<DamageType> DamageType, TraceHitInfo HitInfo, Actor DamageCauser)
{
	local NanoPRI PRI;
	local NanoWeapon Wpn;
	local class<NanoAmmoModifier> AmmoMod;
	local int AmmoModLvl;

	if( InstigatedBy != None && InstigatedBy.Pawn != None )
	{
		Wpn = NanoWeapon(InstigatedBy.Pawn.Weapon);
		PRI = NanoPRI(InstigatedBy.PlayerReplicationInfo);
		if( Wpn != None && PRI != None )
		{
			AmmoMod = PRI.GetAmmoModClass( Wpn.Class, AmmoModLvl );
			if( AmmoMod != None )
			{
				AmmoMod.static.HandleAmmoImpact( AmmoModLvl, self, InstigatedBy, inDamage, HitLocation, HitInfo );
			}
		}
	}
}

simulated function bool PreventBotMovement()
{
	return FALSE;
}

/** Allow the limb to handle being destroyed */
simulated event NotifyLimbDestroyed()
{
	local int BoneIdx;

	SetEnabled( FALSE );

	BoneIdx = Bot.Mesh.MatchRefBone(BaseBoneName);
	Bot.Mesh.HideBone( BoneIdx, PBO_Term );

	SetCollision( FALSE );

	Destroy();
}

simulated event HandleFootStep( int FootDown );

/////////////////////////////////////////////////////
//////// INTERFACE: NanoInterface_Targetable /////////
/////////////////////////////////////////////////////
simulated function float GetBasePriority(NanoPC Askee, optional NanoPawn AskeePawn)
{
	if( Health <= 0 )
	{
		return -1.f;
	}
	return 1;
}

simulated function bool IsTargetable( optional ETargetQueryType QT )
{
	return (Health > 0);
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
	return TRUE;
}

simulated function bool ShouldIgnoreDistance()
{
	return FALSE;
}

simulated function NotifyImpaledBySword( NanoProj_ThrownSword Sword );
simulated function bool NotifyStruckByHook( NanoProj_RicochetMoonHook Hook );

simulated function bool IsValidSwordDashTarget( NanoPawn Attacker )
{
	return FALSE;
}

/** When this NanoPawn is targetted, which location should we focus on */
simulated event vector GetTargetedLocation()
{
	return Location;
}

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

simulated event BoxSphereBounds GetTargetableBounds()
{
	return StaticMeshComp.Bounds;
}


/////////////////////////////////////////////////////
//////// INTERFACE: NanoInterface_PowerAffect ////////
/////////////////////////////////////////////////////
/** Used to change the nano state of an object */
simulated function bool SetNanoState(ENanoState NewState, Actor InInstigator, optional float NanoPowerAmount)
{
	if( NewState != CurrNanoState )
	{
		if( Role < ROLE_Authority )
		{
			ServerSetNanoState( NewState );
		}

		if( NewState == ENS_Normal )
		{
			class'NanoTypes'.static.SetMaterialInstanceToDefault( LimbMIC );
		}
		else if( NewState == ENS_Dust )
		{
			class'NanoTypes'.static.SetMaterialInstanceToDusted( LimbMIC );
		}
		else if(NewState == ENS_Dense)
		{
			class'NanoTypes'.static.SetMaterialInstanceToDensed( LimbMIC );
		}

		CurrNanoState = NewState;

		// If force to different state, set timer for turning back.
		if( CurrNanoState != ENS_Normal )
		{
			SetTimer( StateChangeAttackDuration, FALSE, nameof(RestoreDefaultNanoState) );
		}

		Weapon.LimbNanoStateChanged( self );
	}
	return TRUE;
}

reliable server function ServerSetNanoState(ENanoState NewState)
{
	SetNanoState(NewState, Bot.Controller);
}

/** Used to restore the nano state of an object to default */
simulated function RestoreDefaultNanoState()
{
	SetNanoState(ENS_Normal,self);
}

simulated function bool CanBeChanged( ENanoState NewState )
{
	if( NewState == ENS_Dust )
	{
		return CanBeDusted();
	}
	if( NewState == ENS_Dense )
	{
		return CanBeDensed();
	}
	return TRUE;
}

simulated function bool CanBeDusted()
{
	return FALSE;
}

simulated function bool CanBeDensed()
{
	return FALSE;
}

simulated function bool IsDusted()
{
	return (CurrNanoState == ENS_Dust);
}

simulated function bool IsDensed()
{
	return (CurrNanoState == ENS_Dense);
}

simulated function OnModifyNanoAffectedActor( SeqAct_ModifyNanoAffectedActor InAction );

/////////////////////////////////////////////////////
////// INTERFACE: NanoInterface_ActiveAttacker //////
/////////////////////////////////////////////////////
/** Get the number of attack slots this attacker consumes */
function int GetActiveAttackSlots()
{
	return 1;
}

/** Notify the attacker that the target they were engaging is available */
function bool NotifyActiveAttackAvailable( NanoPawnBase AvailableTarget )
{
	if( AvailableTarget == FireTarget )
	{
		if( CanFire() )
		{
			FireWeapon();
			return TRUE;
		}
	}
	else
	{
		AvailableTarget.UnregisterAttacker(self);
	}
	return FALSE;
}

function float RateAttacker( NanoPawnBase Targ, optional bool bSkipRandom )
{
	return 10.f;
}

function RegisterAsAttacker()
{
	if( NanoPawnBase(FireTarget) != None )
	{
		NanoPawnBase(FireTarget).RegisterAttacker(self);
	}
}

function UnregisterAsAttacker()
{
	if( NanoPawnBase(FireTarget) != None )
	{
		NanoPawnBase(FireTarget).UnregisterAttacker(self);
	}
}

function RegisterAsActiveAttacker()
{
	if( NanoPawnBase(FireTarget) != None )
	{
		NanoPawnBase(FireTarget).RegisterActiveAttacker(self);
	}
}

function UnregisterAsActiveAttacker()
{
	if( NanoPawnBase(FireTarget) != None )
	{
		NanoPawnBase(FireTarget).UnregisterActiveAttacker(self);
	}
}

function bool IsPushingForward();


function bool AllowedToActivelyAttackTarget()
{
	if(  NanoPawnBase(FireTarget) != None &&
		!NanoPawnBase(FireTarget).AllowedToActivelyAttackTarget(self) )
	{
		return FALSE;
	}
	return TRUE;
}

event Actor GetAttackActor()
{
	return self;
}

simulated function SetUpOrbitalAttractor()
{
	AddAnOrbitalAttractorRadial( 100.0f, -25.0f );
}

simulated function AddAnOrbitalAttractorRadial( float InRadius, float InStrength )
{
    local NanoForceField_OrbitalAttractorRadial OrbitalsAttact;

	OrbitalsAttact = Spawn( class'NanoForceField_OrbitalAttractorRadial', self,,Location );
	OrbitalsAttact.Shape = new(OrbitalsAttact) class'ForceFieldShapeSphere';

    OrbitalsAttact.bForceActive = FALSE;

    OrbitalsAttact.ForceRadius = InRadius;
	OrbitalsAttact.ForceStrength = InStrength;
	OrbitalsAttact.ForceFalloff = RIF_Linear;

    OrbitalsAttact.SetHardAttach( TRUE );
	OrbitalsAttact.SetBase( self );

	OrbitalsAttact.DoInitRBPhys();

	OrbitalsAttractList.AddItem( OrbitalsAttact );
}


/** This will activate orbital attractors on this target. **/
simulated function ActivateOrbitalAttractors()
{
	local NxForceField FF;

	// make certain we have some force fields
	if( OrbitalsAttractList.Length == 0 )
	{
		//SetUpOrbitalAttractor();
	}

	foreach OrbitalsAttractList(FF)
	{
		//`log( "ActivateOrbitalAttractors" @ self @ FF );
		FF.bForceActive = TRUE;
		//FF.DoInitRBPhys();
	}
}

/** This will deactivate orbital attractors on this target. **/
simulated function DeactivateOrbitalAttractors()
{
	local NxForceField FF;

    //`log( "DeactivateOrbitalAttractorsDeactivateOrbitalAttractorsDeactivateOrbitalAttractors" @ self );

	foreach OrbitalsAttractList(FF)
	{
		FF.bForceActive = FALSE;
		//FF.DoInitRBPhys();
	}
}

/** This is needed to find the location of this OrbitalTarget **/
simulated event vector GetOrbitalTargetLocation()
{
	return Location;
}

/** Each Orbital target will have different valid damage distances. **/
simulated event float GetDistanceForDamage()
{
	return 128.0f;
}

/** How many orbitals need to be touching this pawn for damage to occur (where touching is being within range **/
simulated event int GetNumOrbitalsTouchingForDamage()
{
	return 5;
}




defaultproperties
{
	Begin Object Class=TargetableOctreeComponent Name=TargetableOctreeComp0
	End Object
	Components.Add(TargetableOctreeComp0)

	bStatic=FALSE
	bCollideActors=TRUE
	bBlockActors=TRUE
	bCollideAsEncroacher=TRUE
	bNoEncroachCheck=TRUE
	bGameRelevant=TRUE
	bHardAttach=TRUE
	bProjTarget=TRUE //temp until we get phys asset for pac-bot

	RemoteRole=ROLE_SimulatedProxy


	TickFrequencyDecreaseDistanceStart=2000
	TickFrequencyDecreaseDistanceEnd=6000
	TickFrequencyAtEndDistance=0.1
}
