class HodState_Cover extends HodState;

var HodAI hod;

static function bool Start(HodAI iHod)
{
	local HodState_Cover lState;
	local TGAI AI;

	AI = iHod.pawn.MyTGAI;
	if (AI != None)
	{
		lState = new(AI) class'HodState_Cover';
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
	hod.DoCover(self);
	GotoState('cover_state');
}

function Popped()
{
	Super.Popped();
	//hod.prevNode.set(hod.node.data);
	//if (pawn.anchor == hod.node.data)
	//hod.node.set(none);
	InvalidateCover();
	//Pawn.SetAnchor(None); // so we don't try to recurse into SpecialMoveTo()
}

function Finish(optional name iState = 'Success')
{
	Status = iState;
	PopCommand(self);
}

function Resumed( Name OldCommandName )
{
	Super.Resumed( OldCommandName );

	if( ChildStatus == 'Success' )
	{
		GotoState('cover_state');
	}
	else
	{
		Status = 'Failure';
		PopCommand( self );
	}
}


state cover_state
{
Begin:
	Sleep(2.0);
	CheckMoveTransition();
	goto('Begin');
}
