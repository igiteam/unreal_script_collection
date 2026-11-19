class HodAI_DoMelee extends CoreTask within HodAI;

// parameter
var HodState_Melee iState;

// local
var State_Melee lState;
var name lStatus;

state main
{
Begin:
	lStatus = 'Failure';
	if (iState != none && !iState.IsPendingKill())
	{
		notify ('hod state change');
		endon ('hod state change');

		lState = new(outer) class'State_Melee';
		hod_state = lState;
		run (hod_state, true);

		if (!hod_state.IsPendingKill())
		{
			waittill ('state melee end');
			lStatus = 'Success';
		}
	}

	if (iState != none && !iState.IsPendingKill())
		iState.Finish(lStatus);
}
