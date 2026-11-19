class OLAICmd_MoveAbility_Vault extends OLAICmd_MoveAbility 
	within OLBot
	native(AI);

var OLAIVaultMarker VaultMarker;

var vector NextPoint;

static event OLAICmd_MoveAbility_Vault MoveThruLedge( OLBot Bot, OLAIVaultMarker InMarker, vector InitialDestination, bool bInReversed )
{
	local OLAICmd_MoveAbility_Vault Cmd;

	if ( Bot != None )
	{
		Cmd = new(Bot) default.class;
		if ( Cmd != None )
		{
			Cmd.VaultMarker = InMarker;
			Cmd.CurrentDestination = InitialDestination;
			Cmd.bReversed = bInReversed;
			Cmd.WaitPointComponent = InMarker.WaitPointComponent;

			return Cmd;
		}
	}

	return None;
}

function bool IsObjectInUse()
{
	return VaultMarker.Bots.length > 1; // We are in this list so we want to know if there are others.
}

function RegisterWithObject()
{
	local bool bFound;
	local int Idx;

	bFound = false;
	for (Idx = 0; Idx < VaultMarker.Bots.length; ++Idx)
	{
		if (VaultMarker.Bots[Idx] == OLBot(GameAIOwner))
		{
			bFound = true;
		}
	}

	if (!bFound)
	{
		VaultMarker.Bots.AddItem(OLBot(GameAIOwner));
	}
}

function UnregisterWithObject()
{
	VaultMarker.Bots.RemoveItem(OLBot(GameAIOwner));

	if (VaultMarker.ActiveBot == OLBot(GameAIOwner))
	{
		VaultMarker.ActiveBot = None;
	}
}

function OLBot GetClosestToObject()
{
	local int Idx;
	local OLBot TempClosestBot;

	for (Idx = 0; Idx < VaultMarker.Bots.length; ++Idx)
	{
		if (TempClosestBot == None)
		{
			TempClosestBot = VaultMarker.Bots[Idx];
		}
		else
		{
			if (VSizeSq(TempClosestBot.EnemyPawn.Location - VaultMarker.Location)
					> VSizeSq(VaultMarker.Bots[Idx].EnemyPawn.Location - VaultMarker.Location))
			{
				TempClosestBot = VaultMarker.Bots[Idx];
			}
		}
	}

	return TempClosestBot;
}

function OLBot GetActiveOnObject()
{
	return VaultMarker.ActiveBot;
}

function SetActiveOnObject(OLBot NewActiveBot)
{
	VaultMarker.ActiveBot = NewActiveBot;
}

function array<OLBot> GetBotsOnObject()
{
	return VaultMarker.Bots;
}

state Performing
{
	function BeginState(Name PreviousStateName)
	{
		ActiveVault = VaultMarker;
	}

	function EndState(Name NextStateName)
	{
		ActiveVault = None;
	}

Begin:
	EnemyPawn.Acceleration = vect(0,0,0);
	ClearDestination();

	if (bReversed)
	{
		NextPoint = VaultMarker.EndPointOne;
	}
	else
	{
		NextPoint = VaultMarker.EndPointTwo;
	}

	EnemyPawn.TurnOnSpot(rotator(NextPoint - CurrentDestination));
	WaitForSpecialMove();

	EnemyPawn.SetDesiredRotation(rotator(NextPoint - CurrentDestination), true, , ,false);
	FinishRotation();

	if ( EnemyPawn.ReachedDesiredRotation() )
	{
		CurrentDestination.Z = (VaultMarker.Location.Z - 90.0);
		EnemyPawn.StartSpecialMove(SMT_AIVault, CurrentDestination, Normal(NextPoint - CurrentDestination), APTT_TargetAtStart);
		WaitForSpecialMove();

		CurrentDestination = NextPoint;
	}

	EnemyPawn.LockDesiredRotation(false);

	Completed();
}