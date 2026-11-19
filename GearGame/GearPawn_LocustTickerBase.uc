/**
 * Locust Ticker Bomb
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearPawn_LocustTickerBase extends GearPawn_LocustCreatureBase
	abstract
	implements(AIObjectAvoidanceInterface)
	native(Pawn);

/** How long to stay flipped over */
var() const protected config float TimeToStayFlippedOverMin;
var() const protected config float TimeToStayFlippedOverMax;
/** How long to stay flipped over if controlled by a player. */
var() const protected config float TimeToStayFlippedOverMin_Player;
var() const protected config float TimeToStayFlippedOverMax_Player;

var repnotify bool bCharging;
var repnotify bool bHiding;
var repnotify bool bExplode;
var repnotify bool bSpawnedFromKantus;

var bool bAllowFlipOver;


var() config vector AngularFlipImpulse;
var() config float LinearFlipImpulseStrength;

var config float ExplosionBaseDamage, ExplosionBaseDamagePlayer;
var config float ExplosionDamageFalloff;
var config float ExplosionDamageRadius;

var ParticleSystem KantusSpawnParticleSystem;

var bool bFlipped;

var protected AIAvoidanceCylinder AvoidanceCylinder;

var AutoNavMeshPathObstacleUnregister ObstacleLifetimeObject;

/** indicates the ticker is ignored by AI when playing SP/Campaign */
var bool bInvisibleInSP;

/** @hack so we can stop anim tree camera anims if we gib */
var array<CameraAnim> CameraAnimsUsedByAnimTree;

/** if this is false we exploded on our own volition */
var bool bExplosionInvoluntary;
/** person who shot at us last (person who set off the explosion) */
var Controller LastDamageInstigator;
var config float DamageMultiplierToSquadMatesOfExploder;


var() const protected name ExplosionBoneName;
var GearExplosion ExplosionTemplate;

/** These guys have a dust cloud around them all the time **/
var transient ParticleSystem DustCloudTemplate;
var transient ParticleSystemComponent PSC_DustCloud;
var name DustCloudSocketName;


struct native ChatterZone
{
	var float Range;
	var SoundCue Sound;
	var float NextPlayTime;
};
/** List of ranges which represent different zones to play different speed chatter sounds in **/
var() array<ChatterZone> ChatterZones;
var float LastChatterSoundTime;
var float MinTimeBetweenAllSounds;

/** the current zone for chatter sounds **/
var int CurrentChatterZone;

/** minimum time between chatters from the same zone **/
var() float MinChatterReplayTime;
/** maximum time between chatters from the same zone **/
var() float MaxChatterReplayTime;

var() float MinAmbientChatterReplayTime;
var() float MaxAmbientChatterReplayTime;

/** Cue to play every now and then when we have no enemy in range **/
var SoundCue AmbientSound;
/** next world time to play an ambient cue **/
var float NextAmbientSoundTime;

/** sound to play when the Ticker charges his enemy **/
var() SoundCue ChargeSound;
/** sound to play when the Ticker is scared and hides **/
var() SoundCue HideSound;
/** footstep sound **/
var() SoundCue FootstepLoop;
/** death sound, played just before explode */
var() SoundCue DeathSound;
/** sound that plays when the ticker gets flipped onto its back */
var() SoundCue FlipOverSound;

/** Audio component used to play footstep audio **/
var AudioComponent FootstepComp;

var		MaterialInstanceConstant		GlowMIC;
var		vector2d						GlowRange;
var		float							CurrentGlowVal;
var		float							ExplodeAnimDuration;

// once we do damage, this is on and we don't do damage any more
var bool bPopped;

/** Beast Mode's "charge" ability */
var transient protectedwrite float LastBeastModeChargeTime;
var() config protected const float MinTimeBetweenBeastModeCharges;
var() config protected const float BeastModeChargeSpeed;
var() config protected const float BeastModeChargeDuration;
var() config protected const float BeastModeExplodingSpeed;

replication
{
	if (Role == ROLE_Authority)
		bCharging, bHiding, bExplode, bSpawnedFromKantus;
}

