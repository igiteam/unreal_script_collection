/**
 * Shotgun "Gnasher"
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearWeap_Shotgun extends GearWeapon;


var array<vector2D> PelletSpread;

/** delay before playing the cock sound */
var()	config float	ShotgunCockDelay;

/** delay before playing the ejected shell impact sound **/
var     float       ShotgunCockShellImpactDelay;

/** Shotgun cock shell impact sound */
var		SoundCue	ShotgunCockShellImpactSound;

/** Shotgun cocking after firing */
var()	GearPawn.BodyStance	BS_PawnShotgunCock;
var()	name				WeaponCockAnim;

/** Distance to back up from the trace start, to avoid starting the trace inside an enemy */
var()	float			StartTraceAdjustDist;

/** Temporary value used by FireAllPellets/GetFireModeDamage to handle the special damage values depending on number of hits */
var transient int TransientShotgunDamage;

var transient float LastImpactSoundTime;

//Modifier to the spread of the pellets
var() config float SpreadMultiplier;

/** Struct used in FireAllPellets to track individual hits */
struct ShotgunHitInfo
{
	var Actor HitActor;
	var int NumHits;
	var ImpactInfo Impact;
};

/** list of locations hit in last shot */
var array<vector> LastHitLocations;
/** indicates LastHitLocations are from a hit on a Lambent pawn (use a different hit material) */
var bool bLastHitWasLambent;
/** Disable screenspace blood effects */
var bool bSkipScreenSpaceHit;
/** value used for semirandom rotation of the hit indicators */
var int HitIconRotationSeed;
/** scale of X/Y in the pellet info to X/Y on the crosshair */
var float CrosshairPelletScale;
/** icon used in crosshair to mark pellet hits */
var MaterialInterface CrosshairHitMat, CrosshairHitMatNoGore, CrosshairHitMatLambent;
/** MIC for the fade on the hit material */
var MaterialInstanceConstant CrosshairHitMIC;

/** List of all the hit locations that were traced to when shooting */
var array<Vector> AllHitLocation;

/** Whether the shotgun cares about OnSameTeam checks for determining the handling of impacts */
var bool bIgnoreTeamCheck;

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

simulated function bool AllowPickupMove()
{
	// the cocking state transition has some bad interactions with the pickup move, so don't allow it for the shotgun while firing
	return !IsFiring();
}

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
		//PlayWeaponAnimByDuration(WeaponFireAnim, GetFireInterval(FireModeNum));
		SetTimer( ShotgunCockDelay, FALSE, nameof(PlayShotgunCockSound) );
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


simulated function CustomFire()
{
	local vector StartTrace, EndTrace, ShotDir;
	local rotator AimRot;
	local ImpactInfo Impact;

	if (WorldInfo.NetMode != NM_Client || bClientSideInstantHit)
	{
		// grab from the pawn
		StartTrace = Instigator.GetWeaponStartTraceLocation();

		AimRot = GetAdjustedAim(StartTrace);
		ShotDir = vector(AimRot);

		EndTrace = StartTrace + (ShotDir * GetTraceRange());
		Impact = CalcWeaponFire(StartTrace, EndTrace);

		// Set FlashLocation to be the point of impact.
		// A completely new set of traces will be performed on remote clients.
		// But we keep the general area of impact. Individual pellets will be slightly different on every client.
		SetFlashLocation(Impact.HitLocation);

		// Shoot all pellets
		FireAllPellets(StartTrace, AimRot, CurrentFireMode);

	}
	else if( Instigator.IsLocallyControlled() )
	{
		// local player simulates firing locally, to give instant response.
		// FlashLocation will only replicate the exact impact location, and play impact effects.
		WeaponFired(CurrentFireMode);
	}
}

/** Overridden to check for our transient damage value. */
simulated function float GetFireModeDamage( Vector HitLocation, optional Actor HitActor )
{
	local float ModifiedDamage;

	// use the transient damage value
	ModifiedDamage = TransientShotgunDamage;
	ModifyDamage(ModifiedDamage, HitLocation, HitActor);
	return ModifiedDamage;
}

