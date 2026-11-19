/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */
class TMCTFTeamAI extends TMTeamAI;

var TMCTFFlag FriendlyFlag, EnemyFlag;
var float LastGotFlag;

function TMSquadAI AddSquadWithLeader(Controller C, TMGameObjective O)
{
	local TMCTFSquadAI S;

	if ( O == None )
		O = EnemyFlag.HomeBase;
	S = TMCTFSquadAI(Super.AddSquadWithLeader(C,O));
	if ( S != None )
	{
		S.FriendlyFlag = FriendlyFlag;
		S.EnemyFlag = EnemyFlag;
	}
	return S;
}

function TMGameObjective GetPriorityFreelanceObjectiveFor(TMSquadAI InFreelanceSquad)
{
	if (InFreelanceSquad != None)
	{
		InFreelanceSquad.bFreelanceAttack = true;
	}
	return GetPriorityAttackObjectiveFor(InFreelanceSquad, (InFreelanceSquad != None) ? InFreelanceSquad.SquadLeader : None);
}

