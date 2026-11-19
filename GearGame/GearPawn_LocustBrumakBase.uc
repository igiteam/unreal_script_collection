/**
 * GearPawnRidable_BrumakBase
 *
 * The base class for the ridable Brumak pawn
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearPawn_LocustBrumakBase extends GearPawnRidable_Base
	implements(Interface_AIAimLocationOverride)
	native(Pawn)
	config(Pawn)
	abstract;


/** Constants which will map a component on the mesh to a byte value for client-side-hit-detection (0 is reserved for no component) */
const COMPONENT_HIT_LeftArmGun = 1;
const COMPONENT_HIT_RightArmGun = 2;
const COMPONENT_HIT_BackPack = 3;

/************************************************************************/
/* Member variables                                                     */
/************************************************************************/

/** Actor main gun is currently aiming at */
var Actor				MainGunTarget;
/** Location main gun is aiming */
var Vector				MainGunAimLocation;
/** Controllers used to aim main gun toward target */
var SkelControlLookAt	MainGunAimController1;
var SkelControlLookAt	MainGunAimController2;
/** The spawned POI for the driver */
var GearPointOfInterest	DriverPOI;
/** Whether the driver POI has enable yet or not - so that it isn't enable again */
var bool				bDriverPOIEnabled;
/** The spawned POI for the legs */
var GearPointOfInterest	LegPOI;
/** Whether the leg POI has enable yet or not - so that it isn't enable again */
var bool				bLegPOIEnabled;
/** Flinching b/c of kismet control */
var	bool				bFlinching;

/** Main Gun Health */
var config float		MainGunHealth;

/** Brumak is capable of firing rockets */
var bool				bCanFireRockets;

var repnotify	byte	RoarCount;

/////// SIDE GUN VARIABLES ///////
var class<Pawn>					SideGunClass;
var Pawn						RightGunPawn;
var Pawn						LeftGunPawn;
var GearPawn					HumanGunner;
/** How much damage the side guns can continue to take */
var config	int					LeftGunHealth;
var config	int					RightGunHealth;
/** Name of sockets for weapon muzzle flash */
var			Name				LeftMuzzleSocketName;
var			Name				RightMuzzleSocketName;
/** Controllers used to aim side guns toward targets */
var SkelControlLookAt			LeftGunAimController;
var SkelControlLookAt			RightGunAimController;
/** Actors guns are currently aiming at */
var Actor						LeftGunTarget;
var Actor						RightGunTarget;
/** Locations that side guns are aiming */
var Vector						LeftGunAimLocation;
var Vector						RightGunAimLocation;
var Vector						AimOffsetViewLoc;
/** Number of times left before to be "hurt" before guns are destroyed */
var config repnotify Byte		LeftGunLives;
var config repnotify Byte		RightGunLives;
var config repnotify Byte       MainGunLives;
/** Amount of damage to deal to Brumak when a side gun is destroyed */
var config int					SideGunDestroyedHitPointPenalty;
/** Amount of damage to deal to Brumak when the main gun cannon explodes. */
var config int					BackpackDestroyedHitPointPenalty;
/** Name of state for player controller to be in while gunning */
var Name						GunnerState;
/** AimPct */
var Vector2D					LeftGunAimPct;
var	Vector2D					RightGunAimPct;

var Array<GearSkelCtrl_IKRecoil>	IKRecoilCtrl;
/** Blend nodes to enable/disable arm aim offset nodes */
var AnimNodeBlend				LeftArmAimOffsetBlend, RightArmAimOffsetBlend;
var GearAnim_BlendByRefRelative	MainGunFireAdditiveBlend;

/** FOVs for brumak guns */
var() float						SideGunConeAngle;
var() Vector					SideGunOriginOffset;
var() float						MainGunConeAngle;
var() Vector					MainGunOriginOffset;
var SkelControlSingleBone		MainGunScaleController;

/** Mesh components for attached pieces */
var StaticMeshComponent LeftGunComponent;
var StaticMeshComponent RightGunComponent;
var StaticMeshComponent MaskComponent;
var StaticMeshComponent BackpackComponent;

/** Turn in place player */
var GearAnim_TurnInPlace_Player	TurnPlayer;

// Damage dealing limbs
struct native DmgDealingLimbStruct
{
	/** Bone Name/Socket Name */
	var()				Name	BoneName;
	/** Extent, for bounding box size */
	var()				float	BoxSize;
	/** Last known location. */
	var		transient	vector	LastLocation;
};