simulated static function ParticleSystem GetImpactOverrideParticleSystem(ImpactInfo Hit)
{
	local GearPawn GP;
	local WorldInfo WI;

	WI = class'Engine'.static.GetCurrentWorldInfo();

	// Don't spawn blood on a vehicle or silverback
	if (Hit.HitActor.IsA('Vehicle') || Hit.HitActor.IsA('GearPawn_SilverbackBase') || Hit.HitActor.IsA('GearPawn_LocustKantusArmorBase') || !WI.GRI.ShouldShowGore() ||
		(GearPawn(Hit.HitActor) != None && GearPawn(Hit.HitActor).ShouldPlayNonDamageHitEffects(Hit, None, default.InstantHitDamageTypes[0])) )
	{
		return None;
	}
	else
	{
		//If it is a gearpawn and you did NOT hit the shield or a cleaver
		GP = GearPawn(Hit.HitActor);
		return (GP != None && !GP.HitEquipment(Hit.HitInfo.HitComponent)) ? GP.BloodLowHitTemplate : None;
	}
}

/**
 * Kicks off sound/particles/decals based on an ImpactInfo struct, called on all visual clients either simulated locally or
 * replicated through GearPawn.ReplicatedPlayTakeHitEffects().
 * @param TheInstigator - Pawn that fired the weapon
 * @param Weapon - Reference to weapon (dummy fire has a weapon but no instigator, so Instigator.Weapon is not possible)
 * @param GearDmgType - damage type reference for effects
 * @param Impact - information about the impact
 * @param bFatalShot
 * @param bMeleeHit -
 * @param bPlayExplosiveRadialDamageEffects -
 * @param bSuppressImpactFXIn - should impact effects be played (dummy fire mostly)
 */
simulated static function SpawnImpactFX(Pawn TheInstigator, GearWeapon Weapon, const class<GearDamageType> GearDmgType, const out ImpactInfo Impact, bool bFatalShot, bool bMeleeHit, bool bPlayExplosiveRadialDamageEffects, bool bSuppressImpactFXIn)
{
	local PhysicalMaterial PhysMaterial;
	local WorldInfo WI;
	local GearPawn GP;
	local ImpactInfo NewImpactInfo;
	local vector Dir;

	Super.SpawnImpactFX(TheInstigator, Weapon, GearDmgType, Impact, bFatalShot, bMeleeHit, bPlayExplosiveRadialDamageEffects, bSuppressImpactFXIn);

	WI = class'Engine'.static.GetCurrentWorldInfo();

	if (!bFatalShot && !bMeleeHit && !GearDmgType.default.bSuppressImpactFX && WI.GRI.ShouldShowGore())
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
		}
	}
}

/** we compress the damage from the various pellets to a single damage call,
 * so this function calculates the actual damage value from the number of hits
 */
simulated final function SetTransientShotgunDamage(Actor HitActor, int NumHits)
{
	local int BaseDamage;

	BaseDamage = (GearAI(GetWeaponController()) != None && GearAI_TDM(GetWeaponController()) == None) ? WeaponDamageAI : WeaponDamage;
	// if we hit 75% then apply full damage
	if (NumHits >= PelletSpread.Length * 0.75f)
	{
		TransientShotgunDamage = BaseDamage;
	}
	else
	{
		// otherwise scale by number of hits
		TransientShotgunDamage = BaseDamage * (float(NumHits) / float(PelletSpread.Length));
	}
	// damage bonus if within very short range
	if (VSize2D(HitActor.Location - Instigator.Location) < 256.f)
	{
		TransientShotgunDamage *= 1.2f;
	}
}

