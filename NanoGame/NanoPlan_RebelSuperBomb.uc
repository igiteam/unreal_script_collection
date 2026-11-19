/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoPlan_RebelSuperBomb extends NanoPlan;

var() protected const float ForgeDistance;
var() protected const float ForgeHeight;

var() protected const vector SpawnOffset;


// spawn a proj that goes up and blows up

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
	local NanoProj_SuperBomb TheBomb;
	local NanoMCP MCP;

	// if we found a spot then let's go ahead and spawn it!
	if( FindLocationAndRotationToSpawn( PawnOwner, SpawnLoc, SpawnRot, HitActor ) == TRUE )
	{

		TheBomb = NanoProj_SuperBomb(PawnOwner.Spawn(class<Actor>(DynamicLoadObject("NanoGame.NanoProj_SuperBomb", class'class')),,, SpawnLoc, SpawnRot,, TRUE));

		TheBomb.NanoProjInit(vect(0,0,1));

		TheBomb.SetTimer( 1.0f, FALSE, nameof(TheBomb.Detonate) );

		MCP = NanoGRI(PawnOwner.WorldInfo.GRI).MCP;

		MCP.UpdateLocalMCPDatum( "", class'NanoMCPKeys'.default.RebelSuperBombForge_Location, vect(0,0,0) );
		MCP.UpdateLocalMCPDatum( "", class'NanoMCPKeys'.default.RebelSuperBombForge_LastUsedBy, class'NanoTypes'.static.GetLocalPlayerUserName() );

		// tell the world that we need to spawn a bomb into the level
		MCP.UpdateLocalMCPDatum( "", class'NanoMCPKeys'.default.RebelSuperBombForge_BombState, "FindPlaceToSpawn" ); // reset the bomb basically
		

		NanoGRI(PawnOwner.WorldInfo.GRI).NCM.HandleChallengeEvent( ECET_DetonateRebelSuperBomb );

		NanoGRI(PawnOwner.WorldInfo.GRI).GetNanoPC().GetPRI().RemoveNanoPlan( default.Class );
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
	TraceStart = NP.Location + (default.SpawnOffset >> CamRot);
	TraceEnd = TraceStart + CamFvec * default.ForgeDistance;

	HitActor = NP.Trace(HitLoc, HitNorm, TraceEnd, TraceStart, FALSE,,, class'Actor'.const.TRACEFLAG_Bullet);

	if( HitActor == None )
	{
		out_Loc = TraceEnd;
		out_Rot = rot(0,0,0);
		out_HitActor = HitActor;

		return TRUE;
	}


	return FALSE;


}


defaultproperties
{
	PlanName="RebelSuperBomb"
	PlanSlot=EPS_Utility

	ForgeUIData=(PlanName="Rebel Super Bomb",PlanDescription="This is the rebel super bomb.  It will destroy ALL within a radius",UIMesh=StaticMesh'MET_PacifierMechProto.SM.S_Proto_PacifierMech_Rocket',MeshRotation=(Pitch=0,Yaw=0,Roll=0),Scale=3.0f)
	PlanIcon=(IconTex=Texture2D'UI_HUD.Menu.BlueprintBomb',Coords=(U=0,V=0,UL=256,VL=256))	

	ForgeDistance=512
	ForgeHeight=64

	SpawnOffset=(Y=-350.f)
}