/** Array of damage dealing limbs. */
var() Array<DmgDealingLimbStruct>	DmgDealingLimbs;

/** The PS to play when the brumak is moving.  Played at each foot step **/
var ParticleSystem PS_FootstepDust;
var SoundCue FootSound;
var ParticleSystem PS_BreathEffect;
var ParticleSystemComponent PSC_BreathEffect;
/** Explosion template for footsteps. Not really dealing damage, just effects. */
var() GearExplosion FootStepExploTemplate;

var vector	OldCamPosition;
var	rotator	OldCamRotation;

/** when TRUE side gun aim controllers strength is set to 0 */
var bool bDisableSideGunAimControllers;

/** Bone names of the rocket launcher and the backpack that supports it */
var array<Name> RocketPackBoneNames;


/************************************************************************/
/* Replication Block                                                    */
/************************************************************************/

replication
{
	if( Role == ROLE_Authority )
		bCanFireRockets, HumanGunner, AimOffsetViewLoc, LeftGunAimLocation, RightGunAimLocation, RoarCount, LeftGunLives, RightGunLives, MainGunLives;
}


/************************************************************************/
/* C++ functions                                                        */
/************************************************************************/

cpptext
{
	/** Overridden so we can use the Driver's camera origin */
	virtual FVector GetIdealCameraOrigin()
	{
		if (Driver != NULL)
		{
			return Driver->GetIdealCameraOrigin();
		}
		return Super::GetIdealCameraOrigin();
	}

	virtual void TickSpecial(FLOAT DeltaSeconds);

	virtual UBOOL IgnoreBlockingBy(const AActor* Other) const;
}


/************************************************************************/
/* Stub script functions for subclasses to define                       */
/************************************************************************/

function SetGunner(Pawn NewGunner, optional int Side);
function NotifyDriverDied(Pawn DeadPawn, Controller Killer);
function Pawn GetOtherGunEnemy(GearPawn_LocustBrumak_SideGun ThisGun);


/************************************************************************/
/* Overloaded script functions                                          */
/************************************************************************/

simulated function PostBeginPlay()
{
	local int i, NumMaterials;

	Super.PostBeginPlay();

	// Create MICs for each material, so we can modify them for gore
	NumMaterials = Mesh.SkeletalMesh.Materials.length;
	for(i=0; i<NumMaterials; i++)
	{
		Mesh.CreateAndSetMaterialInstanceConstant(i);
	}

	// Increase foot steps volume
	FootSound.VolumeMultiplier = 5.0;
}

/** Need to make sure the gunners are cleaned up */
simulated function Destroyed()
{
	super.Destroyed();

	// Clean up the gunners
	if (LeftGunPawn != None)
	{
		LeftGunPawn.Destroy();
		LeftGunPawn = None;
	}
	if (RightGunPawn != None)
	{
		RightGunPawn.Destroy();
		RightGunPawn = None;
	}
}

/** Handle all replication events */
simulated event ReplicatedEvent( Name VarName )
{
	// See if we need to play the roar sound
	if (VarName == nameof(RoarCount))
	{
		if (RoarCount > 0)
		{
			PlayRoar();
		}
	}
	else
	{
		Super.ReplicatedEvent( VarName );
	}
}

/** Overloaded so that AI uses "Eye Location" */
simulated native event vector GetPhysicalFireStartLoc( vector FireOffset );

/** Overloaded so we can use the local GetPhysicalFireStartLoc() function which makes the AI use the "Eye Location" */
simulated event Vector GetWeaponStartTraceLocation(optional Weapon CurrentWeapon)
{
	return GetPhysicalFireStartLoc(vect(0,0,0));
}

