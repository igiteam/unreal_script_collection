/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoSkill_Health extends NanoSkill;


struct SkillDatum
{
	var config float Mutliplier;
};
var config array<SkillDatum> HealthModLevels;

function float GetHealthMutliplier( NanoPawn NP )
{
	return HealthModLevels[SkillLevel].Mutliplier;
}

simulated function SkillLevelJustModified()
{
	// we actually want to use .default.DefaultHealth here as we are setting DefaultHealth from it!
	PawnOwner.DefaultHealth = PawnOwner.default.DefaultHealth * GetHealthMutliplier( PawnOwner );
	PawnOwner.Health = PawnOwner.DefaultHealth;
}



defaultproperties
{
	SkillType=NS_Health
	bSkipReplication=TRUE

	SkillIconOrigin=(X=192)
	SkillIconSize=(X=64,Y=64)
}





