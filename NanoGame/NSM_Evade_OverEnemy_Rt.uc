/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_Evade_OverEnemy_Rt extends NSM_Evade_Base;

function InitFollowerSpecialMoveName()
{
	if( Follower != None )
	{
		if( (Vector(MyNP.Rotation) DOT Vector(Follower.Rotation)) < 0.f )
		{
			FollowerSpecialMoveName = 'NSM_Evade_OverEnemy_Victim_Lt';
		}
	}
}

defaultproperties
{
	AnimName="Sword_Jump_RollOnOpponent_Rt"
	RBA_X=RBA_Translate
	RBA_Y=RBA_Translate
	RBA_Z=RBA_Discard
	RMM=RMM_Accel

	FollowerSpecialMoveName="NSM_Evade_OverEnemy_Victim_Rt"
}