/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */
//=============================================================================
// TMTeamAI.
// strategic team AI control for TeamGame
//
//=============================================================================
class TMTeamAI extends Info
	native;

var TMTeamInfo Team;
var TMTeamInfo EnemyTeam;
var	int	NumSupportingPlayer;

var TMGameObjective Objectives; // list of objectives to be defended or attacked by this team
var TMGameObjective PickedObjective;	// objective that was picked from a list of equal priority objectives
var TMGameObjective PickedStandaloneObjective;	// objective that was picked from a list of equal priority objectives

var TMSquadAI Squads;
var TMSquadAI AttackSquad, FreelanceSquad;
var class<TMSquadAI> SquadType;
var int OrderOffset;
var name OrderList[8];

var TMPickupFactory SuperPickups[16];
var int NumSuperPickups;
var bool bFoundSuperItems;
var array<TMVehicleFactory> ImportantVehicleFactories;

function PostBeginPlay()
{
	Super.PostBeginPlay();
	SetTimer(5.0,true);
}

function Timer()
{
	ReAssessStrategy();
}

function CriticalObjectiveWarning(TMGameObjective G, Pawn NewEnemy);

/** finds all the static super pickups/vehicle factories/etc in the level and registers them for fast lookup */
function FindSuperItems()
{
	local TMPickupFactory P;
	//local TMVehicleFactory V;

	foreach WorldInfo.AllNavigationPoints(class'TMPickupFactory', P)
	{
		if ( P.bIsSuperItem )
		{
			SuperPickups[NumSuperPickups] = P;
			NumSuperPickups++;
			if ( NumSuperPickups == 16 )
				break;
		}
	}

//	foreach WorldInfo.AllNavigationPoints(class'TMVehicleFactory', V)
//	{
//		if (V.bStartNeutral || V.bKeyVehicle || (V.VehicleClass != None && V.VehicleClass.default.bKeyVehicle))
//		{
//			ImportantVehicleFactories[ImportantVehicleFactories.length] = V;
//		}
//	}

	bFoundSuperItems = true;
}

function Reset()
{
	Super.Reset();
	PickedObjective = None;
}

function ClearEnemies()
{
	local TMSquadAI S;
	local int i;
	local TMBot M;

	Reset();
	for ( S=Squads; S!=None; S=S.NextSquad )
	{
		for ( i=0; i<8; i++ )
			S.Reset();
		for	( M=S.SquadMembers; M!=None; M=M.NextSquadMember )
			M.Reset();
	}
}

function TMSquadAI GetSquadLedBy(Controller C)
{
	local TMSquadAI S;

	for ( S=Squads; S!=None; S=S.NextSquad )
		if ( S.SquadLeader == C )
			return S;
	return None;
}

// ReAssessStrategy()
//Look at current strategic situation, and decide whether to update squad objectives

function ReAssessStrategy()
{
	local TMGameObjective O;
	local int PlusDiff, MinusDiff;

	if ( FreelanceSquad == None )
		return;

	// decide whether to play defensively or aggressively
	if ( WorldInfo.Game.TimeLimit > 0 )
	{
		PlusDiff = 1;
		MinusDiff = 2;
		if ( WorldInfo.GRI.RemainingTime < 180 )
		{
			PlusDiff = 0;
			MinusDiff = 0;
		}
	}
	else
	{
		PlusDiff = 2;
		MinusDiff = 2;
	}

	FreelanceSquad.bFreelanceAttack = false;
	FreelanceSquad.bFreelanceDefend = false;
	if ( Team.Score > EnemyTeam.Score + PlusDiff )
	{
		FreelanceSquad.bFreelanceDefend = true;
		O = GetLeastDefendedObjective(FreelanceSquad.SquadLeader);
	}
	else if ( Team.Score < EnemyTeam.Score - MinusDiff )
	{
		FreelanceSquad.bFreelanceAttack = true;
		O = GetPriorityAttackObjectiveFor(FreelanceSquad, FreelanceSquad.SquadLeader);
	}
	else
		O = GetPriorityFreelanceObjectiveFor(FreelanceSquad);

	if ( (O != None) && (O != FreelanceSquad.SquadObjective) )
		FreelanceSquad.SetObjective(O,true);
}

function NotifyKilled(Controller Killer, Controller Killed, Pawn KilledPawn, class<DamageType> damageTyp)
{
	local TMSquadAI S;

	for ( S=Squads; S!=None; S=S.NextSquad )
		S.NotifyKilled(Killer,Killed,KilledPawn, damageTyp);
}