reliable server function ServerNotifyHit(byte FiringMode, ImpactInfo Impact, byte HitType, byte NumHits)
{
	// make sure client gave a valid value for the number of hits
	if (NumHits <= PelletSpread.length)
	{
		// if HitActor didn't replicate it, try to get it from the hit component
		// this most commonly happens when hitting StaticMeshCollectionActors, as they are created by the cooker and so don't replicate
		if (Impact.HitActor == None && Impact.HitInfo.HitComponent != None)
		{
			Impact.HitActor = Impact.HitInfo.HitComponent.Owner;
		}

		SetTransientShotgunDamage(Impact.HitActor, NumHits);
		Super.ServerNotifyHit(FiringMode, Impact, HitType, NumHits);
		TransientShotgunDamage = (GearAI(GetWeaponController()) != None && GearAI_TDM(GetWeaponController()) == None) ? WeaponDamageAI : WeaponDamage;
	}
}

simulated function ProcessInstantHit(byte FiringMode, ImpactInfo Impact, optional int NumHits)
{
	SetTransientShotgunDamage(Impact.HitActor, NumHits);
	Super.ProcessInstantHit(FiringMode, Impact, NumHits);
	TransientShotgunDamage = (GearAI(GetWeaponController()) != None && GearAI_TDM(GetWeaponController()) == None) ? WeaponDamageAI : WeaponDamage;
}

