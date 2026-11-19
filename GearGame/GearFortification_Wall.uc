/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearFortification_Wall extends GearFortification
	abstract
	native;

/** amount this fortification slows enemies that pass through it (when passing through is possible) */
var config float SlowPct;
/** amount of damage this fortification deals to enemies travelling through it at each level (if possible) */
var config array<int> TouchDamageToEnemyPerSec;
/** amount of damage this fortification takes when enemies are travelling through it */
var config int TouchDamageToSelfPerSec;
/** multiplier to melee damage dealt to this wall (used to reduce damage to the variants designed to be walked through) */
var config array<float> MeleeDamageMultiplier;
/** amount of damage dealt to an enemy when they melee this wall (if possible) */
var config array<int> MeleePunishmentDamage;
/** damage type to use at each upgrade level */
var array< class<DamageType> > MyDamageType;
/** whether the wall has blocking collision for enemies (instead of the slow effect) at each upgrade level */
var array<byte> bBlocksEnemies;

/** laser effect for upgrade levels that use them instead of a mesh */
var array<ParticleSystem> LaserEffect;
/** laser effect offsets (array is number of effects; all upgrade levels use the same offset) */
var array<vector> LaserOffsets;
/** components for the lasers */
var array<ParticleSystemComponent> Lasers;
/** set when lasers are hidden due to being turned off by button press */
var repnotify protectedwrite bool bLasersHidden;
/** X axis scaling supplied by LD from the marker */
var repnotify float WallScaleX;

/** sound played when an enemy is moving through the wall (when that's possible) */
var SoundCue TouchSound;

/** MIC used to modify damage parameter */
var MaterialInstanceConstant WallMICs[2];
/** component for damage particle effects */
var ParticleSystemComponent DamageEffectComp;
/** particle systems to set in the damage component */
var ParticleSystem MediumDamageEffect, HighDamageEffect;

var array<EGUDEventID> WallUpgradeGUDEvents;
var array<EGUDEventID> WallDestroyedGUDEvents;
var array<EGUDEventID> WallRepairedGUDEvents;

cpptext
{
	virtual UBOOL IgnoreBlockingBy(const AActor* Other) const;
}

replication
{
	if (bNetDirty)
		bLasersHidden;
	if (bNetInitial)
		WallScaleX;
}

function ApplyMarkerScale(vector InScale)
{
	WallScaleX = InScale.X;

	InScale.Y = 1.0;
	InScale.Z = 1.0;
	SetDrawScale3D(InScale);
}

function UpgradedWith(GearFortification NewFortification)
{
	local vector NewDrawScale3D;

	GearFortification_Wall(NewFortification).WallScaleX = WallScaleX;
	NewDrawScale3D.X = WallScaleX;
	NewDrawScale3D.Y = 1.0;
	NewDrawScale3D.Z = 1.0;
	NewFortification.SetDrawScale3D(NewDrawScale3D);
}

simulated function InitializeUpgradeLevel(byte NewLevel)
{
	local int i;

	Super.InitializeUpgradeLevel(NewLevel);

	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		if (LaserEffect[UpgradeLevel] != None)
		{
			for (i = 0; i < LaserOffsets.length; i++)
			{
				Lasers[i] = new(self) class'ParticleSystemComponent';
				Lasers[i].TranslucencySortPriority = 1;
				Lasers[i].SetTemplate(LaserEffect[UpgradeLevel]);
				Lasers[i].SetTranslation(LaserOffsets[i]);
				Lasers[i].SetVectorParameter('End', vect(-2,0,0) * LaserOffsets[i]);
				AttachComponent(Lasers[i]);
			}
		}

		WallMICs[0] = DisplayComponent[UpgradeLevel].CreateAndSetMaterialInstanceConstant(0);
		WallMICs[1] = DisplayComponent[UpgradeLevel].CreateAndSetMaterialInstanceConstant(1);
		if (UpgradeLevel < 3)
		{
			DamageEffectComp = new(self) class'ParticleSystemComponent';
			DamageEffectComp.bAutoActivate = false;
			AttachComponent(DamageEffectComp);
		}
	}
	if (NewLevel < WallUpgradeGUDEvents.length && WallUpgradeGUDEvents[NewLevel] != GUDEvent_None)
	{
		UpgradedGUDEvent = WallUpgradeGUDEvents[NewLevel];
	}
	if (NewLevel < WallDestroyedGUDEvents.length && WallDestroyedGUDEvents[NewLevel] != GUDEvent_None)
	{
		DestroyedGUDEvent = WallDestroyedGUDEvents[NewLevel];
	}
	if (NewLevel < WallRepairedGUDEvents.length && WallRepairedGUDEvents[NewLevel] != GUDEvent_None)
	{
		RepairedGUDEvent = WallRepairedGUDEvents[NewLevel];
	}
}

