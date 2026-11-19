class OLAICmd_MoveAbility extends GameAICommand
	within OLBot
	dependson(OLWaitPointComponent)
	abstract
	native(AI);

var vector CurrentDestination;
var bool bReversed;

var OLWaitPointComponent WaitPointComponent;
var WaitPoint CurrentWaitPoint;

// Temp Variables
var transient OLBot ClosestBot;
var transient OLBot ActiveBot;
var transient OLAICmd_MoveAbility TempMoveAbility;

var transient array<vector> TempPath;

var transient bool bAtWaitPoint;

function Pushed()
{
	Super.Pushed();
	GotoState('Approaching');

	RegisterWithObject();
}

function Popped()
{
	Super.Popped();

	if (!IsZero(CurrentWaitPoint.Point))
	{
		ReturnWaitPoint(CurrentWaitPoint);
		CurrentWaitPoint.Point = vect(0.f,0.f,0.f);
		bAtWaitPoint = false;
	}

	UnregisterWithObject();

	ClosestBot = GetClosestToObject();

	if (ClosestBot != None)
	{
		TempMoveAbility = ClosestBot.FindCommandOfClass(class'OLAICmd_MoveAbility');
		if (TempMoveAbility.IsInState('Waiting'))
		{
			TempMoveAbility.ContinueFromWaiting();
		}

		SetActiveOnObject(ClosestBot);
	}

	EnemyPawn.LockDesiredRotation(false);
	EnemyPawn.ResetDesiredRotation();
}

