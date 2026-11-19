class HodAI_DoCustomAnim extends CoreTask within HodAI;

var HodState_CustomAnim iState;

var State_CustomAnim lState;
var name lStatus;

state main
{
Begin:
	lStatus = 'Failure';
	if (iState != none && !iState.IsPendingKill())
	{
		notify ('hod state change');
		endon ('hod state change');

		lState = new(self) class'State_CustomAnim';
		lState.note = name("state custom anim end " $ GetUniqueID());
		hod_state = lState;
		run (hod_state, true);

		if (!hod_state.IsPendingKill())
		{
			waittill (lState.note);
			lStatus = 'Success';
		}
	}

	if (iState != none && !iState.IsPendingKill())
		iState.Finish(lStatus);
}
