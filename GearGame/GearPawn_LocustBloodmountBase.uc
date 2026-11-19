
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearPawn_LocustBloodmountBase extends GearPawnRidable_Base
	dependson(ItemSpawnable)
	config(Pawn)
	native(Pawn)
	abstract;


/************************************************************************/
/* Member variables                                                     */
/************************************************************************/

/** Scalar to apply to groundspeed when the driver is knocked off **/
var config float		NoDriverSpeed;

/** chance that the driver will stay in the saddle when it dies (and flop around OH BOY!)*/
var() config float		DriverStayInSaddleChance;

/** speed to use when charging (with a driver)*/
var() config float ChargeSpeed;
/** ChargeSpeed to use in Beast mode */
var() protected config float ChargeSpeed_Siege;
/** speed to use when walking (with a driver) in Beast mode */
var() protected config float DefaultGroundSpeed_Siege;


/** sound that plays when the bloodmount does his melee attack */
var SoundCue AttackSound;

/** sound that plays when his helmet is blown off and he freaks out */
var SoundCue HeadShotCue;

/** sound that plays when we first acquire an enemy */
var SoundCue EnemyAcquiredCue;

/** sound that plays when our driver gets blown off and we start moving faster */
var SoundCue DriverGoneCue;

/** sound that plays every so often when we're not in combat */
var SoundCue AmbientCue;
/** Sound that plays every so often when we are in combat */
var SoundCue CombatAmbientCue;
/** sound to play when the bloodmount is charging his enemy */
var SoundCue ChargeCue;
/** sound that plays when the bloodmount's body is falling to the ground */
var SoundCue BodyFallSound;

var Vector2d AmbientTimeRange;

var StaticMeshComponent HeadSlotStaticMesh;

var class<Item_HelmetBase> HelmetItem;

var protected transient MaterialInstanceConstant MIC_PawnMatHelmet;

var float lastChargeSoundTime;

var BodyStance	LastPlayedHitReactionStance;

/** Node for playing custom anims on the head */
var GearAnim_Slot	HeadSlot;
/** How often roar anim plays */
var vector2D	RoarInterval;

/** Path to use when interpolating */
var	InterpData InterpPath;

/** Path to use when interpolating */
var	name InterpGroupName;

/** Current position within the interp path. */
var	float CurrentInterpTime;

/** Body stance to play when a chasing bloodmount gets a jump event */
var BodyStance BS_JumpStance;

cpptext
{
	/**
	 * Custom movement when PHYS_Interpolation
	 *
	 * @param DeltaTime - the timeslice for the current frame
	 */
	virtual void physInterpolating(FLOAT DeltaTime);

	/**
	 * Util for getting current InterpGroup used by this bloodmount.
	 *
	 * @return the InterpGroup that physInterpolating should use
	 */
	class UInterpGroup* GetCurrentInterpGroup();
}

replication
{
	if (bNetInitial)
		CurrentInterpTime;

	if (bNetDirty)
		InterpPath;
}

/************************************************************************/
/* Stub script functions for subclasses to define                       */
/************************************************************************/


/************************************************************************/
/* Overloaded script functions                                          */
/************************************************************************/

simulated function ReplicatedEvent(name VarName)
{
	Super.ReplicatedEvent(VarName);

	if (VarName == nameof(Controller))
	{
		if ( PlayerController(Controller) != None )
		{
			DefaultGroundSpeed = DefaultGroundSpeed_Siege;
			ChargeSpeed = ChargeSpeed_Siege;
		}
	}
}


simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	SetTimer(RandRange(RoarInterval.X,RoarInterval.Y),FALSE,nameof(PlayRoarAnim));

	SetTimer(RandRange(AmbientTimeRange.X,AmbientTimeRange.Y),FALSE,nameof(DoAmbientSound));

	SetupHelmet();
}

simulated function bool ShouldTorqueBowArrowGoThroughMe(GearProjectile Proj, TraceHitInfo HitInfo, vector HitLocation, vector Momentum, optional out byte out_bHasHelmet)
{
	return FALSE;
}

/** Cache pointer to head slot */
simulated function CacheAnimNodes()
{
	Super.CacheAnimNodes();

	HeadSlot = GearAnim_Slot(Mesh.FindAnimNode('Custom_Head'));
}

simulated function bool CanBeSpecialMeleeAttacked( GearPawn Attacker )
{
	return FALSE;
}

