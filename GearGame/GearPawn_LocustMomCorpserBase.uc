
/**
 * GearPawn_LocustMomCorpserBase
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearPawn_LocustMomCorpserBase extends GearPawn_LocustCreatureBase
	implements(Interface_AIAimLocationOverride)
	implements(Interface_AIAttackWarning)
	native(Pawn)
	config(Pawn)
	abstract;


/** Constants which will map a component on the mesh to a byte value for client-side-hit-detection (0 is reserved for no component) */
const COMPONENT_HIT_LeftEye = 1;
const COMPONENT_HIT_RightEye = 2;
const COMPONENT_HIT_LeftMidEye = 3;
const COMPONENT_HIT_RightMidEye = 4;

/*****************************************************************************
	Other misc variables
 *****************************************************************************/

/** Desired rotation to reach with Root Rotation */
var repnotify int DesiredYawRootRotation;

/** List of objects we already bust through so we don't collide more than once */
var array<Actor> ChargeHitList;

/** Camera shake for charging into a wall */
var() protected const GearCameraShake ChargeHitWallCameraShake;
var() protected const float ChargeHitWallCameraShakeInnerRadius;
var() protected const float ChargeHitWallCameraShakeOuterRadius;


/** Collision component to stop player from walking behind corpser */
var() StaticMeshComponent ObstructionComponent;

/** Eyeball attachments */
var StaticMeshComponent	LeftEyeSM, LeftMidEyeSM, RightEyeSM, RightMidEyeSM;

/** Enum of the eyes */
enum ECorpserEye
{
	ECORPSEREYE_Left,
	ECORPSEREYE_Right,
	ECORPSEREYE_LeftMid,
	ECORPSEREYE_RightMid,
};

/** Structure to hold data for the eyes */
struct native CorpserEyeData
{
	var StaticMeshComponent EyeMesh;
	var transient MaterialInstanceTimeVarying MIC_Eye;
	var ParticleSystemComponent EyeDamageEffect;
	var Name SocketName;
};

/** Array of eye data for the 4 eyes */
var array<CorpserEyeData> EyeData;

/** Array of eye health */
var repnotify float LeftEyeHealth;
var repnotify float RightEyeHealth;
var repnotify float LeftMidEyeHealth;
var repnotify float RightMidEyeHealth;

var repnotify bool  bLeftEyeOpen;
var repnotify bool  bRightEyeOpen;
var repnotify bool  bLeftMidEyeOpen;
var repnotify bool  bRightMidEyeOpen;

var InterpCurveFloat EyeOpenCurve, EyeClosedCurve;


/** Amount of health each eyeball has */
var config float HealthPerEye;

/** The audio component to keep a reference to the eye damage sound */
var AudioComponent EyeTakingDamageAC;
/** Sound when the eye is taking damage */
var const SoundCue EyeTakingDamageSound;

/** The hit effect when the eye gets shot out */
var ParticleSystem PS_EyeDamage;

/** List of foot bone names */
var array<Name> FootNames;

/** Death explosion template */
var GearExplosion FootExplosionTemplate;
var GearExplosion SmallFootstepExplosionTemplate;

/** Foot sound cues */
var SoundCue FootStepCue;
var SoundCue FootStepPoundCue;

/** Single arm attack raises **/
var SoundCue ArmRaiseRoar;
/** Single arm attack impacts ground or player **/
var SoundCue ArmAttackImpact;
/** Four arm attack slams on ground causing earthquake **/
var SoundCue StompAttackImpact;
/** Vocal sound for Four arm attack, trigger before, after, during ??? **/
var SoundCue StompAttackVocal;
/** Earth cracking + rumble caused by Four arm attack slam **/
var SoundCue PostStompAttackRumble;


/** Whether the corpser is rampaging */
var bool bIsRampaging;
/** If Corpser should push away players near him */
var transient bool bPushAwayPlayers;


struct native AttackZoneInfo
{
	/** Near right corner (from corpser perspective) */
	var Vector Min;
	/** Far left corner (from corpser perspective) */
	var Vector Max;

	/** Patterns that can be used to attack this zone */
	var() array<int>	PatternList;
};
/** List of zones that can be attacked */
var array<AttackZoneInfo>	AttackZones;

var()   float   AttackZoneWidth;
/** Offset forward to start of attack box */
var()	float	AttackZoneFwdOffset;

struct native LegAttackDelay
{
	/** Leg number for this attack section */
	var()	int			LegIdx;
	/** Amount of time after previous leg to start moving this leg */
	var()	float		Delay;
	/** Offset from target location for this leg to IK */
	var()	Vector		Offset;
	/** Amount of time pre attack for leg to stay up */
	var()	float		TelegraphTime;
	/** Amount of time for leg to stay in ground on impact */
	var()	float 		StayInGroundTime;
	/** Amount of time post attack for leg to stay up */
	var()	float		RetractHoldTime;

	/** WorldInfo.TimeSeconds >= Attack time triggers this leg to start attack */
	var		float		AttackTime;
	/** IK location that will be given to this leg */
	var		Vector		StabLocation;
	/** Attack actor */
	var		Actor		StabActor;

	structdefaultproperties
	{
		TelegraphTime=0.35f
		StayInGroundTime=0.15f
		RetractHoldTime=0.15f
	}
};
struct native LegAttackPattern
{
	var() array<LegAttackDelay>	Legs;
};
var() array<LegAttackPattern> Patterns;
var() int PatternIdx;
var() int PatternLegIdx;

/** Replicated Leg Attack structure */
struct native LegAttack
{
	var	byte	AttackCount;
	var	Vector	IKLocation;
	var Vector	Direction;
	var Actor	TargetActor;
};

var()	repnotify	LegAttack	AttackingLegs[6];
var	transient	LegAttack	LastAttackingLegs[6];

/** used to replicate to clients when to stop stab attack */
var repnotify byte StopStabAttackCount;

/** Stab Attack Leg Information */
struct native LegIKInfo
{
	/** TRUE if Leg is doing a stab attack. FALSE if it is idle. */
	var transient	bool			bIsAttacking;
	/** World IK Controller Name */
	var	const		Name			WorldIKName;
	/** World IK Controller */
	var transient	SkelControlLimb	WorldIKCtrl;
	/** Bone IK Controller Name */
	var const		Name			BoneIKName;
	/** Bone IK Controller */
	var transient	SkelControlLimb	BoneIKCtrl;
	/** Name of slot to play animations on */
	var const		Name			SlotName;
	/** Cached Slot node */
	var transient	GearAnim_Slot	SlotNode;
};
var	Array<LegIKInfo>	LegsIKInfo;

/** Stab Attack animations */
var	const	Name	AnimStabIntro_Start, AnimStabIntro_Loop, AnimStabIntro_End, AnimStab_Loop;
var	const	Name	AnimStabOutro_Start, AnimStabOutro_Loop, AnimStabOutro_End;
var const	Name	AnimStabBody_Intro, AnimStabBody_Hold, AnimStabBody_Outro;
var         float   AttackAnimRate;

/** List of encroachment actors attached to leg tips */
var	array<MomCorpser_Encroacher>	Encroachers;

var() config int	StabAttackDamage;
var() config float	StabAttackRadius;
var() config int    StompAttackDamage;
var() config float	StompAttackRadius;
var() Vector WarnAttackLocation;

/** Turn in place node */
var GearAnim_TurnInPlace TurnInPlaceNode;

/** Whether to use more relaxed walk instead of hunkered down version */
var repnotify bool bOpenWalkAnim;

var protected AIAvoidanceCylinder AvoidanceCylinder;
var float                         AvoidRadius;

/** Base blend node */
var AnimNodeSlot	StandIdleNode;

cpptext
{
	virtual UBOOL ShouldTrace(UPrimitiveComponent* Primitive,AActor *SourceActor, DWORD TraceFlags);
	virtual UBOOL IgnoreBlockingBy(const AActor *Other) const;
};

replication
{
	if (bNetDirty)
		DesiredYawRootRotation, LeftEyeHealth, RightEyeHealth, LeftMidEyeHealth, RightMidEyeHealth, bIsRampaging,
		AttackingLegs, PatternIdx, PatternLegIdx, StopStabAttackCount,
		bLeftEyeOpen, bRightEyeOpen, bLeftMidEyeOpen, bRightMidEyeOpen,
		bOpenWalkAnim;

}

