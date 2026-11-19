/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoSkill_Bamf extends NanoSkill;

struct BamfLevelDatum
{
	var config float BamfDistance;
};
var config array<BamfLevelDatum> BamfLevels;

function float GetBamfDistance( NanoPawn NP )
{
	return BamfLevels[SkillLevel].BamfDistance;
}

defaultproperties
{
	SkillType=NS_Bamf
	bSkipReplication=TRUE


	SkillIconOrigin=(X=192)
	SkillIconSize=(X=64,Y=64)
}