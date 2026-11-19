/**
 * Naked Ticker devouring execution
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_Ticker_EatDBNOBase extends GSM_CQC_Killer_Base
	abstract;

/** Second anim to play after the kill has occurred */
var	GearPawn.BodyStance BS_PostKillAnim;

/** Sound to play when playing execution animation */
var SoundCue ExecutionSound;

/** Sound to play when killing the victim */
var SoundCue KillSound;

/** Special Move can be done if we can find a nearby victim. */
protected function bool InternalCanDoSpecialMove()
{
	// don't allow player controlled tickers to grief teammates (e.g. Siege)
	if (PawnOwner.IsPlayerOwned())
	{
		bAllowTeamKill = false;
	}
	Follower = GetVictimPawn();
	return (Follower != None && !Follower.IsBeingExecuted());
}

/** Play the execution sound */
function PlayExecution()
{
	Super.PlayExecution();
	PawnOwner.PlaySound(ExecutionSound);
}

/** Play the kill sound */
function KillVictim()
{
	Super.KillVictim();
	PawnOwner.PlaySound(KillSound);
}

function BS_AnimEndNotify(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	// If we just finished BS_KillerAnim, play BS_PostKillAnim
	if( PawnOwner.BS_SeqNodeBelongsTo(SeqNode, BS_KillerAnim) )
	{
		PawnOwner.BS_Stop(BS_KillerAnim, 0.2f);
		PawnOwner.BS_SetAnimEndNotify(BS_KillerAnim, FALSE);

		PawnOwner.BS_Play(BS_PostKillAnim, SpeedModifier, BlendInTime/SpeedModifier, BlendOutTime/SpeedModifier, FALSE, TRUE);
		PawnOwner.BS_SetAnimEndNotify(BS_PostKillAnim, TRUE);

		bForcePrecisePosition = false;
		bAlignPawns = false;
		PawnOwner.ZeroMovementVariables();
	}
	else
	{
		Super.BS_AnimEndNotify(SeqNode, PlayedTime, ExcessTime);
	}
}

defaultproperties
{
	bAllowTeamKill=true
	bDisablePhysics=true
	BS_KillerAnim=(Stance=((Slot=BS_FullBody,AnimName="digging_loop")))
	BS_VictimAnim=(Stance=((Slot=BS_FullBody,AnimName="DBNO_SmashFace")))
	BS_PostKillAnim=(Stance=((Slot=BS_FullBody,AnimName="scavenging_loop")))
	VictimDeathTime=1.0f
	VictimRotStartTime=0.42f
}