/** Find all the AnimNodes and Controllers for the Brumak */
simulated function CacheAnimNodes()
{
	local AnimNode	Node;

	Super.CacheAnimNodes();

	// Find the AnimNodes
	foreach Mesh.AllAnimNodes(class'AnimNode', Node)
	{
		if (Node.NodeName == 'LeftArmAimOffsetBlend')
		{
			LeftArmAimOffsetBlend = AnimNodeBlend(Node);
		}
		else if (Node.NodeName == 'RightArmAimOffsetBlend')
		{
			RightArmAimOffsetBlend = AnimNodeBlend(Node);
		}
		else if (Node.NodeName == 'MainGunFireAdditiveBlend')
		{
			MainGunFireAdditiveBlend = GearAnim_BlendByRefRelative(Node);
			MainGunFireAdditiveBlend.SetBlendTarget(0.f, 0.f);
		}
		else if (Node.NodeName == 'TurnPlayer')
		{
			TurnPlayer = GearAnim_TurnInPlace_Player(Node);
		}
	}

	// Find the LookAt Controllers
	LeftGunAimController  = SkelControlLookAt(Mesh.FindSkelControl('LeftGunAimController'));
	RightGunAimController = SkelControlLookAt(Mesh.FindSkelControl('RightGunAimController'));
	MainGunAimController1 = SkelControlLookAt(Mesh.FindSkelControl('MainGunAimController1'));
	MainGunAimController2 = SkelControlLookAt(Mesh.FindSkelControl('MainGunAimController2'));

	MainGunScaleController = SkelControlSingleBone(Mesh.FindSkelControl('GunScale'));

	// Initialize the LookAt Controllers
	LeftGunAimController.SetSkelControlActive(TRUE);
	LeftGunAimController.SetLookAtAlpha(0, 0);
	RightGunAimController.SetSkelControlActive(TRUE);
	RightGunAimController.SetLookAtAlpha(0, 0);
	MainGunAimController1.SetSkelControlActive(TRUE);
	MainGunAimController1.SetLookAtAlpha(0, 0);
	MainGunAimController2.SetSkelControlActive(TRUE);
	MainGunAimController2.SetLookAtAlpha(0, 0);

	// Find the Recoil Controllers
	IKRecoilCtrl[0] = GearSkelCtrl_IKRecoil(Mesh.FindSkelControl( 'LeftGunRecoil' ));
	IKRecoilCtrl[1] = GearSkelCtrl_IKRecoil(Mesh.FindSkelControl( 'RightGunRecoil' ));
}

/** Clear all the AnimNodes and Controllers */
simulated function ClearAnimNodes()
{
	Super.ClearAnimNodes();

	// Clear the AnimNodes
	LeftArmAimOffsetBlend = None;
	RightArmAimOffsetBlend = None;
	MainGunFireAdditiveBlend = None;
	TurnPlayer = None;
	MainGunScaleController = None;

	// Clear the LookAt Controllers
	LeftGunAimController = None;
	RightGunAimController = None;
	MainGunAimController1 = None;
	MainGunAimController2 = None;

	// Clear the Recoil Controllers
	IKRecoilCtrl[0] = None;
	IKRecoilCtrl[1] = None;
}

/** Overloaded so we can cache the weapon to the MyGearWeapon variable */
simulated function PlayWeaponSwitch(Weapon OldWeapon, Weapon NewWeapon)
{
	MyGearWeapon = GearWeapon(Weapon);
}

/**
* Brumaks are so tall they can base on other pawns as they walk.
* If this happens we will kill the pawns we step on and set the base to none */
event BaseChange()
{
	local Pawn BasePawn;

	BasePawn = Pawn(Base);
	if (BasePawn != None)
	{
		if (!BasePawn.IsHumanControlled() && BasePawn.GetTeamNum() == TEAM_COG)
		{
			BasePawn.TakeDamage(100000, Controller, BasePawn.Location, vect(0,0,-1), class'GDT_Melee');
		}
		else if (!BasePawn.InGodMode() && (GearPawn(BasePawn) == None || !GearPawn(BasePawn).bUnlimitedHealth))
		{
			BasePawn.Died(Controller, class'GDT_Melee', BasePawn.Location);
		}
		SetPhysics(PHYS_Falling);
		SetBase(None);
	}
	else
	{
		Super.BaseChange();
	}
}

/** If bumped by the other team, the Brumak will inflict damage */
simulated event Bump( Actor Other, PrimitiveComponent OtherComp, Vector HitNormal )
{
	local Pawn OtherPawn;

	OtherPawn = Pawn(Other);
	if( !IsZero(Velocity) &&
		OtherPawn != None &&
		!OtherPawn.IsSameTeam(self) )
	{
		OtherPawn.TakeDamage( 500, Controller, OtherPawn.Location, vect(0,0,0), class'GDT_Brumak_SteppedOn' );
	}

	Super.Bump( Other, OtherComp, HitNormal );
}

/** No stopping power against Brumaks */
function HandleStoppingPower(class<GearDamageType> GearDamageType, Vector Momentum, float DmgDistance);

