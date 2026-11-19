/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoPlan_BulletMagnet extends NanoPlan;



var() protected const float ForgeDistance;
var() protected const float ForgeHeight;

var() protected const vector SpawnOffset;


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




function StartForge(optional delegate<NanoPawn.OnForgeFinished> OnFinishCallback)
{
	local vector SpawnLoc;
	local rotator SpawnRot;
	local Actor HitActor;

	local BulletMagnet TheMagnet;


	// if we found a spot then let's go ahead and spawn it!
	if( FindLocationAndRotationToSpawn( PawnOwner, SpawnLoc, SpawnRot, HitActor ) == TRUE )
	{

		TheMagnet = BulletMagnet(PawnOwner.Spawn(class<Actor>(DynamicLoadObject("NanoGame.BulletMagnet", class'class')),,, SpawnLoc, SpawnRot,, TRUE));

		TheMagnet.Attach( HitActor );
	}
}

/** 
 * We need to make certain we have a correct place to spawn the hand print.
 *
 * returns TRUE/FALSE if it found a location.  And will update the out_loc and out_rot 
 **/
protected static function bool FindLocationAndRotationToSpawn( const NanoPawn NP, out vector out_Loc, out rotator out_Rot, out Actor out_HitActor )
{
	local vector TraceStart, TraceEnd, HitLoc, HitNorm, CamFvec;
	local Actor HitActor;
	local rotator CamRot;

	// trace out
	CamRot = NP.GetViewRotation();
	CamFvec = vector(NP.GetViewRotation());
	TraceStart = NP.Location + vect(0,0,64) + (default.SpawnOffset >> CamRot);
	TraceEnd = TraceStart + CamFvec * default.ForgeDistance;

	HitActor = NP.Trace(HitLoc, HitNorm, TraceEnd, TraceStart, TRUE,,, class'Actor'.const.TRACEFLAG_Bullet);

	NP.DrawDebugLine( TraceEnd, TraceStart, 255, 0, 0, TRUE );

	// if we hit an actor!  Then let's attach it
	if( HitActor != None )
	{
		out_Loc = HitLoc;
		out_Rot = rot(0,0,0);
		out_HitActor = HitActor;

		return TRUE;
	}


	return FALSE;

}


defaultproperties
{
	PlanName="Bullet Magnet"
	PlanSlot=EPS_Utility

	ForgeUIData=(PlanName="Bullet Magnet",PlanDescription="What ever attached to will cause all bullets to fly toward it",UIMesh=StaticMesh'Locust_PoisonGrenade.Meshes.Locust_PoisonGrenade_Pickup1_SM')
	PlanIcon=(IconTex=Texture2D'UI_HUD.Menu.BlueprintMines',Coords=(U=0,V=0,UL=256,VL=256))


	ForgeDistance=512
	ForgeHeight=128

	//SpawnOffset=(Y=-350.f)

}