cpptext
{
	virtual void PostProcessRBPhysics(FLOAT DeltaSeconds, const FVector& OldVelocity){/* Shhhh... it's cool */}
};

simulated event ReplicatedEvent(name VarName)
{
	if (VarName == 'bCharging')
	{
		if(bCharging)
		{
			PlayChargeSound();
		}
	}
	else if(VarName == 'bHiding')
	{
		if(bHiding)
		{
			PlayHideSound();
		}
	}
	else if(VarName == 'bExplode')
	{
		if(bExplode)
		{
			PlayExplodeAnim();
		}
		else
		{
			StopExplodeAnim();
		}
	}
	else if(VarName == 'bSpawnedFromkantus')
	{
		if(bSpawnedFromkantus)
		{
			PlayKantusSpawnEffects();
		}
	}
	else
	{
		Super.ReplicatedEvent(VarName);
	}
}

native function bool IsInvisible();

native event bool IsValidEnemyTargetFor(const PlayerReplicationInfo PRI, bool bNoPRIisEnemy);

simulated function PostBeginPlay()
{
	local GearInventoryManager Inv;
	Super.PostBeginPlay();

	// we don't need accuracy updates every frame, thanks
	Inv = GearInventoryManager(InvManager);
	if( Inv != none )
	{
		Inv.bSkipAccuracyUpdates = true;
	}

	PSC_DustCloud = new(self) class'ParticleSystemComponent';
	DetermineDustCloudType();
	SetTimer(1.0, true, nameof(DetermineDustCloudType));
	SetTimer(0.25, true, nameof(PlayFootStepSounds));
	if (Role == ROLE_Authority)
	{
		SetTimer(MinTimeBetweenAllSounds, true, nameof(PlayChatterSounds));
	}

	LastChatterSoundTime = WorldInfo.TimeSeconds + RandRange(MinChatterReplayTime,MaxChatterReplayTime);

	GlowMIC = Mesh.CreateAndSetMaterialInstanceConstant(0);

	// set up for siege?
	if (bBeastMode)
	{
		// players can come to a stop
		bForceMaxAccel = FALSE;
	}
}


function PossessedBy(Controller C, bool bVehicleTransition)
{
	Super.PossessedBy(C, bVehicleTransition);

	ExplosionBaseDamage = (PlayerController(Controller) != None) ? ExplosionBaseDamagePlayer : default.ExplosionBaseDamage;
}

// Client function so we can stop the ticker when siege rounds are over
reliable client function ClientStopAccelerating()
{
	bForceMaxAccel = FALSE;
}

simulated function PlayKantusSpawnEffects()
{
	bSpawnedFromKantus = true;
	WorldInfo.MyEmitterPool.SpawnEmitter(KantusSpawnParticleSystem, Location, rot(16384,0,0));
	//DesiredKantusFadeVal=0.4f;
}

exec simulated function PlayChargeSound()
{
	// jf: this is bad.  calling a function to play the sound shouldn't have this sort of side effect
	if(Role == ROLE_Authority)
	{
		bCharging = true;
	}

	PlaySound(ChargeSound, true);
}

simulated function PlayHideSound()
{
	// jf: this is bad.  calling a function to play the sound shouldn't have this sort of side effect
	if (Role == ROLE_Authority)
	{
		bHiding = true;
	}

	PlaySound(HideSound, true);
}

simulated function PlayExplodeAnim()
{
	local BodyStance	BS_Explode;
	local Rotator MeshFacingRot;

	if (Role == ROLE_Authority)
	{
		bExplode = true;
	}

	// animation turns mesh to face l/r when strafing, but explode anim assumes facing fwd
	// so adjust pawn rot to compensate
	MeshFacingRot = QuatToRotator(Mesh.GetBoneQuaternion('body'));
	MeshFacingRot.Pitch = Rotation.Pitch;
	MeshFacingRot.Roll = Rotation.Roll;
	SetRotation(MeshFacingRot);
	bLockRotation = true;

	BS_Explode.Stance.Length = 1; // Array of struct needs to be pre-sized.
	BS_Explode.Stance[0].Slot = BS_FullBody;
	BS_Explode.Stance[0].AnimName = 'Explode';

	if (bBeastMode)
	{
		BS_Play(BS_Explode, 1.f, 0.f, -1.f, FALSE,,, 0.85);
	}
	else
	{
		BS_Play(BS_Explode, 1.f, 0.f, -1.f, FALSE);
	}
	ExplodeAnimDuration = BS_GetTimeLeft(BS_Explode);

	CurrentGlowVal = GlowRange.X;

	PlayDeathSound();

	SetupAvoidanceCylinder();
}