/** Disable Drone-like melee attacks for Brumak. */
simulated function StartMeleeAttack();

/** Handle the bite attack */
simulated function StartFire( byte FireModeNum )
{
	if (FireModeNum == class'GearWeapon'.const.MELEE_ATTACK_FIREMODE)
	{
		LocalDoSpecialMove( GSM_Brumak_OverlayBite );
	}
	else
	{
		Super.StartFire( FireModeNum );
	}
}

/** A pawn specific way of handling what component was hit on the pawn */
simulated function byte GetPawnSpecificComponentHitType(PrimitiveComponent Component)
{
	if (Component == RightGunComponent)
	{
		return COMPONENT_HIT_RightArmGun;
	}
	else if (Component == LeftGunComponent)
	{
		return COMPONENT_HIT_LeftArmGun;
	}
	else if (Component == BackPackComponent)
	{
		return COMPONENT_HIT_BackPack;
	}

	return Super.GetPawnSpecificComponentHitType(Component);
}

/** Handle pawn specific way of handling the component that was hit on the pawn */
function HandleServerSideComponentRemap(out ImpactInfo Impact, byte HitType)
{
	switch (HitType)
	{
	case COMPONENT_HIT_RightArmGun:
		Impact.HitInfo.HitComponent = RightGunComponent;
		break;
	case COMPONENT_HIT_LeftArmGun:
		Impact.HitInfo.HitComponent = LeftGunComponent;
		break;
	case COMPONENT_HIT_BackPack:
		Impact.HitInfo.HitComponent = BackPackComponent;
		break;
	}
}

/************************************************************************/
/* Script functions                                                     */
/************************************************************************/

function SetDriverCollision()
{
	Driver.SetCollision( FALSE, FALSE, TRUE );
}

/** Event called when new Driver is Set. Called on server only. */
function OnDriverSet()
{
	Super.OnDriverSet();
	Health = DefaultHealth;
}

/** Event called when Driver is unset. Called on server only. */
function OnDriverUnset(GearPawn OldDriver)
{
	if( OldDriver != None )
	{
		OldDriver.InvManager.DiscardInventory();
		OldDriver.AddDefaultInventory();
	}
}

simulated function DoDriverAttachment(GearPawn InDriver)
{
	super.DoDriverAttachment(InDriver);

	Driver.Mesh.bUpdateSkelWhenNotRendered = FALSE;
	Driver.Mesh.MinDistFactorForKinematicUpdate = 10.0; // Stop physics updates even when seen

	LeftGunAimController.SetLookAtAlpha(  1.f, 0.1f );
	RightGunAimController.SetLookAtAlpha( 1.f, 0.1f );
	MainGunAimController1.SetLookAtAlpha( 1.f, 0.1f );
	MainGunAimController2.SetLookAtAlpha( 1.f, 0.1f );
}

simulated function DoDriverDetach(GearPawn OldDriver)
{
	super.DoDriverDetach(OldDriver);

	LeftGunAimController.SetLookAtAlpha(  0.f, 0.1f );
	RightGunAimController.SetLookAtAlpha( 0.f, 0.1f );

	if( OldDriver != None )
	{
		OldDriver.Mesh.bUpdateSkelWhenNotRendered = TRUE;
		OldDriver.Mesh.MinDistFactorForKinematicUpdate = OldDriver.default.Mesh.MinDistFactorForKinematicUpdate;
	}
}

function SetHumanGunner( GearPawn GP )
{
	HumanGunner = GP;
}

/** Set the actors the side guns should aim at */
final simulated function SetSideGunAimTarget( Actor NewTarget, bool bLeftGun )
{
	if( bLeftGun )
	{
		//debug
		`log( GetFuncName()@"LEFT"@LeftGunTarget@NewTarget@IsLeftGunDestroyed(), bDebug);

		LeftGunTarget = (!IsLeftGunDestroyed()) ? NewTarget : None;
	}
	else
	{
		//debug
		`log( GetFuncName()@"RIGHT"@RightGunTarget@NewTarget@IsRightGunDestroyed(),bDebug);

		RightGunTarget = (!IsRightGunDestroyed()) ? NewTarget : None;
	}
}

