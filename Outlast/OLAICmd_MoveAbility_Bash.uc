class OLAICmd_MoveAbility_Bash extends OLAICmd_MoveAbility 
	within OLBot
	native(AI);

var OLBashableObject Bashable;
var vector LastDestination;

static event OLAICmd_MoveAbility_Bash MoveThruBashable( OLBot Bot, OLBashableObject InBashable, vector InitialDestination, bool bInReversed )
{
	local OLAICmd_MoveAbility_Bash Cmd;

	if ( Bot != None )
	{
		Cmd = new(Bot) default.class;
		if ( Cmd != None )
		{
			Cmd.Bashable = InBashable;
			Cmd.CurrentDestination = InitialDestination;
			Cmd.bReversed = bInReversed;

			return Cmd;
		}
	}

	return None;
}

state Performing
{
	function BeginState(Name PreviousStateName)
	{
		ActiveBashable = Bashable;
	}

	function EndState(Name NextStateName)
	{
		ActiveBashable = None;
	}

Begin:
	if(Bashable.bBroken)
	{
		CurrentDestination = bReversed ? Bashable.Edge1Dest : Bashable.Edge0Dest;

		MoveTo( CurrentDestination, None, -20.0f );
	}
	else
	{
		ClearDestination();

		LastDestination = CurrentDestination;
		CurrentDestination = bReversed ? Bashable.Edge1Dest : Bashable.Edge0Dest;

		EnemyPawn.TurnOnSpot(rotator(CurrentDestination - LastDestination));
		WaitForSpecialMove();

		EnemyPawn.SetDesiredRotation(rotator(CurrentDestination - LastDestination), true, , ,false);
		FinishRotation();

		LastDestination.Z = EnemyPawn.Location.Z;

		EnemyPawn.StartSpecialMove(SMT_Bash, LastDestination, Normal(CurrentDestination - LastDestination), APTT_TargetAtStart);

		//CurrentBashable.SetCollisionType(COLLIDE_NoCollision);
		Bashable.TriggerBreakTimer(EnemyPawn.WallBashTime);

		WaitForSpecialMove();

		EnemyPawn.LockDesiredRotation(false);
	}

	Completed();
}