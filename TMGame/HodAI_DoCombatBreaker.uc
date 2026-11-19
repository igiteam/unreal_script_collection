class HodAI_DoCombatBreaker extends CoreTask within HodAI;

// parameter
var HodState_CombatBreaker iState;
var name lStatus;

state main
{
Begin:
	lStatus = 'Failure';
	if (iState != none && !iState.IsPendingKill())
	{
		notify ('hod state change');
		endon ('hod state change');

		if (hod_state == none || hod_state.IsPendingKill() || !hod_state.isA('State_CombatBreaker'))
		{
			hod_state = new(outer) class'State_CombatBreaker';
			run (hod_state, true);
		}

		if (!hod_state.IsPendingKill())
		{
			waittill ('state combat breaker end');
			lStatus = 'Success';
		}
	}

	if (iState != none && !iState.IsPendingKill())
		iState.Finish(lStatus);
}
