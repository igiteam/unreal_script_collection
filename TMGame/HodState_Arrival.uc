class HodState_Arrival extends HodState;

var HodAI hod;

static function bool Start(HodAI iHod)
{
	local HodState_Arrival lState;
	local TGAI AI;

	AI = iHod.pawn.MyTGAI;
	if (AI != None)
	{
		lState = new(AI) class'HodState_Arrival';
		if( lState != None )
		{
			lState.hod = iHod;

			AI.PushCommand(lState);
			return TRUE;
		}
	}

	return FALSE;
}

function Pushed()
{
	pawn.ZeroMovementVariables();
	Super.Pushed();
	hod.DoArrival(self);
}

function Resumed( Name OldCommandName )
{
	Super.Resumed( OldCommandName );

	Status = ChildStatus;
	PopCommand(self);
}

function Finish(optional name iState = 'Success')
{
	Status = iState;
	PopCommand(self);
}
