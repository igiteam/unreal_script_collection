/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearFortification_Decoy extends GearFortification
	abstract;

/** explosion damage properties for each upgrade level */
var config array<float> ExplosionDamage;
var config array<float> ExplosionDamageRadius;
/** melee attraction radius for each upgrade level */
var config array<float> MeleeAttractRadius;

/** common values for the explosion created when this fortification is destroyed */
var GearExplosion ExplosionTemplate;

/** taunts the decoy might randomly play when attracting an enemy */
var array<SoundCue> TauntSounds;
/** last time we taunted so it doesn't happen too often */
var float LastTauntTime;

/** max level spawns an AI guy */
var class<GearPawn> GuardClass;
var GearPawn LinkedGuard;

simulated function InitializeUpgradeLevel(byte NewLevel)
{
	local GearAI GuardAI;
	local GearWeapon Weap;

	if (NewLevel != 4)
	{
		Super.InitializeUpgradeLevel(NewLevel);
		if (Role == ROLE_Authority)
		{
			SetTimer(1.0, true, nameof(NotifyAI));
		}
	}
	else
	{
		// this upgrade spawns an AI wingman instead
		UpgradeLevel = NewLevel;
		SetHidden(true);
		if (Role == ROLE_Authority)
		{
			Health = StartingHealth[NewLevel];
			SetCollision(true, false);
			bProjTarget = false;
			LinkedGuard = Spawn(GuardClass,,, Location, Rotation);
			SetBase(LinkedGuard);
			GuardAI = Spawn(class'GearAI_COGGear');
			GuardAI.bCheckForVehicles = false;
			WorldInfo.Game.ChangeTeam(GuardAI, 0, false);
			GuardAI.Possess(LinkedGuard, false);
			LinkedGuard.DefaultHealth = Health;
			LinkedGuard.Health = Health;
			Weap = GearWeapon(LinkedGuard.CreateInventory(class'GearWeap_Shotgun'));
			if (Weap != None)
			{
				Weap.SetInfiniteSpareAmmo();
			}
			GuardAI.SetSquadName('Fortification', true);
			GotoState('MonitorGuard');
		}
	}
}

/** tell AI that can see the decoy to be distracted by it */
function NotifyAI()
{
	local GearAI AI;
	local CoverInfo ChkCover;

	foreach WorldInfo.AllControllers(class'GearAI', AI)
	{
		if (!WorldInfo.GRI.OnSameTeam(AI, self) && !AI.IgnoreNotifies())
		{
			if ( AI.CanFireAt(self, AI.Pawn.GetWeaponStartTraceLocation()) ||
				(AI.MyGearPawn != None && AI.MyGearPawn.IsInCover() && GearAI_Cover(AI).GetCoverAction(ChkCover, self, false, true)) )
			{
				// tell the AI to shoot the decoy
				if ( AI.MyGearPawn.Weapon != None && GearWeap_Melee(AI.MyGearPawn.Weapon) == None &&
					AI.TargetList.Find(self) == INDEX_NONE )
				{
					AI.TargetList.AddItem(self);
					AI.FireTarget = self;
				}

				// if the AI is close and isn't already meleeing, have it melee us instead
				if ( AI.MyGearPawn != None && VSize2D(Location - AI.Pawn.Location) < MeleeAttractRadius[UpgradeLevel] &&
					!AI.MyGearPawn.bWantsToMelee &&
					AI.FindCommandOfClass(class'AICmd_Melee_Forced') == None &&
					AI.FindCommandOfClass(class'AICmd_Attack_Melee') == None )
				{
					class'AICmd_Melee_Forced'.static.ForceMelee(AI, self);
					if (TauntSounds.length > 0 && WorldInfo.TimeSeconds - LastTauntTime > 10.0)
					{
						PlaySound(TauntSounds[Rand(TauntSounds.length)]);
					}
				}

			}
			else
			{
				AI.TargetList.RemoveItem(self);
			}
		}
	}
}

simulated function Explode(bool bCompletelyDestroy)
{
	local GearExplosionActor ExplosionActor;
	local GearAI AI;

	if (UpgradeLevel == 4)
	{
		bCompletelyDestroy = true;
	}

	Super.Explode(bCompletelyDestroy);

	if (Role == ROLE_Authority)
	{
		ClearTimer(nameof(NotifyAI));
		// release any ranged AI from our effects (melee commands will detect our death on their own)
		foreach WorldInfo.AllControllers(class'GearAI', AI)
		{
			AI.TargetList.RemoveItem(self);
			if (AI.FireTarget == self)
			{
				AI.FireTarget = None;
				AI.SelectTarget();
			}
		}
	}

	if (ExplosionDamage[UpgradeLevel] > 0)
	{
		ExplosionTemplate.InitFromContentTemplate();
		ExplosionTemplate.Damage = ExplosionDamage[UpgradeLevel];
		ExplosionTemplate.DamageRadius = ExplosionDamageRadius[UpgradeLevel];

		ExplosionActor = Spawn(class'GearExplosionActor', self,, Location, Rotation);
		ExplosionActor.InstigatorController = GetDamageInstigator();
		if (ExplosionActor.InstigatorController != None)
		{
			ExplosionActor.Instigator = ExplosionActor.InstigatorController.Pawn;
		}
		ExplosionActor.Explode(ExplosionTemplate);
	}
}

simulated event Destroyed()
{
	Super.Destroyed();

	if (Role == ROLE_Authority && LinkedGuard != None)
	{
		if (LinkedGuard.Controller != None)
		{
			LinkedGuard.Controller.Destroy();
		}
		LinkedGuard.Destroy();
	}
}

/** checks Guard's state and updates fortification; server only */
state MonitorGuard
{
	ignores IsValidMeleeTarget;

	event Tick(float DeltaTime)
	{
		if (LinkedGuard == None || LinkedGuard.bTearOff || LinkedGuard.bDeleteMe)
		{
			Explode(true);
		}
		else
		{
			Health = LinkedGuard.Health;
		}
	}
}

state Crippled
{
	simulated event EndState(name NextStateName)
	{
		Super.EndState(NextStateName);

		if (Role == ROLE_Authority)
		{
			SetTimer(1.0, true, nameof(NotifyAI));
		}
	}
}

defaultproperties
{
	Begin Object Class=CylinderComponent Name=CollisionCylinder
		CollisionRadius=34.0
		CollisionHeight=78.0
		BlockNonZeroExtent=true
		BlockZeroExtent=false
		BlockActors=true
		CollideActors=true
	End Object
	CollisionComponent=CollisionCylinder
	Components.Add(CollisionCylinder)

	Begin Object Class=GearExplosion Name=ExploTemplate0
		MomentumTransferScale=1.f
		ExploShakeInnerRadius=650
		ExploShakeOuterRadius=1500
		FractureMeshRadius=100.0
		FracturePartVel=300.0
		DamageFalloffExponent=1.0
		MyDamageType=class'GDT_Boomshot' //@FIXME: temp
	End Object
	ExplosionTemplate=ExploTemplate0

	bReplicateMovement=true
	StatName=Decoy
	BuiltGUDEvent=GUDEvent_Horde_DecoyBuilt
	UpgradedGUDEvent=GUDEvent_Horde_DecoyUpgraded
	RepairedGUDEvent=GUDEvent_Horde_DecoyRepaired
	DestroyedGUDEvent=GUDEvent_Horde_DecoyDestroyed
}