simulated function FireAllPellets(vector StartLocation, rotator InAimRot, byte FireModeNum)
{
	local vector EndTrace;
	local array<ImpactInfo>	ImpactList;
	local int Number, Idx, ImpactIdx, BaseDamage;
	local GearPawn InstigatorGP, EnemyGP;
	local Rotator AimRot;
	local array<ShotgunHitInfo> HitList;
	local float SpreadModifier, TraceRange;
	local Pawn P;
	local bool bUpdateHitPellets;
	local GearPawnRidable_Base GPR;
	local vector MuzzleLoc;
	local ImpactInfo TestImpact;

	LastHitLocations.length = 0;
	HitIconRotationSeed = Rand(65535);

	// reset the transient damage for the non-pawn hit cases
	BaseDamage = (GearAI(GetWeaponController()) != None && GearAI_TDM(GetWeaponController()) == None) ? WeaponDamageAI : WeaponDamage;
	TransientShotgunDamage = BaseDamage;

	MuzzleLoc = GetMuzzleLoc();
	// if the gun is penetrating another Pawn, force all pellets to hit that target
	// this accounts for some edge cases where you fire through a hole in the physics asset
	// and cases where the gun mesh is point blank/inside the target but the camera is actually pointing over the shoulder
	// (since weapon traces come from the camera in the general case)
	foreach CollidingActors(class'Pawn', P, 1.0, MuzzleLoc, true)
	{
		if ((Instigator == None || ((bIgnoreTeamCheck && Instigator != P) || !WorldInfo.GRI.OnSameTeam(Instigator, P))) &&
			(GearPawn(P) == None || !GearPawn(P).IsCarryingShield()) &&
			FastTrace(MuzzleLoc, StartLocation))
		{
			GPR = GearPawnRidable_Base(P);
			if (GPR != None && GPR.Driver != None)
			{
				if (VSize(MuzzleLoc - GPR.Driver.Location) <= GPR.Driver.GetCollisionRadius())
				{
					P = GPR.Driver;
				}
			}

			HitList.length = 1;
			HitList[0].HitActor = P;
			HitList[0].NumHits = PelletSpread.length;
			HitList[0].Impact.HitActor = P;
			HitList[0].Impact.StartTrace = StartLocation;
			HitList[0].Impact.RayDir = Normal(P.Location - StartLocation);
			TraceComponent(HitList[0].Impact.HitLocation, HitList[0].Impact.HitNormal, P.CollisionComponent, P.Location, StartLocation,, HitList[0].Impact.HitInfo);
			LastHitLocations[0] = HitList[0].Impact.HitLocation;
			bLastHitWasLambent = (GearPawn(P) != None && GearPawnFX_Lambent(GearPawn(P).GearPawnFX) != None);
			bSkipScreenSpaceHit = P.IsA('GearPawn_LocustKantusArmorBase');
			break;
		}
	}
	if (HitList.length == 0)
	{
		// clamp the pitch when blindfiring over cover
		InstigatorGP = GearPawn(Instigator);
		// penalize accuracy if untargeted or recently evading
		if (InstigatorGP != None && InstigatorGP.bIsTargeting && WorldInfo.TimeSeconds - InstigatorGP.LastEvadeTime > 1.5)
		{
			SpreadModifier = 0.5;
		}
		else if (InstigatorGP != None && WorldInfo.TimeSeconds - InstigatorGP.LastEvadeTime < 1.5)
		{
			SpreadModifier = 1.1;
		}
		else
		{
			SpreadModifier = 0.9 + (0.2 * VSize(Instigator.Velocity) / Instigator.GroundSpeed);
		}
		TraceRange = GetTraceRange();

		AllHitLocation.Length = 0;
		// for each pellet to fire
		for (Number = 0; Number < PelletSpread.Length; Number++)
		{
			// Calculate Spread.
			AimRot = InAimRot;
			// less vertical, more horizontal
			AimRot.Yaw += PelletSpread[Number].X * SpreadModifier * SpreadMultiplier;
			AimRot.Pitch += PelletSpread[Number].Y * SpreadModifier * SpreadMultiplier;
			EndTrace = StartLocation + vector(AimRot) * TraceRange;

			// don't show hit indicator if target can't be seen due to smoke
			bUpdateHitPellets = ( Instigator == None || GearPC(Instigator.Controller) == None ||
						!GearPC(Instigator.Controller).IsSmokeGrenadeBlockingSight(StartLocation, EndTrace) );

			CalcWeaponFire(StartLocation, EndTrace, ImpactList);

			// spawn a tracer for the upper shots to show the spread
			if (Number == 0 || Number % 2 == 1)
			{
				SpawnTracerEffect(Instigator, MuzzleLoc, Rotation, ImpactList[0].HitLocation, VSize(ImpactList[0].HitLocation - MuzzleLoc));
			}

			// for each thing we hit,
			for (ImpactIdx = 0; ImpactIdx < ImpactList.length; ImpactIdx++)
			{
				AllHitLocation.AddItem(ImpactList[ImpactIdx].HitLocation);

				if (ImpactList[ImpactIdx].HitActor != None)
				{
					// update HUD info
					if (bUpdateHitPellets)
					{
						EnemyGP = GearPawn(ImpactList[ImpactIdx].HitActor);
						if (EnemyGP != None &&
							((bIgnoreTeamCheck && EnemyGP != Instigator) || !WorldInfo.GRI.OnSameTeam(EnemyGP, Instigator)))
						{
							// have to copy since not allowed to pass array elements by reference
							TestImpact = ImpactList[ImpactIdx];
							if (!EnemyGP.ShouldPlayNonDamageHitEffects(TestImpact, Instigator, InstantHitDamageTypes[FireModeNum]))
							{
								LastHitLocations.AddItem(ImpactList[ImpactIdx].HitLocation);
								bLastHitWasLambent = (GearPawnFX_Lambent(EnemyGP.GearPawnFX) != None);
								bSkipScreenSpaceHit = EnemyGP.IsA('GearPawn_LocustKantusArmorBase');
							}
						}
					}
					// add up the hits
					Idx = HitList.Find('HitActor', ImpactList[ImpactIdx].HitActor);
					if (Idx == INDEX_NONE)
					{
						Idx = HitList.Add(1);
						HitList[Idx].HitActor = ImpactList[ImpactIdx].HitActor;
						HitList[Idx].Impact = ImpactList[ImpactIdx];
					}
					else if (GearPawn(ImpactList[ImpactIdx].HitActor) != None)
					{
						// force headshot hits to be the "master" hit so that we have the maximum chance of having the headshot death
						if (GearPawn(ImpactList[ImpactIdx].HitActor).TookHeadShot(ImpactList[ImpactIdx].HitInfo.BoneName, ImpactList[ImpactIdx].HitLocation, ImpactList[ImpactIdx].RayDir))
						{
							HitList[Idx].Impact = ImpactList[ImpactIdx];
						}
					}
					else if (!PassThroughDamage(ImpactList[ImpactIdx].HitActor))
					{
						// spawn impact effects here as we're only going to do the full processing for one hit
						SpawnImpactFX(Instigator, self, class<GearDamageType>(InstantHitDamageTypes[FireModeNum]), ImpactList[ImpactIdx], false, false, false, bSuppressImpactFX);
					}
					HitList[Idx].NumHits++;
				}
			}
			// clear the list for the next iteration
			ImpactList.Length = 0;
		}
	}
	// call ProcessInstantHit() for each unique actor, passing it the total number of hits
	for (Idx = 0; Idx < HitList.Length; Idx++)
	{
		ProcessInstantHit(FireModeNum, HitList[Idx].Impact, HitList[Idx].NumHits);
	}
}


