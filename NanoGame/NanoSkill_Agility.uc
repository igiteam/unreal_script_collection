/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoSkill_Agility extends NanoSkill
	config(Pawn);

simulated function bool SetSkillLevel(optional bool bSkipXP, optional int DesiredSkillLevel)
{
	local NanoSkill OtherSkill;
	local bool bOK;

	bOK = super.SetSkillLevel(bSkipXP, DesiredSkillLevel);
	if( bOK )
	{
		// Force jump to this level
		OtherSkill = PawnOwner.GetSkill(class'NanoSkill_Jump');
		OtherSkill.SetSkillLevel(TRUE, SkillLevel);
		
		// Force dash to this level
		OtherSkill = PawnOwner.GetSkill(class'NanoSkill_Dash');
		OtherSkill.SetSkillLevel(TRUE, SkillLevel);	
	}

	return bOK;
}

defaultproperties
{
	bHideFromSkillUI=TRUE

	SkillType=NS_Agility


	SkillIconOrigin=(X=128)
	SkillIconSize=(X=64,Y=64)
}
