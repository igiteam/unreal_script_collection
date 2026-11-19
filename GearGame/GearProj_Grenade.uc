/**
 * GearProj_Grenade
 * Grenade Projectile Implementation
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearProj_Grenade extends GearProj_ExplosiveBase
	native(Weapon)
	abstract
	implements(AIObjectAvoidanceInterface);

`include(GearPlayerPersistentDataConstants.uci)

/** Simulate gravity */
var() const protected bool	bPerformGravity;

/** Maximum number of bounces */
var() const config protected int MaxBounceCount;

/** Maximum number of bounces before arming */
var() const protected int	MaxBounceCountToArm;

/** TRUE if this projectile is used for trajectory simulation */
var transient bool			bIsSimulating;

/** Max time in the future the grenade can simulate when doing preview arc.  Keep this low to prevent arc-induced framerate troubles. */
var() const float			MaxSimulationTime;

/** We hit a physics volume, and should go away quietly */
var transient protected bool bHitPhysicsVolume;

/** Mesh used for rendering */
var() protected PrimitiveComponent	Mesh;

/** Mesh used for rendering in taccom */
var() protected PrimitiveComponent	TaccomMesh;

/** The material to use for the taccom preview */
var protected Material TaccomViewMaterial;

/**
  * This is the MIC which will be the weapons's "material" once it is spawned.
 **/
var transient MaterialInstanceConstant MIC_WeaponSkin;

/** size to set the cylinder to when planted, for easier shooting */
var Cylinder PlantedCylinderSize;

//
// Internal
//

/** Number of times grenade has bounced */
var	protected transient int	BounceCount;

/** World position of the grenade's first bounce. */
var transient vector		FirstBounceLoc;

/** Velocity is scaled by this value after each bounce */
var() protected float	VelocityDampingFactor;
/** How much grenade bounces back off wall. 1.0 = normal, 0 = slide against wall */
var() protected float	Bounciness;
/** When grenade dips below this velocity, stop simulating. */
var() protected float	StopSimulatingVelocityThreshhold;

/** sound that plays when you stick a grenade to a foe! **/
var protected const SoundCue GrenadeAttachingToFoeSound;
/** sound that plays when you stick a grenade to the world! **/
var protected const SoundCue GrenadeAttachingToWorldSound;

/** This sound plays when grenade is about to explode **/
var protected const SoundCue BeepBeepAboutToExplodeSound;

/** Sound of grenade bouncing on the ground. */
var protected const SoundCue GrenadeBounceSound;

/** Grenade turned into physics asset? */
var	protected transient bool bEnabledGrenadePhysics;

var protected transient Controller AttacheeController;

//
// Internal simulation variables.
//

/** Length of the fixed timestep for grenade simulation. */
var protected const float			SimFixedTimeStep;
/** Used by simulation code to run gravity on a fixed timestep. */
var protected transient const float	TimeTilNextGravUpdate;
/** Used by simulation code to track mid-simulation gravity advances on collisions. */
var protected const transient float SimInternalGravityAdvanceTime;


/** Time between grenade coming to a rest and grenade arming itself. */
var() protected const config float GrenadeArmingDelay;
/** How long after a grenade arms until the grenade detonates. */
var() protectedwrite const config float GrenadeExplosionDelay;

/** Time between grenade being attached to a pawn and grenade arming itself. */
var() protected config float GrenadeTagArmingDelay;
/** Time between pawn beginning martyr and grenade arming itself. */
var() protected config float GrenadeMartyrArmingDelay;
/** Time between pawn beginning martyr and grenade arming itself. */
var() protected config float GrenadeMartyrExplosionDelay;
/** Frequency, in Hz, of warning beeps that sound between when a grenade arms and it blows up. */
var() protected config float ArmedWarningBeepFrequency;


var protected transient bool bArmed;

/** Used to replicate the explosion, as well as to make sure grenade can't explode more than once. */
var protected transient repnotify bool bGrenadeHasExploded;

/** Actor that has been tagged with this grenade. */
var repnotify transient Actor TagVictim;

/** Pawn who is martyring with this grenade. */
var repnotify protected transient Pawn MartyrVictim;

/** Time between prox grenade being triggered and prox grenade exploding.  Serves as a warning for players. */
var() protected const config float		GrenadeTrapExplosionDelay;
/** When attached to a wall, the grenade will auto-detonate after this time.  0.f means it will never auto-detonate. */
var() protected const config float		GrenadeTrapMaxLifespan;
/** When attached to a wall, the grenade will detonate if an enemy gets closer than this.  */
var() protected const config float		GrenadeTrapTriggerRadius;
/** TRUE if attached to a wall and the explosion sequence is triggered.  Used to tell clients to star the sequence. */
var protected transient repnotify bool	bGrenadeTrapAutoExplosionTriggered;

/** How long after a grenade tag the grenade will detonate. */
var() protected const config float		GrenadeTagExplosionDelay;

/** extra radius beyond trap explosion radius where we play a warning beep */
var config float WarningBeepRadius;
/** minimum amount of time between extra radius warning beeps */
var config float WarningBeepInterval;
/** last time we triggered a warning beep */
var float LastWarningBeepTime;

/** Amount to spawn grenade back along normal so it isn't stuck into surface. */
var() float GrenadeAttachNormalOffset;

var protected transient int TakenDamage;
var() protected const config int DamageToDetonate;

/** Damage type for Martyring */
var class<GearDamageType> MartyrDamageType;
/** Damage type for ObstacleTag */
var class<GearDamageType> TaggedDamageType;
/** Damage type for Pawn Tagging */
var class<GearDamageType> PawnTaggedDamageType;

/** Effect to play on the grenade after grenade tagging someone but before it blows up. */
var transient protected ParticleSystem GrenadeTagPreExplosionSmokeEffect;
/** Effect to play on the grenade after grenade tagging a wall. */
var transient protected ParticleSystem GrenadeTagPreExplosionSmokeEffectPlanted;
/** Socket name to attach GrenadeTagPreExplosionSmokeEffectPlanted */
var protected const name GrenadeTagPlantedSmokeEffectSocketName;

/** Ref to the spawned pre-explosion grenade tag emitter. */
var SpawnedGearEmitter GrenadeTagPreExplosionSmokeEmitter;

//
// debugging
//

/** when true, grenade is frozen. (freezes physics) */
var	bool			bFreeze;

var protected AIAvoidanceCylinder AvoidanceCylinder;

var repnotify byte  TeamNum;

