/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoSkill_NanoBuckets extends NanoSkill;


struct SkillDatum
{
	var config float Mutliplier;
};
var config array<SkillDatum> NanoBucketsLevels;

function float GetNanoBucketMutliplier( NanoPawn NP )
{
	return NanoBucketsLevels[SkillLevel].Mutliplier;
}

simulated function SkillLevelJustModified()
{
	local int NewNumOfNanoPowerBuckets;

	// we actually want to use .default.NumOfNanoPowerBuckets here as we are setting NumOfNanoPowerBuckets from it!
	NewNumOfNanoPowerBuckets = PawnOwner.default.NumOfNanoPowerBuckets * GetNanoBucketMutliplier( PawnOwner );

	PawnOwner.SetNanoBuckets( NewNumOfNanoPowerBuckets, FALSE );

}


defaultproperties
{
	SkillType=NS_NanoBuckets
	bSkipReplication=TRUE


	SkillIconOrigin=(X=192)
	SkillIconSize=(X=64,Y=64)
}




