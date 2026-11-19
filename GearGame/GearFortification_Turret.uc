/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearFortification_Turret extends GearFortification
	abstract;

/** class of turret to spawn */
var array< class<GearTurret> > TurretClass;
/** reference to the spawned turret */
var GearTurret LinkedTurret;
/** starting ammo in turret at each upgrade level */
var config array<int> TurretAmmo;
/** whether turret can overheat at each level */
var config array<byte> TurretHeatLimited;
/** turret rotation range at each level */
var config array<vector2d> TurretYawLimit;
/** percentage of ammo remaining for HUD displays */
var repnotify byte ReplicatedAmmoPct;

replication
{
	if (bNetDirty)
		ReplicatedAmmoPct;
}

simulated function InitializeUpgradeLevel(byte NewLevel)
{
	UpgradeLevel = NewLevel;
	if (Role == ROLE_Authority)
	{
		SpawnTurret();
		if (LinkedTurret == None)
		{
			// turret didn't fit?
			Destroy();
		}
	}

	bInitializedUpgradeLevel = true;
}

/** spawns a turret of the appropriate class and assigns it to LinkedTurret */
final function SpawnTurret()
{
	local GearWeapon TurretWeapon;
	local GearPawn P;

	// sanity check for any nearby Pawns to make sure they can't sneak in a collision hole
	foreach WorldInfo.AllPawns(class'GearPawn', P, Location, 32.0)
	{
		break;
	}
	if (P == None)
	{
		LinkedTurret = Spawn(TurretClass[UpgradeLevel]);
		if (LinkedTurret != None)
		{
			Health = StartingHealth[UpgradeLevel];
			LinkedTurret.OwnerFort = self;
			LinkedTurret.Health = Health;
			LinkedTurret.HealthMax = Health;
			LinkedTurret.YawLimit = TurretYawLimit[UpgradeLevel];
			if (TurretAmmo[UpgradeLevel] > 0)
			{
				TurretWeapon = GearWeapon(LinkedTurret.Weapon);
				if (TurretWeapon != None)
				{
					LinkedTurret.SetMaxAmmo(TurretAmmo[UpgradeLevel]);
					if (!bool(TurretHeatLimited[UpgradeLevel]) && GearWeap_TroikaBase(TurretWeapon) != None)
					{
						GearWeap_TroikaBase(TurretWeapon).MaxFiringTimeBeforeOverheat = 0.0;
					}
				}
			}
			SetBase(LinkedTurret);
		}
	}
}

simulated event Destroyed()
{
	Super.Destroyed();

	if (Role == ROLE_Authority)
	{
		// make sure the turret got cleaned up
		if (LinkedTurret != None && LinkedTurret.Health > 0)
		{
			if (LinkedTurret.Driver != None)
			{
				LinkedTurret.DriverLeave(true);
			}
			LinkedTurret.Destroy();
		}
	}
}

/** turret takes the damage, we just wait for it to die */
event TakeDamage(int Damage, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser);

event Tick(float DeltaTime)
{
	local byte NewAmmoPct;

	if (!bTearOff)
	{
		if (LinkedTurret == None || LinkedTurret.bDeleteMe || LinkedTurret.Health <= 0)
		{
			Health = 0;
			Explode(false);
		}
		else
		{
			if (GearWeapon(LinkedTurret.Weapon).bInfiniteSpareAmmo)
			{
				NewAmmoPct = 255;
			}
			else
			{
				NewAmmoPct = FloatToByte(float(TurretAmmo[UpgradeLevel] - LinkedTurret.GetAmmoUsedCount()) / float(TurretAmmo[UpgradeLevel]));
			}
			// don't assign unless different to avoid unnecessarily setting bNetDirty
			if (NewAmmoPct != ReplicatedAmmoPct)
			{
				ReplicatedAmmoPct = NewAmmoPct;
			}
			if (Health != LinkedTurret.Health)
			{
				Health = LinkedTurret.Health;
			}
		}
	}
}

simulated event ReplicatedEvent(name VarName)
{
	if (VarName == nameof(ReplicatedAmmoPct))
	{
		// if we were repaired, we might need to remove the material indicating repair state
		UpdateRepairGlow();
	}
	else
	{
		Super.ReplicatedEvent(VarName);
	}
}

