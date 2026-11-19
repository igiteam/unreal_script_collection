/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_Trooper_DeployBaton extends NSM_PlaySingleAnim_Base;

function float PlayAnimation()
{
	local float AnimTime;
	local NanoWeap_Baton Baton;

	MyNP.ZeroMovementVariables();

	AnimTime = Super.PlayAnimation();

	Baton = NanoWeap_Baton(MyNP.Weapon);
	if( Baton != None )
	{
		Baton.DeployBaton();
	}

	return AnimTime;
}

function ResetPawnInfo()
{
	MyNP.ResetRunSyncGroup();
	Super.ResetPawnInfo();
}

		
defaultproperties
{
	BlendInTime=0.1f
	BlendOutTime=-1.f

	bUpperBodyAnim=TRUE
	AnimName=ShockTrooper_Combat_Baton_Extract
}