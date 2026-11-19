class HodState_Exposed extends HodState;

var HodAI hod;

static function bool Start(HodAI iHod)
{
	local HodState_Exposed lState;
	local TGAI AI;

	AI = iHod.pawn.MyTGAI;
	if (AI != None)
	{
		lState = new(AI) class'HodState_Exposed';
		if (lState != None)
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
	Super.Pushed();
	hod.DoExposed(self);
	GotoState('exposed_state');
}

function Popped()
{
	Super.Popped();
	hod.prevNode.set(hod.node.data);
	//hod.node.set(none);
}

function Finish(optional name iState = 'Success')
{
	Status = iState;
	PopCommand(self);
}

function Resumed(Name OldCommandName)
{
	Super.Resumed(OldCommandName);

	if (ChildStatus == 'Success')
	{
		GotoState('resume_state');
	}
	else
	{
		Status = 'Failure';
		AbortCommand(self);
	}
}

state resume_state
{
Begin:
	Sleep(0);
	Sleep(0);
	GotoState('exposed_state');
}

state exposed_state
{
Begin:
	Sleep(2.0);
	CheckMoveTransition();
	goto('Begin');
}
