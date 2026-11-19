/**
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAIAction_EngageThreat_Trooper_ProvidingCover extends NanoAIAction_EngageThreat_Trooper within NanoAI_Trooper;


static function int InternalGetUtility( NanoAIBase InAI )
{
	return 0;
}



state Combat_ProvidingCover
{
	function bool CanProvideCover(NanoAI_Trooper TestBuddy)
	{
		return TestBuddy == FireBuddy;
	}

Begin:
	if (!LineOfSightTo(FireTarget))
	{
		class'NanoAICmd_Move_UntilInRange'.static.MoveToVisibleActor(Outer,FireTarget,FALSE,1.5f);
	}
	MyTrooper.SpawnNanoBaton();
	if (!MyTrooper.bHasShield && NumBatonsToThrowLeft > 0 && FRand() > 0.85)
	{
		MyTrooper.ThrowTesla();
		do
		{
			Sleep(1.f);
		} until (!MyTrooper.bThrowingTesla);
		NumBatonsToThrowLeft--;
	}
	else
	{
		if (MyTrooper.bHasShield)
		{
			MyTrooper.bShieldPose = TRUE;
			Sleep(0.25f);
		}
		StartFiring();
		do
		{
			Sleep(0.5f);
		} until(!IsFiringWeapon());
	}
	if (MyTrooper.bHasShield)
	{
		Sleep(0.5);
	}
	else
	{
		Sleep(MyTrooper.FullBodySlot.PlayCustomAnim('SMG_Reload_4th',2.f,0.2f,0.2f));
	}
	//GotoState('Combat_WithFireBuddy');
}


defaultproperties
{
	StartingStateName="Combat_ProvidingCover"
}