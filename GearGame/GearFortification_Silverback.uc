/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearFortification_Silverback extends GearFortification
	abstract;

/** reference to Silverback when we spawn that instead */
var class<GearPawn_SilverbackArmedBase> SilverbackClass;
var repnotify GearPawn_SilverbackArmedBase LinkedSilverback;

replication
{
	if (bNetInitial)
		LinkedSilverback;
}

simulated function InitializeUpgradeLevel(byte NewLevel)
{
	UpgradeLevel = NewLevel;
	if (Role == ROLE_Authority)
	{
		SpawnSilverback();
		if (LinkedSilverback == None)
		{
			// didn't fit?
			Destroy();
		}
	}

	bInitializedUpgradeLevel = true;
}

/** spawns a Silverback of the appropriate class and assigns it to LinkedSilverback */
final function SpawnSilverback()
{
	LinkedSilverback = Spawn(SilverbackClass);
	if (LinkedSilverback != None)
	{
		LinkedSilverback.OwnerFort = self;
		WorldInfo.Game.SetPlayerDefaults(LinkedSilverback);
		Health = StartingHealth[UpgradeLevel];
		LinkedSilverback.Health = StartingHealth[UpgradeLevel];
		LinkedSilverback.DefaultHealth = LinkedSilverback.Health;
		LinkedSilverback.HealthMax = LinkedSilverback.Health;
		SetBase(LinkedSilverback);
	}
}

simulated event Destroyed()
{
	Super.Destroyed();

	if (Role == ROLE_Authority)
	{
		// make sure the silverback got cleaned up
		if (LinkedSilverback != None && !LinkedSilverback.bDeadVehicle)
		{
			if (LinkedSilverback.Driver != None)
			{
				LinkedSilverback.DriverLeave(true);
			}
			LinkedSilverback.Destroy();
		}
	}
}

/** silverback takes the damage, we just wait for it to die */
event TakeDamage(int Damage, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser);

event Tick(float DeltaTime)
{
	if (!bTearOff)
	{
		if (LinkedSilverback == None || LinkedSilverback.bDeleteMe || LinkedSilverback.Health <= 0)
		{
			Health = 0;
			Explode(false);
		}
		else if (Health != LinkedSilverback.Health)
		{
			Health = LinkedSilverback.Health;
		}
	}
}

simulated event ReplicatedEvent(name VarName)
{
	if (VarName == nameof(LinkedSilverback))
	{
		if (LinkedSilverback != None)
		{
			SetBase(LinkedSilverback);
		}
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
	if (LinkedSilverback != None)
	{
		LinkedSilverback.Died(InstigatedBy, class'GearDamageType', LinkedSilverback.Location);
	}
	Destroy();
}

protected function RepairPct(float AmountToRepair)
{
	LinkedSilverback.Health = Min(StartingHealth[UpgradeLevel], LinkedSilverback.Health + StartingHealth[UpgradeLevel] * AmountToRepair);
	LinkedSilverback.DamageTakenPct = (1.0 - (LinkedSilverback.Health / float(LinkedSilverback.DefaultHealth)));
	LinkedSilverback.PlayDamageEffect();
	Health = LinkedSilverback.Health;

	bForceNetUpdate = true;
	UpdateRepairGlow();
}

state Crippled
{
	function Repair(Controller InstigatedBy, float PlayerRepairPct)
	{
		local vector HitLocation, HitNormal;

		if (InstigatedBy.PlayerReplicationInfo.Score > 0)
		{
			SpawnSilverback();
			if (LinkedSilverback != None)
			{
				// make sure the Silverback has a valid rotation that players can actually get in from
				if (Trace(HitLocation, HitNormal, LinkedSilverback.Location - vector(LinkedSilverback.Rotation) * 100.0, LinkedSilverback.Location, false, vect(10,10,20)) != None)
				{
					LinkedSilverback.SetRotation(InstigatedBy.Pawn.Rotation);
				}

				// set to zero so repair code can add the appropriate amount based on how much they can pay
				Health = 0;
				LinkedSilverback.Health = 0;

				Global.Repair(InstigatedBy, PlayerRepairPct);

				GotoState('Auto');
			}
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

	bReplicateMovement=true
	bProjTarget=false
	bBlockActors=false
	bRequiresFlag=false
	bScoreDamageCaused=true

	StatName=Silverback
	BuiltGUDEvent=GUDEvent_Horde_SilverbackBuilt
	RepairedGUDEvent=GUDEvent_Horde_SilverbackRepaired
	DestroyedGUDEvent=GUDEvent_Horde_SilverbackDestroyed
}