/**
 * Calculate weapon impacts for remote clients.
 * Remote clients may only get a HitLocation replicated,
 * so we need to figure out the HitNormal and HitActor to play proper effects.
 */

simulated function CalcRemoteImpactEffects( byte FireModeNum, vector GivenHitLocation, bool bViaReplication )
{
	local Vector	StartTrace, EndTrace;
	local rotator	AimRot;

	//`log( GetFuncName() @ WorldInfo.TimeSeconds );
	// this isn't exactly where the shot originated on the server, but it's
	// close enough as far as effects are concerned
	if (Instigator != None)
	{
		StartTrace	= Instigator.GetWeaponStartTraceLocation();
	}
	else
	{
		StartTrace = GetPhysicalFireStartLoc();
	}

	EndTrace	= GivenHitLocation;
	AimRot		= Rotator( Normal(EndTrace-StartTrace) );

	// Shoot all pellets
	FireAllPellets(StartTrace, AimRot, FireModeNum);
}


/** disable default shell eject when firing, as we want to spawn it when player cocks weapon. See below. */
simulated function PlayShellCaseEject();

/** temp solution */
simulated function PlayShotgunCockSound()
{
	// Here we force spawning the shell eject particle system.
	// As we want it to play when we cock the gun, and not when we fire it.
	Super(GearWeapon).PlayShellCaseEject();
}


simulated function PlayShotgunCockShellImpactSound()
{
	PlaySound( ShotgunCockShellImpactSound, true );
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
			// and nearly worthless at very long range
			else if (VSize(EnemyLoc - AI.Pawn.Location) > AI.EnemyDistance_Long)
			{
				Rating = 0.25;
			}
		}
	}

	return Rating;
}

simulated event DummyFire(byte FireModeNumm, vector TargetLoc, optional Actor AttachedTo, optional float AimErrorDeg, optional Actor TargetActor)
{
	local Actor HitActor;
	local vector StartLoc, EndLoc, HitLocation, HitNormal;
	local rotator AimRot;
	local float AimErrorUnr;

	DummyFireParent = AttachedTo;
	bDummyFireWeapon = TRUE;

	// impact effects
	StartLoc = GetPhysicalFireStartLoc();

	AimRot = rotator(TargetLoc - StartLoc);

	// modify Aim to add player aim error
	// and convert aim error from degrees to Unreal Units ( * 65536 / 360 )
	if (AimErrorDeg != 0.f)
	{
		AimErrorUnr = AimErrorDeg * 182.044;
		AimRot.Pitch += AimErrorUnr * (0.5 - FRand());
		AimRot.Yaw	 += AimErrorUnr * (0.5 - FRand());
	}

	EndLoc = StartLoc + vector(AimRot) * 30000;		// way out there
	HitActor = Trace(HitLocation, HitNormal, EndLoc, StartLoc, true, vect(0,0,0),, TRACEFLAG_Bullet);
	if (HitActor != None)
	{
		WeaponFired(FireModeNumm, HitLocation);
		CalcRemoteImpactEffects(FireModeNumm, HitLocation, FALSE);
	}
	else
	{
		WeaponFired(FireModeNumm, EndLoc);
	}
}

/**
 * This will spawn a PhysicalMaterial based sound.	It looks up the PhysicalMaterial
 * tree until it finds a valid sound to Spawn.	If it does not find one then
 * it defaults the sound coded in to the .uc file for that specific weapon
 * @param TheInstigator - Pawn that fired the weapon
 * @param Weapon - Reference to weapon (dummy fire has a weapon but no instigator, so Instigator.Weapon is not possible)
 * @param GearDmgType - damage type reference for effects
 * @param Impact - information about the impact
 * @param PhysMaterial - physical material properties for the impact
 **/
