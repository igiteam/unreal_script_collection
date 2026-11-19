/**
 * this is the bomb for the bomb delivery gametype
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearTrackBomb extends GearTrackActor
	abstract;


/** number of checkpoints to place on the track, to which we'll reset if we're destroyed */
var config int NumCheckpoints;
/** amount of damage we can take before being destroyed */
var config int DefaultHealth;
/** health remaining */
var int Health;
/** how long after being damaged before bomb starts self repair */
var config float HealthRecoveryDelay;
/** how much bomb heals each second when repairing */
var config float HealthRecoveryRate;
/** last time the bomb took damage */
var float LastDamageTime;
/** set when invulnerable due to having just respawned/reset */
var bool bSpawnProtected;
/** maximum time spawn protection last if the attacking team ignores or is unable to reach the bomb (0 == never times out) */
var config float MaxSpawnProtectionTime;
/** amount of time in seconds between taking fatal damage and exploding */
var config byte ExplosionCountdown;
/** if not zero, amount of time remaining in active explosion countdown */
var byte CountdownRemaining;
/** true while exploding due to being destroyed */
var repnotify bool bExploding;
/** effect played while exploding */
var ParticleSystem ExplosionTemplate;
/** damage radius and amount for explosion */
var config float ExplosionDamage, ExplosionRadius;
/** whether the bomb explosion ignores line of sight, causing damage through walls */
var config bool bExplosionIgnoresLOS;
/** how long we're exploding before we reset to the last checkpoint */
var config float DeathTime;
/** multiplier to melee damage that hits us */
var config float MeleeDamageMult;
/** amount of damage taken when the opposing team "uses" the bomb */
var config int UseDamage;
/** which team we're currently on */
var byte TeamNum;
/** colors for the ring effect */
var vector RingMovementColor[2];
/** last time the bomb was moved forward */
var float LastAdvanceTime;
/** interaction displayed on the HUD */
var ActionInfo InteractAction;
/** number of points players obtain for triggering the bomb to explode (divided among all players that dealt unhealed damage) */
var config int PointsForDestruction;
/** list of players that damaged the bomb for destruction points */
var array<PlayerDamageInfo> PlayerDamageList;

replication
{
	if (bNetDirty)
		bExploding, TeamNum, Health, CountdownRemaining;
}

simulated event PreBeginPlay()
{
	Health = DefaultHealth;

	Super.PreBeginPlay();
}

simulated event ReplicatedEvent(name VarName)
{
	if (VarName == nameof(bExploding))
	{
		if (bExploding)
		{
			Explode();
		}
	}
	else
	{
		Super.ReplicatedEvent(VarName);
	}
}

simulated event byte ScriptGetTeamNum()
{
	return TeamNum;
}

function TakeDamage( int DamageAmount, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType,
			optional TraceHitInfo HitInfo, optional Actor DamageCauser )
{
	local GearPRI PRI;
	local int Idx;

	if ( !bExploding && Health > 0 && !bSpawnProtected && WorldInfo.Game.IsInState('MatchInProgress') &&
		!WorldInfo.GRI.OnSameTeam(EventInstigator, self) )
	{
		if (ClassIsChildOf(DamageType, class'GDT_Melee'))
		{
			DamageAmount *= MeleeDamageMult;
		}

		Super.TakeDamage(DamageAmount, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);

		// add to list for destruction scoring
		if (EventInstigator != None)
		{
			PRI = GearPRI(EventInstigator.PlayerReplicationInfo);
			if (PRI != None)
			{
				Idx = PlayerDamageList.Find('PRI', PRI);
				if (Idx == INDEX_NONE)
				{
					Idx = PlayerDamageList.Add(1);
				}
				PlayerDamageList[Idx].PRI = PRI;
				PlayerDamageList[Idx].DamageTotal += Min(DamageAmount, Health);
			}
		}

		Health -= DamageAmount;
		if (Health <= 0)
		{
			if (ExplosionCountdown > 0)
			{
				CountdownRemaining = ExplosionCountdown;
				SetTimer(1.0, true, nameof(DecrementCountdown));
			}
			else
			{
				Explode();
			}
		}

		LastDamageTime = WorldInfo.TimeSeconds;
	}
}

function bool UsedBy(Pawn User)
{
	if (!bSpawnProtected)
	{
		TakeDamage(UseDamage, User.Controller, Location, vect(0,0,0), class'DamageType');
		return true;
	}
	else
	{
		return false;
	}
}

/** called while counting down to explosion to decrement the timer */
final function DecrementCountdown()
{
	if (WorldInfo.Game.IsInState('MatchInProgress'))
	{
		CountdownRemaining--;
		if (CountdownRemaining == 0)
		{
			Explode();
			ClearTimer(nameof(DecrementCountdown));
		}
	}
	else
	{
		ClearTimer(nameof(DecrementCountdown));
	}
}

