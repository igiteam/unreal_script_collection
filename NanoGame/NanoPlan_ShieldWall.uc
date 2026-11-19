/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoPlan_ShieldWall extends NanoPlan;

var() protected const vector SpawnOffset;

var class<NanoShieldWall> ShieldWallClass;


static function bool IsValidLocationToSpawn( NanoPawn NP )
{
	local vector SpawnLoc;
	local rotator SpawnRot;
	local Actor HitActor;

	// check to see if we can spawn a hand print or not first
	if( FindLocationAndRotationToSpawn( NP, SpawnLoc, SpawnRot, HitActor ) == FALSE )
	{
		return FALSE;
	}

	return TRUE;
}


/** 
 * We need to make certain we have a correct place to spawn.
 *
 * returns TRUE/FALSE if it found a location.  And will update the out_loc and out_rot 
 **/
protected static function bool FindLocationAndRotationToSpawn( const NanoPawn NP, out vector out_Loc, out rotator out_Rot, out Actor out_HitActor )
{
	local vector SpawnLoc, CamX, CamY, CamZ;
	local rotator CamRot;
	local rotator SpawnRot;
	local vector HitLoc, HitNorm;
	local Actor HitActor;

	CamRot = NP.GetViewRotation();
	NP.GetAxes(CamRot, CamX, CamY, CamZ);
	SpawnLoc = NP.Location + (default.SpawnOffset >> CamRot);

	// trace down to the floor here
	HitActor = NP.Trace(HitLoc, HitNorm, SpawnLoc-vect(0,0,128), SpawnLoc, FALSE,,, class'Actor'.const.TRACEFLAG_Bullet);

	if( HitActor != None )
	{
		out_Loc = HitLoc;

		SpawnRot = CamRot;
		SpawnRot.Roll = 0;
		SpawnRot.Pitch = 0;

		out_Rot = SpawnRot;
		out_HitActor = HitActor;

		return TRUE;
	}

	return FALSE;
}



function StartForge(optional delegate<NanoPawn.OnForgeFinished> OnFinishCallback)
{
	local vector SpawnLoc;
	local rotator SpawnRot;
	local Actor HitActor;

	local NanoShieldWall Forged;

	if( FindLocationAndRotationToSpawn( PawnOwner, SpawnLoc, SpawnRot, HitActor ) == TRUE )
	{
		Forged = PawnOwner.Spawn(ShieldWallClass,,, SpawnLoc, SpawnRot,, TRUE);
		Forged.ForgeActor();

		// start pawn's special move
		PawnOwner.DoSpecialMove( 'NSM_ForgeCycleFast' );
	}
}






defaultproperties
{
	PlanName="Shield Wall"
	PlanSlot=EPS_Utility

	ForgeUIData=(PlanName="Shield Wall",PlanDescription="Creates a wall in front of the creator to block enemy fire",UIMesh=StaticMesh'NYC_SetC_01.SM.Mesh.S_NYC_SetC_Wall_01',MeshRotation=(Pitch=-16384,Yaw=0,Roll=-16384),Scale=0.1f)
	PlanIcon=(IconTex=Texture2D'UI_HUD.Menu.BlueprintShieldWall',Coords=(U=0,V=0,UL=256,VL=256))

	SpawnOffset=(X=200.f,Z=0)


	ShieldWallClass=class'NanoShieldWall'


}