/** replicated event */
simulated event ReplicatedEvent(Name VarName)
{
	switch( VarName )
	{
		case 'DesiredYawRootRotation':
			DesiredRootRotationUpdated();
			return;
		case 'AttackingLegs':
			AttackingLegsChanged();
			break;
		case 'StopStabAttackCount':
			StopStabAttack();
			break;
		case 'bLeftEyeOpen':
		case 'bRightEyeOpen':
		case 'bLeftMidEyeOpen':
		case 'bRightMidEyeOpen':
			EyeStatusChanged();
			break;
		case 'bOpenWalkAnim':
			SetOpenWalkAnim( bOpenWalkAnim );
			break;
		default:
	}

	Super.ReplicatedEvent(VarName);
}

simulated function CacheAnimNodes()
{
	local int		i;
	local AnimNode	Node;

	Super.CacheAnimNodes();

	foreach Mesh.AllAnimNodes(class'AnimNode', Node)
	{
		if( Node.NodeName == '' )
		{
			continue;
		}

		if( Node.NodeName == 'TurnInPlace' )
		{
			TurnInPlaceNode = GearAnim_TurnInPlace(Node);
		}

		for(i=0; i<LegsIKInfo.Length; i++)
		{
			// Cache AnimSlot nodes
			if( Node.NodeName == LegsIKInfo[i].SlotName )
			{
				LegsIKInfo[i].SlotNode = GearAnim_Slot(Node);
			}
		}
	}

	// Cache IK Controllers
	for(i=0; i<LegsIKInfo.Length; i++)
	{
		LegsIKInfo[i].WorldIKCtrl	= SkelControlLimb(Mesh.FindSkelControl(LegsIKInfo[i].WorldIKName));
		LegsIKInfo[i].BoneIKCtrl	= SkelControlLimb(Mesh.FindSkelControl(LegsIKInfo[i].BoneIKName));
	}

	StandIdleNode = BodyStanceNodes[BS_Std_Idle_Lower];
}

/** Clear references to anim nodes. */
simulated function ClearAnimNodes()
{
	local int i;

	Super.ClearAnimNodes();

	TurnInPlaceNode = None;

	for(i=0; i<LegsIKInfo.Length; i++)
	{
		LegsIKInfo[i].WorldIKCtrl	= None;
		LegsIKInfo[i].BoneIKCtrl	= None;
		LegsIKInfo[i].SlotNode		= None;
	}
}


final function bool IsTurningInPlace()
{
	if( TurnInPlaceNode != None && TurnInPlaceNode.bPlayingTurnTransition )
	{
		return TRUE;
	}
	return FALSE;
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	SetupAvoidanceCylinder();
}


simulated function Destroyed()
{
	local int Idx, Num;

	super.Destroyed();

	Num = Encroachers.Length;
	for( Idx = 0; Idx < Num; Idx++ )
	{
		Encroachers[Idx].Destroy();
	}
	Encroachers.Length = 0;

	if(AvoidanceCylinder != none)
	{
		AvoidanceCylinder.Destroy();
		AvoidanceCylinder = none;
	}
}

function SetupAvoidanceCylinder()
{
	AvoidanceCylinder = Spawn(class'AIAvoidanceCylinder',self,,Location,,,TRUE);
	if( AvoidanceCylinder != None )
	{
		AvoidanceCylinder.SetBase( self );
		AvoidanceCylinder.SetCylinderSize( AvoidRadius, AvoidRadius * 2.0f );
		AvoidanceCylinder.SetDontAffectMesh( FALSE );
		AvoidanceCylinder.SetEnabled( FALSE );
		AvoidanceCylinder.SetAvoidanceTeam( TEAM_COG );
	}
}

function SetAvoidanceCylActive( bool bActive )
{
	if( AvoidanceCylinder.bEnabled != bActive )
	{
		AvoidanceCylinder.SetEnabled( bActive );
	}
}


// hack to prevent encroachers from getting stuck on stuff in the level
function ResetEncroachers()
{
	local int Idx;

	for( Idx = 0; Idx < Encroachers.Length; Idx++ )
	{
		Encroachers[Idx].SetRelativeLocation(vect(0,0,0));
	}
}


/** A pawn specific way of handling what component was hit on the pawn */
simulated function byte GetPawnSpecificComponentHitType(PrimitiveComponent Component)
{
	if (Component == LeftEyeSM)
	{
		return COMPONENT_HIT_LeftEye;
	}
	else if (Component == RightEyeSM)
	{
		return COMPONENT_HIT_RightEye;
	}
	else if (Component == LeftMidEyeSM)
	{
		return COMPONENT_HIT_LeftMidEye;
	}
	else if (Component == RightMidEyeSM)
	{
		return COMPONENT_HIT_RightMidEye;
	}

	return Super.GetPawnSpecificComponentHitType(Component);
}

/** Handle pawn specific way of handling the component that was hit on the pawn */
function HandleServerSideComponentRemap(out ImpactInfo Impact, byte HitType)
{
	switch (HitType)
	{
	case COMPONENT_HIT_LeftEye:
		Impact.HitInfo.HitComponent = LeftEyeSM;
		break;
	case COMPONENT_HIT_RightEye:
		Impact.HitInfo.HitComponent = RightEyeSM;
		break;
	case COMPONENT_HIT_LeftMidEye:
		Impact.HitInfo.HitComponent = LeftMidEyeSM;
		break;
	case COMPONENT_HIT_RightMidEye:
		Impact.HitInfo.HitComponent = RightMidEyeSM;
		break;
	}
}

/** Can't be special melee attacked **/
simulated function bool CanBeSpecialMeleeAttacked(GearPawn Attacker);

/** Returns TRUE if this Pawn can be chainsaw attacked */
simulated function bool CanBeChainsawAttacked();

/** Returns TRUE if this Pawn can be chainsaw attacked */
simulated function bool CanBeBayonetAttacked();

/** returns TRUE if this pawn shoudl be evaded instead of meleed against */
function bool ShouldOtherEvadeMeInsteadOfMeleeing(GearPawn Other)
{
	return TRUE;
}

/** Sets Target Root Rotation */
simulated final function SetDesiredRootRotation(Rotator Rot)
{
	// Yaw from -32768 to +32767
	DesiredYawRootRotation = NormalizeRotAxis(Rot.Yaw);
	DesiredRootRotationUpdated();
}

/** Clears Desired Root Rotation */
simulated final function ClearDesiredRootRotation()
{
	DesiredYawRootRotation = 65535;	// indicates no rotation.
	DesiredRootRotationUpdated();
}

/** Returns TRUE if Pawn has a DesiredRootRotation set. */
simulated final function bool HasValidDesiredRootRotation()
{
	return (DesiredYawRootRotation != 65535);
}

/** Event called when DesiredRootRotation has been updated */
simulated function DesiredRootRotationUpdated()
{
	if (HasValidDesiredRootRotation())
	{
		// If already doing the charge special move,
		// We now have a proper direction, so let's start charging!
		if (IsDoingSpecialMove(SM_Corpser_Charge))
		{
			GSM_MomCorpser_Charge(SpecialMoves[SM_Corpser_Charge]).StartCharging();
		}
	}
}

/** Whether or not the berserker can melee right now */
simulated function bool CanEngageMelee()
{
	if (IsDoingSpecialMove(SM_Corpser_Charge) ||
		IsDoingSpecialMove(SM_Corpser_Hurt) ||
		IsDoingSpecialMove(SM_Corpser_Stomp) ||
		IsDoingSpecialMove(SM_Corpser_Stab))
	{
		return false;
	}

	return true;
}

/** Play the berserker's special move for meleeing */
simulated function StartMeleeAttack()
{
	local GearAI AI;

	AI = GearAI(Controller);
	if (AI != None)
	{
		class'AICmd_Attack_MomCorpser_Stomp'.static.InitCommand(AI);
	}
}

/** Berserker ignores stopping power */
function HandleStoppingPower(class<GearDamageType> GearDamageType, Vector Momentum, float DmgDistance);