/** called on a timer to damage all enemies touching the wall; disables the timer if no more enemies are touching */
final function DamageTouchingEnemies()
{
	local GearPawn GP;
	local bool bEnemyFound, bDamagedEnemy;

	foreach TouchingActors(class'GearPawn', GP)
	{
		if (!GP.bTearOff && !WorldInfo.GRI.OnSameTeam(GP, self))
		{
			bEnemyFound = true;
			if (!IsZero(GP.Velocity))
			{
				GP.TakeDamage(TouchDamageToEnemyPerSec[UpgradeLevel] / 2, GetDamageInstigator(), GP.Location + Normal(GP.Velocity) * GP.GetCollisionRadius(), -Normal(GP.Velocity), MyDamageType[UpgradeLevel],, self);
				TakeDamage(TouchDamageToSelfPerSec, GP.Controller, GP.Location, vect(0,0,0), class'GearDamageType');
				bForceNetUpdate = true;
				bDamagedEnemy = true;
			}
		}
	}

	if (bEnemyFound)
	{
		if (bDamagedEnemy)
		{
			PlaySound(TouchSound);
			if (Health <= 0)
			{
				Explode(false);
			}
		}
	}
	else
	{
		ClearTimer(nameof(DamageTouchingEnemies));
	}
}

simulated event Touch(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal)
{
	local GearPawn GP;

	if (Other.bScriptInitialized && UpgradeLevel != 255)
	{
		if (Role == ROLE_Authority)
		{
			// lasers temporarily deactivate when a player walks through
			if ( LaserEffect[UpgradeLevel] != None && !bLasersHidden && Pawn(Other) != None && WorldInfo.GRI.OnSameTeam(Other, self) &&
				CreationTime != WorldInfo.TimeSeconds )
			{
				SetCollision(true, false);
				SetLasersHidden(true);
				bForceNetUpdate = true;

				SetTimer(5.0, false, nameof(Reactivate));
			}

			if (!bool(bBlocksEnemies[UpgradeLevel]))
			{
				// apply the slow effect to enemies
				GP = GearPawn(Other);
				if (GP != None && !WorldInfo.GRI.OnSameTeam(GP, self))
				{
					if (GP.bInstakillsFortifications)
					{
						// this enemy should destroy us instead
						TakeDamage(Health, GP.Controller, GP.Location, Normal(GP.Velocity), class'GearDamageType');
					}
					else
					{
						GP.SetBarbedWireTraversal(true);
						GP.SetGroundSpeedModifier(SlowPct);
						GP.Velocity *= SlowPct;
						if (!IsTimerActive(nameof(DamageTouchingEnemies)))
						{
							SetTimer(0.5, true, nameof(DamageTouchingEnemies));
						}
					}
				}
			}
		}
		else if (!bool(bBlocksEnemies[UpgradeLevel]))
		{
			// apply slow effect on clients
			GP = GearPawn(Other);
			if (GP != None && !GP.bInstakillsFortifications && !WorldInfo.GRI.OnSameTeam(GP, self))
			{
				if (GP.IsLocallyControlled())
				{
					GP.SetGroundSpeedModifier(SlowPct);
					GP.Velocity *= SlowPct;
				}
			}
		}
	}
}

//@warning: can be called twice per Touch in cases where the fortification is destroyed while touching
//		so this function MUST use absolute values
simulated event UnTouch(Actor Other)
{
	local GearPawn GP;

	if (!bool(bBlocksEnemies[UpgradeLevel]))
	{
		// remove the slow effect from enemies
		GP = GearPawn(Other);
		if (GP != None && !WorldInfo.GRI.OnSameTeam(GP, self))
		{
			if (Role == ROLE_Authority || GP.IsLocallyControlled())
			{
				GP.SetBarbedWireTraversal(false);
				GP.SetGroundSpeedModifier(1.0);
			}
		}
	}
}

/** empty function used for timer on bumping Pawns to avoid causing damage too frequently */
final function WallDamageTimer();

