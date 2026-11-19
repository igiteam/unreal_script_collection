/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearFortification_CommandCenter extends GearFortification
	abstract;

/** number of charges at each level before the depot runs out (255 = infinity) */
var config array<byte> Charges;
/** number of charges remaining before we run out */
var repnotify byte ChargesRemaining;

/** maximum number of enemy targets for the effect at each upgrade level */
var config array<int> MaxTargets;
/** blast duration of HOD beam for the level 2 effect */
var config float HODBeamDuration;

/** projectile for level 1 mortar strike */
var class<GearProj_ExplosiveBase> MortarProjClass;
/** beam manager for level 2 HOD strike */
var class<HOD_BeamManagerBase> BeamManagerClass;

/** list of pending targets for upgrade levels where the attacks are delayed slightly */
var array<GearPawn> PendingTargets;
/** instigator for delayed attacks */
var Controller PendingInstigator;

replication
{
	if (bNetDirty)
		ChargesRemaining;
}

simulated function InitializeUpgradeLevel(byte NewLevel)
{
	Super.InitializeUpgradeLevel(NewLevel);

	ChargesRemaining = Charges[NewLevel];
}

/** checks the entries in the PendingTargets array to make sure none of them have died or otherwise become invalid targets */
final function ValidatePendingTargets()
{
	local int i;

	while (i < PendingTargets.length)
	{
		if (PendingTargets[i] == None || PendingTargets[i].IsInState('Dying') || PendingTargets[i].bDeleteMe)
		{
			PendingTargets.Remove(i, 1);
		}
		else
		{
			i++;
		}
	}
}

/** called on a looping timer to perform a single HOD strike on a random target in the pending list until the list is empty */
final function DoHODStrike()
{
	local int i;
	local HOD_BeamBase Beam;

	ValidatePendingTargets();
	if (PendingTargets.length == 0)
	{
		ClearTimer(nameof(DoHODStrike));
		if (ChargesRemaining == 0)
		{
			Explode(false);
		}
	}
	else
	{
		i = Rand(PendingTargets.length);
		GearGRI(WorldInfo.GRI).HODBeamManager.BeginBeamWarmup(PendingTargets[i].Location - vect(0,0,1) * PendingTargets[i].GetCollisionHeight(), self, true, HODBeamDuration, Beam);
		if (PendingInstigator == None)
		{
			PendingInstigator = GetDamageInstigator();
		}
		Beam.Instigator = (PendingInstigator != None) ? PendingInstigator.Pawn : None;
		PendingTargets.Remove(i, 1);
		SetTimer(FMax(0.25, GetTimerRate(nameof(DoHODStrike)) - 0.1), true, nameof(DoHODStrike));
	}
}

/** called on a looping timer to perform a single sniper strike on a random target in the pending list until the list is empty */
final function DoSniperStrike()
{
	local int i;
	local vector HitLocation;

	ValidatePendingTargets();
	if (PendingTargets.length == 0)
	{
		ClearTimer(nameof(DoSniperStrike));
		if (ChargesRemaining == 0)
		{
			Explode(false);
		}
	}
	else
	{
		i = Rand(PendingTargets.length);
		if (PendingInstigator == None)
		{
			PendingInstigator = GetDamageInstigator();
		}
		HitLocation = (PendingTargets[i].HeadBoneNames.length > 0) ? PendingTargets[i].GetHeadshotLocation() : PendingTargets[i].Location;
		PendingTargets[i].TakeDamage(300, PendingInstigator, HitLocation, vect(0,0,1), class'GDT_CommandCenterSniper',, self);
		PendingTargets.Remove(i, 1);
		SetTimer(FMax(0.25, GetTimerRate(nameof(DoSniperStrike)) - 0.1), true, nameof(DoSniperStrike));
	}
}

simulated function bool CanBeUsedBy(Pawn User)
{
	// must have charges and not in deployment mode
	return ( ChargesRemaining > 0 && GearGRI(WorldInfo.GRI) != None && !GearGRI_Horde(WorldInfo.GRI).bCanPlaceFortifications &&
		WorldInfo.GRI.OnSameTeam(self, User) );
}

