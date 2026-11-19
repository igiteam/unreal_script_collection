/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/
class SeqAct_AIForceBanzaiCharge extends SequenceAction
	native(Sequence);

/** If true, this will be a melee attack */
var() bool bMelee;
/** List of targets to choose from. */
var() Actor MeleeTarget;

var() enum EForceChargeTeam
{
	ForceChargeTeam_None,
	ForceChargeTeam_COG,
	ForceChargeTeam_Locust,
	ForceChargeTeam_All,
	ForceChargeTeam_Lambent,
} TeamThatShouldCharge;

event Activated()
{
	if( !bMelee )
	{
		if( TeamThatShouldCharge == ForceChargeTeam_COG || TeamThatShouldCharge == ForceChargeTeam_All )
		{
			class'AICmd_Attack_Banzai'.static.EveryoneAttack(GetWorldInfo(), TEAM_COG);
		}

		if( TeamThatShouldCharge == ForceChargeTeam_Locust || TeamThatShouldCharge == ForceChargeTeam_All )
		{
			class'AICmd_Attack_Banzai'.static.EveryoneAttack(GetWorldInfo(), TEAM_LOCUST);
		}

		if( TeamThatShouldCharge == ForceChargeTeam_Lambent || TeamThatShouldCharge == ForceChargeTeam_All )
		{
			class'AICmd_Attack_Banzai'.static.EveryoneAttack(GetWorldInfo(), TEAM_LAMBENT);
		}
	}
}

defaultproperties
{
	ObjName="AI: Force Banzai Charge"
	ObjCategory="AI"

	TeamThatShouldCharge=ForceChargeTeam_None

	VariableLinks(1)=(ExpectedType=class'SeqVar_Object',LinkDesc="Melee Target",PropertyName=MeleeTarget)
}
