/**
* Digger Launcher
*
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/
class GearWeap_DiggerLauncher extends GearWeapon
	abstract;

/** projectile for the simulated trail */
var GearProj_DiggerMissile SimulatedProj;

var ParticleSystemComponent PSC_Trail;
var ParticleSystem PS_TrailCOG;
var ParticleSystem PS_TrailLocust;

/** Reload animations for the boomer */
var	BodyStance	BS_BoomerReload, BS_BoomerReloadFail;

/**
 * End points particle effects
 */
var Emitter EM_EndPoint;
var ParticleSystem PS_EndPointCOG;
var ParticleSystem PS_EndPointLocust;

/** Kill off the emitters that we spawned **/
simulated function Destroyed()
{
	if( SimulatedProj != none )
	{
		SimulatedProj.Destroy();
		SimulatedProj = none;
	}

	if( EM_EndPoint != none )
	{
		EM_EndPoint.Destroy();
		EM_EndPoint = none;
	}

	Super.Destroyed();
}

simulated function AttachWeaponTo(SkeletalMeshComponent MeshCpnt, optional name SocketName)
{
	Super.AttachWeaponTo(MeshCpnt, SocketName);

	//@hack: the reference pose of the mesh has a different transform on the clip for some reason,
	//	so play the anim at startup really fast to avoid it being wrong until the first reload
	PlayWeaponAnimByDuration(WeaponReloadAnim, 0.001);
}

/** turns on the simulated projectile trail */
simulated function SetUpSimulation()
{
	if (PlayerController(GetWeaponController()) == None)
	{
		// no arc for AI
		return;
	}

	if (SimulatedProj == None || SimulatedProj.bDeleteMe)
	{
		GetWeaponController().ShotTarget = None; // make sure simulated projectile doesn't try to warn an old real target
		SimulatedProj = GearProj_DiggerMissile(Spawn(WeaponProjectiles[0],,, GetPhysicalFireStartLoc()));
		if (SimulatedProj == None)
		{
			return;
		}
		SimulatedProj.RemoteRole = ROLE_None;
		SimulatedProj.bIsSimulating = true;
		SimulatedProj.bIgnoreFoliageTouch = TRUE;
		SimulatedProj.SetOwner(self);
		SimulatedProj.LifeSpan = 0.f;
		SimulatedProj.bAddBaseVelocity = false;		// no base vel compensation for simulation, since that happens all in one frame
		if (SimulatedProj.TrailEmitter != None)
		{
			SimulatedProj.TrailEmitter.Destroy();
		}
	}

	SimulatedProj.SetHidden(false);
	SimulatedProj.SetCollision(true, false, false);
	SimulatedProj.Enable('Tick');

	if (EM_EndPoint == None)
	{
		EM_EndPoint = Spawn(class'SpawnedGearEmitter', Instigator,, Location);
		EM_EndPoint.LifeSpan = 0;
		EM_EndPoint.SetHidden(true);
		EM_EndPoint.SetOnlyOwnerSee(true);
		EM_EndPoint.SetTemplate((GetWeaponController().GetTeamNum() == 0) ? PS_EndPointCOG : PS_EndPointLocust);
		EM_EndPoint.ParticleSystemComponent.SetDepthPriorityGroup(SDPG_Foreground);
		EM_EndPoint.ParticleSystemComponent.ActivateSystem();
	}

	if (PSC_Trail == None)
	{
		PSC_Trail = new(self) class'ParticleSystemComponent';
		PSC_Trail.SetTemplate((GetWeaponController().GetTeamNum() == 0) ? PS_TrailCOG : PS_TrailLocust);
		PSC_Trail.SetOnlyOwnerSee(true);
		PSC_Trail.SetActorParameter('TrailActor', SimulatedProj);
		PSC_Trail.SetDepthPriorityGroup(SDPG_Foreground);
		SimulatedProj.AttachComponent(PSC_Trail);
		PSC_Trail.SetHidden(true);
	}
}

/**
 * This will will simulate the projectile arc (in c++) and then tick the trail emitter
 * which causes the list of particles to grow.
 * At the end of the simulation the particle system has an entire trail of particles
 * representing the path of the projectile.
 *
 * Then the arc is turned "on" so that it is visible to the client.
 */
