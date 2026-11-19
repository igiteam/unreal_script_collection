/**
 * Vehicle spawner.
 *
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */

class TMVehicleFactory extends TMBaseVehicleFactory
	abstract
	placeable;

/** Offset from factory location to spawn vehicles at */
var		float			SpawnZOffset;

/** Reverse spawn direction depending on which team controls vehicle factory */
var()   bool            bMayReverseSpawnDirection;

/** Not controlled by either team initially */
var()	bool			bStartNeutral;

/** vehicle factory can't be activated while this is set */
var() bool bDisabled;

/** Reverse spawn dir if controlled by same team controlling this objective */
var		TMGameObjective	ReverseObjective;

/** This array holds the initial gun rotations for a spawned vehicle. */
var() array<Rotator>	InitialGunRotations;

/** If set, vehicles from this factory will be key vehicles (for AI) and show up on minimap */
var() bool bKeyVehicle;

/** if set, force bAvoidReversing to true on the vehicle for the AI */
var() bool bForceAvoidReversing;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	if ( Role == ROLE_Authority )
	{
		if ( HDBaseGame(WorldInfo.Game) != None )
		{
			HDBaseGame(WorldInfo.Game).ActivateVehicleFactory(self);
		}
		else
		{
			bStartNeutral = true;
			Activate(255);
		}
	}
	else
	{
		AddToClosestObjective();
	}
}

simulated function AddToClosestObjective()
{
	local TMGameObjective O, Best;
	local float Distance, BestDistance;

	foreach WorldInfo.AllNavigationPoints(class'TMGameObjective', O)
	{
		Distance = VSize(Location - O.Location);
		if ( (Best == None) || (Distance < BestDistance) )
		{
			BestDistance = Distance;
			Best = O;
		}
	}
	if ( Best != None )
	{
		Best.VehicleFactories[Best.VehicleFactories.Length] = self;
	}
}

// Called after PostBeginPlay.
//
simulated event SetInitialState()
{
	bScriptInitialized = true;
}

simulated function RenderMapIcon(TMMapInfo MP, Canvas Canvas, TMPlayerController PlayerOwner, LinearColor FinalColor)
{
	local LinearColor DrawColor;
	if ( !bHasLockedVehicle )
		return;

	DrawColor = MakeLinearColor(0,0,0,0.6);
	MP.DrawRotatedTile(Canvas,class'TMHUD'.default.IconHudTexture, HUDLocation, Rotation.Yaw + 16384, class<TMVehicle>(VehicleClass).Default.MapSize * 1.05, class<TMVehicle>(VehicleClass).Default.IconCoords, DrawColor);
	FinalColor.A = 0.6;
	MP.DrawRotatedTile(Canvas,class'TMHUD'.default.IconHudTexture, HUDLocation, Rotation.Yaw + 16384, class<TMVehicle>(VehicleClass).Default.MapSize, class<TMVehicle>(VehicleClass).Default.IconCoords, FinalColor);
}

function Activate(byte T)
{
	if ( !bDisabled )
	{
		TeamNum = T;
		GotoState('Active');
	}
}

function Deactivate()
{
	local vector HitLocation, HitNormal;

	GotoState('');
	TeamNum = 255;
	if (TMVehicle(ChildVehicle) != None && !ChildVehicle.bDeleteMe && TMVehicle(ChildVehicle).bTeamLocked)
	{
		if (HDBaseGame(WorldInfo.Game).MatchIsInProgress())
		{
			HitLocation = Location;
			ChildVehicle.Health = -2 * ChildVehicle.HealthMax;
			ChildVehicle.TearOffMomentum = vect(0,0,1);
			TraceComponent(HitLocation, HitNormal, ChildVehicle.Mesh, ChildVehicle.Location, Location);
			ChildVehicle.Died(None, class'TMDmgType_Telefrag', HitLocation);
		}
		else
		{
			ChildVehicle.Destroy();
		}
	}
}

/** called when someone starts driving our child vehicle */
function VehicleTaken()
{
	TriggerEventClass(class'TMSeqEvent_VehicleFactory', None, 1);
	bHasLockedVehicle = false;
	// it's possible that someone could enter and immediately exit the vehicle, but if that happens we mark the
	// vehicle as a navigation obstruction and the AI will use that codepath to avoid it, so this extra cost isn't necessary
	ExtraCost = 0;
}

function VehicleDestroyed( TMVehicle V )
{
	TriggerEventClass(class'TMSeqEvent_VehicleFactory', None, 2);
	ChildVehicle = None;
	bHasLockedVehicle = false;
	ExtraCost = 0;
}

function TriggerSpawnedEvent()
{
	TriggerEventClass(class'TMSeqEvent_VehicleFactory', None, 0);
}

function OnToggle(SeqAct_Toggle Action)
{
	local TMGameObjective Objective;

	if (Action.InputLinks[0].bHasImpulse)
	{
		bDisabled = false;
	}
	else if (Action.InputLinks[1].bHasImpulse)
	{
		bDisabled = true;
	}
	else
	{
		bDisabled = !bDisabled;
	}

	if (bDisabled)
	{
		Deactivate();
	}
	else
	{
		// find the objective that owns us and use it to activate us
		foreach WorldInfo.AllNavigationPoints(class'TMGameObjective', Objective)
		{
			if (Objective.VehicleFactories.Find(self) != INDEX_NONE)
			{
				Activate(Objective.GetTeamNum());
				RespawnProgress = 0.0;
				SpawnVehicle();
				break;
			}
		}
	}
}