simulated function StopExplodeAnim()
{
	//`log(GetFuncName());
	//ScriptTrace();
	if (AvoidanceCylinder != None)
	{
		AvoidanceCylinder.Destroy();
		AvoidanceCylinder = None;
	}

	bExplode = false;
	BS_StopAll(0.1f);
}

/** Player enemy support */
reliable server final function ServerExplode()
{
	if (!bExplode)
	{
		PlayExplodeAnim();

		if (bBeastMode)
		{
			GroundSpeed = DefaultGroundSpeed * BeastModeExplodingSpeed;
		}
		else
		{
			SetPhysics(PHYS_None);
			GroundSpeed = 0.0;
		}
	}
}
simulated function StartMeleeAttack()
{
	ServerExplode();
	Controller.bFire = 0;
}

simulated event Tick(float DeltaTime)
{
	Super.Tick(DeltaTime);

	// allow Fire to also trigger explosion
	if ( IsHumanControlled() && bool(Controller.bFire) && IsLocallyControlled() )
	{
		StartMeleeAttack();
	}

	if (bExplode)
	{
		CurrentGlowVal += ((GlowRange.Y - GlowRange.X)/ExplodeAnimDuration)*DeltaTime;
		GlowMIC.SetScalarParameterValue('TickerBrightness',CurrentGlowVal);
	}
	else if (CurrentGlowVal > GlowRange.X)
	{
		CurrentGlowVal -= ((GlowRange.Y - GlowRange.X)/ExplodeAnimDuration)*DeltaTime;
		GlowMIC.SetScalarParameterValue('TickerBrightness',CurrentGlowVal);
	}
}

function ANIM_NOTIFY_DoMeleeDamage();

simulated function bool CanBeSpecialMeleeAttacked( GearPawn Attacker )
{
	return FALSE;
}

simulated function GetWeaponHandPosition(out vector HandLoc, out rotator HandRot)
{
	// ticker has no hand so just return the Pawn location
	HandLoc = Location;
	HandRot = Rotation;
}

simulated function bool TookHeadShot(Name BoneName, vector HitLocation, vector Momentum, optional out byte out_bHasHelmet);