/** If FF is on, this is the delay after setting a grenade trap before a player can trip his own grenade. */
var() protected const float InstigatorTrapSafetyDelay;
/** True if instigator is protected from his own grenade trap. */
var protected transient bool bInstigatorCannotTriggerTrap;

/** Hit normal of last impact. */
var protected transient vector LastHitNormal;
/** Actor of last impact. */
var protected transient Actor LastHitActor;
/** Location of last impact. */
var protected transient vector LastHitLocation;
/** time of last impact */
var protected transient float LastHitTime;

/** class of weapon that spawned us; used to get an icon for HUD displays associated with performing an action on the live projectile */
var class<GearWeapon> OwningWeaponClass;

/** Stats Mask Defines */

const STATS_LEVEL3	= 0x04;


cpptext
{
	virtual void processHitWall(FCheckResult const& Hit, FLOAT TimeSlice=0.f);
	virtual void physProjectile(FLOAT DeltaTime, INT Iterations);

	//////////////////////////////////////////////////////////////////////////
	// AIobjectAvoidanceInterface
	// default is to return event.. but can be overidden to allow quick returns on native classes
	virtual UAIAvoidanceCylinderComponent* GetAIAvoidanceCylinderComponent()
	{
		if(AvoidanceCylinder != NULL)
		{
			return AvoidanceCylinder->GetAIAvoidanceCylinderComponent();
		}
		return NULL;
	}
	//////////////////////////////////////////////////////////////////////////

}

replication
{
	if (bNetDirty)
		bGrenadeHasExploded, TagVictim, MartyrVictim, bGrenadeTrapAutoExplosionTriggered;
	if (bNetInitial)
		OwningWeaponClass, TeamNum;
}

simulated event Destroyed()
{
	Super.Destroyed();

	if (AvoidanceCylinder != None)
	{
		AvoidanceCylinder.Destroy();
	}
	// destroy the pre-explosion tag emitter as well, if playing
	if (GrenadeTagPreExplosionSmokeEmitter != None)
	{
		// will destroy itself when it's done
		GrenadeTagPreExplosionSmokeEmitter.ParticleSystemComponent.DeactivateSystem();
		GrenadeTagPreExplosionSmokeEmitter.LifeSpan = 5.0;
		GrenadeTagPreExplosionSmokeEmitter = None;
	}
	// Remove the tagged grenade from the GRI so it no longer shows up in taccom
	GearGRI(WorldInfo.GRI).RemoveTaggedGrenade(Self);
}

simulated event byte GetTeamNum()
{
	return TeamNum;
}

simulated function ReplicatedEvent(name VarName)
{
	if ( VarName == 'bGrenadeHasExploded' )
	{
		bGrenadeHasExploded = false;
		DoExplosion();
	}
	else if ( VarName == 'TagVictim' )
	{
		if (TagVictim != None)
		{
			AttachInit(TagVictim);
		}
	}
	else if ( VarName == 'MartyrVictim' )
	{
		if (MartyrVictim != None)
		{
			MartyrInit(MartyrVictim);
		}
	}
	else if ( VarName == 'bGrenadeTrapAutoExplosionTriggered' )
	{
		TriggerAttachedToWallExplosionSequence(None);
	}
	else if ( VarName == 'TeamNum')
	{
		SetFlash();
	}
	else
	{
		Super.ReplicatedEvent(VarName);
	}
}

simulated protected function EnableGrenadePhysics()
{
	local int				RootIndex;
	local matrix			RootMatrix;
	local RB_BodyInstance	RootBody;
	local GearAnim_Slot		FullSlot;
	local Name				SpringBodyName;
	local SkeletalMeshComponent	SkelMeshComp;

	SkelMeshComp = SkeletalMeshComponent(Mesh);

	if (SkelMeshComp != None)
	{
		// Blend back to idle
		FullSlot = GetFullSlotNode();
		FullSlot.PlayCustomAnim('Bolo_Extend_Idle', 1.0, 0.2, -1.0, TRUE, TRUE);
		//FullSlot.StopCustomAnim(0.2f);

		SkelMeshComp.SetHasPhysicsAssetInstance(TRUE);

		// Unfix all bodies from kinematic data.
		// So now we switch to being fully physical
		SkelMeshComp.PhysicsAssetInstance.SetAllBodiesFixed(FALSE);

		// Add Spring to prevent physics asset from moving too far from actor's location.
		SpringBodyName	= 'b_bolo_end'; //'b_bolo_root';
		RootIndex	= SkelMeshComp.MatchRefBone(SpringBodyName);
		RootMatrix	= SkelMeshComp.GetBoneMatrix(RootIndex);

		// Find the hip body instance
		RootBody	= SkelMeshComp.FindBodyInstanceNamed(SpringBodyName);

		RootBody.EnableBoneSpring(TRUE, FALSE, RootMatrix);
		RootBody.SetBoneSpringParams(100000.f, 5000.f, 0.f, 0.f);
		RootBody.bDisableOnOverExtension	= FALSE;
		RootBody.bTeleportOnOverextension	= TRUE;
		RootBody.OverextensionThreshold		= 64.f;

		// Wake up physics
		SkelMeshComp.WakeRigidBody();

		SkelMeshComp.PhysicsWeight = 1.f;
	}
}

/** determine if the grenade should blink or not (indicating it was planted by an enemy) */
simulated function SetFlash()
{
	local PlayerController PC;

	if (MIC_WeaponSkin != None)
	{
		foreach LocalPlayerControllers(class'PlayerController', PC)
		{
			if (PC.GetTeamNum() != TeamNum)
			{
				MIC_WeaponSkin.SetScalarParameterValue('GrenadePulse', 1.0);
				MIC_WeaponSkin.SetScalarParameterValue('Emmis_amount', 2.0);
				break;
			}
		}
	}
}

/**
 * This function is called to have the physics simulation of the grenade til the end.
 * we are using this for the grenade arc via particle trails
 */
native function RunPhysicsSimulationTilEnd(float GrenadeLifeSpan);

/** force an update of particle components; useful to force a trail point to be dropped at the grenade's current location (for bouncing, etc) */
native final function ForceTickParticleComponents();

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	if (Mesh != None)
	{
		MIC_WeaponSkin = MeshComponent(Mesh).CreateAndSetMaterialInstanceConstant(0);
	}

	// gravity is handled separately in a special physProjectile for this class
	Acceleration = vect(0,0,0);

	if (Role == ROLE_Authority && Instigator != None)
	{
		TeamNum = Instigator.GetTeamNum();
		if (Instigator.Weapon != None)
		{
			OwningWeaponClass = class<GearWeapon>(Instigator.Weapon.Class);
		}
		SetFlash();
	}
}

