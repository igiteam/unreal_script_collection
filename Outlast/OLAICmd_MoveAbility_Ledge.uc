class OLAICmd_MoveAbility_Ledge extends OLAICmd_MoveAbility 
	within OLBot
	native(AI);

var OLLedgeMarker Ledge;

static event OLAICmd_MoveAbility_Ledge MoveThruLedge( OLBot Bot, OLLedgeMarker InLedge, vector InitialDestination, bool bInReversed )
{
	local OLAICmd_MoveAbility_Ledge Cmd;

	if ( Bot != None )
	{
		Cmd = new(Bot) default.class;
		if ( Cmd != None )
		{
			Cmd.Ledge = InLedge;
			Cmd.CurrentDestination = InitialDestination;
			Cmd.bReversed = bInReversed;
			Cmd.WaitPointComponent = InLedge.WaitPointComponent;

			return Cmd;
		}
	}

	return None;
}

function bool IsObjectInUse()
{
	return Ledge.Bots.length > 1; // We are in this list so we want to know if there are others.
}

function RegisterWithObject()
{
	local bool bFound;
	local int Idx;

	bFound = false;
	for (Idx = 0; Idx < Ledge.Bots.length; ++Idx)
	{
		if (Ledge.Bots[Idx] == OLBot(GameAIOwner))
		{
			bFound = true;
		}
	}

	if (!bFound)
	{
		Ledge.Bots.AddItem(OLBot(GameAIOwner));
	}
}

function UnregisterWithObject()
{
	Ledge.Bots.RemoveItem(OLBot(GameAIOwner));

	if (Ledge.ActiveBot == OLBot(GameAIOwner))
	{
		Ledge.ActiveBot = None;
	}
}

function OLBot GetClosestToObject()
{
	local int Idx;
	local OLBot TempClosestBot;
	local OLAICmd_MoveAbility MoveAbilityClosest;
	local OLAICmd_MoveAbility MoveAbilityCurrent;

	for (Idx = 0; Idx < Ledge.Bots.length; ++Idx)
	{
		if (TempClosestBot == None)
		{
			TempClosestBot = Ledge.Bots[Idx];
		}
		else
		{
			MoveAbilityClosest = TempClosestBot.FindCommandOfClass(class'OLAICmd_MoveAbility');
			MoveAbilityCurrent = Ledge.Bots[Idx].FindCommandOfClass(class'OLAICmd_MoveAbility');

			if (VSizeSq(TempClosestBot.EnemyPawn.Location - MoveAbilityClosest.CurrentDestination)
					> VSizeSq(Ledge.Bots[Idx].EnemyPawn.Location - MoveAbilityCurrent.CurrentDestination))
			{
				TempClosestBot = Ledge.Bots[Idx];
			}
		}
	}

	return TempClosestBot;
}

function OLBot GetActiveOnObject()
{
	return Ledge.ActiveBot;
}

function SetActiveOnObject(OLBot NewActiveBot)
{
	Ledge.ActiveBot = NewActiveBot;
}

function array<OLBot> GetBotsOnObject()
{
	return Ledge.Bots;
}

state Performing
{
	function BeginState(Name PreviousStateName)
	{
		ActiveLedge = Ledge;
	}

	function EndState(Name NextStateName)
	{
		ActiveLedge = None;
	}

Begin:
	EnemyPawn.Acceleration = vect(0,0,0);
	ClearDestination();

	if (EnemyPawn.bUsingWeapon && EnemyPawn.bHasWeaponEquipped && BehaviorState != AIBS_Chasing)
	{
		PlayFullBodyAnim(EnemyPawn.AnimNameUnequipWeapon, 1.0f, 0.1f, 0.1f);
		WaitForFullBodyAnim();
	}

	if(bReversed)
	{
		EnemyPawn.TurnOnSpot(rotator(Ledge.BottomPoint - CurrentDestination));
		WaitForSpecialMove();

		EnemyPawn.SetDesiredRotation(rotator(Ledge.BottomPoint - CurrentDestination), true, , ,false);
		FinishRotation();

		if ( EnemyPawn.ReachedDesiredRotation() )
		{
			CurrentDestination.Z = EnemyPawn.Location.Z;
			EnemyPawn.StartSpecialMove(SMT_DropFromLedge, CurrentDestination, Normal(Ledge.BottomPoint - CurrentDestination), APTT_TargetAtStart);

			CurrentDestination = Ledge.BottomPoint;
		}
	}
	else
	{
		EnemyPawn.TurnOnSpot(rotator(Ledge.TopPoint - CurrentDestination));
		WaitForSpecialMove();

		EnemyPawn.SetDesiredRotation(rotator(Ledge.TopPoint - CurrentDestination), true, , ,false);
		FinishRotation();

		if ( EnemyPawn.ReachedDesiredRotation() )
		{
			CurrentDestination.Z = EnemyPawn.Location.Z;
			EnemyPawn.StartSpecialMove(SMT_ClimbUpLedge, CurrentDestination, Normal(Ledge.TopPoint - CurrentDestination), APTT_TargetAtStart);

			CurrentDestination = Ledge.TopPoint;
		}
	}

	WaitForSpecialMove();

	if (EnemyPawn.bUsingWeapon && !EnemyPawn.bHasWeaponEquipped)
	{
		PlayFullBodyAnim(EnemyPawn.AnimNameEquipWeapon, 1.0f, 0.1f, 0.1f);
		WaitForFullBodyAnim();
	}

	EnemyPawn.LockDesiredRotation(false);

	Completed();
}