function Completed()
{
	`AILog("MoveAbility Completed", 'AIState');

	OLNavHandle.PopMoveLocation();

	EnemyPawn.LockDesiredRotation(false);
	EnemyPawn.ResetDesiredRotation();
	
	PopCommand(self);
}

// Returns whether we should skip the approach
function bool ModifyApproach(out vector NewDestination)
{
	return false;
}

native function ModifyPath(vector NewDestination, out array<vector> NewPath);

function WaitPoint GrabBestWaitPoint()
{
	local WaitPoint Point;
	if (WaitPointComponent != None)
	{
		Point = WaitPointComponent.GrabBestWaitPoint(bReversed);
	}

	if (Point.Point == vect(0.f,0.f,0.f))
	{
		Point.Point = CurrentDestination;
	}
	return Point;
}

function ReturnWaitPoint(WaitPoint Point)
{
	WaitPointComponent.ReturnWaitPoint(Point);
}

function vector GetWaitPointForwardDirection(WaitPoint Point)
{
	return WaitPointComponent.GetWaitPointForwardVector(Point);
}

function array<OLBot> GetBotsOnObject()
{
	local array<OLBot> Bots;

	Bots.AddItem(OLBot(GameAIOwner));

	return Bots;
}

function int GetWaitIndex()
{
	local OLBot Bot;
	local array<OLBot> Bots;
	local bool bForReversed, bSideSet;
	local OLAICmd_MoveAbility MoveCmd;
	local int i, WaitIndex;

	if (!IsInState('Waiting') || !IsObjectInUse())
	{
		return 0;
	}
	
	Bots = GetBotsOnObject();

	bSideSet = false;

	foreach Bots(Bot)
	{
		MoveCmd = Bot.FindCommandOfClass(class'OLAICmd_MoveAbility');

		if (MoveCmd.IsInState('Waiting'))
		{
			if (!bSideSet)
			{ 
				bForReversed = MoveCmd.CurrentWaitPoint.bForReversed;

				bSideSet = true;
			}
			else if (bForReversed != MoveCmd.CurrentWaitPoint.bForReversed)
			{
				return 0;
			}

			WaitIndex = 1;
			for(i = 0; i < WaitPointComponent.WaitPoints.length; ++i)
			{
				if (WaitPointComponent.WaitPoints[i].Offset == MoveCmd.CurrentWaitPoint.Offset)
				{
					return WaitIndex;
				}
				else if (WaitPointComponent.WaitPoints[i].bForReversed == bForReversed)
				{
					WaitIndex++;
				}
			}
		}
	}
}

function MoveToWaiting()
{
	StopLatentExecution();

	GotoState('Waiting', , true);
}

function ContinueFromWaiting()
{
	StopLatentExecution();

	GotoState('Approaching');
}

function bool IsObjectInUse()
{
	return false;
}

function RegisterWithObject();
function UnregisterWithObject();

function OLBot GetClosestToObject()
{
	return OLBot(GameAIOwner);
}

function OLBot GetActiveOnObject()
{
	return None;
}

function SetActiveOnObject(OLBot NewActiveBot);

function bool AtPoint(vector Point)
{
	return VSizeSq2D(Point - EnemyPawn.Location) < 100.0f;
}

state Approaching
{
Begin:
	`AILog("Approaching", 'AIState');

	if (IsObjectInUse())
	{
		ClosestBot = GetClosestToObject();
		if (ClosestBot == GameAIOwner)
		{
			ActiveBot = GetActiveOnObject();
			if (ActiveBot != None && ActiveBot != GameAIOwner)
			{
				TempMoveAbility = ActiveBot.FindCommandOfClass(class'OLAICmd_MoveAbility');

				if (TempMoveAbility.IsInState('Performing'))
				{
					MoveToWaiting();
				}
				else
				{
					TempMoveAbility.MoveToWaiting();
					SetActiveOnObject(OLBot(GameAIOwner));
				}
			}
		}
		else
		{
			MoveToWaiting();
		}
	}
	else
	{
		SetActiveOnObject(OLBot(GameAIOwner));
	}

	if (ModifyApproach(CurrentDestination))
	{
		`AILog("Skipping Approach", 'Movement');

		GotoState('Performing');
	}
		
	if (MoveTempPath.length > 0)
	{
		TempPath = MoveTempPath;
		MoveTempPath.length = 0;
		TempPath[TempPath.length - 1] = CurrentDestination;

		MoveAlongPath(TempPath);
	}
	else
	{
		ModifyPath(CurrentDestination, TempPath);
		MoveAlongPath(TempPath);
	}

	if (Pawn.ReachedPoint(CurrentDestination, None))
	{
		GotoState('Performing');
	}

	EnemyPawn.LockDesiredRotation(false);
	EnemyPawn.ResetDesiredRotation();
	RegeneratePath();
	PopCommand(self);
}

state Waiting
{
	function BeginState(Name PreviousStateName)
	{
		CurrentWaitPoint = GrabBestWaitPoint();

		EnemyPawn.ZeroMovementVariables();
	}

	function EndState(Name NextStateName)
	{
		ReturnWaitPoint(CurrentWaitPoint);

		EnemyPawn.ResetDesiredRotation();

		CurrentWaitPoint.Point = vect(0.f,0.f,0.f);

		bAtWaitPoint = false;
	}

Begin:
	while(!AtPoint(CurrentWaitPoint.Point))
	{
		if (MoveTempPath.length > 0)
		{
			TempPath = MoveTempPath;
			MoveTempPath.length = 0;
			TempPath[TempPath.length - 1] = CurrentWaitPoint.Point;

			MoveAlongPath(TempPath);
		}
		else
		{
			ModifyPath(CurrentWaitPoint.Point, TempPath);

			MoveAlongPath(TempPath);
		}

		if (!AtPoint(CurrentWaitPoint.Point))
		{
			Sleep(0.1f);
		}
	}

	while(true)
	{
		if (!AtPoint(CurrentWaitPoint.Point))
		{
			MoveTo(CurrentWaitPoint.Point);
		}

		EnemyPawn.ZeroMovementVariables();

		EnemyPawn.TurnOnSpot(rotator(GetWaitPointForwardDirection(CurrentWaitPoint)));
		WaitForSpecialMove();

		EnemyPawn.SetDesiredRotation(rotator(GetWaitPointForwardDirection(CurrentWaitPoint)));
		FinishRotation();

		bAtWaitPoint = true;

		Sleep(0.1f);
	}
}

state Performing
{
Begin:
	PopCommand(self);
}