/** Heats up the skin by the given amount.  Skin heat constantly diminishes in Tick(). */
simulated function HeatSkin(float HeatIncrement)
{
	Super.HeatSkin( HeatIncrement );

	if( ( HeadSlotStaticMesh != None ) && ( MIC_PawnMatHelmet != None ) )
	{
		MIC_PawnMatHelmet.SetScalarParameterValue('Heat', CurrentSkinHeat);
	}
}

/** Char skin to the given absolute char amount [0..1].  Charring does not diminish over time. */
simulated function CharSkin(float CharIncrement)
{
	Super.CharSkin( CharIncrement );

	if( ( HeadSlotStaticMesh != None )  && ( MIC_PawnMatHelmet != None ) )
	{
		MIC_PawnMatHelmet.SetScalarParameterValue('Burn', CurrentSkinChar);
	}
}

simulated function SetupHelmet()
{
	local SpawnableItemDatum ItemDatum;

	ItemDatum = HelmetItem.static.GetSpawnableItemDatum();

	HeadSlotStaticMesh.SetStaticMesh(ItemDatum.TheMesh);
	HeadSlotStaticMesh.SetShadowParent(Mesh);
	HeadSlotStaticMesh.SetLightEnvironment(LightEnvironment);
	HeadSlotStaticMesh.SetHidden(FALSE);
	Mesh.AttachComponentToSocket(HeadSlotStaticMesh, ItemDatum.AttachSocketName);

	SetupHelmetMaterialInstanceConstant();

}

event PostAIFactorySpawned(SeqAct_AIFactory SpawningFactory, INT SpawnSetIdx)
{
	Super.PostAIFactorySpawned(SpawningFactory,SpawnSetIdx);
	// add the driver (if any) to the factory's watch list
	if(Driver != none)
	{
		SpawningFactory.AddPawnToSetWatchListByIndex(SpawnSetIdx, Driver);
	}
}

simulated function DoDriverAttachment(GearPawn InDriver)
{
	Super.DoDriverAttachment(InDriver);

	// Switch default death animation special move to falling from beast.
	InDriver.SpecialMoveClasses[SM_DeathAnim] = class'GSM_DeathAnimFallFromBeast';
	InDriver.SpecialMoveClasses[SM_DeathAnimFire] = None;
	InDriver.SpecialMoveClasses[SM_StumbleFromMelee] = None;
	InDriver.SpecialMoveClasses[SM_StumbleFromMelee2] = None;

	// Sync animations between mount and driver
	InDriver.AnimTreeRootNode.ForceGroupRelativePosition('IdleAnims', AnimTreeRootNode.GetGroupRelativePosition('IdleAnims'));
	InDriver.AnimTreeRootNode.ForceGroupRelativePosition('RunWalk', AnimTreeRootNode.GetGroupRelativePosition('RunWalk'));
}

simulated function Destroyed()
{
	Super.Destroyed();
	EjectDriver();
}

/** Overridden to throw driver off. */
function bool Died(Controller Killer, class<DamageType> GearDamageType, vector HitLocation)
{
	ClearTimer(nameof(DoAmbientSound));
	if (IsHumanControlled() && Driver != None && !Driver.IsHumanControlled())
	{
		Driver.Died(Killer, GearDamageType, HitLocation);
	}
	else
	{
		EjectDriver();
	}
	return Super.Died( Killer, GearDamageType, HitLocation );
}

// if our driver gets off, speed up
event Detach(Actor Detachee)
{
	Super.Detach(Detachee);

	if (Detachee == Driver)
	{
		Driver = None;
		GroundSpeed = NoDriverSpeed;
		PlayDriverGoneSound();
	}
}

simulated function OnDeathAnimBodyRest()
{
	Super.OnDeathAnimBodyRest();
	PlaySound(BodyFallSound);
}


/** Turn off controllers and get pawn ready for being put into physics */
simulated function ReadyPawnForRagdoll()
{
	local SkelControlLimb SCL;

	Super.ReadyPawnForRagdoll();

	// turn off the IK on this guy when he is RagDolled
	SCL = SkelControlLimb(Mesh.FindSkelControl('IKCtrl_LeftFoot'));
	if( SCL != None )		SCL.SetSkelControlActive(FALSE);

	SCL	= SkelControlLimb(Mesh.FindSkelControl('IKCtrl_RightFoot'));
	if( SCL != None )		SCL.SetSkelControlActive(FALSE);
}