/** Overridden to handle the Corpser's unique damage system */
event TakeDamage(int Damage, Controller instigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	local int EyeIdx;
	local int OriginalDamage;
	local bool bDidDamage;
	local GearAI_MomCorpser AI;
	local bool bKilledEye;

	OriginalDamage = Damage;
	Damage = 0;

	AI = GearAI_MomCorpser(Controller);

	// Conditionally do damage
	if( ShouldTakeDamage(HitLocation, HitInfo) )
	{
		// Make sure there the corpser is still alive
		if (Mesh != None && IsAlive() && GetTeamNum() != instigatedBy.GetTeamNum() )
		{
			// See if it hit an eyeball
			for (EyeIdx = 0; EyeIdx < EyeData.Length; EyeIdx++)
			{
				if (EyeData[EyeIdx].EyeMesh == HitInfo.HitComponent)
				{
					switch (EyeIdx)
					{
						case ECORPSEREYE_Left:
							if( LeftEyeHealth > 0 && bLeftEyeOpen )
							{
								LeftEyeHealth -= OriginalDamage;
								bDidDamage = TRUE;
								bKilledEye = UpdateLeftEyeStatus( TRUE );
							}
							break;
						case ECORPSEREYE_Right:
							if( RightEyeHealth > 0 && bRightEyeOpen )
							{
								RightEyeHealth -= OriginalDamage;
								bDidDamage = TRUE;

								bKilledEye = UpdateRightEyeStatus( TRUE );
							}
							break;
						case ECORPSEREYE_LeftMid:
							if( LeftMidEyeHealth > 0 && bLeftMidEyeOpen )
							{
								LeftMidEyeHealth -= OriginalDamage;
								bDidDamage = TRUE;

								bKilledEye = UpdateLeftMidEyeStatus( TRUE );
							}
							break;
						case ECORPSEREYE_RightMid:
							if( RightMidEyeHealth > 0 && bRightMidEyeOpen )
							{
								RightMidEyeHealth -= OriginalDamage;
								bDidDamage = TRUE;

								bKilledEye = UpdateRightMidEyeStatus( TRUE );
							}
							break;
					}
					if( bDidDamage )
					{
						Damage = 1;
					}
				}
			}
		}

		if( bDidDamage )
		{
			SetOpenWalkAnim( FALSE );
		}

		// Do the damage
		Super.TakeDamage(Damage, instigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);

		if( bKilledEye && AI != None && InstigatedBy.Pawn != None )
		{
			AI.NotifyLostEye( InstigatedBy.Pawn );
		}
	}
	else if( ClassIsChildOf( DamageType, class'GDT_Explosive' ) && HitInfo.PhysMaterial.Name == 'Corpser_Flesh' )
	{
		if( !IsDoingSpecialMove( SM_Corpser_Hurt ) && `TimeSince( LastMeleeAttackTime ) > 3.f )
		{
			if( AI != None && InstigatedBy != None )
			{
				AI.AbortCommand( AI.CommandList );
				AI.DoMeleeAttack( instigatedBy.Pawn );
			}
		}
	}
}

simulated function SetOpenWalkAnim( optional bool bOpen = TRUE )
{
	ClearTimer( nameof(SetOpenWalkAnim) );

	if( Role == ROLE_Authority && IsDoingASpecialMove() )
	{
		SetTimer( 0.25f );
	}

	if( !bOpen )
	{
		bOpenWalkAnim = FALSE;
//		Mesh.RootMotionMode = RMM_Accel;

		if( Role == ROLE_Authority )
		{
			SetTimer( 1.f + FRand() * 3.f, FALSE, nameof(SetOpenWalkAnim) );
		}
	}
	else
	{
		bOpenWalkAnim = TRUE;
//		Mesh.RootMotionMode = default.Mesh.RootMotionMode;
	}
}

/** plays client-side hit effects using the data in LastTakeHitInfo */
simulated function ReplicatedPlayTakeHitEffects()
{
	DoEyeDamageEffect();

	// Play damage sound
	if( EyeTakingDamageAC != None )
	{
		EyeTakingDamageAC.Play();
	}

	Super.ReplicatedPlayTakeHitEffects();
}

/** Plays the "took damage to eye" effect */
simulated function DoEyeDamageEffect()
{
	local int Idx;
	local float ClosestDist;
	local int ClosestIdx;
	local float Dist;
	local vector EyeLocation;
	local bool bKillEye;

	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		ClosestDist = 999999;
		for (Idx = 0; Idx < EyeData.Length; Idx++)
		{
			Mesh.GetSocketWorldLocationAndRotation(EyeData[Idx].SocketName, EyeLocation);
			Dist = VSize(EyeLocation - LastTakeHitInfo.HitLocation);
			if (Dist < ClosestDist)
			{
				ClosestDist = Dist;
				ClosestIdx = Idx;
			}
		}

		if (EyeData[ClosestIdx].EyeMesh != None)
		{
			Switch (ClosestIdx)
			{
				case ECORPSEREYE_Left: bKillEye = (LeftEyeHealth <= 0); break;
				case ECORPSEREYE_Right: bKillEye = (RightEyeHealth <= 0); break;
				case ECORPSEREYE_LeftMid: bKillEye = (LeftMidEyeHealth <= 0); break;
				case ECORPSEREYE_RightMid: bKillEye = (RightMidEyeHealth <= 0); break;
			}
			if (bKillEye)
			{
				if (Role == ROLE_Authority)
				{
					// Trigger events for losing an eye
					TriggerEventClass(class'SeqEvt_CorpserEvent', self, ClosestIdx);
					if (!IsAlive())
					{
						TriggerEventClass(class'SeqEvt_CorpserEvent', self, 4);
					}
				}
				EyeData[ClosestIdx].EyeDamageEffect = new(self) class'ParticleSystemComponent';
				Mesh.AttachComponentToSocket(EyeData[ClosestIdx].EyeDamageEffect, EyeData[ClosestIdx].SocketName);
				EyeData[ClosestIdx].EyeDamageEffect.SetTemplate(PS_EyeDamage);
				EyeData[ClosestIdx].EyeDamageEffect.ActivateSystem(FALSE);
				Mesh.DetachComponent(EyeData[ClosestIdx].EyeMesh);
				EyeData[ClosestIdx].EyeMesh = None;
			}
		}
	}
}

/** Whether the corpser still has life (doesn't use health) */
simulated function bool IsAlive()
{
	return (LeftEyeHealth > 0 || RightEyeHealth > 0 || LeftMidEyeHealth > 0 || RightMidEyeHealth > 0);
}

/** Whether the berserker should take damage or not */
simulated function bool ShouldTakeDamage(vector HitLocation, optional TraceHitInfo HitInfo)
{
	local int EyeIdx;

	// Make sure there the corpser is still alive
	if (Mesh != None && IsAlive())
	{
		// See if it hit an eyeball
		for (EyeIdx = 0; EyeIdx < EyeData.Length; EyeIdx++)
		{
			if (EyeData[EyeIdx].EyeMesh == HitInfo.HitComponent)
			{
				return true;
			}
		}
	}

	return false;
}

/**
 *  Impact Effects are handled in TakeDamage->DoDamageEffects. But only if there damage done.
 *  If there is no damage done, but you still want an impact effect to be played, return TRUE here.
 */
simulated function bool ShouldPlayNonDamageHitEffects(const out ImpactInfo Impact, Pawn InstigatedBy, class<DamageType> InDamageType)
{
	if (ShouldTakeDamage(Impact.HitLocation, Impact.HitInfo))
	{
		return false;
	}

	return true;
}

/** The berserker started charging so handle any effect, sounds, etc. needed */
simulated function StartedChargingNotify()
{
}

/** The berserker stopped charging so handle any effect, sounds, etc. needed */
simulated function StoppedChargingNotify()
{
}

/** Override to handle special berserker functionality */
simulated event Bump(Actor Other, PrimitiveComponent OtherComp, Vector HitNormal)
{
	// Call our special notification
	NotifyCollideWithActor(HitNormal, Other);
	Super.Bump(Other, OtherComp, HitNormal);
}

/** Override to handle special berserker functionality */
event HitWall( vector HitNormal, actor Wall, PrimitiveComponent WallComp )
{
	// Call our special notification
	NotifyCollideWithActor(HitNormal, Wall);
	Super.HitWall(HitNormal, Wall, WallComp);
}

/** Notification that the berserker has collided with an actor somehow */
function bool NotifyCollideWithActor(Vector HitNormal, Actor Other)
{
	local int Idx;
	local Vector Dir;
	local Pawn OtherPawn;
	local GearPawn OtherGP;
	local GearDroppedPickup_Shield Shield;

	OtherPawn = Pawn(Other);
	Shield = GearDroppedPickup_Shield(Other);

	// If she collided with a KActor don't do anything
	if (KActor(Other) != None)
	{
		return FALSE;
	}

	// If already charging or sliding
	if (IsDoingSpecialMove(SM_Corpser_Charge))
	{
		// Only break pillars when hitting directly
		Dir = Velocity;
		Dir.Z = 0;
		Dir = Normal(Dir);
		HitNormal.Z = 0;
		HitNormal = Normal(HitNormal);

		// If we made a direct hit or what we hit was not a pawn and isn't a wall we can adjust to
		if (Controller.MinHitWall > (Dir DOT HitNormal) ||
			(OtherPawn == None && !PickWallAdjust(HitNormal, Other)))
		{
			// See if we already have this actor in the list of charged actors
			Idx = ChargeHitList.Find(Other);
			if (Idx < 0)
			{
				OtherGP = GearPawn(OtherPawn);

				// Wasn't in the list so add it
				ChargeHitList[ChargeHitList.Length] = Other;

				// If she hit a gear pawn we need to play a hit player effect
				if( OtherGP != None )
				{
					PlayChargeHitPlayerEffect(Location, HitNormal);
					if( !OtherGP.IsDBNO() )
					{
						Other.TakeDamage(GearAI_COGGear(OtherGP.Controller) != None ? 2000.0f : 1000.f, Controller, Other.Location, vect(0,0,0), class'GDT_MomCorpser_Charge');
					}
				}
				// Else we play a hit wall effect
				else
				{
					PlayChargeHitWallEffect(Location, HitNormal);
					Other.TakeDamage(2000.0f, Controller, Other.Location, vect(0,0,0), class'GDT_MomCorpser_Charge');
				}

						// Let her plow through planted shields
				if( Shield != None && Shield.bDeployed )
				{
					Shield.KickOver();
				}
				else
				{
					// Let the pawn know we are no longer charging so it can perform any effects or sounds necessary
					StoppedChargingNotify();
				}
			}

			return TRUE;
		}
	}
	// She's not charging
	else
	{
		// Kick over any planted shields
		if( Shield != None && Shield.bDeployed )
		{
			StartMeleeAttack();

			Shield.KickOver();
		}
	}

	return FALSE;
}

/**
 * A large dust impact for when she slams into the wall after missing a charge attack and becomes dazed.
 *	Should play from the point of impact with the X axis facing in towards her.
 **/
simulated function PlayChargeHitWallEffect( vector HitLocation, vector HitNormal )
{
	local GearPC PC;

// 	// Play not one but TWO sounds for hitting a wall
// 	PlaySound(HitWallImpactSound1);
// 	// Spawn an effect for hitting a wall
// 	WorldInfo.MyEmitterPool.SpawnEmitter(PS_ChargeHitWall, HitLocation, rotator(HitNormal));

	// Force feedback if I AM the berserker
	PC = GearPC(Controller);
	if (PC != None)
	{
		PC.ClientPlayForceFeedbackWaveform(class'GameWaveForms'.default.CameraShakeMediumLong);
	}
}

/** Returns whether the actor is something she can smash through */
function bool ActorIsBustable(Actor TestActor)
{
	return ((TestActor != None && TestActor.Tag == 'Bustable') ||
		GearMeleeTarget(TestActor) != None ||
		GearDestructibleObject(TestActor) != None);
}

/** Accessor for whether the pawn can strafe or not (used so we can have situationaly strafing */
function bool CanStrafe()
{
	if (IsDoingSpecialMove(SM_Corpser_Charge))
	{
		return true;
	}
	return bCanStrafe;
}

/**
 * A light dust cloud to be played when she makes contact with the player in her charge.
 *	Should play from the point of impact with the X axis facing in towards her.
 **/
simulated function PlayChargeHitPlayerEffect( vector HitLocation, vector HitNormal )
{
// 	// Do the hit player effect
// 	WorldInfo.MyEmitterPool.SpawnEmitter(PS_ChargeHitPlayer, HitLocation, rotator(HitNormal));
// 	// Play a sound for the effect
// 	PlaySound(HitPlayerImpactSound);
// 	// Play voice sound
// 	if (VoiceHitPlayerSound != None)
// 	{
// 		PlaySound(VoiceHitPlayerSound);
// 	}

	// Shake the camera for wall hits
	class'GearPlayerCamera'.static.PlayWorldCameraShake(ChargeHitWallCameraShake, self, Location, ChargeHitWallCameraShakeInnerRadius, ChargeHitWallCameraShakeOuterRadius, 1.3f, true );
}

/** Event from c++ land that tells us to play a footstep */
simulated event PlayFootStepSound(int FootDown)
{
	local vector FootLocation;
	local SoundCue FootCue;

	if (Mesh != None)
	{
		FootLocation = Mesh.GetBoneLocation(FootNames[FootDown]);
		if (IsDoingSpecialMove(SM_Corpser_Hurt) && (FootDown == 0 || FootDown == 7))
		{
			FootCue = FootStepPoundCue;
		}
		else if (IsDoingSpecialMove(SM_Corpser_Stomp) && (FootDown >= 2 && FootDown <= 5))
		{
			FootCue = FootStepPoundCue;
		}
		else
		{
			FootCue = FootStepCue;
		}
		PlaySound(FootCue, true,,,FootLocation);
	}
}


final function GetAttackColInfo( out float out_ColSize, out float out_Width )
{
	out_Width   = AttackZoneWidth;
	out_ColSize = (out_Width * 2.f) / 3.f;	// Nudge zone out a bit to account for edges
}

final function SetupAttackZones()
{
	local int ColIdx;
	local Vector Col;
	local float ColSize, Width;

	GetAttackColInfo( ColSize, Width );

	for( ColIdx = 0; ColIdx < 3; ColIdx++ )
	{
		Col = (vect(0,1,0) * Width) - (ColIdx * ColSize * vect(0,1,0));

		AttackZones[ColIdx].Min = (vect(1,0,0) * AttackZoneFwdOffset) + Col;
		AttackZones[ColIdx].Max = AttackZones[ColIdx].Min - (ColSize * vect(0,1,0));
	}
}

final function int GetAttackZone( Vector TestPoint )
{
	local int Idx;
	local Vector Offset;

	SetupAttackZones();

	Offset = (TestPoint - Location) << Rotation;
	for( Idx = 0; Idx < AttackZones.Length; Idx++ )
	{
		//debug
		`AILog_Ext( "Test"@Idx@TestPoint, '', GearAI(Controller) );
		`AILog_Ext( "Idx"@Idx@"Min"@AttackZones[Idx].Min@"Max"@AttackZones[Idx].Max, '', GearAI(Controller) );

		if(
//			Offset.X >= AttackZones[Idx].Min.X &&
//			Offset.X <= AttackZones[Idx].Max.X &&
			Offset.Y <= AttackZones[Idx].Min.Y &&
			Offset.Y >= AttackZones[Idx].Max.Y )
		{
			return Idx;
		}
	}

	return -1;
}

final function SetPatternIdx( int NewIdx, Actor TargActor, Vector TargLoc )
{
	local float Delay;
	local int Idx;

	PatternIdx = NewIdx;
	PatternLegIdx = 0;

	Delay = 0.f;
	for( Idx = 0; Idx < Patterns[PatternIdx].Legs.Length; Idx++ )
	{
		Delay += Patterns[PatternIdx].Legs[Idx].Delay;

		Patterns[PatternIdx].Legs[Idx].AttackTime	= WorldInfo.TimeSeconds + Delay;
		Patterns[PatternIdx].Legs[Idx].StabActor	= TargActor;
		Patterns[PatternIdx].Legs[Idx].StabLocation = GetStabLocation( TargLoc, Idx );
	}
}

final simulated function Vector GetStabLocation( Vector TargLoc, int Idx )
{
	local Vector X, Y, Z;

	GetAxes( Rotation, X, Y, Z );

	return	TargLoc +
			Patterns[PatternIdx].Legs[Idx].Offset.X * X +
			Patterns[PatternIdx].Legs[Idx].Offset.Y * Y;
}

final function bool UpdateStabPattern( Actor StabVictim )
{
	local int Idx;

	if( PatternIdx < 0 ||
		PatternLegIdx >= Patterns[PatternIdx].Legs.Length )
	{
		return FALSE;
	}

	`log( WorldInfo.TimeSeconds @ GetFuncName() @ `showvar(StabVictim) );

	for( Idx = PatternLegIdx; Idx < Patterns[PatternIdx].Legs.Length; Idx++ )
	{
		if( WorldInfo.TimeSeconds < Patterns[PatternIdx].Legs[Idx].AttackTime )
		{
			break;
		}

		StartLegAttack( Patterns[PatternIdx].Legs[Idx].LegIdx, Patterns[PatternIdx].Legs[Idx].StabActor, Vector(Rotation), Patterns[PatternIdx].Legs[Idx].StabLocation );
		PatternLegIdx++;
	}

	return TRUE;
}

/** returns TRUE if leg LegIndex is currently attacking (Stab Attack) */
final simulated function bool IsLegAttacking(INT LegIndex)
{
	if( LegIndex < LegsIKInfo.Length )
	{
		return LegsIKInfo[LegIndex].bIsAttacking;
	}

	return FALSE;
}

/** returns TRUE if any leg is currently attacking */
final function bool AnyLegAttacking()
{
	local int Idx;

	for( Idx=0; Idx<LegsIKInfo.Length; Idx++ )
	{
		if( IsLegAttacking(Idx) )
		{
			return TRUE;
		}
	}

	return FALSE;
}

/** Returns the number of legs current attacking */
final function INT GetNumAttackingLegs()
{
	local int Idx, Num;

	for( Idx=0; Idx<LegsIKInfo.Length; Idx++ )
	{
		if( IsLegAttacking(Idx) )
		{
			Num++;
		}
	}

	return Num;
}


/**
 * Toggle a leg attack
 * @param	LegIndex			Leg Index from 0 to 5
 * @param	DesiredHitLocation	Location in world space where leg should strike.
 */
function StartLegAttack(INT LegIndex, Actor TargActor, Vector Dir, optional Vector DesiredHitLocation)
{
	`log( WorldInfo.TimeSeconds @ GetFuncName() @ "LegIndex:" @ LegIndex );

	if( LegIndex < LegsIKInfo.Length && !IsLegAttacking(LegIndex) )
	{
		AttackingLegs[LegIndex].AttackCount++;
		AttackingLegs[LegIndex].IKLocation	= DesiredHitLocation;
		AttackingLegs[LegIndex].TargetActor = TargActor;
		AttackingLegs[LegIndex].Direction	= Dir;

		AttackingLegsChanged();
	}
}

/** Notification called on all netmodes when a leg starts attacking */
simulated function AttackingLegsChanged()
{
	local int i;

	`log( WorldInfo.TimeSeconds @ GetFuncName() );

	for(i=0; i<LegsIKInfo.Length; i++)
	{
		// Did leg 'i' state changed since last time?
		if( AttackingLegs[i].AttackCount != LastAttackingLegs[i].AttackCount )
		{
			LegAttackStarted(i);

			// Update variable used to track changes
			LastAttackingLegs[i].AttackCount = AttackingLegs[i].AttackCount;
		}
	}

	// Force replication now
	if( Role == Role_Authority )
	{
		bNetDirty = TRUE; // because updating struct members won't set it automatically
		bForceNetUpdate = TRUE;
	}
}


/** LegNumber is starting its attack */
simulated function LegAttackStarted(INT LegIndex)
{
	`log(WorldInfo.TimeSeconds @ GetFuncName() @ "LegIndex:" @ LegIndex);

	// Play full body animation if needed
	// Don't play it if already playing Intro or Hold.
	if( !StandIdleNode.bIsPlayingCustomAnim || StandIdleNode.GetPlayedAnimation() == AnimStabBody_Outro )
	{
		StandIdleNode.PlayCustomAnim(AnimStabBody_Intro, 1.f, 0.2f, 0.f, FALSE);
		StandIdleNode.SetActorAnimEndNotification(TRUE);
	}

	// This leg is now attacking
	LegsIKInfo[LegIndex].bIsAttacking = TRUE;

	// Play Stab intro animation
	LegsIKInfo[LegIndex].SlotNode.PlayCustomAnim(AnimStabIntro_Start, AttackAnimRate, 0.2f, 0.f, FALSE);
	LegsIKInfo[LegIndex].SlotNode.SetActorAnimEndNotification(TRUE);

	// Set IK to the desired hit location.
	if( LegsIKInfo[LegIndex].WorldIKCtrl != None )
	{
		// If we have a desired strike location, use it
		if( AttackingLegs[LegIndex].IKLocation != Vect(0,0,0) )
		{
			LegsIKInfo[LegIndex].WorldIKCtrl.EffectorLocationSpace	= BCS_WorldSpace;
			LegsIKInfo[LegIndex].WorldIKCtrl.EffectorLocation		= AttackingLegs[LegIndex].IKLocation;
		}
		else
		{
			// otherwise default to using the animation
			LegsIKInfo[LegIndex].WorldIKCtrl.EffectorLocationSpace	= BCS_BoneSpace;
			LegsIKInfo[LegIndex].WorldIKCtrl.EffectorLocation		= Vect(0,0,0);
		}
	}

	// Turn encroachment off for stab attack
	Encroachers[LegIndex].SetCollision(FALSE, FALSE);
}


/** Given an AnimSequenceNode playing a leg animation, try to find which LegIndex it belongs to. */
simulated final function int FindLegIndexFromSeqNode(AnimNodeSequence SeqNode)
{
	local int			i;
	local GearAnim_Slot	SlotNode;

	for(i=0; i<LegsIKInfo.Length; i++)
	{
		SlotNode = LegsIKInfo[i].SlotNode;
		if( SeqNode == SlotNode.Children[SlotNode.CustomChildIndex].Anim )
		{
			return i;
		}
	}

	return INDEX_NONE;
}

/** Notification when an animation has stopped playing. */
simulated event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	local int LegIndex;

	`log(WorldInfo.TimeSeconds @ GetFuncName() @ SeqNode.AnimSeqName);

	// Full body animations
	if( SeqNode == StandIdleNode.Children[StandIdleNode.CustomChildIndex].Anim )
	{
		// Intro to Hold transition
		if( SeqNode.AnimSeqName == AnimStabBody_Intro )
		{
			StandIdleNode.PlayCustomAnim(AnimStabBody_Hold, 1.f, 0.1f, 0.f, TRUE);
			return;
		}
	}

	// Leg animations
	LegIndex = FindLegIndexFromSeqNode(SeqNode);
	if( LegIndex != INDEX_NONE )
	{
		switch( SeqNode.AnimSeqName )
		{
			case AnimStabIntro_Start :
				// Play AnimStabIntro_Loop animation for StabTelegraphTime seconds
				PlayStabIntro_Loop(LegIndex);
				return;

			case AnimStabIntro_Loop :
				// Play AnimStabIntro_End animation.
				PlayStabIntro_End(LegIndex);
				return;

			case AnimStabIntro_End :
				// Play AnimStab_Loop animation for StabStayInGroundTime seconds
				PlayStabLoop(LegIndex);
				return;

			case AnimStab_Loop :
				// Play AnimStabOutro_Start animation.
				PlayStabOutro_Start(LegIndex);
				return;

			case AnimStabOutro_Start :
				// Play AnimStabOutro_Loop animation for StabTelegraphTime seconds
				PlayStabOutro_Loop(LegIndex);
				return;

			case AnimStabOutro_Loop :
				// Play AnimStabIntro_End animation.
				PlayStabOutro_End(LegIndex);
				return;

			case AnimStabOutro_End :
				// Leg attack sequence finished
				LegAttackEnded(LegIndex);
				return;
		}
	}

	Super.OnAnimEnd(SeqNode, PlayedTime, ExcessTime);
}


/** Play AnimStabIntro_Loop animation for StabTelegraphTime seconds */
simulated function PlayStabIntro_Loop(int LegIndex)
{
	local float TelegraphTime;

	// Find out how long lasts the finger telegraphing
	TelegraphTime = GetStabTelegraphTime( LegIndex );

	`log(WorldInfo.TimeSeconds @ GetFuncName() @ "LegIndex:" @ LegIndex @ "TelegraphTime:" @ TelegraphTime);

	if( TelegraphTime > 0.f )
	{
		LegsIKInfo[LegIndex].SlotNode.PlayCustomAnimByDuration(AnimStabIntro_Loop, TelegraphTime, 0.f, 0.f, FALSE);
		LegsIKInfo[LegIndex].SlotNode.SetActorAnimEndNotification(TRUE);
	}
	// If telegraph time is zero, then go straight to the next step.
	else
	{
		PlayStabIntro_End(LegIndex);
	}
}

/** Play AnimStabIntro_End animation. */
simulated function PlayStabIntro_End(int LegIndex)
{
	local float AnimLength;

	`log(WorldInfo.TimeSeconds @ GetFuncName() @ "LegIndex:" @ LegIndex);

	// If on the server
	if( Role == ROLE_Authority )
	{
		WarnAttackIncoming( AttackingLegs[LegIndex].IKLocation );
	}

	AnimLength = LegsIKInfo[LegIndex].SlotNode.PlayCustomAnim(AnimStabIntro_End, AttackAnimRate, 0.1f, 0.f, FALSE);
	LegsIKInfo[LegIndex].SlotNode.SetActorAnimEndNotification(TRUE);

	// Turn on leg IK, so the leg hit the desired hit location
	LegsIKInfo[LegIndex].WorldIKCtrl.BlendInTime = AnimLength;
	LegsIKInfo[LegIndex].WorldIKCtrl.SetSkelControlActive(TRUE);

	// And turn off Bone controller
	LegsIKInfo[LegIndex].BoneIKCtrl.BlendOutTime = AnimLength;
	LegsIKInfo[LegIndex].BoneIKCtrl.SetSkelControlActive(FALSE);
}

/** Play AnimStab_Loop animation for StabStayInGroundTime seconds */
simulated function PlayStabLoop(int LegIndex)
{
	local float StayInGroundTime;
	local Vector HitLoc;

	HitLoc = AttackingLegs[LegIndex].IKLocation + vect(0,0,50);
	PlayStabImpactEffect( HitLoc );
	if( Role == Role_Authority )
	{
		DoStabDamage( HitLoc, LegIndex );
	}

	// Find out how long leg should remain stuck in ground.
	StayInGroundTime = GetStabStayInGroundTime( LegIndex );

	`log(WorldInfo.TimeSeconds @ GetFuncName() @ "LegIndex:" @ LegIndex @ "StayInGroundTime:" @ StayInGroundTime);

	if( StayInGroundTime > 0.f )
	{
		LegsIKInfo[LegIndex].SlotNode.PlayCustomAnimByDuration(AnimStab_Loop, StayInGroundTime, 0.f, 0.f, FALSE);
		LegsIKInfo[LegIndex].SlotNode.SetActorAnimEndNotification(TRUE);
	}
	// If stuck in ground time is zero, then go straight to the next step.
	else
	{
		PlayStabOutro_Start(LegIndex);
	}
}

/** Play AnimStabOutro_Start animation. */
simulated function PlayStabOutro_Start(int LegIndex)
{
	local float AnimLength;

	`log(WorldInfo.TimeSeconds @ GetFuncName() @ "LegIndex:" @ LegIndex);

	// If this is the last leg attacking play the full body outro animation
	if( GetNumAttackingLegs() == 1 &&
		(!StandIdleNode.bIsPlayingCustomAnim || StandIdleNode.GetPlayedAnimation() != AnimStabBody_Outro) )
	{
		StandIdleNode.PlayCustomAnim(AnimStabBody_Outro, 1.f, 0.1f, 0.2f, FALSE);
	}

	AnimLength = LegsIKInfo[LegIndex].SlotNode.PlayCustomAnim(AnimStabOutro_Start, AttackAnimRate, 0.1f, 0.f, FALSE);
	LegsIKInfo[LegIndex].SlotNode.SetActorAnimEndNotification(TRUE);

	// Turn off World leg IK
	LegsIKInfo[LegIndex].WorldIKCtrl.BlendOutTime = AnimLength;
	LegsIKInfo[LegIndex].WorldIKCtrl.SetSkelControlActive(FALSE);

	// And turn on Bone controller
	LegsIKInfo[LegIndex].BoneIKCtrl.BlendInTime = AnimLength;
	LegsIKInfo[LegIndex].BoneIKCtrl.SetSkelControlActive(TRUE);
}

/** Play AnimStabOutro_Loop animation for StabTelegraphTime seconds */
simulated function PlayStabOutro_Loop(int LegIndex)
{
	local float RetractHoldTime;

	// Find out how long the finger should hold before retracting completely
	RetractHoldTime = GetStabRetractHoldTime( LegIndex );

	`log(WorldInfo.TimeSeconds @ GetFuncName() @ "LegIndex:" @ LegIndex @ "RetractHoldTime:" @ RetractHoldTime);

	if( RetractHoldTime > 0.f )
	{
		LegsIKInfo[LegIndex].SlotNode.PlayCustomAnimByDuration(AnimStabOutro_Loop, RetractHoldTime, 0.f, 0.f, FALSE);
		LegsIKInfo[LegIndex].SlotNode.SetActorAnimEndNotification(TRUE);
	}
	// IfStabRetractHoldTime is zero, then go straight to the next step.
	else
	{
		PlayStabOutro_End(LegIndex);
	}
}

/** Play AnimStabIntro_End animation. */
simulated function PlayStabOutro_End(int LegIndex)
{
	`log(WorldInfo.TimeSeconds @ GetFuncName() @ "LegIndex:" @ LegIndex);

	LegsIKInfo[LegIndex].SlotNode.PlayCustomAnim(AnimStabOutro_End, AttackAnimRate, 0.1f, 0.2f, FALSE);
	LegsIKInfo[LegIndex].SlotNode.SetActorAnimEndNotification(TRUE);
}

/** LegNumber is done attacking */
simulated function LegAttackEnded(INT LegIndex)
{
	`log(WorldInfo.TimeSeconds @ GetFuncName() @ "LegIndex:" @ LegIndex);

	// This leg is done attacking
	LegsIKInfo[LegIndex].bIsAttacking = FALSE;

	// Turn encroachment back on for leg
	Encroachers[LegIndex].SetCollision(TRUE, TRUE);
}


/** Force Stab attack to end, because transitioning to another attack/action/state/move */
simulated final function StopStabAttack()
{
	local int LegIndex;

	EndSpecialMove( SM_Corpser_Stab );

	for(LegIndex=0; LegIndex<LegsIKInfo.Length; LegIndex++)
	{
		if( IsLegAttacking(LegIndex) )
		{
			// Stop current stab attack animation.
			LegsIKInfo[LegIndex].SlotNode.StopCustomAnim(0.2f);
			LegsIKInfo[LegIndex].SlotNode.SetActorAnimEndNotification(FALSE);

			LegsIKInfo[LegIndex].bIsAttacking = FALSE;

			// Turn encroachment back on for leg
			Encroachers[LegIndex].SetCollision(TRUE, TRUE);

			// Turn off World leg IK
			LegsIKInfo[LegIndex].WorldIKCtrl.BlendOutTime = 0.2f;
			LegsIKInfo[LegIndex].WorldIKCtrl.SetSkelControlActive(FALSE);

			// And turn on Bone controller
			LegsIKInfo[LegIndex].BoneIKCtrl.BlendInTime = 0.2f;
			LegsIKInfo[LegIndex].BoneIKCtrl.SetSkelControlActive(TRUE);
		}
	}

	// Stop full body node if playing a stab attack animation.
	if( StandIdleNode.bIsPlayingCustomAnim )
	{
		switch( StandIdleNode.GetPlayedAnimation() )
		{
			case AnimStabBody_Intro :
			case AnimStabBody_Hold :
			case AnimStabBody_Outro :
				StandIdleNode.StopCustomAnim(0.2f);
				StandIdleNode.SetActorAnimEndNotification(FALSE);
		}
	}

	// On server, replicate to clients.
	if( Role == Role_Authority )
	{
		StopStabAttackCount++;
	}
}

/** Get delay before next transition evaluation */
simulated function float GetPostAttackDelay()
{
	return 0.f;
}

/** Get amount of time to telegraph the stab */
simulated function float GetStabTelegraphTime( int LegIdx )
{
	local int Idx;
	Idx = Patterns[PatternIdx].Legs.Find( 'LegIdx', LegIdx );
	return Patterns[PatternIdx].Legs[Idx].TelegraphTime;
}

/** Get amount of time leg should stay in the ground */
simulated function float GetStabStayInGroundTime( int LegIdx )
{
	local int Idx;
	Idx = Patterns[PatternIdx].Legs.Find( 'LegIdx', LegIdx );
	return Patterns[PatternIdx].Legs[Idx].StayInGroundTime;
}

/** Get amount of time leg should retract after stab attack */
simulated function float GetStabRetractHoldTime( int LegIdx )
{
	local int Idx;
	Idx = Patterns[PatternIdx].Legs.Find( 'LegIdx', LegIdx );
	return Patterns[PatternIdx].Legs[Idx].RetractHoldTime;
}

/** Should be called when a stab attack impacts the ground and does radial damage */
function DoStabDamage( Vector HitLocation, optional int LegIdx = -1 )
{
	if( LegIdx >= 0 )
	{
		HurtRadius( StabAttackDamage, StabAttackRadius, class'GDT_MomCorpser_Stab', 0.f, HitLocation,, Controller );
	}
	else
	{
		HurtRadius( StompAttackDamage, StompAttackRadius, class'GDT_MomCorpser_Stomp', 0.f, HitLocation,, Controller );

	}
}

simulated function PlayStabAttackSound()
{
	PlaySound( ArmRaiseRoar );
}

simulated function PlayStabImpactEffect( Vector HitLocation );

simulated function PlayStompAttackStartSound()
{
	PlaySound( StompAttackVocal );
}

simulated function PlayStompAttackRumble()
{
	PlaySound( PostStompAttackRumble );
}

simulated function PlayStompEffect();


function PlayFallingRocksAtopPlayer()
{
	local GearPawn DmgPawn;
	local array<GearPawn> Avail;
	local int Idx;

	// find the player
	foreach WorldInfo.AllPawns( class'GearPawn', DmgPawn )
	{
		if( !DmgPawn.IsSameTeam( self ) )
		{
			Idx = Avail.Length;
			Avail.Length = Idx + 1;
			Avail[Idx] = DmgPawn;
		}
	}

	if( Avail.Length > 0 )
	{
		Idx = Rand(Avail.Length);

		// unleash the rocks!
		DropCorpserRocksOntoPawn( self, Avail[Idx] );
	}
}

static function DropCorpserRocksOntoPawn( GearPawn Inst, GearPawn DropRocksTarget );


/** Get number of rocks to spawn over player's head */
static function int GetNumStompRocks()
{
    return 1 + Rand(3);
}

function WarnAttackIncoming( Vector ImpactLocation )
{
	local GearAI AI;
	local GearPawn GP;
	local float Dist;

	WarnAttackLocation = ImpactLocation;
	foreach WorldInfo.AllPawns( class'GearPawn', GP )
	{
		AI = GearAI(GP.Controller);
		if( AI != None )
		{
			Dist = VSize(ImpactLocation-GP.Location);
			if( Dist < 512.f )
			{
				AI.ReactionManager.NudgeChannel( self, 'WarnEnemyAttack' );
			}
		}
	}
}

/**
 * Implements Interface_AIAttackWarning
 * 
 * Allows pawn to warn enemy AI of its incoming attack.
 * Works with AIReactCond_EnemyAttack
 *
 * @return - Location that the attack will occur
 */
function vector GetWarnAttackLocation()
{
	return WarnAttackLocation;
}


/**
 *  Implements Interface_AIAttackWarning
 *  
 * Allows attacking pawn to suggest an evade direction based on its attack type
 *
 * @return - Evade direction
 */
function ESpecialMove GetEnemyEvadeDir()
{
	if( IsDoingSpecialMove( SM_Corpser_Stab ) ||  IsDoingSpecialMove( SM_Corpser_Stomp ) )
	{
		return SM_EvadeBwd;
	}
	return SM_None;
}


function bool UpdateLeftEyeStatus( optional bool bForceClosed, optional bool bManual )
{
	local float NextTimer;

	ClearTimer( nameof(UpdateLeftEyeStatus) );
	if( LeftEyeHealth > 0 )
	{
		bLeftEyeOpen = bForceClosed ? FALSE : (FRand() < 0.65f);
		EyeStatusChanged();

		if( !bManual )
		{
			NextTimer = (bRightMidEyeOpen ? 2.f + (FRand() * 5.f) : 1.f + (FRand() * 1.f));
			SetTimer( NextTimer, FALSE, nameof(UpdateLeftEyeStatus) );
		}

		return FALSE;
	}

	return TRUE;
}

function bool UpdateLeftMidEyeStatus( optional bool bForceClosed, optional bool bManual )
{
	local float NextTimer;

	ClearTimer( nameof(UpdateLeftMidEyeStatus) );
	if( LeftMidEyeHealth > 0 )
	{
		bLeftMidEyeOpen = bForceClosed ? FALSE : (FRand() < 0.65f);
		EyeStatusChanged();

		if( !bManual )
		{
			NextTimer = (bRightMidEyeOpen ? 2.f + (FRand() * 5.f) : 1.f + (FRand() * 1.f));
			SetTimer( NextTimer, FALSE, nameof(UpdateLeftMidEyeStatus) );
		}

		return FALSE;
	}

	return TRUE;
}

function bool UpdateRightEyeStatus( optional bool bForceClosed, optional bool bManual )
{
	local float NextTimer;

	ClearTimer( nameof(UpdateRightEyeStatus) );
	if( RightEyeHealth > 0 )
	{
		bRightEyeOpen = bForceClosed ? FALSE : (FRand() < 0.65f);
		EyeStatusChanged();

		if( !bManual )
		{
			NextTimer = (bRightMidEyeOpen ? 2.f + (FRand() * 5.f) : 1.f + (FRand() * 1.f));
			SetTimer( NextTimer, FALSE, nameof(UpdateRightEyeStatus) );
		}

		return FALSE;
	}

	return TRUE;
}

function bool UpdateRightMidEyeStatus( optional bool bForceClosed, optional bool bManual )
{
	local float NextTimer;

	ClearTimer( nameof(UpdateRightMidEyeStatus) );
	if( RightMidEyeHealth > 0 )
	{
		bRightMidEyeOpen = bForceClosed ? FALSE : (FRand() < 0.65f);
		EyeStatusChanged();

		if( !bManual )
		{
			NextTimer = (bRightMidEyeOpen ? 2.f + (FRand() * 5.f) : 1.f + (FRand() * 1.f));
			SetTimer( NextTimer, FALSE, nameof(UpdateRightMidEyeStatus) );
		}

		return FALSE;
	}

	return TRUE;
}

simulated function EyeStatusChanged()
{
	if( EyeData[ECORPSEREYE_Left].EyeMesh != None )
	{
		if( bLeftEyeOpen && LeftEyeHealth > 0 )
		{
			Helper_EyeStatusChanged( ECORPSEREYE_Left, TRUE );
		}
		else
		{
			Helper_EyeStatusChanged( ECORPSEREYE_Left, FALSE );
		}
	}

	if( EyeData[ECORPSEREYE_LeftMid].EyeMesh != None )
	{
		if( bLeftMidEyeOpen && LeftMidEyeHealth > 0 )
		{
			Helper_EyeStatusChanged( ECORPSEREYE_LeftMid, TRUE );
		}
		else
		{
			Helper_EyeStatusChanged( ECORPSEREYE_LeftMid, FALSE );
		}
	}

	if( EyeData[ECORPSEREYE_RightMid].EyeMesh != None )
	{
		if( bRightMidEyeOpen && RightMidEyeHealth > 0 )
		{
			Helper_EyeStatusChanged( ECORPSEREYE_RightMid, TRUE );
		}
		else
		{
			Helper_EyeStatusChanged( ECORPSEREYE_RightMid, FALSE );
		}
	}

	if( EyeData[ECORPSEREYE_Right].EyeMesh != None )
	{
		if( bRightEyeOpen && RightEyeHealth > 0 )
		{
			Helper_EyeStatusChanged( ECORPSEREYE_Right, TRUE );
		}
		else
		{
			Helper_EyeStatusChanged( ECORPSEREYE_Right, FALSE );
		}
	}
}

simulated function Helper_EyeStatusChanged( int EyeIdx, bool bOpen )
{
	local float Duration;
	local InterpCurveFloat Curve;

	Duration = bOpen ? 0.35f : 0.2f;
	Curve    = bOpen ? EyeOpenCurve : EyeClosedCurve;

	EyeData[EyeIdx].MIC_Eye.SetScalarCurveParameterValue( 'Blink_valuespoint75to4', Curve );
	EyeData[EyeIdx].MIC_Eye.SetDuration( Duration );
}


function PlayScreamAttackEffects();
function StopScreamAttackEffects();

final function StartPushAwayPlayers()
{
	// Set flag now, we'll let players be put in that state in the tick function.
	bPushAwayPlayers = TRUE;

	PlayScreamAttackEffects();
}

final function StopPushAwayPlayers()
{
	local GearPawn_Infantry InfantryPawn;

	bPushAwayPlayers = FALSE;

	// Force all Pawns in that special move to stop it.
	foreach WorldInfo.AllPawns(class'GearPawn_Infantry', InfantryPawn)
	{
		// If Pawn is doing SM_CoverHeadPushed_ByCorpser special move instigated by us, release him now.
		if( InfantryPawn.IsDoingSpecialMove(SM_CoverHeadPushed_ByCorpser) && InfantryPawn.InteractionPawn == self )
		{
			InfantryPawn.ServerEndSpecialMove(SM_CoverHeadPushed_ByCorpser);
		}
	}

	StopScreamAttackEffects();
}

simulated function Tick(float DeltaTime)
{
	local GearPawn_Infantry InfantryPawn;
	local float PushRadius;

	Super.Tick(DeltaTime);

/*
	if( AvoidanceCylinder.bEnabled )
	{
		DrawDebugSphere( AvoidanceCylinder.Location, AvoidRadius, 16, 0, 255, 0 );
	}
	else
	{
		DrawDebugSphere( AvoidanceCylinder.Location, AvoidRadius, 16, 255, 0, 0 );
	}
*/
	if( Role == ROLE_Authority && bPushAwayPlayers )
	{
		// Push Away players
		PushRadius = MyGearAI != None ? MyGearAI.EnemyDistance_Short : class'GearAI_MomCorpser'.default.EnemyDistance_Short;
		foreach WorldInfo.AllPawns(class'GearPawn_Infantry', InfantryPawn)
		{
			// Within Radius, Push
			if( VSize(InfantryPawn.Location - Location) <= PushRadius )
			{
				// If Pawn is already doing the special move, skip
				if( InfantryPawn.IsDoingSpecialMove(SM_CoverHeadPushed_ByCorpser) )
				{
					continue;
				}

				if( InfantryPawn.CanCoverHead() )
				{
					// Quick check for world obstructions
					if( FastTrace(InfantryPawn.Location, Location,, TRUE) == TRUE )
					{
						// Send Pawn into special move.
						InfantryPawn.ServerDoSpecialMove(SM_CoverHeadPushed_ByCorpser, FALSE, Self);
					}
				}
			}
			// Outside of boundaries, release
			else
			{
				// If Pawn is doing SM_CoverHeadPushed_ByCorpser special move instigated by us, release him now.
				if( InfantryPawn.IsDoingSpecialMove(SM_CoverHeadPushed_ByCorpser) && InfantryPawn.InteractionPawn == self )
				{
					InfantryPawn.ServerEndSpecialMove(SM_CoverHeadPushed_ByCorpser);
				}
			}
		}
	}
}

function bool OverrideAimLocation(out vector AimLoc, vector StartLoc, GearAI ShooterAI)
{
	AimLoc = Mesh.GetBoneLocation('head');
	return TRUE;
}

defaultproperties
{
	ControllerClass=class'GearAI_MomCorpser'

	DefaultInventory.Empty()

	bAllowInventoryDrops=false
 	bShouldChainsawAttackInstantKillMe=false

	Begin Object Class=GearCameraShake Name=ChargeHitWallCameraShake0
		OscillationDuration=0.8f
		LocOscillation={(Y=(Amplitude=3.f,Frequency=3.f),
						 Z=(Amplitude=15.f,Frequency=30.f))}
	End Object
	ChargeHitWallCameraShake=ChargeHitWallCameraShake0
	ChargeHitWallCameraShakeInnerRadius=150
	ChargeHitWallCameraShakeOuterRadius=1000

	SpecialMoveClasses.Empty
	SpecialMoveClasses(SM_Corpser_Hurt)=class'GSM_MomCorpser_Hurt'
	SpecialMoveClasses(SM_Corpser_Stab)=class'GSM_MomCorpser_Stab'
	SpecialMoveClasses(SM_Corpser_Stomp)=class'GSM_MomCorpser_Stomp'
	SpecialMoveClasses(SM_Corpser_Charge)=class'GSM_MomCorpser_Charge'

	FootNames(0)="Rt_Clawtip1"
	FootNames(1)="Rt_Clawtip2"
	FootNames(2)="Rt_Clawtip3"
	FootNames(3)="Rt_Clawtip4"
	FootNames(4)="Lft_Clawtip4"
	FootNames(5)="Lft_Clawtip3"
	FootNames(6)="Lft_Clawtip2"
	FootNames(7)="Lft_Clawtip1"


	LegsIKInfo(0)=(WorldIKName="IK_Lt2_World",BoneIKName="IK_Lt2_Bone",SlotName="Slot_LegLt2")
	LegsIKInfo(1)=(WorldIKName="IK_Lt3_World",BoneIKName="IK_Lt3_Bone",SlotName="Slot_LegLt3")
	LegsIKInfo(2)=(WorldIKName="IK_Lt4_World",BoneIKName="IK_Lt4_Bone",SlotName="Slot_LegLt4")
	LegsIKInfo(3)=(WorldIKName="IK_Rt4_World",BoneIKName="IK_Rt4_Bone",SlotName="Slot_LegRt4")
	LegsIKInfo(4)=(WorldIKName="IK_Rt3_World",BoneIKName="IK_Rt3_Bone",SlotName="Slot_LegRt3")
	LegsIKInfo(5)=(WorldIKName="IK_Rt2_World",BoneIKName="IK_Rt2_Bone",SlotName="Slot_LegRt2")


	// Stab attack animations
	AnimStabIntro_Start=StabAttack_Beginning_Start
	AnimStabIntro_Loop=StabAttack_Beginning_Hold
	AnimStabIntro_End=StabAttack_Strike
	AnimStab_Loop=StabAttack_Strike_Hold
	AnimStabOutro_Start=StabAttack_Return_Start
	AnimStabOutro_Loop=StabAttack_Return_Hold
	AnimStabOutro_End=StabAttack_Return_End

	AnimStabBody_Intro=StabAttack_Body_Start
	AnimStabBody_Hold=StabAttack_Body_Hold
	AnimStabBody_Outro=StabAttack_Body_End

	AttackAnimRate=1.5f

	AttackZoneWidth=384.f
	AttackZoneFwdOffset=0.f

	AttackZones(0)=(PatternList=(0))
	AttackZones(1)=(PatternList=(1,2,4))
	AttackZones(2)=(PatternList=(3))

	Patterns(0)={(
					Legs[0]=(LegIdx=5,Delay=0.0f,Offset=(X=-125,Y=125)),
					Legs[1]=(LegIdx=4,Delay=0.25f,Offset=(X=0,Y=0)),
					Legs[2]=(LegIdx=3,Delay=0.25f,Offset=(X=125,Y=-125))
				)}
	Patterns(1)={(
					Legs[0]=(LegIdx=4,Delay=0.0f,Offset=(X=0,Y=100)),
					Legs[1]=(LegIdx=3,Delay=0.25f,Offset=(X=0,Y=0)),
					Legs[2]=(LegIdx=2,Delay=0.25f,Offset=(X=0,Y=-100))
				)}
	Patterns(2)={(
					Legs[0]=(LegIdx=1,Delay=0.f,Offset=(X=0,Y=-100)),
					Legs[1]=(LegIdx=2,Delay=0.25f,Offset=(X=0,Y=0)),
					Legs[2]=(LegIdx=3,Delay=0.25f,Offset=(X=0,Y=100))
				)}
	Patterns(3)={(
					Legs[0]=(LegIdx=0,Delay=0.f,Offset=(X=-125,Y=-125)),
					Legs[1]=(LegIdx=1,Delay=0.25f,Offset=(X=0,Y=0)),
					Legs[2]=(LegIdx=2,Delay=0.25f,Offset=(X=125,Y=125))
				)}
	Patterns(4)={(
					Legs[0]=(LegIdx=2,Delay=0.f,Offset=(X=0,Y=100)),
					Legs[1]=(LegIdx=3,Delay=0.f,Offset=(X=0,Y=-100)),
				)}

	bLeftEyeOpen=TRUE
	bRightEyeOpen=TRUE
	bLeftMidEyeOpen=TRUE
	bRightMidEyeOpen=TRUE

	bOpenWalkAnim=TRUE

	AvoidRadius=512.f

	NoticedGUDSPriority=140
	NoticedGUDSEvent=GUDEvent_NoticedCorpser
}
