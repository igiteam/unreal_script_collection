/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoSkill_DenseBash extends NanoSkill;


struct DenseBashLevelDatum
{
	var config int BashVelocity;
	var config int BashVelocityUp;
	var config int BashDamage;
	var config bool bShouldGibOnDeath;
};
var config array<DenseBashLevelDatum> DenseBashLevels;


function float GetDenseBashVelocity()
{
	return DenseBashLevels[SkillLevel].BashVelocity;
}

function float GetDenseBashVelocityUp()
{
	return DenseBashLevels[SkillLevel].BashVelocityUp;
}

function float GetDenseBashDamage()
{
	return DenseBashLevels[SkillLevel].BashDamage;
}

function class<NanoDamageType> GetDenseBashDamageType()
{
	if( DenseBashLevels[SkillLevel].bShouldGibOnDeath == TRUE )
	{
		return class'NDT_DenseDashGib';
	}
	else
	{
		return class'NDT_DenseDash';
	}
}



defaultproperties
{
	SkillType=NS_DenseBash
	bSkipReplication=TRUE


	SkillIconOrigin=(X=192)
	SkillIconSize=(X=64,Y=64)
}