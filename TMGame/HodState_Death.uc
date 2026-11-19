class HodState_Death extends HodState;

var HodAI hod;

static function bool Start(HodAI iHod)
{
	local HodState_Death lState;
	local TGAI AI;

	AI = iHod.pawn.MyTGAI;
	if (AI != None)
	{
		lState = new(AI) class'HodState_Death';
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
	hod.DoDeath(self);
}

function Finish()
{
	hod.notify('death');
	MyTGPawn.Died(MyTGPawn.DeathKiller, MyTGPawn.DeathDamageType, MyTGPawn.DeathHitLocation);
	Status = 'Success';
	PopCommand(self);
}

function Resumed( Name OldCommandName )
{
	Super.Resumed( OldCommandName );
	assert(false);

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
