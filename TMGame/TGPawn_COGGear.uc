/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 *
 *  Base TM COG TM Character class
 */
class TGPawn_COGGear extends TGPawn_Infantry
	config(TGPawn)
	native(TGPawn);


simulated function ChainSawGore()
{
	BreakConstraint( vect(100,0,0), vect(0,10,0), 'b_MF_Spine_03' );
	BreakConstraint( vect(0,100,0), vect(0,0,10), 'b_MF_UpperArm_R' );
}


simulated function OnDestroy(SeqAct_Destroy Action)
{
	if (PlayerController(Controller) != None &&
		WorldInfo.NetMode != NM_Standalone)
	{
		;
	}
	else
	{
		Super.OnDestroy(Action);
	}
}


simulated function PlayKickSound()
{
	//PlaySound(SoundCue'Foley_BodyMoves.BodyMoves.SquadLegKick_Cue');
}

simulated function bool CanBeSpecialMeleeAttacked(TGPawn Attacker)
{
	// don't allow friendly AI COGs to be executed unless playing on a high difficulty
	// and the AI has been left DBNO for a while
	if (!Super.CanBeSpecialMeleeAttacked(Attacker))
	{
		return false;
	}
	else if (!IsDBNO() || TGGameSP_Base(WorldInfo.Game) == None)
	{
		return true;
	}
	else if (WorldInfo.TimeSeconds - TimeStampEnteredRevivingState < 10.0)
	{
		return false;
	}
	else if (IsHumanControlled())
	{
		return TGPRI(PlayerReplicationInfo).Difficulty.default.bHumanCOGCanBeExecuted;
	}
	else
	{
		return false;
	}
}


simulated function byte GetMPWeaponColorBasedOnClass()
{
	return 0;
}



