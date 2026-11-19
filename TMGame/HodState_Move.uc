class HodState_Move extends HodState;

var HodAI hod;

static function bool Start(HodAI iHod)
{
	local HodState_Move lState;
	local TGAI AI;

	AI = iHod.pawn.MyTGAI;
	if (AI != None)
	{
		lState = new(AI) class'HodState_Move';
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
	//hod.DoMove(self);
}

function Popped()
{
	Super.Popped();
	hod.MoveToEnemy = false;
	hod.requestArrivalNotify = false;

	if (Status == 'Success')
	{
		hod.PendingState = 'cover';
	}
	else if (Status == 'Aborted')
	{
	}
	else
	{
		assert(false);
	}
}

function Finish()
{
	//Status = 'Success';
	//PopCommand(self);
}

function Resumed( Name OldCommandName )
{
	Super.Resumed( OldCommandName );

	if( ChildStatus == 'Success' )
	{
		Status = 'Success';
		PopCommand(self);
	}
	else
	{
		Status = 'Failure';
		AbortCommand( self );
	}
}
