/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_Base_DriveVehicleWeapon extends AICommand
	within GearAI;

/** Cache a reference to our Submarine */
var Vehicle_Submarine_Base MySubmarine;
/** Cache a reference to our GearWeaponPawn */
var GearWeaponPawn MyGearWeaponPawn;

var Vector2D    SelectTargetRange;

function Pushed()
{
	Super.Pushed();
	MySubmarine = Vehicle_Submarine_Base(Pawn.Base);
	MyGearWeaponPawn = GearWeaponPawn(Pawn);
	GotoState( 'InCombat' );
}

final function bool IsValidTarget(Actor Target)
{
	return (Target != None && 
			!WorldInfo.GRI.OnSameTeam(Target, Outer) && 
			Target.bCollideActors && 
			Interface_AIVehicleWeaponTarget(Target).GetVehicleWeaponAIRating() > 0.0);
}

final function float RateTarget(Actor Target)
{
	local float Rating;
	local float TargetDistSq;
	local GearAI SquadMate;

	// Don't target on teammates or actors with collision off
	if( !IsValidTarget(Target) )
	{
		return -1.0;
	}

	Rating = 1.0f;
	if( Interface_AIVehicleWeaponTarget(Target) != None )
	{
		Rating *= Interface_AIVehicleWeaponTarget(Target).GetVehicleWeaponAIRating();
	}
	// Hack for prioritizing the Leviathan in Maelstrom
	else if( InterpActor(Target) != None )
	{
		Rating *= 4.f;
	}

	// Prefer our current target
	if( FireTarget == Target )
	{
		Rating *= 1.5;
	}
	
	// Rate closer targets higher
	TargetDistSq = VSizeSq(MyGearWeaponPawn.Location - Target.Location);
	if( TargetDistSq < EnemyDistance_Short*EnemyDistance_Short )
	{
		Rating *= 2.0;
	}
	else if( TargetDistSq < EnemyDistance_Medium*EnemyDistance_Medium )
	{
		Rating *= 1.5;
	}
	else if( TargetDistSq < EnemyDistance_Long*EnemyDistance_Long )
	{
		Rating *= 1.25;
	}

	// Lower the rating of targets that our squadmates are shooting at
	foreach Squad.AllMembers(class'GearAI', SquadMate)
	{
		if( SquadMate.FireTarget == Target )
		{
			Rating *= 0.5;
		}
	}
	
	return Rating;
}

final function CombatSelectTarget()
{
	SetTimer(RandRange(SelectTargetRange.X, SelectTargetRange.Y), false, nameof(CombatSelectTarget), self);
	SelectTarget();
}

function bool SelectTarget()
{
	local float BestTargetScore, CurTargetScore;
	local int TargetIdx;

	if( !IsValidTarget(FireTarget) )
	{
		FireTarget = None;
	}

	for( TargetIdx = 0; TargetIdx < MySubmarine.NearbyDangerousActors.length; ++TargetIdx )
	{
		if( ProhibitedTargetList.Find(MySubmarine.NearbyDangerousActors[TargetIdx]) >= 0 )
		{
			continue;
		}

		CurTargetScore = RateTarget(MySubmarine.NearbyDangerousActors[TargetIdx]);
		if( CurTargetScore > BestTargetScore )
		{
			BestTargetScore = CurTargetScore;
			FireTarget = MySubmarine.NearbyDangerousActors[TargetIdx];
		}
	}

	for( TargetIdx = 0; TargetIdx < TargetList.Length; TargetIdx++ )
	{
		if( ProhibitedTargetList.Find(TargetList[TargetIdx]) >= 0 )
		{
			continue;
		}

		CurTargetScore = RateTarget(TargetList[TargetIdx]);
		if( CurTargetScore > BestTargetScore )
		{
			BestTargetScore = CurTargetScore;
			FireTarget = TargetList[TargetIdx];
		}
	}

	`AILog( "Best Target"@FireTarget@"Target Score:"@BestTargetScore, 'Combat' );

	Focus = FireTarget;
	Enemy = Pawn(FireTarget);
	return (FireTarget != None);
}

state InCombat
{
	function BeginState(Name PreviousStateName)
	{
		Super.BeginState(PreviousStateName);

		// Set target selection timer
		SetTimer(RandRange(SelectTargetRange.X, SelectTargetRange.Y), false, nameof(CombatSelectTarget), self);
	}

	function SetFocusNoTarget()
	{
		local vector GunLocation, SubLocation;

		MyGearWeaponPawn.MyVehicle.GetBarrelLocationAndRotation(MyGearWeaponPawn.MySeatIndex, GunLocation);
		SubLocation = MyGearWeaponPawn.MyVehicle.Mesh.GetBoneLocation('Chasis');
		SetFocalPoint(GunLocation - SubLocation, true);
	}

Begin:
	`AILog( "BEGIN TAG", 'State' );

	SelectTarget();
	if( FireTarget == None || 
		GearVehicleWeapon(Pawn.Weapon) == None )
	{
		//debug
		`AILog( "Not able to fire at target"@Pawn.Weapon, 'Combat' );
		Focus = None;
		StopFiring();
		SetFocusNoTarget();
		Sleep(RandRange(0.25, 1.0));
		Goto('Begin');
	}

	StartFiring(2 + Rand(3));
	do
	{
		Sleep(RandRange(0.25, 0.75));
		`AILog( "Firing weapon...", 'Loop' );
	} until( !IsValidTarget(FireTarget) );

	Sleep(RandRange(0.1, 0.5));

	Goto('Begin');
}

defaultproperties
{
	SelectTargetRange=(X=1.5f,Y=3.f)
}