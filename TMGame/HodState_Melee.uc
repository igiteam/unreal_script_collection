class HodState_Melee extends HodState;

var HodAI hod;

static function bool Start(HodAI iHod)
{
	local HodState_Melee lState;
	local TGAI AI;

	AI = iHod.pawn.MyTGAI;
	if (AI != None)
	{
		lState = new(AI) class'HodState_Melee';
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
	hod.DoMelee(self);
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