simulated static function SpawnImpactSounds( Pawn TheInstigator, GearWeapon Weapon, const class<GearDamageType> GearDmgType, ImpactInfo Impact, PhysicalMaterial PhysMaterial )
{
	local WorldInfo WI;
	local GearWeap_Shotgun Shotgun;
	local bool bPlaySoundThisTime;

	WI = class'Engine'.static.GetCurrentWorldInfo();

	bPlaySoundThisTime = true;

	Shotgun = GearWeap_Shotgun(Weapon);
	if (Shotgun != None)
	{
		bPlaySoundThisTime = ((WI.TimeSeconds - Shotgun.LastImpactSoundTime) > 0.5f);
	}


	// kind of kludgy, intended to only spawn one impact sound per shotgun blast
	if (bPlaySoundThisTime)
	{
		super.SpawnImpactSounds(TheInstigator, Weapon, GearDmgType, Impact, PhysMaterial);
	}

	if (Shotgun != None)
	{
		Shotgun.LastImpactSoundTime = WI.TimeSeconds;
	}
}

simulated function bool MeleeAttackImpact(optional int InDamage, optional out GearPawn OutVictimPawn, optional out TraceHitInfo OutHitInfo, optional bool bTest, optional float RangeMultiplier=1.0)
{
	local bool bResult;

	bResult = Super.MeleeAttackImpact(InDamage, OutVictimPawn, OutHitInfo, bTest, RangeMultiplier);
	// insane bots try the "two-piece"
	if (bResult && !bTest && GearAI_TDM(GearAIController) != None && GearAIController.GetDifficultyLevel() == DL_Insane)
	{
		GearAIController.StopMeleeAttack();
		GearAIController.StartFiring(1);
	}

	return bResult;
}

simulated function DrawAdditionalCrosshair(GearHUD_Base HUD)
{
	local int i;
	local byte Alpha;
	local rotator DrawRot;
	local vector DrawLoc;

	Alpha = Max(0, 255 - 255 * ((WorldInfo.TimeSeconds - LastShotTime) / GetFireInterval(0)));
	if( Alpha > 0 && !bSkipScreenSpaceHit )
	{
		if (CrosshairHitMIC == None)
		{
			CrosshairHitMIC = new(self) class'MaterialInstanceConstant';
		}
		if( !WorldInfo.GRI.ShouldShowGore() )
		{
			CrosshairHitMIC.SetParent(CrosshairHitMatNoGore);
		}
		else if (bLastHitWasLambent)
		{
			CrosshairHitMIC.SetParent(CrosshairHitMatLambent);
		}
		else
		{
			CrosshairHitMIC.SetParent(CrosshairHitMat);
		}
		CrosshairHitMIC.SetScalarParameterValue('Fade', ByteToFloat(Alpha));
		HUD.Canvas.DrawColor.A = 255;
		for (i = 0; i < LastHitLocations.length; i++)
		{
			DrawLoc = HUD.Canvas.Project(LastHitLocations[i]);
			HUD.Canvas.SetPos(DrawLoc.X - 24.0, DrawLoc.Y - 24.0);
			DrawRot.Yaw = (DrawRot.Yaw + 8192 + HitIconRotationSeed * ((i % 2 == 1) ? i : -i)) % 65536;
			HUD.Canvas.DrawRotatedMaterialTile(CrosshairHitMIC, DrawRot, 48.0, 48.0);
		}
	}
}