function FindNewObjectives(TMGameObjective DisabledObjective)
{
	local TMSquadAI S;

	for (S = Squads; S != None; S = S.NextSquad)
	{
		if (DisabledObjective == None || S.SquadObjective == DisabledObjective)
		{
			FindNewObjectiveFor(S, true);
		}
	}
}

// FindNewObjectiveFor()
//pick a new objective for a squad that has completed its current objective

function FindNewObjectiveFor(TMSquadAI S, bool bForceUpdate)
{
	local TMGameObjective O;

	if ( PlayerController(S.SquadLeader) != None )
		return;
	if ( S.bFreelance )
		O = GetPriorityFreelanceObjectiveFor(S);
	else if ( S.GetOrders() == 'Attack' )
		O = GetPriorityAttackObjectiveFor(S, S.SquadLeader);
	if ( O == None )
	{
		O = GetLeastDefendedObjective(S.SquadLeader);
	}
	if ( (O == None) && (S.bFreelance || (S.GetOrders() == 'Defend')) )
		O = GetPriorityAttackObjectiveFor(S, S.SquadLeader);
	S.SetObjective(O,bForceUpdate);
}

function RemoveSquad(TMSquadAI Squad)
{
	local TMSquadAI S;

	if (Squad == AttackSquad)
	{
		AttackSquad = None;
	}
	if (Squad == FreelanceSquad)
	{
		FreelanceSquad = None;
	}
	if ( Squad == Squads )
	{
		Squads = Squads.NextSquad;
	}
	else
	{
		for (S = Squads; S != None; S = S.NextSquad)
		{
			if (S.NextSquad == Squad)
			{
				S.NextSquad = S.NextSquad.NextSquad;
				return;
			}
		}
	}
}


function TMSquadAI FindSquadOf(Controller C)
{
	local TMSquadAI S;

	if ( TMBot(C) != None )
		return TMBot(C).Squad;

	for ( S=Squads; S!=None; S=S.NextSquad )
		if ( S.SquadLeader == C )
			return S;
	return None;
}

function bool FriendlyToward(Pawn Other)
{
	return WorldInfo.GRI.OnSameTeam(self,Other);
}

simulated native function byte GetTeamNum();

function SetObjectiveLists()
{
	local TMGameObjective O;

	foreach WorldInfo.AllNavigationPoints(class'TMGameObjective', O)
	{
		if (O.bFirstObjective)
		{
			Objectives = O;
			break;
		}
	}
}

function TMSquadAI FindHumanSquad()
{
	local TMSquadAI S;

	for ( S=Squads; S!=None; S=S.NextSquad )
		if ( S.SquadLeader.IsA('PlayerController') )
			return S;

	return None;
}

function TMSquadAI AddHumanSquad()
{
	local TMSquadAI S;
	local PlayerController P;

	S = FindHumanSquad();
	if ( S != None )
		return S;

	// add human squad
	foreach WorldInfo.AllControllers(class'PlayerController', P)
	{
		if (P.PlayerReplicationInfo != None && P.PlayerReplicationInfo.Team == Team && !P.PlayerReplicationInfo.bOnlySpectator)
		{
			return AddSquadWithLeader(P, None);
		}
	}

	return None;
}

function PutBotOnSquadLedBy(Controller C, TMBot B)
{
	local TMSquadAI S;

	for ( S=Squads; S!=None; S=S.NextSquad )
		if ( S.SquadLeader == C )
			break;

	if ( (S == None) && (PlayerController(C) != None) )
		S = AddSquadWithLeader(C,None);

	if ( S != None )
		S.AddBot(B);
}

function TMSquadAI AddSquadWithLeader(Controller C, TMGameObjective O)
{
	local TMSquadAI S;

	S = spawn(SquadType);
	S.Initialize(Team,O,C);
	S.NextSquad = Squads;
	Squads = S;
	return S;
}

function TMGameObjective GetLeastDefendedObjective(Controller InController)
{
	local TMGameObjective O, Best;
	local bool bCheckDistance;
	local float BestDistSq, NewDistSq;

	bCheckDistance = (InController != None) && (InController.Pawn != None);
	for ( O=Objectives; O!=None; O=O.NextObjective )
	{
		if ( (O.DefenderTeamIndex == Team.TeamIndex) && !O.bIsDisabled )
		{
			if ( (Best == None) || (Best.DefensePriority < O.DefensePriority) )
			{
				Best = O;
				if (bCheckDistance)
				{
					BestDistSq = VSizeSq(Best.Location - InController.Pawn.Location);
				}
			}
			else if ( Best.DefensePriority == O.DefensePriority )
			{
				// prioritize less defended or closer nodes
				if (Best.GetNumDefenders() > O.GetNumDefenders())
				{
					Best = O;
					if (bCheckDistance)
					{
						BestDistSq = VSizeSq(Best.Location - InController.Pawn.Location);
					}
				}
				else if (bCheckDistance)
				{
					NewDistSq = VSizeSq(Best.Location - InController.Pawn.Location);
					if (NewDistSq < BestDistSq)
					{
						Best = O;
						BestDistSq = NewDistSq;
					}
				}
			}
		}
	}
	return Best;
}

