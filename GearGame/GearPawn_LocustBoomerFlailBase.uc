
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearPawn_LocustBoomerFlailBase extends GearPawn_LocustBoomerBase
	abstract
	config(Pawn);

/** BlendNode used when boomer ducks behind shield. */
var transient	AnimNodeBlend		CoverBlend;
var transient	GearAnim_BlendList	BoomerStateAnimNode;
/** Flag when it is allowed to trigger melee attack notify */
var transient	bool				bReceivedSpinToMeleeTransitionNotify;
/** Replicated state for flail boomer */
var	repnotify	byte				BoomerAnimState;
/** Angle step for proximity check */
var				INT					ProximityAngleStep;
/** Current trace direction for proximity checks. */
var				Rotator				TraceRotation;
/** Last time proximity check has hit something */
var				float				LastProximityHitTime;

var protected const float			MinTimeBetweenTelegraphs;
var protected transient float		LastTelegraphTime;

/** last time we triggered a flail explosion from the animnotify, used to make sure we only do one per swing */
var float LastFlailExplosionTime;

var AIAvoidanceCylinder AvoidanceCylinder;


replication
{
	// Replicated to ALL but Owning Player
	if( Role == ROLE_Authority)
		BoomerAnimState;
}


/************************************************************************
 * Avoidance Cylinder stuff                                             *
 ************************************************************************/
event AIAvoidanceCylinderComponent GetAIAvoidanceCylinderComponent()
{
	if(AvoidanceCylinder==none)
	{
		return none;
	}
	return AvoidanceCylinder.GetAIAvoidanceCylinderComponent();
}
function SetupAvoidanceCylinder()
{
	local float AvoidRadius;

	if( !bDeleteMe && AvoidanceCylinder == None )
	{
		AvoidRadius = GetCollisionRadius() * 2.5f;
		AvoidanceCylinder = Spawn(class'AIAvoidanceCylinder',self,,Location,,,TRUE);

		if(AvoidanceCylinder!=none)
		{

			AvoidanceCylinder.SetBase(self);
			AvoidanceCylinder.SetRelativeLocation(vect(150.f,0.f,0.f));
			AvoidanceCylinder.SetCylinderSize(AvoidRadius,AvoidRadius*2.0f);
			AvoidanceCylinder.SetAvoidanceTeam(TEAM_COG);
			AvoidanceCylinder.SetDontAffectMesh(true);
			AvoidanceCylinder.SetEnabled(true);
		}
		//DrawDebugSphere(Location,AvoidRadius,16,255,0,0,TRUE);
	}

}

simulated function Destroyed()
{
	Super.Destroyed();

	if(AvoidanceCylinder != none)
	{
		AvoidanceCylinder.Destroy();
		AvoidanceCylinder = none;
	}
}

function bool Died(Controller Killer, class<DamageType> GearDamageType, vector HitLocation)
{

	if(AvoidanceCylinder != none)
	{
		AvoidanceCylinder.Destroy();
		AvoidanceCylinder = none;
	}
	return Super.Died( Killer, GearDamageType, HitLocation );
}

function bool ShouldAvoid(GearAI AskingAI, AIAvoidanceCylinderComponent TriggeringComponent)
{
	return AskingAI.IsEnemyVisible(self);
}

function bool ShouldEvade(GearAI AskingAI, AIAvoidanceCylinderComponent TriggeringComponent)
{
	return TRUE;
}

function bool ShouldRoadieRun(GearAI AskingAI, AIAvoidanceCylinderComponent TriggeringComponent)
{
	return TRUE;
}
/************************************************************************
* END Avoidance Cylinder stuff                                             *
************************************************************************/

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	SetupAvoidanceCylinder();
}

