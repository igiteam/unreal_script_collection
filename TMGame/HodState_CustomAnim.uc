class HodState_CustomAnim extends HodState;

var HodAI hod;
var SeqAct_GearPlayerAnim action;

static function bool Start(HodAI iHod, SeqAct_GearPlayerAnim iAction)
{
	local HodState_CustomAnim lState;
	local TGAI AI;

	if (iAction.AnimName == '')
		return FALSE;

	AI = iHod.pawn.MyTGAI;
	if (AI != None)
	{
		lState = new(AI) class'HodState_CustomAnim';
		if( lState != None )
		{
			lState.hod = iHod;
			lState.action = iAction;

			AI.AbortCommand(AI.CommandList);
			AI.PushCommand(lState);
			return TRUE;
		}
	}

	return FALSE;
}

function Pushed()
{
	Super.Pushed();
	hod.DoCustomAnim(self);
}

function Popped()
{
	Super.Popped();
	MyTGPawn.WeaponChangeHand(false);
	MyTGPawn.DetachAllItem();
	action.bFinished = TRUE;
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

state state_finish
{
Begin:
	Status = 'Success';
	PopCommand(self);
}