event Bump(Actor Other, PrimitiveComponent OtherComp, vector HitNormal)
{
	local GearPawn GP;

	GP = GearPawn(Other);
	if (GP != None)
	{
		if (GP.bInstakillsFortifications)
		{
			// no need to melee, simple bump from this enemy will kill us
			TakeDamage(Health, GP.Controller, GP.Location, Normal(GP.Velocity), class'GearDamageType');
		}
		// special case for tickers to just blow them up
		else if (GP.IsA('GearPawn_LocustTickerBase') && !GP.IsA('GearPawn_LocustNakedTicker'))
		{
			GP.TakeDamage(MeleePunishmentDamage[UpgradeLevel], GetDamageInstigator(), GP.Location, vect(0,0,1), MyDamageType[UpgradeLevel],, self);
			TakeDamage(MeleePunishmentDamage[UpgradeLevel], GP.Controller, GP.Location, vect(0,0,0), class'GearDamageType');
		}
		// try to stumble back while taking damage
		else if (GP.CanDoSpecialMove(SM_StumbleFromMelee2))
		{
			GP.ServerDoSpecialMove(SM_StumbleFromMelee2);
			GP.TakeDamage(MeleePunishmentDamage[UpgradeLevel], GetDamageInstigator(), GP.Location, vect(0,0,1), MyDamageType[UpgradeLevel],, self);
			TakeDamage(MeleePunishmentDamage[UpgradeLevel], GP.Controller, GP.Location, vect(0,0,0), class'GearDamageType');
		}
		// for human controlled enemies or AI that can't melee, do damage on bump
		else if (GP.IsHumanControlled() || GP.IsCarryingAHeavyWeapon() || (GP.MyGearAI != None && !GP.MyGearAI.bCanMelee))
		{
			// set a timer to only do this so often, since they can bump every frame
			if (!GP.IsTimerActive(nameof(WallDamageTimer), self))
			{
				GP.TakeDamage(MeleePunishmentDamage[UpgradeLevel], GetDamageInstigator(), GP.Location, vect(0,0,1), MyDamageType[UpgradeLevel],, self);
				TakeDamage(MeleePunishmentDamage[UpgradeLevel], GP.Controller, GP.Location, vect(0,0,0), class'GearDamageType');
				GP.SetTimer(1.0, false, nameof(WallDamageTimer), self);
			}
		}
		// fall back to standard melee attacks
		else if (!GP.IsDoingASpecialMove())
		{
			Super.Bump(Other, OtherComp, HitNormal);
		}
	}
	else
	{
		Super.Bump(Other, OtherComp, HitNormal);
	}
}

event Attach(Actor Other)
{
	Bump(Other, Other.CollisionComponent, vect(0,0,1));
}

function TakeDamage( int DamageAmount, Controller EventInstigator, vector HitLocation, vector Momentum,
			class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser )
{
	local bool bIsMeleeDamage;

	bIsMeleeDamage = ClassIsChildOf(DamageType, class'GDT_Melee');
	if (bIsMeleeDamage)
	{
		DamageAmount *= MeleeDamageMultiplier[UpgradeLevel];
	}

	Super.TakeDamage(DamageAmount, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);

	if ( EventInstigator != None && EventInstigator.Pawn != None &&
		bIsMeleeDamage && !WorldInfo.GRI.OnSameTeam(EventInstigator, self) )
	{
		EventInstigator.Pawn.TakeDamage(MeleePunishmentDamage[UpgradeLevel], GetDamageInstigator(), EventInstigator.Pawn.Location, vect(0,0,1), MyDamageType[UpgradeLevel],, self);
	}
}

/** check if we should switch to the damaged mesh or use the default mesh based on condition */
simulated function UpdateDamagedEffects()
{
	local int i;
	local float HealthRatio;

	if (WorldInfo.NetMode != NM_DedicatedServer && Health > 0)
	{
		HealthRatio = float(Health) / float(StartingHealth[UpgradeLevel]);
		for (i = 0; i < ArrayCount(WallMICs); i++)
		{
			WallMICs[i].SetScalarParameterValue('Damage', 1.0 - HealthRatio);
			WallMICs[i].SetScalarParameterValue('Damage1', 1.0 - HealthRatio);
		}
		if (DamageEffectComp != None)
		{
			if (HealthRatio < 0.33)
			{
				if (DamageEffectComp.Template != HighDamageEffect)
				{
					DamageEffectComp.SetTemplate(HighDamageEffect);
				}
				DamageEffectComp.SetActive(true);
			}
			else if (HealthRatio < 0.66)
			{
				if (DamageEffectComp.Template != MediumDamageEffect)
				{
					DamageEffectComp.SetTemplate(MediumDamageEffect);
				}
				DamageEffectComp.SetActive(true);
			}
			else
			{
				DamageEffectComp.SetActive(false);
			}
		}
		if (LaserEffect[UpgradeLevel] != None)
		{
			for (i = 0; i < Lasers.length; i++)
			{
				if (HealthRatio < float(i) / float(Lasers.length))
				{
					Lasers[i].SetActive(false);
				}
				else
				{
					Lasers[i].SetActive(true);
				}
			}
		}
	}
}