/** Set the actor the main gun should aim at */
final simulated function SetMainGunAimTarget( Actor NewTarget )
{
	//debug
	`log( GetFuncName()@"MAIN"@MainGunTarget@NewTarget@Driver,bDebug);


	MainGunTarget =  (Driver != None && !IsMainGunDestroyed()) ? NewTarget : None;
}

/** Overriden to bypass all the drone specific rules, and use straight known location interpolation */
simulated function Vector GetAIAimOffsetFireTargetLocation(GearAI AI)
{
	return AI.GetFireTargetLocation(LT_InterpVisibility);
}

/** Given a target to aim at, get the location to aim at */
simulated function vector GetGunLookTargetLocation( Actor TargActor, SkelControlLookAt SkelController )
{
	local GearAI_Brumak	AI;
	local Pawn			TargetPawn;

	if( TargActor != None )
	{
		AI = GearAI_Brumak(Controller);
		TargetPawn = Pawn(TargActor);
		if( AI != None && TargetPawn != None )
		{
			if( TargetPawn.IsValidEnemyTargetFor( PlayerReplicationInfo, FALSE ) )
			{
				return AI.GetEnemyLocation( TargetPawn, LT_InterpVisibility );
			}
			else
			{
				SkelController.SetLookAtAlpha( 0.f, SkelController.BlendOutTime );
				return SkelController.DesiredTargetLocation;
			}
		}

		return TargActor.Location;
	}

	return SkelController.DesiredTargetLocation;
}

/** Returns TRUE if left gun is disabled */
final function bool IsLeftGunDestroyed()
{
	return (LeftGunHealth <= 0);
}

/** Returns TRUE if right gun is disabled */
final function bool IsRightGunDestroyed()
{
	return (RightGunHealth <= 0);
}

final function bool IsMainGunDestroyed()
{
	return (MainGunHealth <= 0);
}

final function bool HasAnyWeaponsAlive()
{
	return (!IsMainGunDestroyed() || !IsLeftGunDestroyed() || !IsRightGunDestroyed());
}


/** Returns ViewLocation to be used by AimOffset, for AI characters, when tracking a Target. */
simulated function vector GetAimOffsetViewLocation()
{
	local Vector RoughHeadLocation, ViewLocation;

	// Get rough head location
	// We prefer Spine2 instead of Head or Neck, because it's about the same height,
	// but it doesn't move as much around as these other bones when aimoffsets change.
	RoughHeadLocation = Mesh.GetBoneLocation('Spine2');

	// RoughHeadLocation could be outside of the collision cylinder, so we just use its height as an indication.
	// We need something stable for AimOffsets, and it doesn't have to be that precise.
	ViewLocation	= Location;
	ViewLocation.Z	= RoughHeadLocation.Z;

	// Set BaseEyeHeight for LineOfSight checks
	BaseEyeHeight = ViewLocation.Z - Location.Z;

	return ViewLocation;
}

/** Play the stumble animation if it's not already playing */
function bool PlayStumbleAnim( bool bLatent )
{
	bFlinching = bLatent;
	if( !IsDoingSpecialMove( SM_StumbleGoDown ) )
	{
		DoSpecialMove( SM_StumbleGoDown, TRUE );
		return TRUE;
	}
	return FALSE;
}

function NotifyBrumakSmashCollision( Actor Other, Vector HitLocation )
{
	local Controller InstigatedBy;
	local FracturedStaticMeshActor FracActor;

	//debug
	`log( GetFuncName()@Other@SpecialMove@Controller, bDebug );

	if( IsDoingSpecialMove( GSM_Brumak_MeleeAttack		  ) ||
		IsDoingSpecialMove( GSM_Brumak_OverlayLftArmSwing ) ||
		IsDoingSpecialMove( GSM_Brumak_OverlayRtArmSwing  ) )
	{
		//debug
		`log("doing damage to"@Other,bDebug);

		InstigatedBy = Controller;
		if( LeftGunPawn != None && LeftGunPawn.IsHumanControlled() )
		{
			InstigatedBy = LeftGunPawn.Controller;
		}

		Other.TakeDamage( 1000.f, InstigatedBy, Other.Location, vect(0,0,0), class'GDT_Brumak_Smash' );

		FracActor = FracturedStaticMeshActor(Other);
		if( FracActor != None && FracActor.Physics == PHYS_None && FracActor.IsFracturedByDamageType(class'GDT_Brumak_Smash') )
		{
			FracActor.BreakOffPartsInRadius( HitLocation, 512.f, 600.f, TRUE );
		}
	}
}

function NotifyBrumakBiteCollision( Actor Other, Vector HitLocation )
{
	local Controller InstigatedBy;

	//debug
	`log( GetFuncName()@Other@SpecialMove,bDebug);

	if( IsDoingSpecialMove( GSM_Brumak_OverlayBite ) )
	{
		`log("doing damage to"@Other,bDebug);

		InstigatedBy = Controller;
		if( LeftGunPawn != None && LeftGunPawn.IsHumanControlled() )
		{
			InstigatedBy = LeftGunPawn.Controller;
		}

		Other.TakeDamage( 1000.f, InstigatedBy, Other.Location, vect(0,0,0), class'GDT_Brumak_Bite' );

		//		PlaySound(SoundCue'Foley_BodyMoves.BodyMoves.BerserkerArmImpactFlesh_Cue'); //replace
	}
}

function NotifyBrumakRoar()
{
	local GearPawn	EnemyPawn;
	local float		DistSq, DotP, DamageScale, Damage;
	local Controller InstigatedBy;

	//debug
	`log( GetFuncName()@SpecialMove,bDebug );

	if( IsDoingSpecialMove( GSM_Brumak_Roar ) )
	{
		InstigatedBy = Controller;
		if( LeftGunPawn != None && LeftGunPawn.IsHumanControlled() )
		{
			InstigatedBy = LeftGunPawn.Controller;
		}

		foreach WorldInfo.AllPawns( class'GearPawn', EnemyPawn )
		{
			if( !InstigatedBy.Pawn.IsSameTeam(EnemyPawn) )
			{
				DistSq = VSizeSq(EnemyPawn.Location-Location);
				DotP = Normal(EnemyPawn.Location-Location) DOT vector(Rotation);
				if( DistSq <= (768*768) && DotP > 0.85f )
				{
					DamageScale = DistSq / (768*768);
					Damage		= 100.f * DamageScale;

					//debug
					`log( ">>>> Damage"@EnemyPawn@DamageScale@Damage,bDebug );

					EnemyPawn.TakeDamage(Damage, InstigatedBy, EnemyPawn.Location, vect(0,0,0), class'GDT_Brumak_Roar' );
				}
			}
		}
	}
}

final function GetGunFOVParameters(vector InOffset, float InDegAngle, out vector OutOrigin, out vector OutOrientation, out float OutRadAngle, optional bool bLeftSide)
{
	local vector X, Y, Z;

	GetAxes(Rotation, X, Y, Z);
	OutOrigin		= Location + InOffset.X * X + InOffset.Y * Y * (bLeftSide ? -1.f : 1.f) + InOffset.Z * Z;
	OutOrientation	= Vector(Rotation);
	OutRadAngle		= InDegAngle * DegToRad;
}

final function bool IsWithinGunFOV(vector InOffset, float InDegAngle, vector TestLocation, optional bool bLeftSide)
{
	local Vector	OutOrigin, OutOrientation;
	local float		OutRadAngle, DotAngle;

	// Get FOV parameters.
	GetGunFOVParameters(InOffset, InDegAngle, OutOrigin, OutOrientation, OutRadAngle, bLeftSide);

	// Turn rad angle to dot angle
	DotAngle = Cos(OutRadAngle);

	// See if point is contained within cone
	return ((Normal(TestLocation - OutOrigin) dot OutOrientation) >= DotAngle);
}


final function bool IsWithinLeftGunFOV(vector TestLocation)
{
	return IsWithinGunFOV(SideGunOriginOffset, SideGunConeAngle, TestLocation, TRUE);
}

final function bool IsWithinRightGunFOV(vector TestLocation)
{
	return IsWithinGunFOV(SideGunOriginOffset, SideGunConeAngle, TestLocation);
}

final function bool IsWithinMainGunFOV(vector TestLocation)
{
	return IsWithinGunFOV(MainGunOriginOffset, MainGunConeAngle, TestLocation);
}

/** Notification called when a damage dealing limb collided with an Actor. */
simulated event DmgDealingLimbsCollision(Actor HitActor, Vector HitLocation, Vector HitNormal, PhysicalMaterial PhysMaterial)
{
	local ParticleSystem ImpactPS;

	//`log(WorldInfo.TimeSeconds @ Self @ GetFuncName() @ "HitActor:" @ HitActor);
	if( WorldInfo.NetMode != NM_Client && HitActor.IsA('GearDestructibleObject') || HitActor.IsA('InterpActor') )
	{
		// using GDT_BrumakCannon instead of _Smash, because destructible pipes don't recognize the latter.
		HitActor.TakeDamage(10, Controller, HitLocation, HitNormal, class'GDT_BrumakBullet',, Self);
	}
	else if (HitActor.bWorldGeometry || HitActor.IsA('FracturedStaticMeshActor'))
	{
		ImpactPS = class'GearPhysicalMaterialProperty'.static.DetermineImpactParticleSystem(PhysMaterial, class'GDT_Brumak_Smash', FALSE, WorldInfo, self);
		WorldInfo.MyEmitterPool.SpawnEmitter(ImpactPS, HitLocation, rotator(HitNormal), HitActor);
		if (HitActor.IsA('FracturedStaticMeshActor'))
		{
			HitActor.TakeDamage(1000, Controller, HitLocation, -HitNormal, class'GDT_Brumak_Smash',, self);
		}
	}
}


/**
*  Event from c++ land that tells us to play a footstep
**/
simulated event PlayFootStepSound( int FootDown )
{
// 	local PlayerController PC;
// 	local ParticleSystemComponent WE;
	local vector SpawnLocation;
	local rotator SpawnRotator;
	local GearExplosionActor ExplosionActor;
	
	if( FootDown == 1 )
	{
		Mesh.GetSocketWorldLocationAndRotation( 'DustRightFoot', SpawnLocation, SpawnRotator );
	}
	else
	{
		Mesh.GetSocketWorldLocationAndRotation( 'DustLeftFoot', SpawnLocation, SpawnRotator );
	}
	
	// Spawn explosion
	ExplosionActor = Spawn(class'GearExplosionActor', self,, SpawnLocation, SpawnRotator);
	ExplosionActor.Instigator = Self;
	ExplosionActor.InstigatorController = Controller;
	FootStepExploTemplate.InitFromContentTemplate();
	FootStepExploTemplate.Damage = 0;
	FootStepExploTemplate.DamageRadius = 0;
	ExplosionActor.SetDrawScale(DrawScale);
	ExplosionActor.Explode(FootStepExploTemplate);

// 	WE = WorldInfo.MyEmitterPool.SpawnEmitter(PS_FootstepDust, SpawnLocation, SpawnRotator);
// 	WE.SetScale(DrawScale);

	//	`log("FootSound Volume: " @ FootSound.VolumeMultiplier);
	PlaySound(FootSound);

	// Tell AI that brumak has stepped
	if( Role == ROLE_Authority || IsLocallyControlled() )
	{
		MakeNoise( 1.0, 'NOISETYPE_FootStep_Brumak' );
	}
}

function PlayExposeDriver();
simulated function PlayRoar();

function UpdateRoarCount()
{
	RoarCount++;
	if( RoarCount == 0 )
	{
		RoarCount = 1;
	}

	PlayRoar();
}

simulated function SetCinematicMode( bool bInCinematicMode )
{
	Super.SetCinematicMode( bInCinematicMode );
	Driver.SetHidden( bHidden );
}

/** Plays a sound when the pawn is dying */
function PlayDyingSound()
{
	if (DyingSound != none)
	{
		PlaySound(DyingSound);
	}
}

function ANIMNOTIFY_FireRockets()
{
	local GearAI_Brumak AI;
	AI = GearAI_Brumak(Controller);
	if( AI != none && AI.DriverAI != None )
	{
		AI.DriverAI.GotoState( 'RocketAttack' );
	}
}

function bool OverrideAimLocation(out vector AimLoc, vector StartLoc, GearAI ShooterAI)
{
	// just use base location all the time
	AimLoc = ShooterAI.GetEnemyLocation(self);
	return true;
}

simulated function bool ShouldRefireWeapon(GearWeap_BrumakWeaponBase Gun)
{
	local Vector TestLocation;

	if( Physics == PHYS_Falling )
		return FALSE;

	if( Gun.Instigator == LeftGunPawn )
	{
		TestLocation = GetGunLookTargetLocation(LeftGunTarget, LeftGunAimController);
		return IsWithinLeftGunFOV(TestLocation);
	}
	else if( Gun.Instigator == RightGunPawn )
	{
		TestLocation = GetGunLookTargetLocation(RightGunTarget, RightGunAimController);
		return IsWithinRightGunFOV(TestLocation);
	}
	else if( Gun.Instigator == Driver )
	{
		TestLocation = GetGunLookTargetLocation(MainGunTarget, MainGunAimController2);
		return IsWithinMainGunFOV(TestLocation);
	}

	return TRUE;
}

// no one can ride us besides the driver we spawned initially
function bool TryToDrive(Pawn P)
{
	return false;
}
simulated function bool CanEnterRidablePawn(GearPawn P, optional bool bIgnoreRange)
{
	return false;
}
event bool DriverLeave(bool bForceLeave)
{
	return (bForceLeave && Super.DriverLeave(bForceLeave));
}


defaultproperties
{
	SpecialMoveClasses(SM_DeathAnim)					=class'GSM_DeathAnim'
	SpecialMoveClasses(SM_RoadieRun)					=None
	SpecialMoveClasses(SM_StumbleGoDown)				=class'GSM_Brumak_StumbleBack'
	SpecialMoveClasses(GSM_Brumak_Roar)					=class'GSM_Brumak_Roar'
	SpecialMoveClasses(GSM_Brumak_RtGunHit)				=class'GSM_Brumak_RtGunHit'
	SpecialMoveClasses(GSM_Brumak_LtGunHit)				=class'GSM_Brumak_LtGunHit'
	SpecialMoveClasses(GSM_Brumak_CannonHit)			=class'GSM_Brumak_CannonHit'
	SpecialMoveClasses(GSM_Brumak_CannonFire)			=class'GSM_Brumak_CannonFire'
	SpecialMoveClasses(GSM_Brumak_MeleeAttack)			=class'GSM_Brumak_MeleeAttack'
	SpecialMoveClasses(GSM_Brumak_OverlayLftArmSwing)	=class'GSM_Brumak_OverlayLftArmSwing'
	SpecialMoveClasses(GSM_Brumak_OverlayRtArmSwing)	=class'GSM_Brumak_OverlayRtArmSwing'
	SpecialMoveClasses(GSM_Brumak_OverlayBite)			=class'GSM_Brumak_OverlayBite'
	SpecialMoveClasses(GSM_Brumak_Scream)				=class'GSM_Brumak_Scream'
	SpecialMoveClasses(GSM_Brumak_LtGunPain)			=class'GSM_Brumak_LtGunPain'
	SpecialMoveClasses(GSM_Brumak_RtGunPain)			=class'GSM_Brumak_RtGunPain'
	SpecialMoveClasses(GSM_Brumak_ExposeDriver)			=class'GSM_Brumak_ExposeDriver'


	SideGunConeAngle=85.f
	SideGunOriginOffset=(Z=200,Y=250)
	MainGunConeAngle=100.f
	MainGunOriginOffset=(X=100,Z=600)

	DmgDealingLimbs(0)=(BoneName="LeftHand",BoxSize=75.f)
	DmgDealingLimbs(1)=(BoneName="RightHand",BoxSize=75.f)
	DmgDealingLimbs(2)=(BoneName="DustLeftFoot",BoxSize=75.f)
	DmgDealingLimbs(3)=(BoneName="DustRightFoot",BoxSize=75.f)
	DmgDealingLimbs(4)=(BoneName="Driver",BoxSize=75.f)
	DmgDealingLimbs(5)=(BoneName="RocketMuzzle",BoxSize=50.f)

	//	RightFootBoneName="DustRightFoot"
	//	LeftFootBoneName="DustLeftFoot"
	RightFootBoneName="RightBall"
	LeftFootBoneName="LeftBall"

	bCanFireRockets=true
	bCanBeRunOver=false
	bPushedByEncroachers=false
	bCanDoFloorConform=true
	bDoDeathUpKick=false

	DeathAnimHighFwd(0)=death_backward
	DeathAnimHighBwd(0)=death_backward
	DeathAnimStdFwd(0)=death_backward
	DeathAnimStdBwd(0)=death_backward
	DeathAnimStdLt(0)=death_crumple_left
	DeathAnimStdRt(0)=death_crumple_left

	RocketPackBoneNames(0)="MachinGunArm1"
	RocketPackBoneNames(1)="MachinGunArm2"
	RocketPackBoneNames(2)="MachinGunArm3"
	RocketPackBoneNames(3)="MachinGun"
	RocketPackBoneNames(4)="MachinGunBarrel"

	NoticedGUDSPriority=140
	NoticedGUDSEvent=GUDEvent_NoticedBrumak
}
