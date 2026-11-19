class HodCmd_RunToPos extends AICommand within TGAI;

var HodAI hod;
var vector point;

static function bool RunToPos(HodAI iHod, vector iPoint)
{
	local HodCmd_RunToPos Cmd;
	local TGAI AI;

	AI = iHod.pawn.MyTGAI;
	if (AI != None)
	{
		Cmd = new(AI) class'HodCmd_RunToPos';
		if( Cmd != None )
		{
			Cmd.hod = iHod;
			Cmd.point = iPoint;

			AI.PushCommand( Cmd );
			return TRUE;
		}
	}

	return FALSE;
}

function Pushed()
{
	Super.Pushed();

	GotoState('MovingToGoal');
}

function Resumed( Name OldCommandName )
{
	Super.Resumed( OldCommandName );

	if( ChildStatus == 'Success' )
	{
		hod.notify('runto_arrived');
		Status = 'FinalMove';
		PopCommand(self);
	}
	else
	{
		Status = 'FinalMove';
		PopCommand( self );
	}
}

state MovingToGoal
{
Begin:
	SetMovePoint(point + vect(0, 0, 32), , false, , , , , true);
}