simulated function Init(vector Direction)
{
	Super.Init( Direction );

	// reset Projectile
	SetPhysics(default.Physics);

	// reset grenade
	bBounce = TRUE;
	BounceCount = 0;

	// if we are using this projectile for trajectory simulation, then set it up
	if( bIsSimulating )
	{
		LifeSpan = 0;

		if( Mesh != None )
		{
			Mesh.SetHidden( TRUE );
		}
	}
}

/**
 * Initialization function for grenades when being detonated w/o
 * throwing (when DBNO).
 *
 * @param NewMartyrVictim   Pawn who is using grenade on himself.
 *
 * NET: called by everybody, clients from MartyrVictim repnotify
 */
simulated function MartyrInit(Pawn NewMartyrVictim)
{
	if (Role == Role_Authority)
	{
		MartyrVictim = NewMartyrVictim;
		AttacheeController = NewMartyrVictim.Controller;
		//@STATS - Record martyr death
		`RecordPlayerIntStat(GRENADE_MARTYR, AttacheeController, 1);
	}
	Disable('Touch');
	bIsSimulating = FALSE;
	SetTickIsDisabled(false);
	// no physics
	SetPhysics(PHYS_None);
	bBounce = FALSE;
	// hide the mesh
	if (Mesh != None)
	{
		Mesh.SetHidden(TRUE);
	}
	// stop the flight sound
	StopInFlightAudio();

	BeginExplosionSequence(GrenadeMartyrArmingDelay, GrenadeMartyrExplosionDelay);

	// Setup Pawn animation
	PlayMartyrAnimation(GearPawn(NewMartyrVictim));
}

/** starts the timer towards explosion */
simulated function BeginExplosionSequence(float ArmingDelay, float ExplosionDelayAfterArming)
{
	local float TotalExploDelay;

	if (bIsSimulating)
	{
		// do nothing here
		return;
	}

	//`log(GetFuncName()@ArmingDelay@ExplosionDelayAfterArming@self);

	TotalExploDelay = ArmingDelay + ExplosionDelayAfterArming;
	if (TotalExploDelay > 0.f)
	{
		if (Role == ROLE_Authority)
		{
			// set explosion timer
			SetTimer(TotalExploDelay, FALSE, nameof(DoExplosion));
			SetTimer(TotalExploDelay - FRand(), FALSE, nameof(WarnProjExplode));		// 0-1 sec warning
		}

		if (ArmingDelay > 0.f)
		{
			// set arming timer
			SetTimer(ArmingDelay, FALSE, nameof(ArmGrenade));
		}
		else
		{
			// immediate
			ArmGrenade();
		}
	}
	else
	{
		// no delays, just explode
		DoExplosion();
	}
}

simulated function PlayMartyrAnimation(GearPawn MartyrPawn)
{
	/*
	local BodyStance	BS_MartyrAnim;

	// Prevent Pawn from moving
	MartyrPawn.SetPhysics(PHYS_None);

	// Have Martyr Play his animation
	BS_MartyrAnim.AnimName[BS_FullBody] = 'DBNO_Grenade_Kneel';
	MartyrPawn.BS_Play(BS_MartyrAnim, 1.f, 0.25f, -1.f);
	*/

	MartyrPawn.SoundGroup.PlayEffort(MartyrPawn, GearEffort_ChainsawDuel, true, true);
}

simulated protected function PrepareExplosionTemplate()
{
	Super.PrepareExplosionTemplate();

	// determine which damagetype to use
	if (MartyrVictim != None)
	{
		// Use martyr damagetype
		ExplosionTemplate.MyDamageType = MartyrDamageType;
	}
	else if (Pawn(TagVictim) != None && PawnTaggedDamageType != None)
	{		
		// Tagged victim
		ExplosionTemplate.MyDamageType = PawnTaggedDamageType;
	}
	else if (TagVictim != None && TaggedDamageType != None)
	{
		// Tagged obstacle
		ExplosionTemplate.MyDamageType = TaggedDamageType;
	}
}

simulated protected function PrepareExplosionActor(GearExplosionActor GEA)
{
	Super.PrepareExplosionActor(GEA);

	// add the attachee so that FX are properly attached to them
	GEA.Attachee = TagVictim;
	GEA.AttacheeController = None;

	// determine which damagetype to use
	if (MartyrVictim == None)
	{
		if ( Pawn(TagVictim) != None &&	( GearPawn(TagVictim) == None || GearPawn(TagVictim).TimeOfDeath == WorldInfo.TimeSeconds ||
							(!TagVictim.bTearOff && !GearPawn(TagVictim).IsDBNO()) ) )
		{
			GEA.AttacheeController = AttacheeController;
		}
		else if (TagVictim != None && TaggedDamageType != None)
		{
			GEA.AttacheeController = Instigator != None ? Instigator.Controller : None;
		}
	}
}

/**
 * Keeps track of this player's planted grenades to prevent more than 2 active at any time.
 */
function RegisterPlantedGrenade()
{
	local GearPRI InstigatorPRI;
	local int Idx;
	local GearProj_Grenade OtherGrenade;
	InstigatorPRI = GearPRI(Instigator.PlayerReplicationInfo);
	if (InstigatorPRI != None)
	{
		// clear out any null/deleted entries in the list
		for (Idx = 0; Idx < InstigatorPRI.PlantedGrenades.Length; Idx++)
		{
			OtherGrenade = InstigatorPRI.PlantedGrenades[Idx];
			if (OtherGrenade == None || OtherGrenade.bDeleteMe)
			{
				InstigatorPRI.PlantedGrenades.Remove(Idx--,1);
			}
		}
		// if more than one in the list
		if (InstigatorPRI.PlantedGrenades.Length > 1)
		{
			// blow up the first one and remove
			InstigatorPRI.PlantedGrenades[0].DoExplosion();
			InstigatorPRI.PlantedGrenades.Remove(0,1);
		}
		// add this one to the list
		InstigatorPRI.PlantedGrenades.AddItem(self);
	}
}

simulated function name AttachInit(Actor Attachee)
{
	local SkeletalMeshComponent VictimMesh, NadeMesh;
	local array<Name> RootBoneName;
	local vector HitLoc, HitNorm, ToPawn;
	local TraceHitInfo HitInfo;
	local Name BoneName;
	local Pawn AttacheePawn;
	local GearAnim_Slot FullSlot;
	local rotator UpwardRot;

	if(Role == ROLE_Authority)
	{
		// Handle case of attaching to SMCA - just use WorldInfo instead.
		if( StaticMeshCollectionActor(Attachee) != None)
		{
			Attachee = WorldInfo;
		}
	}

	TagVictim = Attachee;

	SetPhysics(PHYS_None);
	SetCollision(TRUE,FALSE);
	bIsSimulating = FALSE;
	bBounce = FALSE;

	// After initial spawn, we will let the client handle attachment and movement.
	bReplicateMovement = FALSE;

	// Attach to pawn case
	AttacheePawn = Pawn(Attachee);
	if (AttacheePawn != None)
	{
		AttacheeController = AttacheePawn.Controller;

		if(Role == ROLE_Authority)
		{
			if (GearGRI(WorldInfo.GRI).IsMultiPlayerGame() && 
				GearPC(Instigator.Controller) != None && GearPawn(AttacheePawn) != None && GearPawn(AttacheePawn).IsDoingSpecialMove(SM_RoadieRunStab))
			{
				// @AWARD - Ole
				GearPC(Instigator.Controller).NotifyEarnedAward('Ole');
			}

			//@STATS - Record grenade tag (Instigator)
			`RecordProjectileIntStat(WEAPON_GRENADE_TAG,Instigator.Controller,Class,1);
			//@STATS - Record grenade tagged (Attachee)
			`RecordProjectileIntStat(WEAPON_GRENADE_TAGGED,AttacheePawn.Controller,Class,1);
		}

		PlaySound(GrenadeAttachingToFoeSound, true);
		VictimMesh = AttacheePawn.Mesh;

		// Do a trace and see if hit a bone we can attach to
		if(TraceComponent(HitLoc, HitNorm, VictimMesh, Attachee.Location + vect(0,0,45), Location,, HitInfo))
		{
			// Got a bone - set location on the bone surface and using hit normal
			SetRotation(rotator(HitNorm) + rot(16384,0,0));
			SetLocation(HitLoc + (0.5 * GrenadeAttachNormalOffset*HitNorm)); // Put nade a bit closer on pawns
			// Note the bone name to return it
			BoneName = HitInfo.BoneName;

			SetBase(Attachee,, VictimMesh, BoneName);
		}
		// No bone hit - we just attach to the pawn
		else
		{
			// Get direction nade -> Pawn
			ToPawn = Normal((Attachee.Location + vect(0,0,30)) - Location);
			// Put it kind of in the pawn
			SetLocation(Attachee.Location - (20.0 * ToPawn));
			// And pointing the way we threw it
			SetRotation(rotator(ToPawn) + rot(16384,0,0));
			// Attach to actor
			SetBase(Attachee);
		}
	}
	// Attach to non-Pawn
	else
	{
		if(Role == ROLE_Authority)
		{
			//@STATS - Record mine planted (Instigator)
			`RecordProjectileIntStat(WEAPON_GRENADE_MINE_PLANTED,Instigator.Controller,Class,1);
		}

		PlaySound(GrenadeAttachingToWorldSound, true);

		//@hack: GDOs are bWorldGeometry and so don't maintain Attached list, but we need a link
		//	to blow up the grenade if the GDO is destroyed
		if (GearDestructibleObject(Attachee) != None)
		{
			GearDestructibleObject(Attachee).AttachedGrenades.AddItem(self);
		}

		if (Role == ROLE_Authority)
		{
			SetupAvoidanceCylinder();
			RegisterPlantedGrenade();
			// handle case where we are attached to a GDO as the 3rd grenade from this player;
			// old grenade then detonates and wipes out this GDO
			if (bHasExploded)
			{
				return '';
			}
			GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_GrenadeTrapSet, Instigator);
		}

		SetBase(Attachee);

		// turn on the cylinder so there's more to shoot at
		SetCollisionSize(PlantedCylinderSize.Radius, PlantedCylinderSize.Height);
		CollisionComponent.SetActorCollision(true, false);
	}

	// dangle some shiznit
	NadeMesh = SkeletalMeshComponent(Mesh);
	if (NadeMesh != None)
	{
		FullSlot = GetFullSlotNode();
		FullSlot.PlayCustomAnim('Bolo_Extend_Idle', 1.0, 0.2, -1.0, TRUE, TRUE);

		RootBoneName.AddItem('b_bolo_end');
		NadeMesh.SetHasPhysicsAssetInstance(true);
		NadeMesh.PhysicsAssetInstance.SetNamedBodiesFixed(TRUE,RootBoneName,NadeMesh,TRUE);

		// If attached to a Pawn, disable collision, so it doesn't freak out when he does physics hit reactions.
		if( AttacheePawn != None )
		{
			NadeMesh.SetBlockRigidBody(FALSE); // Disable collision (may be inside collision volume etc)
		}

		// Wake up physics
		NadeMesh.WakeRigidBody();
		NadeMesh.PhysicsWeight = 1.f;
	}


	// if attached to a player then explode quickly
	if (Pawn(Attachee) != None || Trigger_ChainsawInteraction(Attachee) != None || Attachee.Tag == 'DeckTentacle' )
	{
		BeginExplosionSequence(GrenadeTagArmingDelay, GrenadeTagExplosionDelay);
	}
	else
	{
		if (GrenadeTrapMaxLifespan > 0.f)
		{
			BeginExplosionSequence(GrenadeTrapMaxLifespan, 0.f);
		}

		if (Role == ROLE_Authority)
		{
			// if we didn't hit a player then set the timer to auto-check
			SetTimer( 1.5f, FALSE, nameof(CheckAutoExplosion) );
			bInstigatorCannotTriggerTrap = TRUE;
			SetTimer( InstigatorTrapSafetyDelay, FALSE, nameof(RemoveInstigatorTrapSafety) );
			LifeSpan = 0.f;		// live indefinitely until exploded

			bProjTarget = TRUE;
		}
	}

	StopInFlightAudio();

	if (TrailEmitter != None)
	{
		TrailEmitter.Destroy();
		TrailEmitter = None;
	}

	// Create the cloned mesh for view in taccom
	CreateTaccomMesh();

	if (!bDeleteMe) // sanity since this is cleaned up via Destroyed()
	{
		if ((AttacheePawn != None) ? (GrenadeTagPreExplosionSmokeEffect != None) : (GrenadeTagPreExplosionSmokeEffectPlanted != None))
		{
			GrenadeTagPreExplosionSmokeEmitter = Spawn(class'SpawnedGearEmitter',,, Mesh.GetPosition());
			if (GrenadeTagPreExplosionSmokeEmitter != None)
			{
				GrenadeTagPreExplosionSmokeEmitter.LifeSpan = 0.0;

				// We want the emitter to always have smoke rising up
				UpwardRot.Yaw = 16384;
				GrenadeTagPreExplosionSmokeEmitter.ParticleSystemComponent.SetAbsolute(FALSE, TRUE);
				GrenadeTagPreExplosionSmokeEmitter.ParticleSystemComponent.SetRotation(UpwardRot);

				if (AttacheePawn != None)
				{
					// attach a special particle system to the mesh
					GrenadeTagPreExplosionSmokeEmitter.SetTemplate(GrenadeTagPreExplosionSmokeEffect, true);
					GrenadeTagPreExplosionSmokeEmitter.SetBase(AttacheePawn,, AttacheePawn.Mesh, BoneName);
				}
				else if (GrenadeTagPreExplosionSmokeEffectPlanted != None)
				{
					GrenadeTagPreExplosionSmokeEmitter.SetTemplate(GrenadeTagPreExplosionSmokeEffectPlanted, true);
					GrenadeTagPreExplosionSmokeEmitter.SetBase(self,, SkeletalMeshComponent(Mesh), GrenadeTagPlantedSmokeEffectSocketName);
				}
			}
		}
	}

	return BoneName;
}

/**
 * Clones the grenade mesh, changes the materials for it, and registers it with the GRI
 */
simulated function CreateTaccomMesh()
{
	local int MaterialIndex;
	local SkeletalMeshComponent MeshComp;
	local GearGRI GRI;

	GRI = GearGRI(WorldInfo.GRI);
	if (class<GearGame>(GRI.GameClass).default.bShouldDisplayTaggedGrenadesViaTaccom)
	{
		// Attach the taccom component and place the tagged grenade in the GRI so we can show it in taccom
		GRI.AddTaggedGrenade(Self);

		// Clone the pickup mesh and set the material and DPG
		TaccomMesh = new(Self) Mesh.Class(Mesh);
		TaccomMesh.CastShadow = false;
		MeshComp = SkeletalMeshComponent(TaccomMesh);
		if (MeshComp != None)
		{
			// reinit template
			MeshComp.SetAnimTreeTemplate(SkeletalMeshComponent(Mesh).AnimTreeTemplate);
			for (MaterialIndex = 0; MaterialIndex < MeshComp.GetNumElements(); MaterialIndex++)
			{
				MeshComp.SetMaterial(MaterialIndex,TaccomViewMaterial);
			}
			MeshComp.SetParentAnimComponent(SkeletalMeshComponent(Mesh));
			AttachComponent(TaccomMesh);
		}
	}
}

protected function RemoveInstigatorTrapSafety()
{
	// makes instigator eligible to trigger his own grenade trap (if friendly fire is on)
	bInstigatorCannotTriggerTrap = FALSE;
}

protected function CheckAutoExplosion()
{
	local GearPawn P;
	local Actor HitActor;
	local vector HitL, HitN;
	local bool bInstigatorInRadius;

	//FlushPersistentDebugLines();

	if (!bDeleteMe && !bGrenadeHasExploded)
	{
		//DrawDebugSphere(Location, 10, 10, 255, 0, 0,TRUE);
		//DrawDebugSphere(Location + (HeadFacingNormal * 20), 10, 10, 255, 0, 255,TRUE);
		// and see if we should auto-explode
		foreach WorldInfo.AllPawns(class'GearPawn', P, Location, GrenadeTrapTriggerRadius + WarningBeepRadius)
		{
			if (!P.bCanTriggerGrenadeTrap)
			{
				continue;
			}

			if (P == Instigator)
			{
				bInstigatorInRadius = TRUE;
				if (bInstigatorCannotTriggerTrap)
				{
					continue;
				}
			}

			if (!WorldInfo.GRI.OnSameTeam(P,self))
			{
				if ((P.Health > 0 || P.IsDBNO()) && !P.IsAHostage())
				{
					// make sure we can sort of see them
					HitActor = Trace(HitL, HitN, P.GetPawnViewLocation(), Location - (GetHeadFacingDir() * 10), TRUE, vect(8,8,32));
					//DrawDebugLine(P.GetPawnViewLocation(), Location - (GetHeadFacingDir() * 10), 255, 0, 0, TRUE);
					if (HitActor == None || HitActor == P || !HitActor.bBlockActors)
					{
						if (VSize(P.Location - Location) <= GrenadeTrapTriggerRadius)
						{
							//@STATS - Record mine trip (Instigator -> P (tripper))
							`RecordProjectileIntStat(WEAPON_GRENADE_MINE_TRIPPED,Instigator.Controller,Class,1);
							`RecordProjectileIntStat(WEAPON_GRENADE_MINE_TRIPPEDBYME,P.Controller,Class,1);

							TriggerAttachedToWallExplosionSequence(P);
							return;
						}
						else if (WorldInfo.TimeSeconds - LastWarningBeepTime > WarningBeepInterval)
						{
							PlayBeepSound();
							LastWarningBeepTime = WorldInfo.TimeSeconds;
						}
					}
					//`log("blocked by:"@`showvar(HitActor));
				}
			}
		}

		if (!bInstigatorInRadius)
		{
			RemoveInstigatorTrapSafety();
		}

		SetTimer( 0.25f, FALSE, nameof(CheckAutoExplosion) );
	}
}

/** called to trigger the explosion of a proximity grenade
 * @param TriggerInstigator - the Pawn that triggered the grenade (only valid on server; None on client)
 */
simulated protected function TriggerAttachedToWallExplosionSequence(GearPawn TriggerInstigator)
{
	if (Role == ROLE_Authority)
	{
		// signals clients to start this as well
		bGrenadeTrapAutoExplosionTriggered = TRUE;
	}

	ClearTimer('CheckAutoExplosion');

	BeginExplosionSequence(0.f, GrenadeTrapExplosionDelay);
}

/************************************************************************************
 * Collision
 ***********************************************************************************/

simulated singular event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	// ignore touches while spawning
	// ignore foliage and walk volumes
	if (bBegunPlay && InteractiveFoliageActor(Other) == None && WalkVolume(Other) == None)
	{
		// Ignore touches on fluid surface or physics volumes
		if(FluidSurfaceActor(Other) != None || PhysicsVolume(Other) != None)
		{
			// If simulating the arc - just change physics mode (will stop drawing arc at this point)
			if(bIsSimulating)
			{
				SetPhysics(PHYS_None);
			}
			return;
		}

		if (bStoppedByGrenadeBlockingVolume || GrenadeBlockingVolume(Other) == None)
		{
			HandleCollision(Other, OtherComp, HitLocation, HitNormal);
		}
	}
}

simulated event Bump( Actor Other, PrimitiveComponent OtherComp, Vector HitNormal )
{
	HandleCollision( Other, OtherComp, Location, HitNormal );
}

simulated function HitWall( vector HitNormal, Actor Wall, PrimitiveComponent WallComp )
{
	HandleCollision( Wall, WallComp, Location, HitNormal );
}

/** Handle collision */
simulated function HandleCollision( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	// if we hit the same exact spot twice, we're stuck, so just blow up
	if (Physics != PHYS_None && LastHitLocation == HitLocation && LastHitTime != WorldInfo.TimeSeconds)
	{
		DoExplosion();
	}
	else
	{
		LastHitNormal = HitNormal;
		LastHitActor = Other;
		LastHitLocation = HitLocation;
		LastHitTime = WorldInfo.TimeSeconds;

		if (Other != None && ShouldBounce(Other, HitNormal) && Physics == PHYS_Projectile)
		{
			// a bit of a hack, massage data for pawns
			if ( (Pawn(Other) != None) && (SkeletalMeshComponent(OtherComp) != None) )
			{
				HitNormal = HitLocation - Other.Location;
				HitNormal.Z = 0.f;
				HitNormal = Normal(HitNormal);
			}

			Bounce(HitLocation, HitNormal, Other);
		}
	}
}

simulated protected function StopSimulating()
{
	Velocity = vect(0,0,0);
	Acceleration = vect(0,0,0);
	RotationRate = rot(0,0,0);
	SetPhysics(PHYS_None);
	// don't turn off collision

	StopInFlightAudio();
	StopTrailEmitter();

	bRotationFollowsVelocity = false;
}

/** Called when grenade stops bouncing and comes to rest. */
simulated function StopBounce(vector HitNormal)
{
	local AIController C;

	bBounce = FALSE;
	StopSimulating();

	if ( (Role == ROLE_Authority) && !bIsSimulating )
	{
		// notify AI of the bounce
		foreach WorldInfo.AllControllers(class'AIController', C)
		{
			C.NotifyProjLanded( self );
		}

		BeginExplosionSequence(GrenadeArmingDelay, GrenadeExplosionDelay);
	}
}

/** Internal.  "Arms" grenade.  */
simulated protected final function ArmGrenade()
{
	//`log("arming grenade"@1.f/ArmedWarningBeepFrequency);
	if (!bIsSimulating && !bArmed)
	{
		// start the beeping loop
		PlayBeepSound();
		SetTimer(1.f/ArmedWarningBeepFrequency, TRUE, nameof(PlayBeepSound));
		bArmed = TRUE;
	}
}

/** This will play the beep beep sound **/
simulated function PlayBeepSound()
{
	PlaySound( BeepBeepAboutToExplodeSound, FALSE );
}

/**
 * We do an explosion here and then tell the projectile to hide itself and prepare to be destroyed.
 * We can't destroy now as the trail emitter is still probably active.
 **/
simulated event DoExplosion()
{
	local GearPawn	Kidnapper, TaggedVictim, MartyrPawn;
	local Actor		HitActor;

	if (bGrenadeHasExploded || bIsSimulating)
	{
		return;
	}

	// Remove the tagged grenade from the GRI so it no longer shows up in taccom
	GearGRI(WorldInfo.GRI).RemoveTaggedGrenade(Self);

	ClearTimer('PlayBeepSound');
	ClearTimer('CheckAutoExplosion');

	// If we've been attached to a Pawn, guarantee his death by ignoring modifiers (like immunity behind cover)
	if( TagVictim != None)
	{
		HitActor = TagVictim;
		TaggedVictim = GearPawn(TagVictim);
		if( TaggedVictim != None )
		{
			TaggedVictim.SetDontModifyDamage( TRUE );
		}
	}

	if( MartyrVictim != None )
	{
		MartyrPawn = GearPawn(MartyrVictim);
		if( MartyrPawn != None )
		{
			MartyrPawn.SetDontModifyDamage(TRUE);
		}

		// If hostage has been grenade tagged, then set it on the kidnapper, so he gets killed too.
		if( MartyrPawn.IsAHostage() )
		{
			Kidnapper = MartyrPawn.InteractionPawn;
			Kidnapper.SetDontModifyDamage(TRUE);
			HitActor = Kidnapper;
		}
		else
		{
			HitActor = MartyrPawn;
		}
	}

	if (HitActor == None)
	{
		// if LastHitActor is close to the explosion, assume we detonated "on" that object
		if ( (LastHitActor != None) && (VSize(LastHitLocation - Location) < 32.f) )
		{
			HitActor = LastHitActor;
		}
	}

	// if we are on "something" pawn or wall
	if( TagVictim != None  )
	{
		TriggerExplosion(Location + GetHeadFacingDir() * GrenadeAttachNormalOffset, -GetHeadFacingDir(), HitActor);
	}
	// on the ground
	else
	{
		TriggerExplosion(Location, LastHitNormal, HitActor);
	}


	// Clear flag
	if( TaggedVictim != None )
	{
		TaggedVictim.SetDontModifyDamage( FALSE );
		SetBase(None);
		TaggedVictim.Mesh.DetachComponent(Mesh);
	}
	if( MartyrPawn != None )
	{
		MartyrPawn.SetDontModifyDamage(FALSE);
	}
	if( Kidnapper != None )
	{
		Kidnapper.SetDontModifyDamage(FALSE);
	}

	if(AvoidanceCylinder!=none)
	{
		AvoidanceCylinder.Destroy();
		AvoidanceCylinder=none;
	}
	SetHidden(TRUE);
}

function float GetAvoidanceRadius()
{
	return Max(ExploDamageRadius,KnockDownRadius);
}

function SetupAvoidanceCylinder()
{
	local float AvoidRadius;

	if( !bIsSimulating && !bGrenadeHasExploded && !bDeleteMe && AvoidanceCylinder == None )
	{
		AvoidRadius = GetAvoidanceRadius();
		AvoidanceCylinder = Spawn(class'AIAvoidanceCylinder',self,,Location,,,TRUE);
		if(AvoidanceCylinder!=none)
		{
			AvoidanceCylinder.SetBase(self);
			AvoidanceCylinder.SetCylinderSize(AvoidRadius,AvoidRadius*2.0f);
			AvoidanceCylinder.SetEnabled(true);
		}
		//DrawDebugSphere(Location,AvoidRadius,16,255,0,0,TRUE);
	}

}

function CoupleLifetime(Interface_NavMeshPathObstacle PO);
//////////////////////////////////////////////////////////////////////////
// AIobjectAvoidanceInterface
event AIAvoidanceCylinderComponent GetAIAvoidanceCylinderComponent()
{
	if(AvoidanceCylinder==none)
	{
		return none;
	}
	return AvoidanceCylinder.GetAIAvoidanceCylinderComponent();
}
function bool ShouldAvoid(GearAI AskingAI, AIAvoidanceCylinderComponent TriggeringComponent)
{
	//`log(GetFuncName()@AskingAI@TriggeringComponent@AskingAI.GetTeamNum()@Instigator.GetTeamNum());
	// don't avoid grenades from our team, and see if we have LOS to the AI in question, if not don't bother avoiding
	// also don't "see" planted grenades if low skill
	if ( AskingAI.GetTeamNum() != TeamNum &&
		(TagVictim == None || AskingAI.GetDifficultyLevel() > DL_Normal) &&
		FastTrace(Location, AskingAI.Pawn.Location,, true) )
	{
		return true;
	}

	return false;
}

function bool ShouldEvade(GearAI AskingAI, AIAvoidanceCylinderComponent TriggeringComponent);
function bool ShouldRoadieRun(GearAI AskingAI, AIAvoidanceCylinderComponent TriggeringComponent);
// END AIobjectAvoidanceInterface
//////////////////////////////////////////////////////////////////////////


/**
 * Reflect grenade off a wall
 *
 * @param	HitLocation
 * @param	HitNormal
 */
simulated function Bounce(Vector HitLocation, Vector HitNormal, Actor Other)
{
	local AIController C;

	// start replicating position after bounce to make sure client result matches up in case impact is slightly off
	bUpdateSimulatedPosition = true;

	// If we hit a mover coming towards us, on a fairly flat bit - stick to it
	//`log("HIT"@InterpActor(Other)@(Normal(Other.Velocity) Dot HitNormal)@(HitNormal.Z >= MINFLOORZ));
	if( InterpActor(Other) != None &&
		(Normal(Other.Velocity) Dot HitNormal) > 0.4 &&
		(HitNormal.Z >= MINFLOORZ) )
	{
		if( !bEnabledGrenadePhysics )
		{
			EnableGrenadePhysics();
			bEnabledGrenadePhysics = TRUE;
		}

		StopBounce(HitNormal);
		if( !bIsSimulating )
		{
			SetBase(Other);
		}
		return;
	}


	if((Normal(Velocity) Dot HitNormal) > 0.4)
	{
		return;
	}

	// on second bounce kick on avoidance cyl
	if(ROLE== ROLE_Authority && BounceCount == 1 && !bIsSimulating)
	{
		SetupAvoidanceCylinder();
	}
	if( !bBounce || BounceCount >= MaxBounceCount )
	{
		StopBounce(HitNormal);
		return;
	}
	if ( (BounceCount >= MaxBounceCountToArm) && !bIsSimulating )
	{
		BeginExplosionSequence(GrenadeArmingDelay, GrenadeExplosionDelay);
	}

	BounceCount++;
	if (BounceCount > 1)
	{
		StopInFlightAudio();
	}

	// bounce off wall with damping
	Velocity -= (1.f + Bounciness) * HitNormal * (Velocity Dot HitNormal);
	Velocity *= VelocityDampingFactor;

	// should we stop simulating?
	if( VSize(Velocity) < StopSimulatingVelocityThreshhold )
	{
		StopBounce(HitNormal);
	}
	else
	{
		if( !bIsSimulating )
		{
			// this will do a little jitter at the end.  We can add another velocity check to stop it
			PlaySound(GrenadeBounceSound);
		}
	}

	if( !bEnabledGrenadePhysics )
	{
		EnableGrenadePhysics();
		bEnabledGrenadePhysics = TRUE;
	}

	if (BounceCount == 1)
	{
		FirstBounceLoc = HitLocation;
	}

	if ( (Role == ROLE_Authority) && !bIsSimulating )
	{
		// notify AI of the bounce
		foreach WorldInfo.AllControllers(class'AIController', C)
		{
			C.NotifyProjLanded( self );
		}
	}
}

function WarnProjExplode()
{
	local AIController C;

	foreach WorldInfo.AllControllers( class'AIController', C )
	{
		C.WarnProjExplode( self );
	}
}

simulated function int GetBounceCount()
{
	return BounceCount;
}

simulated function Pawn GetMartyrVictim()
{
	return MartyrVictim;
}

/**
 * Test condition to validate a rebound
 *
 * @param	Touched, actor the grenade touched
 * @param	HitNormal, normal of the surface impacted
 * @return	true if the grenade should bounce off
 */
simulated function bool ShouldBounce(Actor Touched, vector HitNormal, optional PrimitiveComponent HitComponent)
{
	if( (Touched == None) || (Base != None) )
	{
		return FALSE;
	}

	// cannot collide with instigator until it has bounced once
	// also don't allow projectiles to collide while spawning on clients
	// because if that were accurate, the projectile would've been destroyed immediately on the server
	// and therefore it wouldn't have been replicated to the client
	if ((Touched == Instigator || (Role < ROLE_Authority && !bBegunPlay)) && BounceCount == 0)
	{
		return FALSE;
	}

	if( Touched.bWorldGeometry || Touched.bBlockActors )
	{
		return TRUE;
	}

	return FALSE;
}

simulated function GearExplosionActor TriggerExplosion(vector HitLocation, vector HitNormal, Actor HitActor)
{
	local bool bInstigatorDead;
	local GearExplosionActor GEA;

	// do not do any visual work when simulating
	if( !bIsSimulating && !bGrenadeHasExploded )
	{
		bInstigatorDead = Instigator.bTearOff;
		GEA = super.TriggerExplosion(HitLocation, HitNormal, HitActor);

		// If we attached to someone, and now our instigator is dead, it must have been from this grenade
		if (Role == ROLE_Authority && WorldInfo.GRI.IsMultiPlayerGame() && GearPC(AttacheeController) != None && !bInstigatorDead && Instigator.bTearOff)
		{
			// @AWARD - Grenade tag counter-kill
			GearPC(AttacheeController).NotifyEarnedAward('GrenadeAttach');
		}

		bGrenadeHasExploded = true;
		// this hides the mesh of the grenade (other wise is sticks around after the explosion)
		Mesh.SetHidden( TRUE );
	}

	return GEA;
}

/** Returns AnimNodeSlot to play custom animations */
simulated function GearAnim_Slot GetFullSlotNode()
{
	return GearAnim_Slot(SkeletalMeshComponent(Mesh).FindAnimNode('CustomAnim'));
}

/** @return the effective radius of this projectile's explosion for the AI */
static function float GetAIEffectiveRadius()
{
	return default.ExploDamageRadius;
}

/** Overridden to allow explosions to blow up other grenades. */
function TakeDamage(int Dmg, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	local bool bOldInstigatorDiedFromGrenade;
	local Pawn OldInstigator;
	// Simulated grenades should not take damage
	if (bIsSimulating)
	{
		return;
	}

	//`log("***   "@self@"took damage"@Dmg@EventInstigator@DamageType);
	if (Base != None && Pawn(Base) == None && (EventInstigator == None || EventInstigator.Pawn == None || EventInstigator.Pawn == Instigator || !EventInstigator.Pawn.IsSameTeam(Instigator)))
	{
		if (ClassIsChildOf(DamageType, class'GDT_Explosive'))
		{
			// slight delay, then blow up
			SetTimer( 0.3f, FALSE, nameof(DoExplosion) );
		}
		else
		{
			TakenDamage += Dmg;
			if (TakenDamage >= DamageToDetonate)
			{
				// Someone else blew up the grenade, they should get credit for any kills. Mostly for shooting planted grenades.
				if (EventInstigator.Pawn != none)
				{
					if (WorldInfo.GRI.IsMultiPlayerGame())
					{
						if (!WorldInfo.GRI.OnSameTeam(Instigator, EventInstigator.Pawn) && GearPC(EventInstigator) != None)
						{
							// No credit for team grenades
							GearPC(EventInstigator).ClientModifyStat('GrenadesDestroyedMP');
						}

						OldInstigator = Instigator;
					}

					Instigator = EventInstigator.Pawn;
				}


				// Is the original instigator already dead?
				bOldInstigatorDiedFromGrenade = OldInstigator != None ? OldInstigator.bTearOff : false;

				DoExplosion();

				// Now is the original instigator dead?
				bOldInstigatorDiedFromGrenade = !bOldInstigatorDiedFromGrenade && (OldInstigator != None ? OldInstigator.bTearOff : false);

				if (WorldInfo.GRI.IsMultiPlayerGame() && bOldInstigatorDiedFromGrenade)
				{
					if (!WorldInfo.GRI.OnSameTeam(Instigator, OldInstigator) && GearPC(EventInstigator) != None)
					{
						// @AWARD - Sapper
						GearPC(EventInstigator).NotifyEarnedAward('Sapper');
					}
				}
			}
		}
	}

	super.TakeDamage(Dmg, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
}

/** Tells grenade to get ready to be simulating, or not. */
simulated function SetupForSimulation(bool bSimulating)
{
	if (bSimulating)
	{
		SetHidden( FALSE );
		SetCollision( TRUE, FALSE, FALSE );
//		Enable( 'Tick' );
//		SuppressAudio(FALSE);
	}
	else
	{
		SetHidden( TRUE );
		SetCollision( FALSE, FALSE, FALSE );
//		Disable( 'Tick' );
//		SuppressAudio(TRUE);
	}
}

/** This grenade will be used for simulation, get it ready. */
simulated function InitForSimulation()
{
	bIsSimulating = TRUE;
	bIgnoreFoliageTouch = TRUE;

	RemoteRole = ROLE_None;

	// no audio
	SuppressAudio(TRUE);

	// get rid of unnecessary components, so we don't tick them
	// during simulation

	// hide the mesh
	Mesh.SetHidden(TRUE);
	DetachComponent(Mesh);
	Mesh = None;
}

simulated function bool CanSplash()
{
	return !bIsSimulating;
}

/** Return direction that the grenade head is facing.  e.g. towards the wall when tagged, etc. */
simulated function vector GetHeadFacingDir()
{
//	local rotator BoneRot;
//	local vector X, Y, Z;
	local matrix M;
	local SkeletalMeshComponent SMC;

	SMC = SkeletalMeshComponent(Mesh);

	M = SMC.GetBoneMatrix(SMC.MatchRefBone('b_bolo_end'));
	return MatrixGetAxis(M, AXIS_Z);

//	BoneRot = QuatToRotator();
//	GetAxes(BoneRot, X, Y, Z);
//	return Z;
}


defaultproperties
{
	Begin Object Name=CollisionCylinder
		BlockNonZeroExtent=false
	End Object

//	FireDamageReductionRate=50
//	FireDamageToDetonate=300

	SimFixedTimeStep=0.05f		// 20 hz
	MaxSimulationTime=3.5f

	bKillDuringLevelTransition=TRUE

	VelocityDampingFactor=0.6f
	Bounciness=0.5f
	StopSimulatingVelocityThreshhold=40

	bPerformGravity=TRUE
	GravityScale=2.0f
	MaxBounceCountToArm=3

	bCollideComplex=TRUE	// Ignore simple collision on StaticMeshes, and collide per poly
	bStoppedByGrenadeBlockingVolume=TRUE

	bBounce=TRUE
	Physics=PHYS_Projectile
	Speed=1500
	MaxSpeed=0
	Damage=50
	MomentumTransfer=100
	MyDamageType=class'DamageType'

	bNetInitialRotation=TRUE
	RemoteRole=ROLE_SimulatedProxy
	Lifespan=10

	//RotationRate=(Pitch=-64000,Yaw=0,Roll=0)

	bNetTemporary=FALSE
	bAlwaysRelevant=TRUE

	bCollideActors=true

	GrenadeAttachNormalOffset=30.0
	TeamNum=255

	MartyrDamageType=class'GDT_FragMartyr'	// Self inflicted explosion
	TaggedDamageType=class'GDT_FragSticky'	// Stuck to wall explosion
	PawnTaggedDamageType=class'GDT_FragTag'	// Tagged to pawn explosion

	InstigatorTrapSafetyDelay=2.5f
	LastHitNormal=(Z=1.f)

	PlantedCylinderSize=(Radius=10.0,Height=12.0)

	TaccomViewMaterial=Material'ALL_WeaponShaders.GrenadeTaccomView'
	GrenadeTagPlantedSmokeEffectSocketName="walltag"
}

