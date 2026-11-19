/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearWeap_Shotgun_SawedOff extends GearWeapon;

/** delay before playing the cock sound */
var config float ShotgunCockDelay;

/** delay before playing the ejected shell impact sound **/
var float ShotgunCockShellImpactDelay;

/** Shotgun cock shell impact sound */
var SoundCue ShotgunCockShellImpactSound;

/** Shotgun cocking after firing */
var GearPawn.BodyStance	BS_PawnShotgunCock;
var name WeaponCockAnim;

/** cosine of angle from player rotation for damage */
var config float DamageArc;
/** all hits within inner radius do 100% damage */
var config float InnerRadius;
/** all hits within outer radius but outside inner radius do damage linearly scaled from 100% to 0% */
var config float OuterRadius;

/** special hit effects for GearPawns */
var ParticleSystem BloodHitEffect, BloodHitEffectLambent;

simulated event PreBeginPlay()
{
	// bit of a hack to have different MP and Horde settings without adding yet another .ini file
	if (Role == ROLE_Authority && GearGameHorde_Base(WorldInfo.Game) != None)
	{
		WeaponDamage = 2500;
	}

	Super.PreBeginPlay();
}

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	// this weapon has different clip sizes depending on gametype, so adjust HUD
	HUDDrawData.DisplayCount = WeaponMagSize;
	HUDDrawData.AmmoIcon.UL *= WeaponMagSize;
	HUDDrawDataSuper.DisplayCount = WeaponMagSize;
	HUDDrawDataSuper.AmmoIcon.UL *= WeaponMagSize;
}

simulated state ShotgunCocking
{
	simulated function BeginState(Name PreviousStateName)
	{
		// animation is played when receiving the updated firing mode.
		SetCurrentFireMode(SHOTGUN_COCK_FIREMODE);
		SetTimer( GetFireInterval(0)*0.75f, FALSE, nameof(FinishedCockingShotgun) );
	}

	simulated function EndState(Name NextStateName)
	{
		// switch back to default firing mode.
		EndFire(SHOTGUN_COCK_FIREMODE);

		NotifyWeaponFinishedFiring( CurrentFireMode );
		SetCurrentFireMode(0);
	}

	simulated function FlashLocationUpdated(byte FiringMode, vector FlashLocation, bool bViaReplication)
	{
		// if we received an update from the server, it indicates the server is ahead of us
		// and already finished this phase, so exit immediately
		if (bViaReplication && !bClientSideInstantHit)
		{
			ClearTimer(nameof(FinishedCockingShotgun));
			FinishedCockingShotgun();
		}

		Super.FlashLocationUpdated(CurrentFireMode, FlashLocation, bViaReplication);
	}

	simulated function FinishedCockingShotgun()
	{
		// switch back to default firing mode.
		EndFire(SHOTGUN_COCK_FIREMODE);
		SetCurrentFireMode(0);

		// if switching to another weapon, abort firing and put down right away
		if( bWeaponPutDown )
		{
			PutDownWeapon();

			// Set weapon as not firing
			ClearFlashCount();
			ClearFlashLocation();
			return;
		}
		// If weapon should keep on firing, then do not leave state and fire again.
		if( ShouldRefire() )
		{
			GotoState('WeaponFiring');
			return;
		}

		// Set weapon as not firing
		ClearFlashCount();
		ClearFlashLocation();

		// Otherwise we're done firing, so go back to active state.
		GotoState('Active');

		// if out of ammo, then call weapon empty notification
		if( !HasAnyAmmo() )
		{
			WeaponEmpty();
		}
	}

	simulated function bool IsFiring()
	{
		return TRUE;
	}
}

simulated function FinishedCockingShotgun();


/**
 * Event called when Pawn.FiringMode has been changed.
 * bViaReplication indicates if this was the result of a replication call.
 */
simulated function FireModeUpdated(byte FiringMode, bool bViaReplication)
{
	super.FireModeUpdated(FiringMode, bViaReplication);

	// if we're reloading our weapon, play anim
	if( FiringMode == SHOTGUN_COCK_FIREMODE )
	{
		PlayShotgunCocking();
	}
}