function TakeDamage( int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType,
			optional TraceHitInfo HitInfo, optional Actor DamageCauser )
{
	LastDamageInstigator = InstigatedBy;

	if ( Role == ROLE_Authority && InstigatedBy != Controller &&
		!ClassIsChildOf(DamageType, class'GDT_CleaverMelee') && !ClassIsChildOf(DamageType, class'GDT_Silverback_Footstep') &&
		(ClassIsChildOf(DamageType,class'GDT_TickerExplosion') || ClassIsChildOf(DamageType,class'GDT_Melee')) &&
		(!IsHumanControlled() || !WorldInfo.GRI.OnSameTeam(self, InstigatedBy)) )
	{
		if (Health > 1)
		{
			FlipMeOver(InstigatedBy);
			// make sure we survive the hit
			Damage = Min(Health-1,Damage);
		}
		else if (`TimeSince(KnockDownStartTime) < 0.5)
		{
			// Ignore knockdown damage for a bit so it doesn't double trigger
			Damage = 0;
		}

	}

	Super.TakeDamage(Damage,InstigatedBy,HitLocation,Momentum,DamageType,HitInfo,DamageCauser);
}


function FlipMeOver(Controller Inst)
{
	local vector Impulse;
	local rotator NewRot;

	if (bAllowFlipOver)
	{

		//MessagePlayer(GetFuncName()@self@MyGearAI);
		`AILog_Ext(GetFuncName() @ self,, MyGearAI);
		bFlipped = true;
		StopExplodeAnim();
		if (Inst != None)
		{
			Impulse = Normal((Location + vect(0,0,200)) - Inst.Pawn.Location);
		}
		else
		{
			Impulse = vector(Inst.Pawn.Rotation + rot(10,0,0));
		}

		Super.Knockdown(Impulse * LinearFlipImpulseStrength, AngularFlipImpulse >> rotator(Impulse));
	}

	PlaySound(FlipOverSound);
	if(bAllowFlipOver)
	{
		// hax
		GroundSpeed=0;
		NewRot = Rotation;
		NewRot.Pitch += 32768;
		SetDesiredRotation(NewRot);
	}
}


simulated function UnFlipMeOver()
{
	local rotator NewRot;

	bFlipped = false;

	GotoState('');

	GroundSpeed = DefaultGroundSpeed;

	NewRot = Rotation;
	NewRot.Pitch -= 32768;
	SetDesiredRotation(NewRot);
}

// called from anim notify
simulated function JumpStarted()
{
	//MessagePlayer(GetFuncName()@self@MyGearAI);
	bAllowFlipOver = false;
}

state KnockedDown
{
Begin:
	// apply the impulse
	ApplyKnockdownImpulse();
	do
	{
		// delay
		Sleep(0.35f);
		// until we're snapped out of physics, stopped moving, or the physics has gone to sleep
	} until (Physics != PHYS_RigidBody || VSize(Velocity) < 32.f || !Mesh.RigidBodyIsAwake());

	if (GearPC(Controller) != None)
	{
		// player controlled, use different time values
		Sleep(RandRange(TimeToStayFlippedOverMin_Player, TimeToStayFlippedOverMax_Player));
	}
	else
	{
		Sleep(RandRange(TimeToStayFlippedOverMin, TimeToStayFlippedOverMax));
	}

	// if we're still alive at this point
	if (Health > 0)
	{
		ServerDoSpecialMove(SM_RecoverFromRagdoll, TRUE);
		UnFlipMeOver();
		GotoState('');
	}
}

function float GetAIAccuracyModWhenTargetingMe(GearAI GuyTargetingMe)
{
	return 0.6f;
}

/** Applies the contents of KnockdownImpulse.  Clients shouldn't call this function directly, only from repnotify. */
simulated protected function ApplyKnockdownImpulse()
{
	`log("!!!"@`showvar(KnockdownImpulse.LinearVelocity)@`showvar(Location)@`showvar(Mesh.GetPosition()));
	// Record when knockdown happened
	KnockDownStartTime = WorldInfo.TimeSeconds;
	// bail out of cover
	if (IsInCover())
	{
		BreakFromCover();
	}
	if (Physics != PHYS_RigidBody || Mesh != CollisionComponent)
	{
		// first send them to ragdoll
		PlayFallDown();
	}
	if (Physics == PHYS_RigidBody)
	{
		// and apply the forces additively
		if (!IsZero(KnockdownImpulse.AngularVelocity))
		{
			Mesh.SetRBAngularVelocity(KnockdownImpulse.AngularVelocity,TRUE);
		}
		Mesh.SetRBLinearVelocity(KnockdownImpulse.LinearVelocity,TRUE);
	}
	else
	{
		`warn(self@"failed to transition to RigidBody for"@GetFuncName());
	}
}

function EndKnockedDownState()
{
	ClearTimer(nameof(EndKnockedDownState));
	ClearTimer(nameof(CheckGetUp));
	ClearTimer(nameof(KnockdownFailsafe));
	ClearTimer(nameof(EnableKnockdownFallChecking));

	KnockdownImpulse.LinearVelocity = vect(0,0,0);
	KnockdownImpulse.AngularVelocity = vect(0,0,0);

	// if we're still alive at this point
	if( Health > 0 && Physics == PHYS_RigidBody )
	{
		ServerDoSpecialMove(SM_RecoverFromRagdoll, TRUE);
		GotoState('');
	}
}

//////////////////////////////////////////////////////////////////////////
// AIobjectAvoidanceInterface
event AIAvoidanceCylinderComponent GetAIAvoidanceCylinderComponent()
{
	return (AvoidanceCylinder != None) ? AvoidanceCylinder.AvoidanceComp : None;
}

function bool ShouldAvoid(GearAI AskingAI, AIAvoidanceCylinderComponent TriggeringComponent)
{
	// enemy AI doesn't notice us if we've evaded its sight and it's busy with something else
	return ( AskingAI != Controller && (AskingAI.Enemy == self || AskingAI.TimeSinceLastSeenEnemy(self, true) < 1.0) &&
		FastTrace(Location, AskingAI.Pawn.Location,, true) );
}
function bool ShouldEvade(GearAI AskingAI, AIAvoidanceCylinderComponent TriggeringComponent)
{
	local float Thresh;

	// if the AI is not focused on us and unskilled, they just try to walk away instead of evading
	if (AskingAI.Enemy == self || AskingAI.CanEvade(true))
	{
		Thresh = ExplosionDamageRadius * 0.75;
		// evade if it's really close
		return VSize(AskingAI.Pawn.Location - Location) < Thresh;
	}
}
function bool ShouldRoadieRun(GearAI AskingAI, AIAvoidanceCylinderComponent TriggeringComponent);
function CoupleLifetime(Interface_NavMeshPathObstacle PO)
{
	ObstacleLifetimeObject = new(self) class'AutoNavMeshPathObstacleUnregister';
	ObstacleLifetimeObject.PathObstacleRef = PO;
}
// END AIobjectAvoidanceInterface
//////////////////////////////////////////////////////////////////////////

/**
 * @hack to stop camera anims played by the anim tree if we gib
 *
 * @param Killer - the controller that killed us
 *
 * @param GearDamageType - which damage type killed us
 *
 * @param HitLocation - where the damage occurred
 *
 * @return TRUE if death allowed
 */
function bool Died(Controller Killer, class<DamageType> GearDamageType, vector HitLocation)
{
	StopAnimTreeCameraAnimations();

	return Super.Died( Killer, GearDamageType, HitLocation );
}

/** @hack stop camera anims played by the anim tree if we gib */
function StopAnimTreeCameraAnimations()
{
	local int i;
	local GearPC GPC;

	GPC = GearPC(Controller);

	if (GPC != None && GPC.PlayerCamera != None)
	{
		for (i = 0; i < CameraAnimsUsedByAnimTree.Length; i++)
		{
			GPC.PlayerCamera.StopAllCameraAnimsByType(CameraAnimsUsedByAnimTree[i], TRUE);
		}
	}
}

/** How all tickers that self detonated die */
function Suicide()
{
	`Log("Suicide by ticker");
	Health = 0;
	LastHitBy = None;
	Died(Controller,class'GDT_TickerExplosion',Location);
}

/** Create Gore hit mask texture **/
/** this is to make it easy to create custom size of texture per different pawn **/
simulated protected function TextureRenderTarget2D CreateGoreMaskTexture()
{
	return class'TextureRenderTarget2D'.static.Create(32, 32, PF_G8, MakeLinearColor(0, 0, 0, 1));
}

protected function SetupAvoidanceCylinder()
{
	local float AvoidRadius;

	if( !bDeleteMe && AvoidanceCylinder == None )
	{
		AvoidRadius = ExplosionDamageRadius*0.65;
		AvoidanceCylinder = Spawn(class'AIAvoidanceCylinder',self,,Location,,,TRUE);
		if (AvoidanceCylinder != None)
		{
			AvoidanceCylinder.SetBase(self);
			AvoidanceCylinder.SetCylinderSize(AvoidRadius,AvoidRadius*2.0f);
			AvoidanceCylinder.SetEnabled(true);
		}
		//DrawDebugSphere(Location,AvoidRadius,16,255,0,0,TRUE);
	}
}

simulated final function int DetermineZoneForRange(float Range)
{
	local int i;

	for(i=0;i<ChatterZones.Length;i++)
	{
		if(Range < ChatterZones[i].Range )
		{
			return i;
		}
	}

	return -1;
}

simulated final function float GetRangeToPlayer()
{
	local PlayerController	PC;
	local float Closest;
	local float CurDist;
	Closest = 100000000.f;
	ForEach LocalPlayerControllers(class'PlayerController', PC)
	{
		if(PC.Pawn != none && PC.Pawn.Health > 0)
		{
			CurDist = VSize(PC.Pawn.Location - Location);
			Closest = FMin(CurDist,Closest);
		}
	}

	return Closest;
}

final function PlayChatterSounds()
{
	local int NewZone;

	NewZone = -1;

	if (GearAI(Controller) != None && GearAI(Controller).HasValidEnemy())
	{
		NewZone = DetermineZoneForRange(GetRangeToPlayer());
	}
	else if (IsHumanControlled())
	{
		NewZone = ChatterZones.length - 2;
	}

	if (NewZone != CurrentChatterZone)
	{
		CurrentChatterZone = NewZone;
	}

	if ( (WorldInfo.TimeSeconds >= LastChatterSoundTime + MinTimeBetweenAllSounds) && (GearPC_Siege(Controller) == None) )
	{
		if(CurrentChatterZone != -1)
		{
			if(WorldInfo.TimeSeconds >= ChatterZones[CurrentChatterZone].NextPlayTime)
			{
				//DEBUG
				//`log(GetFuncName()@self@"Playing "@ChatterZones[CurrentChatterZone].Sound@"Zone:"@CurrentChatterZone@"Range:"@GetRangeToPlayer());
				SpeakLine(None, ChatterZones[CurrentChatterZone].Sound);
				ChatterZones[CurrentChatterZone].NextPlayTime = WorldInfo.TimeSeconds + RandRange(MinChatterReplayTime,MaxChatterReplayTime);
				LastChatterSoundTime = WorldInfo.TimeSeconds;
			}
		}
		else
		{
			if(WorldInfo.TimeSeconds >= NextAmbientSoundTime)
			{
				SpeakLine(None, AmbientSound);
				NextAmbientSoundTime = WorldInfo.TimeSeconds + (RandRange(MinAmbientChatterReplayTime,MaxAmbientChatterReplayTime*2.0f));
				LastChatterSoundTime = WorldInfo.TimeSeconds;
			}
		}
	}
}

/** For Beast mode */
simulated function ForceChatterSound()
{
	if ( (CurrentChatterZone != -1) && (FRand() > 0.5f) )
	{
		SpeakLine(None, ChatterZones[CurrentChatterZone].Sound);
		ChatterZones[CurrentChatterZone].NextPlayTime = WorldInfo.TimeSeconds + RandRange(MinChatterReplayTime,MaxChatterReplayTime);
		LastChatterSoundTime = WorldInfo.TimeSeconds;
	}
	else
	{
		SpeakLine(None, AmbientSound);
		NextAmbientSoundTime = WorldInfo.TimeSeconds + (RandRange(MinAmbientChatterReplayTime,MaxAmbientChatterReplayTime*2.0f));
		LastChatterSoundTime = WorldInfo.TimeSeconds;
	}
}

simulated function PlayDeathSound()
{
	PlaySound(DeathSound, true);
}


/** This is called every second and will look to see if we are on top of a different PhysicalMaterial than before and update our dust cloud **/
simulated function DetermineDustCloudType()
{
	local ParticleSystem DustPS;

	DustPS = GetDustPS();
	//`log( "DustPS " $ DustPS );

	if( DustCloudTemplate != DustPS )
	{
		DustCloudTemplate = DustPS;
		PSC_DustCloud.SetTemplate( DustCloudTemplate );
		Mesh.AttachComponentToSocket( PSC_DustCloud, DustCloudSocketName );
		PSC_DustCloud.ActivateSystem();
		//`log( "attaching: " $ DustCloudTemplate );
	}
}

simulated function PlayFootStepSounds()
{
	if (FootstepLoop != None && WorldInfo.NetMode != NM_DedicatedServer)
	{
		if (VSizeSq(Velocity) > 256.0)
		{
			if (FootstepComp == None)
			{
				//`log(GetFuncName()@self@"creating audio component using "$FootStepLoop);
				FootstepComp = CreateAudioComponent(FootstepLoop, true, true);
				if ( FootstepComp != None )
				{
					//`log(GetFuncName()@Self@"Attaching audio comp");
					FootstepComp.bAutoDestroy = true;
					FootstepComp.Location = Location;
					AttachComponent(FootstepComp);
				}
			}

			if (FootstepComp != None)
			{
				FootstepComp.FadeIn(0.3, 1.0);
			}
		}
		else if (FootstepComp != None)
		{
			FootstepComp.FadeOut(0.5, 0.0);
		}
	}

}

simulated event Destroyed()
{
	Super.Destroyed();
	if(FootstepComp != none)
	{
		FootstepComp.FadeOut(0.1f,0.f);
	}

	if(AvoidanceCylinder!=none)
	{
		AvoidanceCylinder.Destroy();
		AvoidanceCylinder=none;
	}
}

/** Looks at the physical material below pawn and then determines the physical material and then gets the particle system to play out of it **/
simulated function ParticleSystem GetDustPS()
{
	local vector PawnLoc;
	local float CurrHeight;

	local vector out_HitLocation;
	local vector out_HitNormal;
	local vector TraceDest;
	local vector TraceStart;
	local vector TraceExtent;
	local TraceHitInfo HitInfo;

	local GearPhysicalMaterialProperty PhysMatProp;
	local ParticleSystem ImpactPS;
	local PhysicalMaterial PhysMaterial;

	PawnLoc = Location;
	CurrHeight = GetCollisionHeight();

	TraceStart = PawnLoc;
	TraceDest = TraceStart - ( Vect(0, 0, 1 ) * CurrHeight ) - Vect(0, 0, 16 );

	// trace down and see what we are standing on
	Trace( out_HitLocation, out_HitNormal, TraceDest, TraceStart, false, TraceExtent, HitInfo, TRACEFLAG_PhysicsVolumes );

	// grab the physical material to get things rolling
	PhysMaterial = class'GearPhysicalMaterialProperty'.static.GetImpactPhysicalMaterialHitInfo( Hitinfo );

	//`log( "PhysMaterial " $ PhysMaterial );

	// until we find a particle system or run out of stuff to look in
	while( ImpactPS == None && PhysMaterial != None )
	{
		PhysMatProp = GearPhysicalMaterialProperty(PhysMaterial.PhysicalMaterialProperty);
		if (PhysMatProp != None)
		{
			ImpactPS = PhysMatProp.FootStepInfo[CFST_Locust_Ticker].FootstepEffectPS;
		}

		//`LogExt("- Valid material property");

		PhysMaterial = PhysMaterial.Parent;
	}

	return ImpactPS;
}

simulated function Explode()
{
	if (bBeastMode && !bExplosionInvoluntary)
	{
		// in beast, hang in the air a touch longer before explosion
		SetTimer(0.2f,, nameof(ActuallyExplode));
	}
	else
	{
		ActuallyExplode();
	}
}

simulated function ActuallyExplode()
{
	local GearExplosionActor ExplosionActor;
	local Vector ExplosionLoc;
	local rotator ExplosionRot;
	local GearProj_Grenade Grenade;
	local array<GearProj_Grenade> GrenadesToExplode;

	//`log(GetFuncName()@bPopped@self);
	if(!bPopped)
	{
		//MessagePlayer(bExplosionInvoluntary);

		bPopped = TRUE;
		Mesh.GetSocketWorldLocationAndRotation(ExplosionBoneName, ExplosionLoc, ExplosionRot);

		// spawn explosion
		ExplosionActor = Spawn(class'GearExplosionActor', self,, ExplosionLoc, ExplosionRot);
		ExplosionActor.InstigatorController = Controller;
		ExplosionActor.AttacheeController = bExplosionInvoluntary ? LastDamageInstigator : None;
		ExplosionTemplate.InitFromContentTemplate();
		ExplosionTemplate.Damage = ExplosionBaseDamage;
		ExplosionTemplate.DamageRadius = ExplosionDamageRadius;
		ExplosionTemplate.DamageFalloffExponent = ExplosionDamageFalloff;
		ExplosionActor.Explode(ExplosionTemplate);

		if( WorldInfo.GRI.ShouldShowGore() )
		{
			// delay by a tick to spread out the cost a bit
			SetTimer(WorldInfo.DeltaSeconds + 0.01, false, nameof(SpawnABloodTrail_GibExplode_360));

			if ( EffectIsRelevant(Location, false) )
			{
				SpawnHeadChunks();
			}
		}

		PSC_DustCloud.DeactivateSystem();

		if (AvoidanceCylinder != none)
		{
			AvoidanceCylinder.Destroy();
			AvoidanceCylinder = none;
		}

		StopTickerSounds();

		Suicide();

		// blow up any attached grenades
		foreach BasedActors(class'GearProj_Grenade', Grenade)
		{
			// we need to add to a list and explode later as otherwise the list iteration will break
			GrenadesToExplode.AddItem(Grenade);
		}
		foreach GrenadesToExplode(Grenade)
		{
			Grenade.DoExplosion();
		}
	}
}

simulated function PlayRagDollDeath(class<GearDamageType> GearDamageType, vector HitLoc, bool bShowGore)
{
	// give time for any clients to get updated state
	SetHidden(true);
}

simulated function StopTickerSounds()
{
	ClearTimer('PlayChatterSounds');
	ClearTimer('PlayFootStepSounds');
	if (FootstepComp != None)
	{
		FootstepComp.FadeOut(0.1f,0.f);
		FootstepComp = None;
	}
}

simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	bExplosionInvoluntary = true;
	Explode();
	Super.PlayDying(DamageType,HitLoc);
}