function bool UsedBy(Pawn User)
{
	local GearPawn GP;
	local array<GearPawn> Targets;
	local int ShotsRemaining, Index;
	local vector ProjVel;
	local bool bResult;
	local GearProj_ExplosiveBase MortarProj;
	local HOD_BeamManagerBase BeamManager;

	if (!CanBeUsedBy(User))
	{
		return false;
	}

	if (Marker != None && Marker.TriggerEventClass(class'SeqEvent_CommandCenter', User))
	{
		if (--ChargesRemaining == 0)
		{
			Explode(false);
		}
		bResult = true;
	}
	else
	{
		switch (UpgradeLevel)
		{
			case 0:
				// do sniper headshot damage to random Pawns
				foreach WorldInfo.AllPawns(class'GearPawn', GP)
				{
					if ( !GP.bIgnoredByFortifications && GP.Health > 0 && GP.Health < 1500 &&
						!WorldInfo.GRI.OnSameTeam(GP, User) )
					{
						PendingTargets.AddItem(GP);
					}
				}

				if (PendingTargets.length > 0)
				{
					while (PendingTargets.length > MaxTargets[UpgradeLevel])
					{
						PendingTargets.Remove(Rand(PendingTargets.length), 1);
					}
					PendingInstigator = User.Controller;
					// delayed strikes
					SetTimer(1.0, true, nameof(DoSniperStrike));

					GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_CommandCenterTriggered, User);
					ChargesRemaining--; // destruction check happens after strikes are done
					bResult = true;
				}
				break;
			case 1:
				// lob mortar projectile on random Pawns
				foreach WorldInfo.AllPawns(class'GearPawn', GP)
				{
					if ( !GP.bIgnoredByFortifications && GP.Health > 0 && !WorldInfo.GRI.OnSameTeam(GP, User) &&
						FastTrace(GP.Location + vect(0,0,5000), GP.Location) )
					{
						Targets.AddItem(GP);
					}
				}

				if (Targets.length > 0)
				{
					ShotsRemaining = MaxTargets[UpgradeLevel];
					while (Targets.length > 0 && ShotsRemaining-- > 0)
					{
						Index = Rand(Targets.length);
						MortarProj = Spawn(MortarProjClass,,, Targets[Index].Location + vect(0,0,5000), rotator(vect(0,0,-1)));
						if (MortarProj != None)
						{
							MortarProj.Instigator = User;
							MortarProj.InstigatorController = User.Controller;
							MortarProj.SpawnFort = self;
							ProjVel = Normal(Targets[Index].Velocity) * 200.0;
							ProjVel.Z = -350.0;
							MortarProj.Init(Normal(ProjVel));
							MortarProj.Velocity = ProjVel;
						}
						Targets.Remove(Index, 1);
					}
					GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_CommandCenterTriggered, User);
					if (--ChargesRemaining == 0)
					{
						Explode(false);
					}
					bResult = true;
				}
				break;
			case 2:
				// HOD strikes on random Pawns
				foreach WorldInfo.AllPawns(class'GearPawn', GP)
				{
					if ( !GP.bIgnoredByFortifications && GP.Health > 0 && !WorldInfo.GRI.OnSameTeam(GP, User) &&
						FastTrace(GP.Location + vect(0,0,5000), GP.Location) )
					{
						PendingTargets.AddItem(GP);
					}
				}

				if (PendingTargets.length > 0)
				{
					BeamManager = GearGRI(WorldInfo.GRI).HODBeamManager;
					if (BeamManager == None)
					{
						BeamManager = WorldInfo.Spawn(BeamManagerClass);
						GearGRI(WorldInfo.GRI).HODBeamManager = BeamManager;
					}
					while (PendingTargets.length > MaxTargets[UpgradeLevel])
					{
						PendingTargets.Remove(Rand(PendingTargets.length), 1);
					}
					PendingInstigator = User.Controller;
					// delayed strikes
					SetTimer(1.0, true, nameof(DoHODStrike));

					GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_CommandCenterTriggered, User);
					ChargesRemaining--; // destruction check happens after strikes are done
					bResult = true;
				}
				break;
			default:
				`Warn("Unhandled upgrade level!");
				break;
		}
	}

	return bResult;
}

function bool ShouldBeUsedBy(GearAI AI)
{
	local Pawn P;
	local Controller C;
	local int Count;

	// use command center when there are multiple known enemies in close range
	foreach AI.Squad.AllEnemies(class'Pawn', P, AI)
	{
		foreach AI.Squad.AllMembers(class'Controller', C)
		{
			if (C.Pawn != None && VSize(C.Pawn.Location - P.Location) < 768.0)
			{
				Count++;
				break;
			}
		}
	}
	return (Count > FCeil(WorldInfo.Game.NumPlayers / 2) && Super.ShouldBeUsedBy(AI));
}

protected function RepairPct(float AmountToRepair)
{
	Super.RepairPct(AmountToRepair);
	ChargesRemaining = Min(Charges[UpgradeLevel], ChargesRemaining + Charges[UpgradeLevel] * AmountToRepair);
}

simulated function float GetConditionPct()
{
	return FMin(Super.GetConditionPct(), float(ChargesRemaining) / float(Charges[UpgradeLevel]));
}

simulated event ReplicatedEvent(name VarName)
{
	if (VarName == nameof(ChargesRemaining))
	{
		// if we were repaired, the marker might need to remove the material indicating repair state
		if (Marker != None)
		{
			Marker.SetEnabled(false);
		}
	}
	else
	{
		Super.ReplicatedEvent(VarName);
	}
}

defaultproperties
{
	Begin Object Class=CylinderComponent Name=Cylinder
		CollisionRadius=100.0
		CollisionHeight=72.0
		CollideActors=true
		BlockActors=false
		BlockZeroExtent=false
		BlockNonZeroExtent=true
	End Object
	Components.Add(Cylinder)

	StatName=CommandCenter
	BuiltGUDEvent=GUDEvent_Horde_CommandCenterBuilt
	UpgradedGUDEvent=GUDEvent_Horde_CommandCenterUpgraded
	RepairedGUDEvent=GUDEvent_Horde_CommandCenterRepaired
	DestroyedGUDEvent=GUDEvent_Horde_CommandCenterDestroyed
	bScoreDamageCaused=true
}
