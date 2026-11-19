/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoPawn_MetaCorp_RiotCop_Agent extends NanoPawn_MetaCorp_RiotCop_Captain;


var config vector2d AbleToDoGroundPoundRange;
var transient float NextGroundPoundTime;



simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	DetachComponent( NanoPawnArmorBlue );
	NanoPawnArmorBlue = None;
}



function class<NanoAICmd> GetSpecialMeleeMove()
{
	return class'NanoAICmd_Trooper_Attack_GroundPound';
}

function bool AbleToDoSpecialMeleeMove()
{
	if( NextGroundPoundTime < WorldInfo.TimeSeconds )
	{
		return TRUE;
	}

	return FALSE;
}


function DidSpecialMeleeMove()
{
	NextGroundPoundTime = WorldInfo.TimeSeconds + RandRange( AbleToDoGroundPoundRange.X, AbleToDoGroundPoundRange.Y );
}


function ModifyPawnBasedBoidRules_AvoidTeamaates( bool bShoudAvoid )
{
	local int Idx;
	local NanoAIBase AI;

	AI = NanoAIBase(Controller);

	if( AI != None )
	{
		for( Idx = 0; Idx < AI.BoidRules.Length; Idx++ )
		{
			AI.BoidRules[Idx].bAvoidTeammates = bShoudAvoid;
		}
	}
}



simulated function bool IsShowcaseForForMelee()
{
	return TRUE;
}



/** This will return the struct that holds all of the values for this specific pawn **/
simulated function NanoCausingChaosValueDatum GetDeathChaosValue()
{
	return class'NanoCausingChaosValues'.default.RiotTrooperAgentKilled;
}




defaultproperties
{
	ControllerClass=class'NanoAI_Agent'
	
	PreferredRangedWeaponClass=class'NanoWeap_ShotGunSemiAuto'
	
	Begin Object Name=NanoPawnMesh
		Materials(0)=MaterialInstanceConstant'MET_ShockTrooper.M_ShieldTrooper_Body_Agent'
		Scale=1.3
	End Object

	MeleeEngagePriorityLevel=10

	// this is the DestFallZ distance for a lot of stories. (basically he will follow you anywhere)
	Jump_DestZValueThatICanSurvive=10000
	Jump_HowHighICanJumpInStories=6

	DroppedOrbClasses.Add(class'NanoAbsorbOrb_Body_Agent')
}