function TelegraphAttack()
{
	// throttle telegraphs for mauler
	if (`TimeSince(LastTelegraphTime) > MinTimeBetweenTelegraphs)
	{
		super.TelegraphAttack();
		LastTelegraphTime = WorldInfo.TimeSeconds;
	}
}

function AdjustPawnDamage( out int Damage, Pawn InstigatedBy, vector HitLocation, out vector Momentum,
				class<GearDamageType> GearDamageType, Actor DamageCauser, optional out TraceHitInfo HitInfo )
{
	// hardcode them not taking damage from the flail
	if (GearDamageType == class'GDT_Boomer_Flail')
	{
		Damage = 0;
	}
	else
	{
		if (ClassIsChildOf(GearDamageType, class'GDT_HOD'))
		{
			LastHODDamageTime = WorldInfo.TimeSeconds;
		}
		Super.AdjustPawnDamage(Damage, InstigatedBy, HitLocation, Momentum, GearDamageType, DamageCauser, HitInfo);
	}

}

simulated event ReplicatedEvent( name VarName )
{
	if( VarName == 'BoomerAnimState' )
	{
		BoomerFlailStateChanged();
	}
	else
	{
		Super.ReplicatedEvent(VarName);
	}
}

/** Cache additional animation nodes. */
simulated function CacheAnimNodes()
{
	Super.CacheAnimNodes();

	// Cover blend node.
	CoverBlend = AnimNodeBlend(Mesh.FindAnimNode('CoverBlend'));
	BoomerStateAnimNode = GearAnim_BlendList(Mesh.FindAnimNode('BoomerStateNode'));

	// Reset blend node just in case.
	if( CoverBlend != None )
	{
		CoverBlend.SetBlendTarget(0.f, 0.f);
	}

	// Set reference to special move as well. LocustBoomerFlail is not defined in GearGame unfortunately. :(
	VerifySMHasBeenInstanced(SM_CoverHead);
	GSM_Boomer_ShieldDefense(SpecialMoves[SM_CoverHead]).CoverBlend = CoverBlend;
}

simulated function ClearAnimNodes()
{
	Super.ClearAnimNodes();

	CoverBlend = None;
	BoomerStateAnimNode = None;
	if(Specialmoves.length > SM_CoverHead)
	{
		GSM_Boomer_ShieldDefense(SpecialMoves[SM_CoverHead]).CoverBlend = None;
	}
}

function AddDefaultInventory()
{
	local GearInventoryManager Inv;
	local GearWeapon Weap;

	Super.AddDefaultInventory();

	Inv = GearInventoryManager(InvManager);
	if( Inv != None && Inv.Shield != None )
	{
		EquipShield( Inv.Shield );
	}

	//debug
	ForEach InvManager.InventoryActors(class'GearWeapon', Weap)
	{
		Weap.SetInfiniteMagazineSize();	// disable reloads
		Weap.SetInfiniteSpareAmmo();	// unlimited spare ammo
	}
}

simulated function ClientReStart()
{
	local GearShield Shield;

	// make sure shield is equipped
	if (EquippedShield == None)
	{
		Shield = GearShield(FindInventoryType(class'GearShield', true));
		if (Shield != None)
		{
			EquipShield(Shield);
		}
	}
}

/**
 * Return attachment info for Shield.
 *
 * @param OutBoneName - the bone that the shield should attach to
 *
 * @param OutRelativeRotation - the relative rotation the shield should be attached at
 *
 * @param OutRelativeLocation - the relative location the shield should be attached at
 *
 * @param OutScale - the scale the shield should be while attached
 */
simulated function GetShieldAttachBone(out Name OutBoneName, out Rotator OutRelativeRotation, out Vector OutRelativeLocation, out float OutScale)
{
	local SkeletalMeshSocket	ShieldSocket;

	ShieldSocket = Mesh.GetSocketByName('Shield');

	OutBoneName = ShieldSocket.BoneName;
	OutRelativeRotation = ShieldSocket.RelativeRotation;
	OutRelativeLocation = ShieldSocket.RelativeLocation;
	OutScale = 1.0f;
}

/** @see Pawn::WeaponFired */
simulated function WeaponFired(Weapon InWeapon, bool bViaReplication, optional vector HitLocation)
{
	// Skip parent boomer version.
	Super(GearPawn_Infantry).WeaponFired(InWeapon, bViaReplication, HitLocation);
}

/**
 * Play flail attack animation on pawn.
 * animation parameters are provided as input variables, so they're all set from the same place and remain identical.
 */
simulated function float PlayFlailAttack(float InRate, float InBlendInTime, float InBlendOutTime)
{
	local float	AnimTime;

	// Play boom shot firing animation
	AnimTime = BS_Play(BS_WeaponFire, InRate, InBlendInTime, InBlendOutTime, FALSE, TRUE);
	BS_SetAnimEndNotify(BS_WeaponFire, TRUE);
	bDoingMeleeAttack = TRUE;

	TelegraphAttack();

	return AnimTime;
}

simulated function BS_AnimEndNotify(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	if( BS_SeqNodeBelongsTo(SeqNode, BS_WeaponFire) )
	{
		// Notification that the flail melee attack is done playing.
		// We resynchronize the spinning animation to create a smooth transition.
		AnimTreeRootNode.ForceGroupRelativePosition('FlailSpin', 0.3);
		BS_SetAnimEndNotify(BS_WeaponFire, false);

		if (bDoingMeleeAttack)
		{
			bDoingMeleeAttack = false;

			// if player is holding the aim button, go back to shielding after the attack
			if ( IsLocallyControlled() && GearPC(Controller) != None &&
				GearPC(Controller).IsButtonActive(GB_LeftTrigger, true) )
			{
				ServerOpenShield();
			}
		}

		return;
	}

	Super.BS_AnimEndNotify(SeqNode, PlayedTime, ExcessTime);
}

/** Called from an anim notify. */
simulated function Notify_FlailImpact()
{
	local GearWeap_Boomer_FlailBase FlailWeap;
	local vector ExploLoc, HitLocation, HitNormal;

	if (WorldInfo.TimeSeconds - LastFlailExplosionTime > 1.0)
	{
		LastFlailExplosionTime = WorldInfo.TimeSeconds;
		FlailWeap = GearWeap_Boomer_FlailBase(Weapon);
		ExploLoc = SkeletalMeshComponent(FlailWeap.Mesh).GetBoneLocation('b_Flail_ChainEnd');

		// make sure explosion reaches the floor
		if (Trace(HitLocation, HitNormal, ExploLoc - vect(0,0,500), ExploLoc + vect(0,0,100), false, vect(1,1,1)) != None)
		{
			ExploLoc = HitLocation;
		}
		FlailWeap.CauseFlailExplosion(ExploLoc, vect(0,0,1));
	}
}

simulated function FlailSpinToMeleeTransition()
{
//	`log(WorldInfo.TimeSeconds @ Self @ GetFuncName());
	bReceivedSpinToMeleeTransitionNotify = TRUE;
}

simulated function Tick(float DeltaTime)
{
	// automatically close shield if the player presses the fire button
	if (IsHumanControlled() && IsLocallyControlled() && EquippedShield != None && EquippedShield.bExpanded && IsControllerFireInputPressed(0))
	{
		ServerCloseShield();
	}

	Super.Tick(DeltaTime);

	// Clear notify -- we want this after the Super.Tick that handles weapon firing.
	bReceivedSpinToMeleeTransitionNotify = false;

	if (Role == ROLE_Authority)
	{
		UpdateProximityCheck();
		UpdateFlailBoomerAnimState();
	}
}

simulated function bool IsControllerFireInputPressed(Byte InFiringMode)
{
	// Re-route melee input into main firing mode.
	if( InFiringMode == 0 && bWantsToMelee )
	{
		return TRUE;
	}

	// Disable melee attack firing mode since we're re-routing the input into the main one.
	if( InFiringMode == class'GearWeapon'.const.MELEE_ATTACK_FIREMODE )
	{
		return FALSE;
	}

	return Super.IsControllerFireInputPressed(InFiringMode);
}

simulated function bool ShouldDelayFiring(optional bool bReticleTesting)
{
	// Delay until proper animation transition point.
	return !bReceivedSpinToMeleeTransitionNotify;
}

// Server only, updates state of flail boomer
function UpdateFlailBoomerAnimState()
{
	if (BoomerStateAnimNode == None)
	{
		return;
	}

	// check for raising shield overhead
	if (WorldInfo.TimeSeconds - LastHODDamageTime < 1.5)
	{
		BoomerAnimState = 2;
	}
	// no swing if no enemies.
	else if (MyGearAI != None && MyGearAI.Enemy == None && !MyGearAI.bDoingMeleeAttack)
	{
		BoomerAnimState = 3;
	}
	// Short swing
	else if (ShouldUseShortSwing())
	{
		BoomerAnimState = 0;
	}
	// Large swing
	else
	{
		BoomerAnimState = 1;
	}

	if (BoomerStateAnimNode.ActiveChildIndex != BoomerAnimState)
	{
		// Force replication now to clients
		bForceNetUpdate = true;
		BoomerFlailStateChanged();
	}
}

// Server only, do traces for proximity check
function UpdateProximityCheck()
{
	local Vector	StartTrace, EndTrace;
	local float		HeightRandomizer;

	TraceRotation.Yaw += ProximityAngleStep;
	TraceRotation = Normalize(TraceRotation);

	HeightRandomizer = GetCollisionHeight() * 0.67f * (FRand() - 0.5f);
	StartTrace = Location + vect(0,0,1) * HeightRandomizer;
	EndTrace = StartTrace + Vector(TraceRotation) * 200.f;
// 	DrawDebugLine(StartTrace, EndTrace, 255, 0, 0);
	if( !FastTrace(EndTrace, StartTrace) )
	{
		LastProximityHitTime = WorldInfo.TimeSeconds;
	}
}

/**
 * Determine if we should use our short swing as opposed to long swing
 * by attaching a trigger to use, and seeing if anything collides with it.
 */
function bool ShouldUseShortSwing()
{
	// If we've hit the world in the last second, then use the short swing.
	return `TimeSince(LastProximityHitTime) < 1.f;
}

// Both client and server. Updates boomer state based on replicated variable BoomerAnimState.
simulated function BoomerFlailStateChanged()
{
	BoomerStateAnimNode.SetActiveChild(BoomerAnimState, 0.67f);

	// If protecting from hail, then open up shield.
	if( BoomerAnimState == 2 )
	{
		OpenShield( FALSE );
	}
}

simulated function bool ShouldDeployShield()
{
	// we'll control when we want to deploy, thank you very much
	return false;
}

simulated function OpenShield( bool bModGroundSpeed, optional float ModGroundSpeed, optional bool bDoSpecialMove )
{
	if( EquippedShield != None && !EquippedShield.bExpanded )
	{
		EquippedShield.Expand();
		if( bModGroundSpeed )
		{
			ShouldCrouch( TRUE );
		}
	}

	if( bDoSpecialMove && Role == ROLE_Authority && !IsDoingSpecialMove(SM_CoverHead) )
	{
		ServerDoSpecialMove(SM_CoverHead);
	}

	if( bModGroundSpeed )
	{
		GroundSpeed = ModGroundSpeed;
	}
}

simulated function CloseShield()
{
	if( EquippedShield != None && EquippedShield.bExpanded )
	{
		EquippedShield.Retract();
		ShouldCrouch( FALSE );
	}

	if (Role == ROLE_Authority && IsDoingSpecialMove(SM_CoverHead))
	{
		ServerEndSpecialMove();
	}

	GroundSpeed = DefaultGroundSpeed;
}

/** Event called when A new special move has stopped */
simulated function SpecialMoveAssigned(ESpecialMove NewMove, ESpecialMove PrevMove)
{
	Super.SpecialMoveAssigned(NewMove, PrevMove);

	// A special move has ended, update status of shield deployment
	if( NewMove == SM_None && PendingSpecialMoveStruct.SpecialMove == SM_None )
	{
		// Chain Roadie Run if we're holding A
		if( IsLocallyControlled() && GearPC(Controller) != None && GearPC(Controller).IsButtonActive(GB_A, TRUE) )
		{
			ServerDoSpecialMove(SM_RoadieRun, TRUE);
		}
	}
}

/** called by client when player controlled to expand the shield */
reliable server final function ServerOpenShield()
{
	if (!bDoingMeleeAttack)
	{
		OpenShield(true, class'GearAI_Boomer_Shield'.default.ShieldOpenGroundSpeed, true);
	}
}
/** called by client when player controlled to close the shield */
reliable server final function ServerCloseShield()
{
	CloseShield();
}

simulated function DropShield(optional bool bSkipToss, optional bool bDestroyShield)
{
	// don't allow mauler to drop shield until it dies or if we're the client and the server said so
	if (Health <= 0 || (WorldInfo.NetMode == NM_Client && AttachClass_Shield == None))
	{
		Super.DropShield(bSkipToss, bDestroyShield);
	}
}

/** Boomer never damaged hail, he has shield! */
simulated function bool TryToRaiseShieldOverHead()
{
	return TRUE;
}

/** Play Hit Reaction animation */
simulated function bool PlayHitReactionAnimation(ImpactInfo Impact)
{
	return FALSE;
}

// only do flame damage reduction if our shield is deployed since we hold the shield at an off angle otherwise
function float ReduceDamageForShieldHolder(vector ShotDirection, class<GearDamageType> DamType, const out TraceHitInfo HitInfo, float Damage)
{
	local vector Dir;
	local float DotAngle, Factor, ProtAngle;

	Dir = -Normal(ShotDirection);
	DotAngle = Dir dot vector(Rotation);
	// If being shot from the front
	if (DotAngle > 0.f)
	{
		ProtAngle = IsDeployingShield() ? DeployedShieldHalfAngleOfProtection : ShieldHalfAngleOfProtection;
		Factor = FClamp(Square(1.f - DotAngle) * (90.f / ProtAngle), 0.f, 1.f);
	}
	else
	{
		Factor = 1.0;
	}

	if ( EquippedShield.bExpanded &&
		(ClassIsChildOf(DamType, class'GDT_Explosive') || ClassIsChildOf(DamType, class'GDT_Fire') || ClassIsChildOf(DamType, class'GDT_Melee')) )
	{
		// Reduce damage
		Damage *= Factor;
	}
	else
	{
		// did we hit the shield itself?
		if (ComponentIsAnEquippedShield(HitInfo.HitComponent))
		{
			if (ClassIsChildOf(DamType, class'GDT_HeavySniperRifle'))
			{
				// special handling for getting hit in the shield with heavy sniper
				// we want to drop the shield, cringe the hitpawn, and do a fixed amount of damage
				Damage = 1000000; // force death since we don't have proper handling for this creature being without its shield
				Super.DropShield(true, true);
				Cringe();
			}
			else
			{
				Damage = 0.f;
			}
		}
		else if (IsDeployingShield())
		{
			// give some damage reduction in front even in the areas not covered by the shield
			Damage *= FMax(Factor, 0.35);
		}
	}

	return Damage;
}

defaultproperties
{
	MPHeadRadius=16

	ProximityAngleStep=8000	// spread it over a few frames
	bCanPlayPhysicsHitReactions=FALSE	// turn off because doesn't play well with physics flail.

	HeadSocketName="Helmet"

	ControllerClass=class'GearAI_Boomer'

	BS_WeaponFire=(Stance=((Slot=BS_Std_Up,AnimName="FL_MeleeAttack_Overhand"),(Slot=BS_Std_Idle_Lower,AnimName="FL_MeleeAttack_Overhand")))
	BS_MeleeAttack=(Stance=((Slot=BS_Std_Up,AnimName="FL_MeleeAttack_Overhand"),(Slot=BS_Std_Idle_Lower,AnimName="FL_MeleeAttack_Overhand")))

	SpecialMoveClasses(SM_CoverHead)=class'GSM_Boomer_ShieldDefense'

	NoticedGUDSEvent=GUDEvent_NoticedMauler

	SiegeTutorialType=GEARTUT_SIEGE_FlailBoomer
}