/** turns on and off the laser effects */
simulated final function SetLasersHidden(bool bNowHidden)
{
	local ParticleSystemComponent PSC;

	bLasersHidden = bNowHidden;

	foreach Lasers(PSC)
	{
		PSC.SetHidden(bLasersHidden);
	}
}

simulated event ReplicatedEvent(name VarName)
{
	local vector NewDrawScale3D;

	if (VarName == nameof(bLasersHidden))
	{
		SetLasersHidden(bLasersHidden);
	}
	else if (VarName == nameof(WallScaleX))
	{
		NewDrawScale3D.X = WallScaleX;
		NewDrawScale3D.Y = 1.0;
		NewDrawScale3D.Z = 1.0;
		SetDrawScale3D(NewDrawScale3D);
	}
	else
	{
		Super.ReplicatedEvent(VarName);
	}
}

/** called on a timer to reactivate a disabled wall */
final function Reactivate()
{
	SetLasersHidden(false);
	SetCollision(true, default.bBlockActors);
	bForceNetUpdate = true;
}

simulated function bool IsValidMeleeTarget(Pawn AskingPawn)
{
	return ( !WorldInfo.GRI.OnSameTeam(AskingPawn, self) && (!bLasersHidden || LaserEffect[UpgradeLevel] == None) &&
		(UpgradeLevel > 0 || GearPawn_LocustTickerBase(AskingPawn) != None) && Super.IsValidMeleeTarget(AskingPawn) );
}
simulated function bool IsDesirableMeleeTarget(GearPawn AskingPawn)
{
	return (GearPawn_LocustNakedTickerBase(AskingPawn) != None && Super.IsDesirableMeleeTarget(AskingPawn));
}

simulated event Tick(float DeltaTime)
{
	local float TouchParam;
	local GearPawn P;

	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		foreach TouchingActors(class'GearPawn', P)
		{
			if (P.GroundSpeed > 0.0 && !WorldInfo.GRI.OnSameTeam(P, self))
			{
				TouchParam = VSize(P.Velocity) / P.GroundSpeed;
			}
		}
		TouchParam = FClamp(TouchParam, 0.0, 1.0);
		WallMICs[1].SetScalarParameterValue('Touch', TouchParam);
	}
}

state Crippled
{
	simulated event BeginState(name PreviousStateName)
	{
		local Actor A;

		Super.BeginState(PreviousStateName);

		SetLasersHidden(true);
		ClearTimer(nameof(Reactivate));
		if (DamageEffectComp != None)
		{
			DamageEffectComp.SetActive(false);
		}
		// untouch everything to eliminate the slow effect
		if (Role == ROLE_Authority)
		{
			foreach TouchingActors(class'Actor', A)
			{
				UnTouch(A);
			}
		}
	}
	simulated event EndState(name NextStateName)
	{
		SetLasersHidden(false);

		Super.EndState(NextStateName);
	}
}

defaultproperties
{
	Begin Object Class=StaticMeshComponent Name=WallComp
	End Object
	DisplayComponent[0]=WallComp
	DisplayComponent[1]=WallComp
	DisplayComponent[2]=WallComp
	bDisplayCompIsCollisionComp=true

	WallScaleX=1.0

	StatName=Wall
	BuiltGUDEvent=GUDEvent_Horde_WallLevel1Built
	UpgradedGUDEvent=GUDEvent_Horde_WallLevel2Built
	RepairedGUDEvent=GUDEvent_Horde_WallRepaired
	DestroyedGUDEvent=GUDEvent_Horde_WallDestroyed

	WallUpgradeGUDEvents[1]=GUDEvent_Horde_WallLevel2Built
	WallUpgradeGUDEvents[2]=GUDEvent_Horde_WallLevel3Built
	WallUpgradeGUDEvents[3]=GUDEvent_Horde_WallLevel4Built

	WallDestroyedGUDEvents[0]=GUDEvent_Horde_WallLevel1Destroyed
	WallRepairedGUDEvents[0]=GUDEvent_Horde_WallLevel1Repaired

	bCanStepUpOn=false

	bBlocksEnemies[0]=0
	bBlocksEnemies[1]=0
	bBlocksEnemies[2]=1
	bBlocksEnemies[3]=1
}
