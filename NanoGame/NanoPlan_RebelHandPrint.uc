/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoPlan_RebelHandPrint extends NanoPlan;


var() protected const float ForgeDistance;
var() protected const float ForgeHeight;



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

	local RebelHandPrint HandPrint;


	// if we found a spot then let's go ahead and spawn it!
	if( FindLocationAndRotationToSpawn( PawnOwner, SpawnLoc, SpawnRot, HitActor ) == TRUE )
	{
		// Find and remove any other existing RebelHandPrint
		FindAndRemoveAnyExistingRebelHandPrintsOwnedByUs();

		HandPrint = RebelHandPrint(PawnOwner.Spawn(class<Actor>(DynamicLoadObject("NanoGame.RebelHandPrint", class'class')),,, SpawnLoc, SpawnRot,, TRUE));
		HandPrint.UpdateForgedLocation();
		HandPrint.OwnerID = class'NanoTypes'.static.GetLocalPlayerUserName();

		NanoGRI(PawnOwner.WorldInfo.GRI).NCM.HandleChallengeEvent( ECET_PlacedRebelHandPrint );

		// start pawn's special move
		PawnOwner.DoSpecialMove( 'NSM_ForgeCycleFast' );
	}
	
}

/** 
 * We need to make certain we have a correct place to spawn the hand print.
 *
 * returns TRUE/FALSE if it found a location.  And will update the out_loc and out_rot 
 **/
protected static function bool FindLocationAndRotationToSpawn( const NanoPawn NP, out vector out_Loc, out rotator out_Rot, out Actor out_HitActor )
{
	local vector TraceStart, TraceEnd, HitLoc, HitNorm;
	local rotator PawnRot;
	local Actor HitActor;
	local vector SpawnLoc;
	local rotator SpawnRot;


	// trace out
	//PawnOwner.GetActorEyesViewPoint( TraceStart, PawnRot );
	TraceStart = NP.Location;
	PawnRot = NP.Rotation;
	TraceStart += vect(0,0,64); // EyeViewPoint is not quite correct...
	TraceEnd = TraceStart + Vector(PawnRot) * default.ForgeDistance;
	HitActor = NP.Trace(HitLoc, HitNorm, TraceEnd, TraceStart, FALSE,,, class'Actor'.const.TRACEFLAG_Bullet);
	//PawnOwner.DrawDebugLine(TraceStart, TraceEnd, 0, 0, 255, TRUE);

	//`log( `showvar(HitActor) );

	// if we hit a wall in front of us, save off the location as we are going to spawn the handprint there
	if( HitActor != None )
	{
		SpawnLoc = HitLoc;
		SpawnRot = Rotator(-HitNorm);

		// now trace down
		TraceStart = HitLoc;
		TraceEnd = TraceStart;
		TraceEnd.Z -= default.ForgeHeight;
		HitActor = NP.Trace(HitLoc, HitNorm, TraceEnd, TraceStart, FALSE,,, class'Actor'.const.TRACEFLAG_Bullet);
		//PawnOwner.DrawDebugLine(TraceStart, TraceEnd, 0, 0, 255, TRUE);

		//`log( `showvar(HitActor) );

		// since our trace hit nothing we know we are at least ForgeHeight off the ground.
		// so go ahead and spawn the RabelHandPrint
		if( HitActor == None )
		{
			out_Loc = SpawnLoc;
			out_Rot = SpawnRot;
			out_HitActor = HitActor;

			return TRUE;
		}
	}


	return FALSE;
}



function FindAndRemoveAnyExistingRebelHandPrintsOwnedByUs()
{
	local string UserName;
	local RebelHandPrint HandPrint;

	UserName = class'NanoTypes'.static.GetLocalPlayerUserName();

	ForEach PawnOwner.DynamicActors( class'RebelHandPrint', HandPrint )
	{
		if( HandPrint.OwnerID == UserName )
		{
			HandPrint.Destroy();
		}
	}

}


defaultproperties
{
	PlanName="RebelHandPrint"
	PlanSlot=EPS_Utility

	ForgeUIData=(PlanName="Rebel Hand Print",PlanDescription="Place a single hand in the world for your friends to get 10 buckets of Nano",UIMesh=StaticMesh'REB_Deco01.SM.Mesh.S_REB_Deco01_HandForge_Symbol',MeshRotation=(Pitch=0,Yaw=16384,Roll=0),Scale=3.0f)
	PlanIcon=(IconTex=Texture2D'UI_HUD.Menu.BlueprintHandForge',Coords=(U=0,V=0,UL=256,VL=256))

	ForgeDistance=1024
	ForgeHeight=128
}