/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearCrowdAgent extends GameCrowdAgentSkeletal
	native;

/** Which team we're currently on */
var() EGearTeam CrowdTeam;
/** Should killing this agent count toward the Seriously achivement */
var() bool bCountForSeriouslyAchievement;
/** Which type of weapon to shoot */
var() class<GearWeapon> WeaponClass;
/** Weapon to use for firing effects */
var transient GearWeapon SpawnedWeapon;

simulated event byte ScriptGetTeamNum()
{
	return CrowdTeam;
}

function TakeDamage(int DamageAmount, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	local GearPC PC;

	if( WorldInfo.GRI.OnSameTeam(self, EventInstigator) )
	{
		DamageAmount = 0;
	}

	Super.TakeDamage(DamageAmount, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);

	if( Health <= 0 )
	{
		// Score kill (Seriously 3.0?)
		PC = GearPC(EventInstigator);
		if( PC != None && bCountForSeriouslyAchievement )
		{
			PC.UpdateSeriously();
		}
	}
}

simulated function OnAgentFireAtTarget(SeqAct_AgentFireAtTarget Action)
{
	Super.OnPlayAgentAnimation(Action);
}


event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	Super.OnAnimEnd(SeqNode, PlayedTime, ExcessTime);

	// Delete crowd agent after death anim is finished
	if( bIsPlayingDeathAnimation )
	{
		LifeSpan = -0.1f;
	}
}	

defaultproperties
{
	bCountForSeriouslyAchievement=true
}