function TMGameObjective GetPriorityAttackObjectiveFor(TMSquadAI InAttackSquad, Controller InController)
{
	local TMGameObjective O;
	local bool bCheckDistance;
	local float BestDistSq, NewDistSq;

	bCheckDistance = (InController != None) && (InController.Pawn != None);

	if ( (PickedObjective != None) && PickedObjective.bIsDisabled )
		PickedObjective = None;
	if ( PickedObjective == None )
	{
		for ( O=Objectives; O!=None; O=O.NextObjective )
		{
			if ( (O.DefenderTeamIndex != Team.TeamIndex) && !O.bIsDisabled )
			{
				if ( (PickedObjective == None) || (PickedObjective.DefensePriority < O.DefensePriority) )
				{
					PickedObjective = O;
					if (bCheckDistance)
					{
						BestDistSq = VSizeSq(PickedObjective.Location - InController.Pawn.Location);
					}
				}
				else if ( bCheckDistance && (PickedObjective.DefensePriority == O.DefensePriority) )
				{
					// prioritize closer nodes
					NewDistSq = VSizeSq(O.Location - InController.Pawn.Location);
					if ( NewDistSq < BestDistSq )
					{
						PickedObjective = O;
						BestDistSq = NewDistSq;
					}
				}
			}
		}
	}
	return PickedObjective;
}


function TMGameObjective GetPriorityStandaloneObjectiveFor(TMSquadAI InAttackSquad, Controller InController)
{
	local TMGameObjective O;
	local bool bCheckDistance;
	local float BestDistSq, NewDistSq;

	bCheckDistance = (InController != None) && (InController.Pawn != None);
	PickedStandaloneObjective = none;

	for ( O=Objectives; O!=None; O=O.NextObjective )
	{
		if ( (O.DefenderTeamIndex != Team.TeamIndex) && O.IsStandalone() && !O.bIsDisabled )
		{
			if ( (PickedStandaloneObjective == None) || (PickedStandaloneObjective.DefensePriority < O.DefensePriority) )
			{
				PickedStandaloneObjective = O;
				if (bCheckDistance)
				{
					BestDistSq = VSizeSq(PickedStandaloneObjective.Location - InController.Pawn.Location);
				}
			}
			else if ( bCheckDistance && (PickedStandaloneObjective.DefensePriority == O.DefensePriority) )
			{
				// prioritize closer nodes
				NewDistSq = VSizeSq(O.Location - InController.Pawn.Location);
				if ( NewDistSq < BestDistSq )
				{
					PickedStandaloneObjective = O;
					BestDistSq = NewDistSq;
				}
			}
		}
	}
	return PickedStandaloneObjective;
}

function TMGameObjective GetPriorityFreelanceObjectiveFor(TMSquadAI InFreelanceSquad)
{
	return GetPriorityAttackObjectiveFor(InFreelanceSquad, (InFreeLanceSquad != None) ? InFreelanceSquad.SquadLeader : None);
}

function bool PutOnDefense(TMBot B)
{
	local TMGameObjective O;

	O = GetLeastDefendedObjective(B);
	if ( O != None )
	{
		if ( O.DefenseSquad == None )
			O.DefenseSquad = AddSquadWithLeader(B, O);
		else
			O.DefenseSquad.AddBot(B);
		return true;
	}
	return false;
}

function PutOnOffense(TMBot B)
{
	if ( (AttackSquad == None) || (AttackSquad.Size >= AttackSquad.MaxSquadSize) )
		AttackSquad = AddSquadWithLeader(B, GetPriorityAttackObjectiveFor(None, B));
	else
		AttackSquad.AddBot(B);
}