simulated function UpdateMeshBoneControllers(float DeltaTime);
simulated function HandleWeaponFiring();

reliable server function ServerBeastModeCharge()
{
	BeastModeCharge();
}

simulated function BeastModeCharge()
{
	PlayChargeSound();
	// make sure to maintain the ratio in case we're under a slow effect
	GroundSpeed = (GroundSpeed / DefaultGroundSpeed) * DefaultGroundSpeed * BeastModeChargeSpeed;
	SetTimer(BeastModeChargeDuration, false, nameof(EndBeastModeCharge));
	LastBeastModeChargeTime = WorldInfo.TimeSeconds;
}

/** For beast mode */
simulated function TryToCharge()
{
	if (`TimeSince(LastBeastModeChargeTime) >= MinTimeBetweenBeastModeCharges)
	{
		BeastModeCharge();
		if (Role < ROLE_Authority)
		{
			ServerBeastModeCharge();
		}
	}
}

function EndBeastModeCharge()
{
	GroundSpeed = DefaultGroundSpeed * (GroundSpeed / DefaultGroundSpeed / BeastModeChargeSpeed);
	bCharging = false;
}

function SetGroundSpeedModifier(float NewModifier)
{
	GroundSpeed = DefaultGroundSpeed * NewModifier;
	if (IsTimerActive(nameof(EndBeastModeCharge)))
	{
		GroundSpeed *= BeastModeChargeSpeed;
	}
}

defaultproperties
{
	bCanDBNO=false
	bCanClimbLadders=false
	bCanPickupInventory=false
	bAllowFlipOver=true
	bForceMaxAccel=true
	bCanBeHealed=false
	SpecialMoveClasses(SM_RecoverFromRagdoll)=class'GSM_RecoverFromRagdoll_Ticker'
	SpecialMoveClasses(SM_Emerge_Type1)=class'GSM_Emerge'
	SpecialMoveClasses(SM_Emerge_Type2)=class'GSM_Emerge'
	SpecialMoveClasses(SM_Emerge_Type3)=class'GSM_Emerge'
	SpecialMoveClasses(SM_DeathAnimFire)=None // this is needed to make it so the pawn doesn't play the fire death anim and then be stuck in ragdoll forever

	bCanPlayPhysicsHitReactions=false

	NoticedGUDSPriority=105
	NoticedGUDSEvent=GUDEvent_NoticedTickers

	BaseEyeHeight=10
	EyeHeight=10
	SiegeTutorialType=GEARTUT_SIEGE_Ticker
}
