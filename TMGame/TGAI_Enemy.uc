class TGAI_Enemy extends TGAI_Cover;

var name PendingState;

state Action_Idle
{
Begin:
	if (MyTGPawn.hod.PendingState != '')
	{
		PendingState = MyTGPawn.hod.PendingState;
		MyTGPawn.hod.PendingState = '';
		MyTGPawn.hod.goto_state(PendingState);
	}
	else
		MyTGPawn.hod.goto_state('Cover');
		//Sleep(0.05);
	goto('Begin');
}