defaultproperties
{
	WeaponStatName="Gnasher"

	ShotgunCockShellImpactDelay=0.7

	bWeaponCanBeReloaded=TRUE

	// Weapon anim set
	CustomAnimSets(0)=AnimSet'COG_MarcusFenix.Animations.AnimSetMarcus_CamSkel_Shotgun'

	WeaponAnimType=EWAT_Shotgun

	BS_PawnWeaponReload={(Stance=((Slot=BS_Layer1,AnimName="ADD_SG_Reload"),
		(Slot=BS_Layer_MidCov_Ready,AnimName="ADD_SG_Cov_Mid_Reload"),
		(Slot=BS_Layer_StdCov_Ready,AnimName="ADD_SG_Cov_Std_Reload"))
		)}

	BS_PawnWeaponReloadFail={(Stance=((Slot=BS_Layer1,AnimName="ADD_SG_Reload_Fail"),
		(Slot=BS_Layer_MidCov_Ready,AnimName="ADD_SG_Cov_Mid_Reload_Fail"),
		(Slot=BS_Layer_StdCov_Ready,AnimName="ADD_SG_Cov_Std_Reload_Fail"))
		)}

	BS_PawnWeaponReloadSuccess={(Stance=((Slot=BS_Layer1,AnimName="ADD_SG_Reload_Success"),
		(Slot=BS_Layer_MidCov_Ready,AnimName="ADD_SG_Cov_Mid_Reload_Success"),
		(Slot=BS_Layer_StdCov_Ready,AnimName="ADD_SG_Cov_Std_Reload_Success"))
		)}

	BS_PawnShotgunCock={(Stance=((Slot=BS_Layer1,AnimName="ADD_SG_Idle_Ready_Chamber"),
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

	FireSound=SoundCue'Weapon_Shotgun.Shotgun.ShotgunFireEnemyCue'
	FireSound_Player=SoundCue'Weapon_Shotgun.Shotgun.ShotgunFirePlayerCue'
	FireSound_Squad=SoundCue'Weapon_Shotgun.Shotgun.ShotgunFireSquadCue'
	ShotgunCockShellImpactSound=SoundCue'Weapon_Shotgun.Reloads.ShotgunAmmoBounceCue'

	BulletWhipArchetype=GearBulletWhip'GearSoundGroupArchetypes.BulletWhips.Shotgun'

	WeaponReloadSound=None

	WeaponEquipSound=SoundCue'Weapon_Shotgun.Actions.ShotgunRaiseCue'
	WeaponDeEquipSound=SoundCue'Weapon_Shotgun.Actions.ShotgunLowerCue'
	PickupSound=SoundCue'Weapon_Shotgun.Actions.ShotgunPickupCue'
	WeaponDropSound=SoundCue'Weapon_Shotgun.Actions.ShotgunDropCue'

	InstantHitDamageTypes(0)=class'GDT_Shotgun'
	WeaponFireTypes(0)=EWFT_Custom
	AmmoTypeClass=class'GearAmmoType_Shotgun'

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
		SkeletalMesh=SkeletalMesh'COG_Gnasher.Mesh.COG_Gnasher_Skel'
		PhysicsAsset=PhysicsAsset'COG_Gnasher.Mesh.COG_Gnasher_Skel_Physics'
		AnimSets(0)=AnimSet'COG_Gnasher.Animations.COG_Gnasher_Anim'
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
		Template=ParticleSystem'COG_Gnasher.Effects.P_COG_Gnasher_Reload'
	End Object
	PSC_ReloadBarrelSmoke=PSC_WeaponReloadBarrelSmokeComp

	bCanDisplayReloadTutorial=TRUE
	DamageTypeClassForUI=class'GDT_Shotgun'
	WeaponIcon=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=222,V=53,UL=143,VL=46)
	AnnexWeaponIcon=(U=0,V=362,UL=128,VL=39)
	CrosshairIcon=Texture2D'Warfare_HUD.HUD.HUD_Xhair_COG_Gnasher'

	StartTraceAdjustDist=-64

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

	NeedReloadNotifyThreshold=2

	HUDDrawData			= (DisplayCount=8,AmmoIcon=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=0,V=265,UL=117,VL=7),ULPerAmmo=15)
	HUDDrawDataSuper	= (DisplayCount=8,AmmoIcon=(Texture=Texture2D'Warfare_HUD.WarfareHUD_main',U=0,V=265,UL=117,VL=7),ULPerAmmo=15)

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

	WeaponID=WC_Gnasher

	TracerType=WTT_Gnasher
	TracerTypeAR=WTT_Gnasher_AR

	PelletSpread(0)=(X=0,Y=0)
	PelletSpread(1)=(X=0,Y=284)
	PelletSpread(2)=(X=-350,Y=-256)
	PelletSpread(3)=(X=350,Y=-256)
	PelletSpread(4)=(X=0,Y=900)
	PelletSpread(5)=(X=875,Y=425)
	PelletSpread(6)=(X=-875,Y=425)
	PelletSpread(7)=(X=-875,Y=-425)
	PelletSpread(8)=(X=875,Y=-425)
	PelletSpread(9)=(X=0,Y=-900)

	CrosshairPelletScale=15.0
	CrosshairHitMat=Material'Warfare_HUD.HUD.M_BulletHit_Screenspace_Master'
	CrosshairHitMatNoGore=Material'Warfare_HUD.HUD.M_BulletHit_Screenspace_NO_Gore'
	CrosshairHitMatLambent=MaterialInstanceConstant'Warfare_HUD.HUD.MI_BulletHit_Screenspace_Lambent'

	WeaponRange=2048

	MuzzleFlashArchetype=GearMuzzleFlash'GearMuzzleFlashes.GearWeap_Shotgun_MuzFlash'

	// CQC Long Executions
	LongExecutions(3)={(CQC_Long_KillerAnim="CTRL_Quick_Shotgun",
						CQC_Long_KillerAnim_Loop="",
						CQC_Long_KillerAnim_End="",
						CQC_Long_VictimAnim="",
						CQC_Long_VictimAnim_Loop="",
						CQC_Long_VictimAnim_End="",
						CQC_Long_bHolsterWeapon=FALSE,
						CQC_Long_VictimDeathTime=0.64f,
						CQC_Long_VictimRotStartTime=0.0f,
						CQC_Long_VictimRotInterpSpeed=8.f,
						CQC_Long_CameraAnims=(),
						CQC_Long_DamageType=class'GDT_QuickExecution_Shotgun',
						CQC_Long_EffortID=GearEffort_ShotgunQuickExecutionEffort,
						MarkerRelOffset=(X=84.570,Y=27.190,Z=0),
						AwardRequired="GnasherExecution",
						CameraLensEffect=class'Emit_CameraBlood_LongExecution_Gnasher')}
	
	// These are the player's bling skin options
	WeaponSkins(0)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.Gnasher.COG_WeaponShader_Gnasher_Gold'
	WeaponSkins(1)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.Gnasher.COG_WeaponShader_Gnasher_CHROME'
	WeaponSkins(2)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.Gnasher.COG_WeaponShader_Gnasher_OMEN'
	WeaponSkins(3)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.Gnasher.COG_WeaponShader_Gnasher_TRIBALMASKED'
	WeaponSkins(4)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.Gnasher.COG_WeaponShader_Gnasher_CAMO'
	WeaponSkins(5)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.Gnasher.COG_WeaponShader_Gnasher_DIGITAL'
	WeaponSkins(6)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.Gnasher.COG_WeaponShader_Gnasher_PINK'
	WeaponSkins(7)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.Gnasher.COG_WeaponShader_Gnasher_GARISH'
	WeaponSkins(8)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.Gnasher.COG_WeaponShader_Gnasher_BLOOD'
	WeaponSkins(9)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.Gnasher.COG_WeaponShader_Gnasher_CRACKLE'
	WeaponSkins(10)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.Gnasher.COG_WeaponShader_Gnasher_FLOWER'
	WeaponSkins(11)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.Gnasher.COG_WeaponShader_Gnasher_PAISLEY'
	WeaponSkins(12)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.Gnasher.COG_WeaponShader_Gnasher_TRIBAL'
	WeaponSkins(13)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.Gnasher.COG_WeaponShader_Gnasher_URBAN'
	WeaponSkins(14)=MaterialInstanceConstant'ALL_WeaponShaders.CustomSkins.Gnasher.COG_WeaponShader_Gnasher_XBOX'
}
