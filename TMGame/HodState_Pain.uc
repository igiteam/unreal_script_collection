class HodState_Pain extends HodState;

var HodAI hod;
var bool Finished;

static function bool Start(HodAI iHod)
{
	local HodState_Pain lState;
	local TGAI AI;

	AI = iHod.pawn.MyTGAI;
	if (AI != None)
	{
		lState = new(AI) class'HodState_Pain';
		if( lState != None )
		{
			lState.hod = iHod;

			AI.PushCommand( lState );
			return TRUE;
		}
	}

	return FALSE;
}

function Pushed()
{
	Super.Pushed();
	hod.DoPain(self);
}

function Finish(optional name iState = 'Success')
{
	CheckMoveTransition();
	Status = iState;
	PopCommand(self);
}

function Resumed( Name OldCommandName )
{
	Super.Resumed( OldCommandName );

	Status = ChildStatus;
	PopCommand(self);
}

state state_finish
{
Begin:
	Status = 'Success';
	PopCommand(self);
}
