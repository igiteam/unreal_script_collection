class HodAI_DoExposed extends CoreTask within HodAI;

// parameter
var HodState_Exposed iState;

// output

// local
var name lStatus;
var float lCurrentTime;

state main
{
Begin:
	lStatus = 'Failure';
	if (iState != none && !iState.IsPendingKill())
	{
		notify ('hod state change');
		endon ('hod state change');
		lCurrentTime = float(GetTime()) / 1000.0;
		if (!toggle_combat && (enemy == none) && (lCurrentTime - in_combat_time >= 10))
		{
			if (hod_state == none || hod_state.IsPendingKill() || !hod_state.isA('State_Stop'))
			{
				hod_state = new(outer) class'State_Stop';
				run (hod_state, true);
			}

			if (!hod_state.IsPendingKill())
			{
				waittill ('state stop end');
				lStatus = 'Success';
			}

		}
		else
		{
			if (hod_state == none || hod_state.IsPendingKill() || !hod_state.isA('State_Combat'))
			{
				hod_state = new(outer) class'State_Combat';
				run (hod_state, true);
			}

			if (!hod_state.IsPendingKill())
			{
				waittill ('state combat end');
				lStatus = 'Success';
			}
		}
	}

	if (iState != none && !iState.IsPendingKill())
		iState.Finish(lStatus);
}