/** Play Hit Reaction animation */
simulated function bool PlayHitReactionAnimation(ImpactInfo Impact)
{
	local BodyStance	BS_HitReaction;
	local Name			AnimName;
	local float			DotFront, DotRight;
	local Vector		HitNormal, LookDir, RightDir;

	// Don't override animations playing except if it's the last hit reaction we've played
	if( FullBodyNode == None ||
		(FullBodyNode.bIsPlayingCustomAnim && !BS_IsPlaying(LastPlayedHitReactionStance)) )
	{
		return FALSE;
	}

	HitNormal	= Normal(-Impact.RayDir);
	LookDir		= vector(Rotation);
	RightDir	= vect(0,0,1) cross LookDir;

	DotFront = HitNormal dot LookDir;
	DotRight = HitNormal dot RightDir;

	if( Abs(DotFront) > Abs(DotRight) )
	{
		if( DotFront > 0.f )
		{
			AnimName = FRand() > 0.5f ? 'ADD_Hit_Reaction_Fwd_A' : 'ADD_Hit_Reaction_Fwd_B';
		}
		else
		{
			AnimName = 'ADD_Hit_Reaction_Back_A';
		}
	}
	else if( DotRight > 0.f )
	{
		AnimName = 'ADD_Hit_Reaction_Rt_A';
	}
	else
	{
		AnimName = 'ADD_Hit_Reaction_Lft_A';
	}

	BS_HitReaction.Stance.Length = 1; // Array of struct needs to be pre-sized.
	BS_HitReaction.Stance[0].Slot = BS_FullBody;
	BS_HitReaction.Stance[0].AnimName = AnimName;
	NextHitReactionAnimTime = WorldInfo.TimeSeconds + RandRange(0.33f, 0.67f);

	if( BS_Play(BS_HitReaction, 0.67f, 0.05f, 0.2f) > 0.f )
	{
		LastPlayedHitReactionStance = BS_HitReaction;
		// If we have a rider, have play the same animation in sync.
		if( Driver != None )
		{
			Driver.BS_Play(BS_HitReaction, 0.67f, 0.05f, 0.2f);
		}
		return TRUE;
	}

	return FALSE;
}

event bool EncroachingOn(Actor Other)
{
	if ( !bScriptInitialized )
	{
		return false;
	}
	return Super.EncroachingOn(Other);
}

/************************************************************************/
/* Script functions                                                     */
/************************************************************************/