simulated function PlayShotgunCocking()
{
	local GearPawn	P;
	local float		AnimTime;

	if( WorldInfo.NetMode != NM_DedicatedServer )
	{
		P = GearPawn(Instigator);

		AnimTime = GetFireInterval(0)*0.75f;

		if( P != None )
		{
			// play shotgun cocking body stance
			P.BS_PlayByDuration(BS_PawnShotgunCock, AnimTime, 0.3f, 0.3f, FALSE, TRUE, 'ShotgunCock');
		}

		// Play animation on weapon as well
		PlayWeaponAnimByDuration(WeaponCockAnim, AnimTime);

		// Play Weapon fire animation
		SetTimer( ShotgunCockShellImpactDelay, FALSE, nameof(PlayShotgunCockShellImpactSound) );
	}
}


/** Overriden to half firing duration, because cocking is in a separate state */
simulated function TimeWeaponFiring( byte FireModeNum )
{
	if (!IsTimerActive('RefireCheckTimer'))
	{
		SetTimer(GetFireInterval(FireModeNum)*0.25f, false, nameof(RefireCheckTimer));
	}
}


simulated state WeaponFiring
{
	simulated function bool ShouldRefire()
	{
		return FALSE;
	}

	simulated function EndState(Name NextStateName)
	{
		ClearTimer('RefireCheckTimer');
		if (NextStateName != 'WeaponPuttingDown')
		{
			// shotgun cocking is a must happen. Then it handles transition to other states.
			GotoState('ShotgunCocking');
		}
	}
}

simulated function float GetWeaponRating()
{
	local float Rating;
	local GearAI AI;
	local vector EnemyLoc;
	local Controller C;

	Rating = super.GetWeaponRating();

	C = GetWeaponController();

	if(  Rating > 0 &&
		 !Instigator.IsHumanControlled() &&
		 C != None &&
		 C.Enemy != None )
	{
		AI = GearAI(C);
		if (AI != None)
		{
			EnemyLoc = AI.GetEnemyLocation();
			// shotgun is really good at short range
			if (AI.IsShortRange(EnemyLoc))
			{
				Rating = 1.5f;
			}
			else
			{
				Rating = 0.25f;
			}
		}
	}

	return Rating;
}

simulated function PlayShellCaseEject();


simulated function PlayShotgunCockShellImpactSound()
{
	PlaySound( ShotgunCockShellImpactSound, true );
}