function TearDown(Controller InstigatedBy)
{
	`RecordFortificationEvent(InstigatedBy, GFET_Sold, Marker);
	InstigatedBy.PlayerReplicationInfo.Score += int(GetConditionPct() * Cost[UpgradeLevel] * TearDownRecoveryPct);
	if (LinkedTurret != None)
	{
		LinkedTurret.Died(InstigatedBy, class'GearDamageType', LinkedTurret.Location);
	}
	Destroy();
}

protected function RepairPct(float AmountToRepair)
{
	if (ReplicatedAmmoPct < 255)
	{
		// GetConditionPct() returns the lesser of the two 'repair' types needed, so we need to do some conversion
		AmountToRepair = AmountToRepair / (1.0 - GetConditionPct()) * (1.0 - ByteToFloat(ReplicatedAmmoPct));

		LinkedTurret.GiveAmmo(TurretAmmo[UpgradeLevel] * AmountToRepair);
		ReplicatedAmmoPct = FloatToByte(float(TurretAmmo[UpgradeLevel] - LinkedTurret.GetAmmoUsedCount()) / float(TurretAmmo[UpgradeLevel]));
	}
	else
	{
		LinkedTurret.Health = Min(StartingHealth[UpgradeLevel], LinkedTurret.Health + StartingHealth[UpgradeLevel] * AmountToRepair);
		Health = LinkedTurret.Health;
	}

	bForceNetUpdate = true;
	UpdateRepairGlow();
}

simulated function float GetConditionPct()
{
	return FMin(Super.GetConditionPct(), ByteToFloat(ReplicatedAmmoPct));
}

simulated function int GetRepairCost()
{
	local int Result;

	// must reload first
	if (ReplicatedAmmoPct < 255)
	{
		Result = Cost[UpgradeLevel] * ((1.0 - ByteToFloat(ReplicatedAmmoPct)) * RepairCostPct * 0.5);
	}
	else
	{
		Result = Cost[UpgradeLevel] * ((1.0 - Super.GetConditionPct()) * RepairCostPct * 0.5);
	}

	return Result;
}

simulated function bool RepairIsReload()
{
	return (ReplicatedAmmoPct < 255);
}

simulated function UpdateRepairGlow()
{
	Super.UpdateRepairGlow();

	if (LinkedTurret != None && SkeletalMeshComponent(RepairGlow) != None)
	{
		SkeletalMeshComponent(RepairGlow).SetParentAnimComponent(LinkedTurret.Mesh);
		RepairGlow.SetTranslation(vect(0.0,-3.5,-5.0));
	}
}

static function bool IsEncroachingOnBuildLocation(Pawn TestPawn, vector BuildLoc, rotator BuildRot)
{
	BuildLoc += default.TurretClass[0].default.CylinderComponent.Translation >> BuildRot;
	return VSize2D(TestPawn.Location - BuildLoc) < (TestPawn.GetCollisionRadius() + default.TurretClass[0].default.CylinderComponent.CollisionRadius);
}

simulated function PlayExplosionEffect()
{
	WorldInfo.MyEmitterPool.SpawnEmitter(ExplosionEffect, Location + vector(Rotation) * 64.0, rotator(vect(0,0,1)));
	PlaySound(ExplosionSound, true);
}

state Crippled
{
	simulated function int GetRepairCost()
	{
		return (Cost[UpgradeLevel] * RepairCostPct);
	}

	simulated function bool RepairIsReload()
	{
		return false;
	}

	protected function RepairPct(float AmountToRepair)
	{
		// repair both equally in this case as both are needed
		LinkedTurret.GiveAmmo(TurretAmmo[UpgradeLevel] * AmountToRepair);
		ReplicatedAmmoPct = FloatToByte(float(TurretAmmo[UpgradeLevel] - LinkedTurret.GetAmmoUsedCount()) / float(TurretAmmo[UpgradeLevel]));
		LinkedTurret.Health = Min(StartingHealth[UpgradeLevel], LinkedTurret.Health + StartingHealth[UpgradeLevel] * AmountToRepair);
		Health = LinkedTurret.Health;

		bForceNetUpdate = true;
		UpdateRepairGlow();
	}

	function Repair(Controller InstigatedBy, float PlayerRepairPct)
	{
		if (InstigatedBy.PlayerReplicationInfo.Score > 0)
		{
			SpawnTurret();
			if (LinkedTurret != None)
			{
				// set to zero so repair code can add the appropriate amount based on how much they can pay
				LinkedTurret.Health = 0;
				LinkedTurret.SetAmmoUsedCount(TurretAmmo[UpgradeLevel]);

				Global.Repair(InstigatedBy, PlayerRepairPct);

				GotoState('Auto');
			}
		}
	}

	simulated event BeginState(name PreviousStateName)
	{
		Super.BeginState(PreviousStateName);

		if (Role == ROLE_Authority)
		{
			ReplicatedAmmoPct = 0;
		}
	}
}

defaultproperties
{
	// this cylinder is so that the volume can detect it for fortification count limiting and owner teardown
	Begin Object Class=CylinderComponent Name=Cylinder
		CollisionRadius=1.0
		CollisionHeight=1.0
		CollideActors=true
		BlockActors=false
		BlockZeroExtent=false
		BlockNonZeroExtent=false
	End Object
	CollisionComponent=Cylinder
	Components.Add(Cylinder)

	bBlockActors=false
	bProjTarget=false
	bScoreDamageCaused=true

	ReplicatedAmmoPct=255

	StatName=Turret
	BuiltGUDEvent=GUDEvent_Horde_TurretBuilt
	UpgradedGUDEvent=GUDEvent_Horde_TurretUpgraded
	RepairedGUDEvent=GUDEvent_Horde_TurretRepaired
	DestroyedGUDEvent=GUDEvent_Horde_TurretDestroyed
}
