/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoPlan_SentryTurret extends NanoPlan;

var() protected const float ForgeDistance;


var private vector DelayedSpawnLoc;
var private rotator DelayedSpawnRot;

static function bool IsValidLocationToSpawn( NanoPawn NP )
{
	local vector SpawnLoc;
	local rotator SpawnRot;
	local Actor HitActor;

	// check to see if we can spawn or not first
	if( FindLocationAndRotationToSpawn( NP, SpawnLoc, SpawnRot, HitActor ) == FALSE )
	{
		return FALSE;
	}

	return TRUE;
}



function StartForge(optional delegate<NanoPawn.OnForgeFinished> OnFinishCallback)
{
	local vector SpawnLoc;
	local rotator SpawnRot;
	local Actor HitActor;

	//local class<NanoSentryTurretBase> TurretClass;
	//local NanoSentryTurretBase Turret;

	// if we found a spot then let's go ahead and spawn it!
	if( FindLocationAndRotationToSpawn( PawnOwner, SpawnLoc, SpawnRot, HitActor ) == TRUE )
	{
		DelayedSpawnLoc = SpawnLoc;
		DelayedSpawnRot = SpawnRot;

		PawnOwner.SetTimer( 1.0f, FALSE, nameof(DelayedSpawning), self );

		PawnOwner.DoSpecialMove( 'NSM_ForgeCycleFast' );
	}
}

// remove this once we get a real art asset with constructing effects
private function DelayedSpawning()
{
	local class<NanoSentryTurretBase> TurretClass;
	local NanoSentryTurretBase Turret;

	TurretClass = class<NanoSentryTurretBase>(DynamicLoadObject("NanoGameContent.NanoSentryTurret", class'class'));

	Turret = PawnOwner.Spawn(TurretClass,PawnOwner,,DelayedSpawnLoc, DelayedSpawnRot,, TRUE);
	Turret.ForgeActor();
	Turret.InitTeam(PawnOwner);
}


/** 
 * We need to make certain we have a correct place to spawn.
 *
 * returns TRUE/FALSE if it found a location.  And will update the out_loc and out_rot 
 **/
protected static function bool FindLocationAndRotationToSpawn( const NanoPawn NP, out vector out_Loc, out rotator out_Rot, out Actor out_HitActor )
{
	local vector HitLoc, HitNorm, TraceStart, TraceEnd, CamFvec;
	local Actor HitActor;
	local vector TurretRotX, TurretRotY, TurretRotZ;

	local class<NanoSentryTurretBase> TurretClass;

	CamFvec = vector(NP.GetViewRotation());
	TraceStart = NP.Location;
	TraceEnd = TraceStart + CamFvec * default.ForgeDistance;

	// trace out
	HitActor = NP.Trace(HitLoc, HitNorm, TraceEnd, TraceStart,,,, class'Actor'.const.TRACEFLAG_Bullet);
	if( HitActor == None )
	{
		// now trace down to find ground
		TraceStart = TraceEnd;
		TraceEnd.Z -= 200.f;
		HitActor = NP.Trace(HitLoc, HitNorm, TraceEnd, TraceStart,,,, class'Actor'.const.TRACEFLAG_Bullet);
	}

	if( HitActor != None )
	{
		TurretRotZ = HitNorm;
		TurretRotY = TurretRotZ cross CamFvec;
		TurretRotX = TurretRotY cross TurretRotZ;

		out_Rot = OrthoRotation(TurretRotX, TurretRotY, TurretRotZ);


		TurretClass = class<NanoSentryTurretBase>(DynamicLoadObject("NanoGameContent.NanoSentryTurret", class'class'));
		HitLoc.Z += TurretClass.default.CylinderComponent.CollisionHeight;

		out_Loc = HitLoc;

		out_HitActor = HitActor;

		return TRUE;
	}

	return FALSE;
}




defaultproperties
{
	PlanName="Sentry Turret"
	PlanSlot=EPS_Utility

	ForgeUIData=(PlanName="Sentry Turret",PlanDescription="Turret will auto target foes until it is destroyed.",UIMesh=StaticMesh'Weapon_Proto.Meshes.SM_WeaponProto_Colt45')
	PlanIcon=(IconTex=Texture2D'UI_HUD.Menu.BlueprintSentryTurret',Coords=(U=0,V=0,UL=256,VL=256))

	ForgeDistance=400
}