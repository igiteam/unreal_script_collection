class HodState_CombatBreaker extends HodState;

var HodAI hod;

static function bool Start(HodAI iHod)
{
	local HodState_CombatBreaker lState;
	local TGAI AI;

	AI = iHod.pawn.MyTGAI;
	if (AI != None)
	{
		lState = new(AI) class'HodState_CombatBreaker';
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
	Super.Pushed();
	hod.DoCombatBreaker(self);
}

function Finish(optional name iState = 'Success')
{
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