function rotator GetSpawnRotation()
{
	local rotator SpawnRot;

	SpawnRot = Rotation;
	if ( bMayReverseSpawnDirection && (ReverseObjective != None) && (ReverseObjective.DefenderTeamIndex == TeamNum) )
	{
		SpawnRot.Yaw += 32768;
	}
	return SpawnRot;
}

state Active
{
	function VehicleDestroyed( TMVehicle V )
	{
		Global.VehicleDestroyed(V);
		RespawnProgress = class<TMVehicle>(VehicleClass).Default.RespawnTime -  class<TMVehicle>(VehicleClass).Default.SpawnInTime;
	}

	event SpawnVehicle()
	{
		local Pawn P;
		local bool bIsBlocked;
		local Rotator SpawnRot, TurretRot;
		local vector SpawnLoc;
		local int i;
		local HDBaseGame G;
		local TMVehicle TMChildVehicle;

		if ( (ChildVehicle != None) && !ChildVehicle.bDeleteMe )
		{
			return;
		}

		// tell AI to avoid navigating through factories with a vehicle on top of them
		ExtraCost = FMax(ExtraCost,5000);

		foreach CollidingActors(class'Pawn', P,  class<TMVehicle>(VehicleClass).default.SpawnRadius)
		{
			bIsBlocked = true;
			if (PlayerController(P.Controller) != None)
				PlayerController(P.Controller).ReceiveLocalizedMessage(class'TMVehicleMessage', 2);
		}

		if (bIsBlocked)
		{
			SetTimer(1.0, false, 'SpawnVehicle'); //try again later
		}
		else
		{
			SpawnRot = GetSpawnRotation();
			SpawnLoc = Location + (vect(0,0,1)*SpawnZOffset);
			ChildVehicle = spawn(VehicleClass,,,SpawnLoc, SpawnRot);
			TMChildVehicle = TMVehicle(ChildVehicle);
			if (TMChildVehicle != None )
			{
				TMChildVehicle.SetTeamNum(TeamNum);
				TMChildVehicle.ParentFactory = Self;
				if ( bStartNeutral )
					TMChildVehicle.bTeamLocked = false;
				else if ( TMChildVehicle.bTeamLocked )
					bHasLockedVehicle = true;
				if ( bKeyVehicle )
				{
					TMChildVehicle.SetKeyVehicle();
					// don't let defenders use key vehicles as they may be requied to complete objectives
					TMChildVehicle.AIPurpose = AIP_Offensive;
				}
				if (bForceAvoidReversing)
				{
					TMChildVehicle.bAvoidReversing = true;
				}
				TMChildVehicle.Mesh.WakeRigidBody();

				for (i=0; i<TMChildVehicle.Seats.Length;i++)
				{
					if (i < InitialGunRotations.Length)
					{
						TurretRot = InitialGunRotations[i];
						if ( bMayReverseSpawnDirection && (ReverseObjective != None) && (ReverseObjective.DefenderTeamIndex == TeamNum) )
						{
							TurretRot.Yaw += 32768;
						}
					}
					else
					{
						TurretRot = SpawnRot;
					}

					TMChildVehicle.ForceWeaponRotation(i,TurretRot);
				}
				G = HDBaseGame(WorldInfo.Game);
				if ( G.MatchIsInProgress() )
				{
					TMChildVehicle.PlaySpawnEffect();
				}
				// if gameplay hasn't started yet, we need to wait a bit for everything to be initialized
				if (WorldInfo.bStartup)
				{
					SetTimer(0.1, false, 'TriggerSpawnedEvent');
				}
				else
				{
					TriggerSpawnedEvent();
				}
//				if ( G.bNecrisLocked && TMChildVehicle.bIsNecrisVehicle && (TeamNum == 1) )
//				{
//					TMChildVehicle.bEnteringUnlocks = false;
//				}
			}
		}
	}

	function Activate(byte T)
	{
		TeamNum = T;
		if (ChildVehicle != None)
		{
			// if we have an unused vehicle available, just change its team
			if (TMVehicle(ChildVehicle).bTeamLocked)
			{
				TMVehicle(ChildVehicle).SetTeamNum(T);
			}
		}
		else
		{
			// force a new vehicle to be spawned
			RespawnProgress = 0.0;
			ClearTimer('SpawnVehicle');
			SpawnVehicle();
		}
	}

	function BeginState(name PreviousStateName)
	{
		if ( HDBaseGame(WorldInfo.Game).MatchIsInProgress() )
		{
			RespawnProgress = class<TMVehicle>(VehicleClass).Default.InitialSpawnDelay -  class<TMVehicle>(VehicleClass).Default.SpawnInTime;
			if (RespawnProgress <= 0.0)
			{
				SpawnVehicle();
			}
		}
		else
		{
			RespawnProgress = 0.0;
			SpawnVehicle();
		}
	}

	function EndState(name NextStateName)
	{
		RespawnProgress = 0.0;
		ClearTimer('SpawnVehicle');
	}
}