/** makes the bomb blow up and reset to the last checkpoint due to being destroyed by the enemy */
simulated final function Explode()
{
	local Actor Victim;
	local int i;
	local float TotalDamage;

	bExploding = true;
	CountdownRemaining = 0;

	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		WorldInfo.MyEmitterPool.SpawnEmitter(ExplosionTemplate, Location, Rotation);
	}
	SetHidden(true);
	SetCollision(false);

	if (Role == ROLE_Authority)
	{
		// explode
		if (bExplosionIgnoresLOS)
		{
			foreach CollidingActors(class'Actor', Victim, ExplosionRadius, Location)
			{
				if (!Victim.bWorldGeometry && Victim != self && (Victim.bProjTarget || (NavigationPoint(Victim) == None)))
				{
					Victim.TakeRadiusDamage(None, ExplosionDamage, ExplosionRadius, class'GDT_TrackBombExplosion', 1.0, Location, false, self);
				}
			}
		}
		else
		{
			HurtRadius(ExplosionDamage, ExplosionRadius, class'GDT_TrackBombExplosion', 1.0, Location,, None);
		}
		// award destruction points
		while (i < PlayerDamageList.length)
		{
			if (PlayerDamageList[i].PRI == None)
			{
				PlayerDamageList.Remove(i, 1);
			}
			else
			{
				TotalDamage += PlayerDamageList[i].DamageTotal;
				i++;
			}
		}
		for (i = 0; i < PlayerDamageList.length; i++)
		{
			PlayerDamageList[i].PRI.ScoreGameSpecific2(`StatId(SCORE_DESTROY_BOMB), PointsForDestruction * (PlayerDamageList[i].DamageTotal / TotalDamage));
		}

		SetTimer(DeathTime, false, nameof(ReturnToCheckpoint));
		GearGameBombDelivery(WorldInfo.Game).NotifyBombExploded();
	}
}

/** called on a timer to disable spawn protection if the maximum amount of time expires */
final function SpawnProtectionTimedOut()
{
	bSpawnProtected = false;
}

/** resets the bomb and moves it to the last checkpoint location */
final function ReturnToCheckpoint()
{
	local float CheckpointInterval;

	CheckpointInterval = TrackMatinee.InterpData.InterpLength / NumCheckpoints;
	TrackMatinee.SetPosition(CheckpointInterval * int(TrackMatinee.Position / CheckpointInterval));
	TrackPosition = TrackMatinee.Position;
	VerifyMatineeActive();

	Health = DefaultHealth;
	PlayerDamageList.length = 0;
	bExploding = false;
	CountdownRemaining = 0;
	bSpawnProtected = true;
	SetTimer(MaxSpawnProtectionTime, false, nameof(SpawnProtectionTimedOut));
	SetHidden(false);
	SetCollision(true);
}

simulated function bool CanMove()
{
	return !bExploding && Super.CanMove();
}

simulated function float GetMovementPctFor(GearPawn P)
{
	local float Pct;

	if (P.GetTeamNum() == TeamNum)
	{
		Pct = MovementPctPerPlayer;
		if (P.IsDBNO())
		{
			Pct *= 0.5;
		}
	}
	return Pct;
}

function CheckProgress(float AmountMoved)
{
	LastAdvanceTime = WorldInfo.TimeSeconds;
	if (bSpawnProtected)
	{
		bSpawnProtected = false;
		ClearTimer(nameof(SpawnProtectionTimedOut));
	}
	if (TrackMatinee.Position >= TrackMatinee.InterpData.InterpLength)
	{
		// victory!
		GearGameBombDelivery(WorldInfo.Game).NotifyBombPathComplete();
	}
	else if ( int((TrackMatinee.Position - AmountMoved) / TrackMatinee.InterpData.InterpLength * NumCheckpoints) <
			int(TrackMatinee.Position / TrackMatinee.InterpData.InterpLength * NumCheckpoints) )
	{
		// we passed a checkpoint
		GearGameBombDelivery(WorldInfo.Game).NotifyBombCheckpoint();
	}
}

simulated function vector GetRingMovementColor(float AmountMoved)
{
	return RingMovementColor[TeamNum];
}

simulated event Tick(float DeltaTime)
{
	Super.Tick(DeltaTime);

	// see if we should repair
	if (Role == ROLE_Authority && !bExploding && Health > 0 && WorldInfo.TimeSeconds - LastDamageTime > HealthRecoveryDelay)
	{
		Health = Min(Health + HealthRecoveryRate * DeltaTime, DefaultHealth);
	}
}

defaultproperties
{
	bCollideActors=true
	bBlockActors=true
	bSpawnProtected=true
}
