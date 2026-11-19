/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoPlan_Cannon extends NanoPlan;

var() protected const float ForgeDistance;

function StartForge(optional delegate<NanoPawn.OnForgeFinished> OnFinishCallback)
{
	local NanoTurret_Cannon Turret;

	local vector HitLoc, HitNorm, TraceStart, TraceEnd, CamFvec;
	local Actor HitActor;
	local vector TurretRotX, TurretRotY, TurretRotZ;

	CamFvec = vector(PawnOwner.GetViewRotation());
	TraceStart = PawnOwner.Location;
	TraceEnd = TraceStart + CamFvec * default.ForgeDistance;
	
	// trace out
	HitActor = PawnOwner.Trace(HitLoc, HitNorm, TraceEnd, TraceStart,,,, class'Actor'.const.TRACEFLAG_Bullet);
	if (HitActor == None)
	{
		// now trace down to find ground
		TraceStart = TraceEnd;
		TraceEnd.Z -= 200.f;
		HitActor = PawnOwner.Trace(HitLoc, HitNorm, TraceEnd, TraceStart,,,, class'Actor'.const.TRACEFLAG_Bullet);
	}

	if (HitActor != None)
	{
		TurretRotZ = HitNorm;
		TurretRotY = TurretRotZ cross CamFvec;
		TurretRotX = TurretRotY cross TurretRotZ;
		
		HitLoc.Z += class'NanoTurret_Cannon'.default.CylinderComponent.CollisionHeight;

		Turret = PawnOwner.Spawn(class'NanoTurret_Cannon', PawnOwner,, HitLoc, OrthoRotation(TurretRotX, TurretRotY, TurretRotZ),, TRUE);
		Turret.Init(PawnOwner);

		PawnOwner.DoSpecialMove( 'NSM_ForgeCycle' );
	}
}

defaultproperties
{
	ForgeDistance=200

	PlanName="Cannon Turret"
	PlanSlot=EPS_Utility

	ForgeUIData=(PlanName="Cannon Turret",PlanDescription="Summon for one single massive destructive shot.",UIMesh=StaticMesh'Weapon_Proto.Meshes.SM_WeaponProto_Colt45')
	PlanIcon=(IconTex=Texture2D'UI_HUD.Menu.BlueprintCannon',Coords=(U=0,V=0,UL=256,VL=256))
}