function PutOnFreelance(TMBot B)
{
	if ( (FreelanceSquad == None) || (FreelanceSquad.Size >= FreelanceSquad.MaxSquadSize) )
		FreelanceSquad = AddSquadWithLeader(B, GetPriorityFreelanceObjectiveFor(None));
	else
		FreelanceSquad.AddBot(B);
	if ( !FreelanceSquad.bFreelance )
	{
	FreelanceSquad.bFreelance = true;
		bForceNetUpdate = TRUE;
	}
}


//SetBotOrders - sets bot's initial orders

//FIXME - need assault type pick leader when leader dies for attacking
//freelance squad - backs up defenders under attack, or joins in attacks

function SetBotOrders(TMBot NewBot)
{
	local TMSquadAI HumanSquad;
	local name NewOrders;

	if ( Objectives == None )
		SetObjectiveLists();

	if ( TMTeamGame(WorldInfo.Game).bForceAllRed )
		NewOrders = 'DEFEND';
	/* @FIXME: get singleplayer orders from somewhere
	else if ( (R==None) || R.NoRecommendation() )
	{
		// pick orders
		if ( Team.Size == 0 )
			OrderOffset = 0;
		NewOrders = OrderList[OrderOffset % 8];
		OrderOffset++;
	}
	else if ( R.RecommendDefense() )
		NewOrders = 'DEFEND';
	else if ( R.RecommendAttack() )
		NewOrders = 'ATTACK';
	else if ( R.RecommendSupport() )
		NewOrders = 'FOLLOW';
	else
		NewOrders = 'FREELANCE';
	*/
	else
	{
		// resset orders list if only bot on team
		//@FIXME: this still doesn't handle players joining/leaving in e.g. Players vs Bots screwing up orders over time
		if (Team.Size == 1)
		{
			OrderOffset = 0;
		}
		NewOrders = OrderList[OrderOffset % 8];
		OrderOffset++;
	}

	// `log(NewBot$" set Initial orders "$NewOrders);
	if ( (NewOrders == 'DEFEND') && PutOnDefense(NewBot) )
		return;

	if ( NewOrders == 'FREELANCE' )
	{
		PutOnFreelance(NewBot);
		return;
	}

	if ( NewOrders == 'ATTACK' )
	{
		PutOnOffense(NewBot);
		return;
	}

	if ( NewOrders == 'FOLLOW' )
	{
		// Follow any human player
		HumanSquad = AddHumanSquad();
		if ( HumanSquad != None )
		{
			HumanSquad.AddBot(NewBot);
			return;
		}
	}
	PutOnOffense(NewBot);
}

// SetOrders()
// Called when player gives orders to bot
function SetOrders(TMBot B, name NewOrders, Controller OrderGiver)
{
	local TMPlayerReplicationInfo PRI;

	PRI = TMPlayerReplicationInfo(B.PlayerReplicationInfo);
	if ( TMHoldSpot(B.DefensePoint) != None )
	{
		PRI.bHolding = false;
		B.FreePoint();
	}
	//`log("Team New orders "$NewOrders@OrderGiver);
	if ( NewOrders == 'Hold' )
	{
		PRI.bHolding = true;
		PutBotOnSquadLedBy(OrderGiver,B);
		B.DefensePoint = PlayerController(OrderGiver).ViewTarget.Spawn(class'TMHoldSpot');
		if ( Vehicle(PlayerController(OrderGiver).ViewTarget) != None )
			TMHoldSpot(B.DefensePoint).HoldVehicle = TMVehicle(PlayerController(OrderGiver).ViewTarget);
		if ( PlayerController(OrderGiver).ViewTarget.Physics == PHYS_Ladder )
			B.DefensePoint.SetPhysics(PHYS_Ladder);
	}
	else if ( NewOrders == 'Defend' )
		PutOnDefense(B);
	else if ( NewOrders == 'Attack' )
		PutOnOffense(B);
	else if ( NewOrders == 'Follow' )
	{
		B.FreePoint();
		PutBotOnSquadLedBy(OrderGiver,B);
	}
	else if ( NewOrders == 'Freelance' )
	{
		PutOnFreelance(B);
		return;
	}
	else if ( NewOrders == 'DropFlag' )
	{
		B.TossFlagToPlayer(OrderGiver);
	}
}

function CallForHelp(TMBot B)
{
}

function RemoveFromTeam(Controller Other)
{
	local TMSquadAI S;

	if ( PlayerController(Other) != None )
	{
		for ( S=Squads; S!=None; S=S.NextSquad )
			S.RemovePlayer(PlayerController(Other));
	}
	else if ( TMBot(Other) != None )
	{
		for ( S=Squads; S!=None; S=S.NextSquad )
			S.RemoveBot(TMBot(Other));
	}
}