function NotifyCharging(Actor ChargeTarget)
{
	if(ChargeTarget != none)
	{
		if(`TimeSince(lastChargeSoundTime)>3.0)
		{
			PlaySound(ChargeCue);
			lastChargeSoundTime=worldinfo.timeseconds;
		}

		// if we have no driver, dont' mess with speed
		if(Driver != none && Driver.IsAliveAndWell())
		{
			GroundSpeed = ChargeSpeed;
		}

	}
	else
	{
		if(Driver != none && Driver.IsAliveAndWell())
		{
			GroundSpeed = DefaultGroundSpeed;
		}
		else
		{
			GroundSpeed = NoDriverSpeed;
		}
	}
}

function PlayAttackSound()
{
	PlaySound(AttackSound);
}

simulated function RemoveHelmet()
{
	PlaySound(HeadShotCue);
	ShootOffHelmet();
}

/**
 * To remove blood mount helmets we do it differently than the normal GearPawn_Infantry.
 *
 * This is triggered from an anim notify
 * which is triggered by sufficient damage to the head
 *
 * Check out: AIReactCond_BloodMountHeadDamage for the internals of this behavior
 *
 * NOTE: you can not test this with ce dumbai.  The bloodmount needs to be alive and trying to kill you for it to work.
 **/
simulated function ShootOffHelmet()
{
	local SpawnableItemDatum ItemDatum;
	local Vector SpawnLoc;
	local Rotator SpawnRot;
	local Item_HelmetBase AHelmet;

	HeadSlotStaticMesh.SetHidden( TRUE );
	Mesh.DetachComponent(HeadSlotStaticMesh);

	ItemDatum = HelmetItem.static.GetSpawnableItemDatum();

	Mesh.GetSocketWorldLocationAndRotation( ItemDatum.AttachSocketName, SpawnLoc, SpawnRot );

	AHelmet = Spawn( HelmetItem,,, SpawnLoc,,, TRUE );
	AHelmet.StaticMeshComponent.SetStaticMesh( ItemDatum.TheMesh );

	AHelmet.CollisionComponent.AddImpulse( Vector(Rotation) * RandRange(25,45), vect(0,0,100) );
	AHelmet.CollisionComponent.SetRBAngularVelocity( vect(0,100,300), TRUE );

	AHelmet.PlayShotOffSound();

	// >>> play particle effect for when we're shot off

	if( AHelmet != None )
	{
		AHelmet.TurnCollisionOff();

		AHelmet.SetTimer( 0.100f, FALSE, nameof(AHelmet.TurnCollisionOn) ); // to stop inter penetrating and then OOE as physics corrects and shoots it off
	}
}

/** This will set up all of the MICs on the helmets if this pawn has one **/
simulated function SetupHelmetMaterialInstanceConstant()
{
	if( ( HeadSlotStaticMesh != None )  )
	{
		MIC_PawnMatHelmet = HeadSlotStaticMesh.CreateAndSetMaterialInstanceConstant(0);
	}
}

function PlayEnemyAcquiredSound()
{
	PlaySound(EnemyAcquiredCue);
}

function PlayDriverGoneSound()
{
	PlaySound(DriverGoneCue);
}

/** Play a roar animation every so often */
simulated function PlayRoarAnim()
{
	if(IsAliveAndWell())
	{
		HeadSlot.PlayCustomAnim('ADD_Roar_Overlay', 1.0, 0.1, 0.2, FALSE, TRUE);

		if(Health > 0)
		{
			SetTimer(RandRange(RoarInterval.X,RoarInterval.Y),FALSE,nameof(PlayRoarAnim));
		}
	}
}

simulated function DoAmbientSound()
{
	if(IsAliveAndWell())
	{
		if(MyGearAI != none && MyGearAI.IsInCombat())
		{
			PlaySound(CombatAmbientCue,TRUE);
		}
		else
		{
			PlaySound(AmbientCue,TRUE);
		}
		SetTimer(RandRange(AmbientTimeRange.X,AmbientTimeRange.Y),FALSE,nameof(DoAmbientSound));
	}
}

simulated function PlayMountedDeathFor(GearPawn Rider,class<GearDamageType> GearDamageType, vector HitLoc, bool bShowGore)
{
	local Vector		ApplyImpulse;
	local TraceHitInfo	HitInfo;

	Rider.SetBase(NONE);
	Rider.SetPhysics(PHYS_None);
	Rider.SetHardAttach(TRUE);
	Rider.SetBase(Self,, Mesh, 'Driver');
	Rider.SetPhysics(PHYS_None);

	if( Rider.Mesh.PhysicsAssetInstance != None )
	{
		// fix the proper bones
		Rider.Mesh.PhysicsAssetInstance.SetNamedBodiesFixed(TRUE,Rider.BloodMountFixedBoneList,Rider.Mesh,TRUE);
		Rider.Mesh.PhysicsAssetInstance.SetNamedMotorsAngularPositionDrive(TRUE, TRUE, Rider.BloodMountFixedBoneList, Rider.Mesh, TRUE);
	}

	Rider.StopAllAnimations();
	// Wake up rigid body
	Rider.Mesh.WakeRigidBody();

	// Enable full physics on body
	Rider.Mesh.PhysicsWeight = 1.f;

	// always reduce constraints here cuz it looks better to be less flippityfloppity on the back of the bloodmount
	ReduceConstraintLimits();

	// make sure we're going the slow speed since he's still strapped to my back!
	GroundSpeed = DefaultGroundSpeed;

	// disable timer that destroys dead guys so he doesn't get cleaned up when you look away
	Rider.ClearTimer();

	SetTimer(RandRange(2,6),FALSE,nameof(DetachDeadDriver));

	ApplyImpulse = GetImpactPhysicsImpulse(GearDamageType, HitLoc, Rider.TearOffMomentum, HitInfo);
	if( !IsZero(ApplyImpulse) )
	{
		Rider.Mesh.AddImpulse(ApplyImpulse*1.5f, HitLoc, HitInfo.BoneName);
	}
	Driver = Rider;
}

simulated function DetachDeadDriver()
{
	if( Driver != none && Driver.Mesh.PhysicsAssetInstance != None )
	{
		// un-fix the proper bones
		Driver.Mesh.PhysicsAssetInstance.SetNamedBodiesFixed(FALSE,Driver.BloodMountFixedBoneList,Driver.Mesh,FALSE);
		Driver.Mesh.PhysicsAssetInstance.SetNamedMotorsAngularPositionDrive(FALSE, FALSE, Driver.BloodMountFixedBoneList, Driver.Mesh, FALSE);
		Driver.SetBase(None);
		Driver.SetHardAttach(FALSE);
		Driver.Mesh.SetShadowParent( None );
	}
}

simulated function EjectDriver()
{
	if( Driver != None && Driver.Base == Self )
	{
		DoEjectDriver();
	}
}

simulated function DoEjectDriver()
{
	local GearPawn	OldDriver;
	local vector	Impulse;
	local int i;
	local MeshComponent MeshComp;

	OldDriver = Driver;
	OldDriver.SetBase(None);
	OldDriver.SetHardAttach(FALSE);
	OldDriver.SetPhysics(PHYS_Falling);
	OldDriver.SetCollision(TRUE, TRUE);
	OldDriver.bCollideWorld = TRUE;
	OldDriver.Mesh.SetShadowParent( None );
	OldDriver.bCanDBNO = OldDriver.default.bCanDBNO;
	// Reset mesh translation when driver ragdolls
	OldDriver.Mesh.SetTranslation( OldDriver.default.Mesh.Translation );

	OldDriver.Mesh.SetLightEnvironment(OldDriver.LightEnvironment);
	for (i = 0; i < OldDriver.Mesh.Attachments.Length; i++)
	{
		MeshComp = MeshComponent(OldDriver.Mesh.Attachments[i].Component);
		if (MeshComp != None)
		{
			MeshComp.SetLightEnvironment(OldDriver.LightEnvironment);
		}
	}
	OldDriver.LightEnvironment.SetEnabled(TRUE);

	Impulse = Velocity;
	if( VSizeSq(Velocity) < 100.f )
	{
		Impulse += vector(Rotation) * 100.0f;
	}

	OldDriver.bInvalidMeleeTarget = TRUE;
	if( OldDriver.Health <= 0 )
	{
		OldDriver.PlayRagDollDeath(None, OldDriver.Location, FALSE);
		// start the cleanup timer
		OldDriver.SetTimer(2.0f,true);
	}
	else
	{
		OldDriver.Knockdown(Impulse * 1.25f + vect(0,0,150), VRand() * 15.f);
	}
}

function DoSwipeAttackDamage()
{
	local GearWeap_BloodMountMelee	Wpn;
	local float Tolerance, DotP;
	local actor HitActor;
	local vector Start, End;
	local GearPawn EnemyGP;
	local ImpactInfo FirstHitInfo;
	local GearPC PC;

	if( IsDoingSpecialMove(GSM_BloodMount_Melee) )
	{
		Wpn = GearWeap_BloodMountMelee(Weapon);
		Tolerance = GetAIMeleeAttackRange();
		Tolerance += (Controller.Enemy != None) ? (Controller.Enemy.GetCollisionRadius() * 1.5) : 55.0;

		if( Wpn != None )
		{
			PlayAttackSound();

			Start = Location;
			Start.Z -= 10.0; // need to be a bit lower so we can hit DBNO enemies
			End = Start + vector(Rotation) * Tolerance;
			Start += Normal(End-Start) * GetCollisionRadius();

			FirstHitInfo = Wpn.CalcWeaponFire(Start, End,, vect(25.f,25.f,25.f));
			HitActor = FirstHitInfo.HitActor;

			EnemyGP = GearPawn(Controller.Enemy);
			if( EnemyGP != None && EnemyGP.IsAKidnapper() && (HitActor == EnemyGP || HitActor == EnemyGP.InteractionPawn) )
			{
				DotP = Normal(Location-EnemyGP.Location) DOT Vector(EnemyGP.Rotation);
				if( DotP < 0 )
				{
					HitActor = EnemyGP;
				}
				else
				{
					HitActor = EnemyGP.InteractionPawn;
				}
			}

			if (HitActor != None && !HitActor.bWorldGeometry)
			{
				Wpn.DoMeleeDamage(HitActor, FirstHitInfo.HitLocation, 1.0);
				Wpn.PlayMeleeScreenShake(GearPawn(HitActor));
				PC = GearPC(Controller);
				if (PC != None)
				{
					PC.ClientPlayForceFeedbackWaveform(class'GearWaveForms'.default.MeleeHit);
				}
				if (Pawn(HitActor) != None)
				{
					PC = GearPC(Pawn(HitActor).Controller);
					if (PC != None)
					{
						PC.ClientPlayForceFeedbackWaveform(class'GearWaveForms'.default.MeleeHit);
					}
				}
			}
		}
	}
}

/**
 * Handler for AssignInterpPath action, that tells bloodmount about its interpolation path.
 *
 * @param AssignInterpPathAction - the kismet action assigning the interpolation path
 */
simulated function OnAssignInterpPath(SeqAct_AssignInterpPath AssignInterpPathAction)
{
	local Array<InterpData> IDataArray;
	local int idx;
	local InterpData IData;

	InterpGroupName = AssignInterpPathAction.InterpGroupName;

	AssignInterpPathAction.GetInterpDataVars(IDataArray,"InterpPath");

	for (idx = 0; idx < IDataArray.Length; idx++)
	{
		IData = IDataArray[idx];
		if (IData != None)
		{
			InterpPath = IData;

			// Start interpolating and disable simulated position updates
			SetPhysics(PHYS_Interpolating);
			bUpdateSimulatedPosition=FALSE;

			return;
		}
	}
}

function PossessedBy(Controller C, bool bVehicleTransition)
{
	if ( PlayerController(C) != None )
	{
		DefaultGroundSpeed = DefaultGroundSpeed_Siege;
		ChargeSpeed = ChargeSpeed_Siege;
	}

	Super.PossessedBy(C, bVehicleTransition);
}

simulated function StartFire(byte FireModeNum)
{
	if (FireModeNum == class'GearWeapon'.const.DEFAULT_FIREMODE)
	{
		if (!IsDoingSpecialMove(GSM_BloodMount_Melee))
		{
			// Default fires for bloodmounts also result in melee attacks.
			StartMeleeAttack();
		}
	}
	else
	{
		Super.StartFire(FireModeNum);
	}
}

function SetGroundSpeedModifier(float NewModifier)
{
	GroundSpeed = (IsDoingSpecialMove(SM_RoadieRun) ? ChargeSpeed : DefaultGroundSpeed) * NewModifier;
}

defaultproperties
{
	bCanSwim=FALSE
	bCanClimbLadders=FALSE
	bCanDBNO=false
	//bNoEncroachCheck=TRUE

	PeripheralVision=-0.5f

	JumpZ=2500.f

	PelvisBoneName=none
	DriverSocket="Driver"
	SightBoneName=none

	Begin Object Name=CollisionCylinder
		CollisionRadius=+0050.000000
	End Object

	SpecialMoveClasses(SM_BloodMount_HitInFace)=class'GSM_BloodMount_HitInFace'
	SpecialMoveClasses(SM_MidLvlJumpOver)=class'GSM_BloodMount_MantleOverCover'
	SpecialMoveClasses(GSM_BloodMount_Melee)=class'GSM_BloodMount_Melee'
	SpecialMoveClasses(GSM_Leap)=class'GSM_BloodMount_Leap'
	ActionSpecialMoves.Add(SM_MidLvlJumpOver)
	bRespondToExplosions=false

	SpecialMoveClasses(SM_CQC_Victim)				=None
	SpecialMoveClasses(SM_CQCMove_CurbStomp)		=None
	SpecialMoveClasses(SM_CQCMove_PunchFace)		=None
	SpecialMoveClasses(SM_ChainSawHold)				=None
	SpecialMoveClasses(SM_ChainSawAttack)			=None
	SpecialMoveClasses(SM_ChainSawVictim)			=None
	SpecialMoveClasses(SM_RoadieRun)=class'GSM_RoadieRun_Bloodmount'

	AmbientTimeRange=(x=1.0,y=5.0)

	// remove this and spawn dynamically so all infantry don't get this comp
	Begin Object Class=StaticMeshComponent Name=HeadSlotStaticMesh0
		CollideActors=FALSE
		BlockRigidBody=FALSE
		HiddenGame=TRUE
		AlwaysLoadOnClient=TRUE
		bCastDynamicShadow=FALSE
		LightEnvironment=MyLightEnvironment
		MotionBlurScale=0.0
	End Object
	HeadSlotStaticMesh=HeadSlotStaticMesh0

	NoticedGUDSPriority=120
	NoticedGUDSEvent=GUDEvent_NoticedBloodmounts

	AimAttractors(0)=(OuterRadius=90.f,InnerRadius=50.f,BoneName="spine2")
	AimAttractors(1)=(OuterRadius=40.f,InnerRadius=24.f,BoneName="head")

	MPHeadRadius=20

	RoarInterval=(X=2.0,Y=8.0)

	BS_JumpStance=(Stance=((Slot=BS_FullBody,AnimName="Mantle_Start")))
}