//@FIXME: temp hack to get slower reload since the anim overrules all
simulated function float PlayPawnReloadingAnimation(GearPawn GP)
{
	local FLOAT ReloadAnimTime;

	// Make sure Group starts from begining.
	GP.AnimTreeRootNode.ForceGroupRelativePosition('WeaponReload', 0.f);
	ReloadAnimTime = GP.BS_Play(BS_PawnWeaponReload, ReloadAnimRate, 0.25f, 0.33f, FALSE, TRUE, 'WeaponReload');
	GP.BS_SetEarlyAnimEndNotify(BS_PawnWeaponReload, FALSE);

	// uh oh problem
	if( ReloadAnimTime == 0.f || !GP.BS_IsPlaying(BS_PawnWeaponReload) )
	{
		`DLog("Failed to play reload animation for" @ GP @ "ReloadAnimTime:" @ ReloadAnimTime @ "IsPlaying?" @ GP.BS_IsPlaying(BS_PawnWeaponReload) @ "AnimTree:" @ GP.Mesh.Animations @ "Template:" @ GP.Mesh.AnimTreeTemplate @ "FullBodyNode:" @ GP.FullBodyNode);
	}

	return ReloadAnimTime;
}

simulated function float GetFireModeDamage(vector HitLocation, optional Actor HitActor)
{
	local float Result, Dist;

	Result = Super.GetFireModeDamage(HitLocation, HitActor);

	Dist = VSize(HitLocation - Instigator.Location);
	if (Dist > InnerRadius)
	{
		Result *= FClamp(1.0 - Dist / OuterRadius, 0.0, 1.0);
	}
	return Result;
}

/** causes hits against everything in a wide arc */
simulated function DoFireArc(vector StartTrace, vector ShotDir)
{
	local float ShotArc;
	local PrimitiveComponent Primitive;
	local ImpactInfo Impact;
	local TraceHitInfo HitInfo, EmptyHitInfo;
	local vector HitLocation, HitNormal, EndTrace, TestLoc;
	local bool bGotHit, bInCone;
	local Actor A, FirstHitActor;
	local Box ActorBox;
	local GearPawn GP;
	local int PawnsKilled;

	// trace is for effects on world geometry
	EndTrace = StartTrace + (ShotDir * GetTraceRange());
	Impact = CalcWeaponFire(StartTrace, EndTrace);

	if (!bSlaveWeapon && (Role == ROLE_Authority || bClientSideInstantHit))
	{
		SetFlashLocation(Impact.HitLocation);
	}

	ProcessInstantHit(CurrentFireMode, Impact, 1);
	FirstHitActor = Impact.HitActor;

	GP = GearPawn(FirstHitActor);
	if (GP != None && GP.bPlayedDeath && GP.KilledByPawn == Instigator && GP.TimeOfDeath == WorldInfo.TimeSeconds)
	{
		PawnsKilled++;
	}

	// do damage based on our special arc and radius
	ShotArc = DamageArc;
	foreach Instigator.CollidingActors(class'Actor', A, OuterRadius)
	{
		GP = GearPawn(A);
		if ( A != Instigator && A != FirstHitActor && (!A.bWorldGeometry || A.bCanBeDamaged) && (A.bProjTarget || A.bBlockActors) &&
			// since we hit all targets in range, ignore hostages since their holder will already get hit and we don't want them to get hit twice
			(GP == None || !GP.IsAHostage()) )
		{
			A.GetComponentsBoundingBox(ActorBox);
			bInCone = Normal(A.Location - Instigator.Location) dot ShotDir > ShotArc;
			if (!bInCone)
			{
				// try top and bottom of bounding box
				TestLoc = A.Location;
				TestLoc.Z = ActorBox.Max.Z;
				bInCone = Normal(TestLoc - Instigator.Location) dot ShotDir > ShotArc;
				if (!bInCone)
				{
					TestLoc.Z = ActorBox.Min.Z;
					bInCone = Normal(TestLoc - Instigator.Location) dot ShotDir > ShotArc;
				}
			}
			// use the bounding box for the world trace to account for meshes with way off center origins
			if (bInCone && A.FastTrace((ActorBox.Min + ActorBox.Max) * 0.5, StartTrace,, true))
			{
				Impact.HitActor = A;
				Impact.RayDir = Normal(A.Location - Instigator.Location);
				Impact.StartTrace = Instigator.Location;
				bGotHit = false;
				foreach A.AllOwnedComponents(class'PrimitiveComponent', Primitive)
				{
					if ( Primitive.CollideActors && Primitive.BlockZeroExtent &&
						A.TraceComponent(HitLocation, HitNormal, Primitive, A.Location, Instigator.Location,, HitInfo) )
					{
						Impact.HitLocation = HitLocation;
						Impact.HitNormal = HitNormal;
						Impact.HitInfo = HitInfo;
						bGotHit = true;
						break;
					}
				}
				if (!bGotHit)
				{
					// just insert a reasonable guess
					Impact.HitLocation = A.Location;
					Impact.HitNormal = -Impact.RayDir;
					Impact.HitInfo = EmptyHitInfo;
				}

				ProcessInstantHit(CurrentFireMode, Impact, 1);
				if (GP != None && GP.bPlayedDeath && GP.KilledByPawn == Instigator && GP.TimeOfDeath == WorldInfo.TimeSeconds)
				{
					PawnsKilled++;
				}
			}
		}
	}

	if (WorldInfo.Game != None)
	{
		if (PawnsKilled > 1)
		{
			GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_KilledMultipleWithSawedOff, Instigator, GP);
		}
		else if (PawnsKilled > 0)
		{
			GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_KilledEnemyGeneric, Instigator, GP);
		}
	}
}

simulated function CustomFire()
{
	local vector StartTrace, ShotDir;
	local rotator AimRot;

	if (WorldInfo.NetMode != NM_Client || bClientSideInstantHit)
	{
		StartTrace = Instigator.GetWeaponStartTraceLocation();
		AimRot = GetAdjustedAim(StartTrace);
		ShotDir = vector(AimRot);

		DoFireArc(StartTrace, ShotDir);
	}
	else if (Instigator.IsLocallyControlled())
	{
		// local player simulates firing locally, to give instant response.
		// FlashLocation will only replicate the exact impact location, and play impact effects.
		WeaponFired(CurrentFireMode);
	}
}

simulated function CalcRemoteImpactEffects(byte FireModeNum, vector GivenHitLocation, bool bViaReplication)
{
	local vector StartTrace, EndTrace;

	//`log( GetFuncName() @ WorldInfo.TimeSeconds );
	// this isn't exactly where the shot originated on the server, but it's
	// close enough as far as effects are concerned
	StartTrace = (Instigator != None) ? Instigator.GetWeaponStartTraceLocation() : GetPhysicalFireStartLoc();

	EndTrace = GivenHitLocation;

	// Shoot all pellets
	DoFireArc(StartTrace, Normal(EndTrace - StartTrace));
}

simulated function Texture2D GetCrosshairIcon(GearPC PC, out float XOffset, out float YOffset)
{
	XOffset = 0.25;
	return Super.GetCrosshairIcon(PC, XOffset, YOffset);
}

simulated function float GetWeaponDistanceForEnemyTrace()
{
	return Range_Short;
}

simulated static function SpawnImpactDecal(Pawn TheInstigator, GearWeapon Weapon, const class<GearDamageType> GearDmgType, const out ImpactInfo Impact, PhysicalMaterial PhysMaterial)
{
	local WorldInfo WI;
	local DecalData DecalData;
	local float DecalRotation;

	WI = class'Engine'.static.GetCurrentWorldInfo();

	if (GearPawn(Impact.HitActor) == None)
	{
		if (SkeletalMeshComponent(Impact.HitInfo.HitComponent) == None)
		{
			//`LogExt("Instigator:"@Instigator@"PhysMaterial:"@PhysMaterial@"HitActor:"@Impact.HitActor);
			DecalData = class'GearPhysicalMaterialProperty'.static.DetermineImpactDecalData( PhysMaterial, GearDmgType, GearPawn(TheInstigator) != None ? GearPawn(TheInstigator).bActiveReloadBonusActive : FALSE, WI, TheInstigator );

			// create the actual decal
			if (DecalData.bIsValid)
			{
				DecalData.bRandomizeRotation = false;
				if (TheInstigator != None && Abs(Impact.HitNormal.Y) == 0.0)
				{
					DecalRotation = float(rotator(Impact.HitLocation - TheInstigator.Location).Yaw) * UnrRotToDeg;
				}
				else
				{
					DecalRotation = 0.0;
				}
				class'GearDecal'.static.StaticAttachFromImpact(TheInstigator, Impact, DecalData, DecalRotation);
			}
		}
	}
}

simulated static function ParticleSystem GetImpactOverrideParticleSystem(ImpactInfo Hit)
{
	local GearPawn GP;
	local WorldInfo WI;

	WI = class'Engine'.static.GetCurrentWorldInfo();

	// Don't spawn blood on a vehicle or silverback
	if ( Hit.HitActor.IsA('Vehicle') || Hit.HitActor.IsA('GearPawn_SilverbackBase') || Hit.HitActor.IsA('GearPawn_LocustKantusArmorBase') ||
		(GearPawn(Hit.HitActor) != None && GearPawn(Hit.HitActor).ShouldPlayNonDamageHitEffects(Hit, None, default.InstantHitDamageTypes[0])) ||
		(Pawn(Hit.HitActor) != None && Pawn(Hit.HitActor).Health <= 0) || !WI.GRI.ShouldShowGore() )
	{
		return None;
	}
	else
	{
		// If it is a gearpawn and you did NOT hit the shield or a cleaver
		GP = GearPawn(Hit.HitActor);
		if (GP != None && !GP.HitEquipment(Hit.HitInfo.HitComponent))
		{
			return (GearPawnFX_Lambent(GP.GearPawnFX) != None) ? default.BloodHitEffectLambent : default.BloodHitEffect;
		}
		else
		{
			return None;
		}
	}
}

simulated static function SpawnImpactFX(Pawn TheInstigator, GearWeapon Weapon, const class<GearDamageType> GearDmgType, const out ImpactInfo Impact, bool bFatalShot, bool bMeleeHit, bool bPlayExplosiveRadialDamageEffects, bool bSuppressImpactFXIn)
{
	local PhysicalMaterial PhysMaterial;
	local WorldInfo WI;
	local GearPawn GP;
	local ImpactInfo NewImpactInfo;
	local vector Dir;

	Super.SpawnImpactFX(TheInstigator, Weapon, GearDmgType, Impact, bFatalShot, bMeleeHit, bPlayExplosiveRadialDamageEffects, bSuppressImpactFXIn);

	WI = class'Engine'.static.GetCurrentWorldInfo();

	if (!bMeleeHit && !GearDmgType.default.bSuppressImpactFX && WI.GRI.ShouldShowGore() &&
		(!bFatalShot || (Impact.HitActor != None && VSize(TheInstigator.Location - Impact.HitActor.Location) > class'GDT_Shotgun_SawedOff'.default.MaxGibDistance)))
	{
		GP = GearPawn(Impact.HitActor);
		// play an additional copy of the blood effects on GearPawns
		// use instigator for relevancy checking
		if ( GP != None && (WI.TimeSeconds - GP.TimeOfDeath < 20.0f || !GP.bTearOff) && GP.EffectIsRelevant(GP.Location, false, 2000.0) )
		{
			// grab the physical material to get things rolling
			PhysMaterial = class'GearPhysicalMaterialProperty'.static.GetImpactPhysicalMaterial(Impact);

			NewImpactInfo = Impact;
			Dir = (NewImpactInfo.HitLocation - GP.Location) >> GP.Rotation;
			Dir.X = 0;
			NewImpactInfo.HitLocation += Normal(Dir << GP.Rotation) * -20.0;
			SpawnImpactEffects(TheInstigator, Weapon, GearDmgType, NewImpactInfo, PhysMaterial, bFatalShot, bMeleeHit, bPlayExplosiveRadialDamageEffects, bSuppressImpactFXIn);
			NewImpactInfo.HitLocation += Normal(Dir << GP.Rotation) * 40.0;
			SpawnImpactEffects(TheInstigator, Weapon, GearDmgType, NewImpactInfo, PhysMaterial, bFatalShot, bMeleeHit, bPlayExplosiveRadialDamageEffects, bSuppressImpactFXIn);
		}
	}
}

defaultproperties
{
	WeaponStatName="SawedOffShotgun"

	NeedReloadNotifyThreshold=0

	HUDDrawData=(DisplayCount=1,AmmoIcon=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=0,V=265,UL=15,VL=7),ULPerAmmo=15)
	HUDDrawDataSuper=(DisplayCount=1,AmmoIcon=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=0,V=265,UL=15,VL=7),ULPerAmmo=15)

	WeaponID=WC_SawedOffShotgun

	ShotgunCockShellImpactDelay=0.7

	bWeaponCanBeReloaded=true
	bOverrideDistanceForEnemyTrace=true
	bMustBeInRangeToFire=TRUE

	// Weapon anim set
	CustomAnimSets(0)=AnimSet'COG_MarcusFenix.Animations.AnimSetMarcus_CamSkel_ShotgunSawoff'

	WeaponAnimType=EWAT_Shotgun
	BS_PawnWeaponReload={(Stance=(
		(Slot=BS_Layer1,AnimName="ADD_SS_Reload"),
		(Slot=BS_Layer_MidCov_Ready,AnimName="ADD_SS_Cov_Mid_Reload"),
		(Slot=BS_Layer_StdCov_Ready,AnimName="ADD_SS_Cov_Reload"))
		)}

	BS_PawnWeaponReloadFail={(Stance=(
		(Slot=BS_Layer1,AnimName="ADD_SS_Reload_Fail"),
		(Slot=BS_Layer_MidCov_Ready,AnimName="ADD_SS_Cov_Mid_Reload_Fail"),
		(Slot=BS_Layer_StdCov_Ready,AnimName="ADD_SS_Cov_Reload_Fail"))
		)}

		// No success animations, just speed up the normal one.
	BS_PawnWeaponReloadSuccess={(Stance=())}

	BS_PawnShotgunCock={(Stance=(
		(Slot=BS_Layer1,AnimName="ADD_SG_Idle_Ready_Chamber"),
		(Slot=BS_Layer_MidCov_Ready,AnimName="ADD_SG_Cov_Mid_Chamber"),
		(Slot=BS_Layer_StdCov_Ready,AnimName="ADD_SG_Cov_Std_Chamber"),
		(Slot=BS_Layer_StdCov_BackToWall,AnimName="ADD_SG_Cov_Std_Back_Chamber"),
		(Slot=BS_Layer_StdCov_BlindSide,AnimName="ADD_SG_Cov_Std_Blind_Chamber"),
		(Slot=BS_Layer_StdCov_Lean,AnimName="ADD_SG_Cov_Std_Lean_Chamber"),
		(Slot=BS_Layer_MidCov_BackToWall,AnimName="ADD_SG_Cov_Mid_Back_Chamber"),
		(Slot=BS_Layer_MidCov_BlindSide,AnimName="ADD_SG_Cov_Mid_Blind_Chamber"),
		(Slot=BS_Layer_MidCov_BlindUp,AnimName="ADD_SG_Cov_Mid_Blind_Up_Chamber"),
		(Slot=BS_Layer_MidCov_Lean,AnimName="ADD_SG_Cov_Mid_Lean_Chamber"))
		)}

	FireSound=SoundCue'Weapon_Shotgun.SawedOff.SawedOffShotgun_FireMono_Cue'
	FireSound_Player=SoundCue'Weapon_Shotgun.SawedOff.SawedOffShotgun_FireStereo_Cue'
	FireSound_Squad=SoundCue'Weapon_Shotgun.SawedOff.SawedOffShotgun_FireSquad_Cue'
	ShotgunCockShellImpactSound=SoundCue'Weapon_Shotgun.Reloads.ShotgunAmmoBounceCue'
	AlmostOutOfAmmoSound=SoundCue'Weapon_Shotgun.SawedOff.SawedOffShotgun_FireStereoEmpty_Cue'

	BulletWhipArchetype=GearBulletWhip'GearSoundGroupArchetypes.BulletWhips.Shotgun'

	WeaponEquipSound=SoundCue'Weapon_Shotgun.Actions.ShotgunRaiseCue'
	WeaponDeEquipSound=SoundCue'Weapon_Shotgun.Actions.ShotgunLowerCue'
	PickupSound=SoundCue'Weapon_Shotgun.Actions.ShotgunPickupCue'
	WeaponDropSound=SoundCue'Weapon_Shotgun.Actions.ShotgunDropCue'

	InstantHitDamageTypes(0)=class'GDT_Shotgun_SawedOff'
	WeaponFireTypes(0)=EWFT_Custom
	AmmoTypeClass=class'GearAmmoType_Shotgun_SawedOff'

	// Weapon Animation
	Begin Object Class=AnimNodeSequence Name=WeaponAnimNode
    	AnimSeqName=""
	End Object
	WeaponFireAnim=""
	WeaponReloadAnim="SG_Reload"
	WeaponReloadAnimFail="SG_Reload_Fail"
	WeaponReloadAnimSuccess="SG_Reload_Success"
	WeaponCockAnim="SG_Chamber"

	// Weapon Mesh
	Begin Object Name=WeaponMesh
		SkeletalMesh=SkeletalMesh'COG_SawedShotgun.Meshes.COG_Double_Barrel'
		PhysicsAsset=PhysicsAsset'COG_SawedShotgun.Meshes.COG_Double_Barrel_Physics'
		AnimSets(0)=AnimSet'COG_SawedShotgun.Animations.COG_SawedShotgun_Anim'
		Animations=WeaponAnimNode
	End Object
	Mesh=WeaponMesh
	DroppedPickupMesh=WeaponMesh

	FireOffset=(X=66,Y=-1,Z=1.0)

	// shell case ejection emitter
	Begin Object Name=PSC_WeaponShellCaseComp
		Template=ParticleSystem'COG_Gnasher.Effects.Gnasher_Shells'
		Translation=(X=24,Y=0,Z=10)
	End Object
	PSC_ShellEject=PSC_WeaponShellCaseComp

	// reload barrel smoke
	Begin Object Name=PSC_WeaponReloadBarrelSmokeComp
		Template=ParticleSystem'COG_SawedShotgun.Effects.P_COG_Sawed_Shotgun_Reload_Smoke'
	End Object
	PSC_ReloadBarrelSmoke=PSC_WeaponReloadBarrelSmokeComp

	bCanDisplayReloadTutorial=true
	DamageTypeClassForUI=class'GDT_Shotgun_SawedOff'
	WeaponIcon=(Texture=Texture2D'Warfare_HUD.Gears3_WeaponIcons',U=0,V=47,UL=143,VL=46)
	AnnexWeaponIcon=(U=0,V=362,UL=128,VL=39)
	CrosshairIcon=Texture2D'Warfare_HUD.HUD.HUD_Xhair_COG_SawedOff'
	bCrosshairMirrored=true

	bInstantHit=true

	Recoil_Hand={(
					LocAmplitude=(X=-10,Y=6,Z=-6),
					LocFrequency=(X=15,Y=10,Z=10),
					LocParams=(X=ERS_Zero,Y=ERS_Zero,Z=ERS_Zero),
					RotAmplitude=(X=7000,Y=200,Z=0),
					RotFrequency=(X=8,Y=5,Z=0),
					RotParams=(X=ERS_Zero,Y=ERS_Random,Z=ERS_Zero),
					TimeDuration=0.5f
					)}

	Recoil_Spine={(
					RotAmplitude=(X=2000,Y=300,Z=0),
					RotFrequency=(X=10,Y=10,Z=0),
					RotParams=(X=ERS_Zero,Y=ERS_Random,Z=ERS_Zero),
					TimeDuration=0.50f
					)}

	MeleeImpactSound=SoundCue'Weapon_Boomer.Reloads.BoomerHitCue'

	LC_EmisDefaultCOG=(R=0.0,G=0.0,B=0.0,A=1.0)
	LC_EmisDefaultLocust=(R=0.0,G=0.0,B=0.0,A=1.0)

	Begin Object Class=GearCameraShake Name=FireCameraShake0
		OscillationDuration=0.33f
		RotOscillation={(Pitch=(Amplitude=500.f,Frequency=15.f,InitialOffset=EOO_OffsetZero),
						Yaw=(Amplitude=100.f,Frequency=10.f),
						Roll=(Amplitude=-500.f,Frequency=10.f))}
		LocOscillation={(X=(Amplitude=10.f,Frequency=15.f,InitialOffset=EOO_OffsetZero))}
		bOverrideTargetingDampening=TRUE
		TargetingDampening=1.0
	End Object
	FireCameraShake=FireCameraShake0

	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformShooting1
	    Samples(0)=(LeftAmplitude=50,RightAmplitude=50,LeftFunction=WF_LinearDecreasing,RightFunction=WF_LinearDecreasing,Duration=0.400)
	End Object
	WeaponFireWaveForm=ForceFeedbackWaveformShooting1

	TracerType=WTT_SawedOff
	TracerTypeAR=WTT_SawedOff_AR

	WeaponRange=384.0

	MuzzleFlashArchetype=GearMuzzleFlash'GearMuzzleFlashes.GearWeap_Shotgun_SawedOff_MuzFlash'
	BloodHitEffect=ParticleSystem'Effects_Gameplay.Blood.P_Blood_Sawed_Off_Hit'
	BloodHitEffectLambent=ParticleSystem'Effects_Gameplay.Blood_Lambent.P_Blood_Sawed_Off_Hit_Lambent'

	// CQC Long Executions
	LongExecutions(3)={(CQC_Long_KillerAnim="CTRL_Sawedoff",
						CQC_Long_KillerWeaponAnim="SG_Execution",
						CQC_Long_KillerAnim_Loop="",
						CQC_Long_KillerAnim_End="",
						CQC_Long_VictimAnim="DBNO_Sawedoff",
						CQC_Long_VictimAnim_Loop="",
						CQC_Long_VictimAnim_End="",
						CQC_Long_bHolsterWeapon=FALSE,
						CQC_Long_VictimDeathTime=4.f,
						CQC_Long_VictimRotStartTime=0.f,
						CQC_Long_VictimRotInterpSpeed=0.f,
						CQC_Long_CameraAnims=(CameraAnim'COG_MarcusFenix.Camera_Anims.DBNO_SawedOff_Cam01', CameraAnim'COG_MarcusFenix.Camera_Anims.DBNO_SawedOff_Cam02', CameraAnim'COG_MarcusFenix.Camera_Anims.DBNO_SawedOff_Cam03', CameraAnim'COG_MarcusFenix.Camera_Anims.DBNO_SawedOff_Cam04'),
						CQC_Long_DamageType=class'GDT_LongExecution_SawedOff',
						CQC_Long_EffortID=GearEffort_None,
						MarkerRelOffset=(X=80.466,Y=24.848,Z=0),
						CameraLensEffect=class'Emit_CameraBlood_LongExecution_Gnasher',
						AwardRequired="SawedOffShotgunExecution")}

	// These are the player's bling skin options
	WeaponSkins(0)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.SawedOff.COG_WeaponShader_SawedOff_Gold'
	WeaponSkins(1)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.SawedOff.COG_WeaponShader_SawedOff_CHROME'
	WeaponSkins(2)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.SawedOff.COG_WeaponShader_SawedOff_OMEN'
	WeaponSkins(3)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.SawedOff.COG_WeaponShader_SawedOff_TRIBALMASKED'
	WeaponSkins(4)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.SawedOff.COG_WeaponShader_SawedOff_CAMO'
	WeaponSkins(5)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.SawedOff.COG_WeaponShader_SawedOff_DIGITAL'
	WeaponSkins(6)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.SawedOff.COG_WeaponShader_SawedOff_PINK'
	WeaponSkins(7)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.SawedOff.COG_WeaponShader_SawedOff_GARISH'
	WeaponSkins(8)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.SawedOff.COG_WeaponShader_SawedOff_BLOOD'
	WeaponSkins(9)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.SawedOff.COG_WeaponShader_SawedOff_CRACKLE'
	WeaponSkins(10)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.SawedOff.COG_WeaponShader_SawedOff_FLOWER'
	WeaponSkins(11)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.SawedOff.COG_WeaponShader_SawedOff_PAISLEY'
	WeaponSkins(12)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.SawedOff.COG_WeaponShader_SawedOff_TRIBAL'
	WeaponSkins(13)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.SawedOff.COG_WeaponShader_SawedOff_URBAN'
	WeaponSkins(14)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.SawedOff.COG_WeaponShader_SawedOff_XBOX'
}