simulated function SimulateTrajectory()
{
	local vector ImpactLoc, StartLoc, ImpactNormal, ProjLoc, ProjDir;
	local Controller PawnController;

	// purely a client-side effect, no need for server to care
	PawnController = GetWeaponController();
	if (Instigator == None || !Instigator.IsLocallyControlled(PawnController) || !Instigator.IsHumanControlled(PawnController))
	{
		return;
	}

	SetUpSimulation();

	if (SimulatedProj == None || SimulatedProj.bDeleteMe)
	{
		`Warn("Simulated projectile spawning failure");
		return;
	}

	EM_EndPoint.SetHidden(false);

	PSC_Trail.SetHidden(false);
	PSC_Trail.ActivateSystem();

	StartLoc = GetPhysicalFireStartLoc();

	// unhide and init projectile
	SimulatedProj.SetHidden(false);
	SimulatedProj.SetLocation(StartLoc);
	GetProjectileFirePosition(ProjLoc, ProjDir);
	SimulatedProj.Init(ProjDir);

	SimulatedProj.RunPhysicsSimulationTilEnd(SimulatedProj.BurrowTime);
	ImpactLoc = SimulatedProj.Location;
	ImpactNormal = SimulatedProj.LastTraceResultNormal;
	if (IsZero(ImpactNormal))
	{
		ImpactNormal = vect(0,0,1);
	}

	// position end points
	if (!EM_EndPoint.bHidden)
	{
		EM_EndPoint.SetLocation(ImpactLoc);
		EM_EndPoint.SetRotation(rotator(ImpactNormal));
	}
}

simulated function GetProjectileFirePosition( out vector out_ProjLoc, out vector out_ProjDir, optional out float out_ProjSpeed )
{
	local GearPawn GP;

	Super.GetProjectileFirePosition(out_ProjLoc, out_ProjDir, out_ProjSpeed );

	// push a bit upwards when blindfiring to reduce probability of users blowing themselves up with poor shots
	GP = GearPawn(Instigator);
	if (GP != None && (GP.CoverAction == CA_Default || GP.IsBlindFiring(GP.CoverAction)))
	{
		out_ProjDir = vector(rotator(out_ProjDir) + rot(800,0,0));
	}
}

/** turns off the simulated projectile trail */
simulated function StopSimulation()
{
	if (PSC_Trail != None)
	{
		PSC_Trail.SetHidden(true);
		PSC_Trail.DeactivateSystem();

		EM_EndPoint.SetHidden(true);
	}

	if (SimulatedProj != None)
	{
		SimulatedProj.SetHidden(true);
		SimulatedProj.SetCollision(false, false, false);
		SimulatedProj.Disable('Tick');
	}
}

// Support for Boomer playing different reload animations.
simulated function PlayWeaponReloading()
{
	if( Instigator.IsA('GearPawn_LocustBoomerBase') )
	{
		BS_PawnWeaponReload = BS_BoomerReload;
		BS_PawnWeaponReloadFail = BS_BoomerReloadFail;
	}
	else
	{
		BS_PawnWeaponReload = default.BS_PawnWeaponReload;
		BS_PawnWeaponReloadFail = default.BS_PawnWeaponReloadFail;
	}

	Super.PlayWeaponReloading();
}

simulated state Active
{
	simulated event EndState(name NextStateName)
	{
		StopSimulation();

		Super.EndState(NextStateName);
	}

	simulated function Tick(float DeltaTime)
	{
		local GearPawn P;

		// decide whether we should draw the simulated trail
		P = GearPawn(Instigator);
		if ( P != None && P.bIsTargeting && P.IsLocallyControlled() && P.IsHumanControlled() && HasAnyAmmo() &&
			 (P.CoverType == CT_None || P.IsLeaning() || P.bDoing360Aiming) )
		{
			SimulateTrajectory();
		}
		else
		{
			StopSimulation();
		}
	}
}

simulated function PerformWeaponAttachment(SkeletalMeshComponent MeshCpnt, optional Name SocketName)
{
	// Scale for boomer
	if( Instigator.IsA('GearPawn_LocustBoomerBase') )
	{
		Mesh.SetScale(1.f);
		Mesh.SetRotation( rot(0,0,0) );
		Mesh.SetTranslation( Vect(0,0,0) );
	}
	// Scale for everyone else
	else
	{
		Mesh.SetScale(default.Mesh.Scale);
		Mesh.SetRotation(default.Mesh.Rotation);
		Mesh.SetTranslation(default.Mesh.Translation);
	}

	Super.PerformWeaponAttachment(MeshCpnt, SocketName);

}

/** notification fired from Pawn animation when clip is released from weapon. */
simulated function Notify_AmmoRelease()
{
	local SkeletalMeshComponent SkelMesh;
	local vector MagLoc;
	local rotator MagRot;

	// Skip on dedicated servers, below is just cosmetic
	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		// Hide Ammo part on weapon mesh
		SetWeaponAmmoBoneDisplay(false);

		// Spawn physics magazine instead
		SkelMesh = SkeletalMeshComponent(Mesh);
		SkelMesh.GetSocketWorldLocationAndRotation('Magazine', MagLoc, MagRot);

		// Spawn physics Magazine
		SpawnPhysicsMagazine(MagLoc, MagRot);
	}
}

function bool IsSuppressive()
{
	local GearAI AI;

	// since this weapon can hit through/around cover in some situations, continue to fire for a short time after losing sight of the enemy
	// but not if the enemy has been gone for a while as they're not likely to still be there and we don't want to waste ammo
	AI = GearAI(Instigator.Controller);
	return (AI.Enemy != None && AI.TimeSinceLastSeenEnemy(AI.Enemy) < 5.0);
}

function OverrideAIAimRotation(out rotator DesiredAimRot, vector StartFireLoc, vector AimLoc)
{
	local class<GearProjectile> ProjClass;
	local class<GearProj_DiggerMissile> DiggerProjClass;
	local vector TossVelocity;
	local float ProjSpeed;
	local GearPawn P;

	// when standard infantry fire out in the open, arc a bit to a) avoid cover in front of me, b) to try for direct hit, and c) because it travels faster in the air
	P = GearPawn(Instigator);
	if (P != None && P.bCanUseCover && !P.IsInCover())
	{
		// pretend low gravity so AI only adjusts a bit upwards and doesn't try for a direct hit on long shots
		ProjClass = class<GearProjectile>(GetProjectileClass());
		DiggerProjClass = class<GearProj_DiggerMissile>(ProjClass);
		ProjSpeed = (DiggerProjClass != None) ? DiggerProjClass.default.AirSpeed : ProjClass.default.Speed;
		Instigator.SuggestTossVelocity(TossVelocity, AimLoc, StartFireLoc, ProjSpeed,, 0.2,,, Instigator.PhysicsVolume.GetGravityZ() * ProjClass.default.GravityScale * 0.25);

		DesiredAimRot.Pitch = Max(DesiredAimRot.Pitch, rotator(TossVelocity).Pitch);
	}
}

// no crosshair
simulated function bool ShouldDrawCrosshair();
simulated function DrawWeaponCrosshair(Hud H);

defaultproperties
{
	WeaponStatName="DiggerLauncher"

	AIRating=1.5
	bWeaponCanBeReloaded=true
	bIsSuppressive=true
	bNoAnimDelayFiring=false
	bCanNegateMeatShield=true
	bIgnoresExecutionRules=true
	bLeadTarget=true

	MinBlindFireUpAimPitch=-256
	MinBlindFireSideYaw=-600

	WeaponFireAnim="AR_Fire_Boomshot"
	WeaponReloadAnim="AR_Reload"
	WeaponReloadAnimFail="AR_Reload_Fail"

	BS_BoomerReload=(Stance=((Slot=BS_Std_Up,AnimName="AR_Reload")))
	BS_BoomerReloadFail=(Stance=((Slot=BS_Std_Up,AnimName="AR_Reload_Fail")))

	// Weapon Mesh
	Begin Object Name=WeaponMesh
	End Object
	Mesh=WeaponMesh
	DroppedPickupMesh=WeaponMesh

	bBlindFirable=true

	Begin Object Class=GearCameraShake Name=FireCameraShake0
		OscillationDuration=0.5f
		RotOscillation={(Pitch=(Amplitude=300.f,Frequency=25.f,InitialOffset=EOO_OffsetZero),
						Yaw=(Amplitude=75.f,Frequency=25.f),
						Roll=(Amplitude=150.f,Frequency=50.f))}
		LocOscillation={(X=(Amplitude=-50.f,Frequency=1.f,InitialOffset=EOO_OffsetZero),
						Y=(Amplitude=0.f,Frequency=0.f),
						Z=(Amplitude=0.f,Frequency=0.f))}
		bOverrideTargetingDampening=true
		TargetingDampening=1.f
	End Object
	FireCameraShake=FireCameraShake0

	MuzzleFlashArchetype=GearMuzzleFlash'GearMuzzleFlashes.GearWeap_DiggerLauncher_MuzFlash'
}
