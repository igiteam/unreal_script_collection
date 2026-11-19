
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_BayonetDraw_Victim extends GSM_InteractionPawnFollower_Base;

function SplashBayonetBloodOnScreen()
{
	if (PawnOwner != None)
	{
		PawnOwner.SplashBayonetCameraBlood();
	}
}

/** Notification forwarded by GearAnimNotify_SpecialMove */
function AnimNotify(AnimNodeSequence SeqNode, GearAnimNotify_SpecialMove NotifyObject)
{
	if (NotifyObject.Info == 'SplashBayonetBloodOnScreen')
	{
		SplashBayonetBloodOnScreen();
		return;
	}

	Super.AnimNotify(SeqNode, NotifyObject);
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	Super.SpecialMoveEnded(PrevMove, NextMove);

	// safety kill, if somehow GSM_ChainsawAttack fails to kill the owner
	if( PawnOwner.WorldInfo.NetMode != NM_Client && PawnOwner.IsGameplayRelevant() )
	{
		`warn("victim special move forcing Died(), this shouldn't happen");
		ScriptTrace();
		if( Leader != None )
		{
			PawnOwner.Died(Leader.Controller, class'GDT_BayonetGib', PawnOwner.Location);
		}
		else
		{
			PawnOwner.Died(None, class'GDT_BayonetGib', PawnOwner.Location);
		}
	}
}

defaultproperties
{
	bUseUnsynchedServerMove = TRUE
}
