class HodAI_DoCover extends CoreTask within HodAI;

// parameter
var HodState_Cover iState;

// output

// local
var HodNode lNode;
var name lStatus;

state main
{
Begin:
	lStatus = 'Failure';
	if (iState != none && !iState.IsPendingKill())
	{
		notify ('hod state change');
		endon ('hod state change');
		//assert (node_isdefined(node));
		lNode = animscripts_utility.GetClaimedNode();
		if (!node_isdefined(lNode))
			goto_state('exposed');
		else
		{
			switch (lNode.type)
			{
				//case 'Cover Prone':
				//	if (!CanSee(enemy) ||
				//		(AbsAngleClamp180(vectortoangles(enemy.origin - origin).yaw - lNode.angles.yaw) < 45 &&
				//		distance(enemy.origin, origin) > 800*FInch))
				//	{
				//		animscripts_cover_prone.main();
				//	}
				//	break;

			case 'Cover Stand':
				if (hod_state == none || hod_state.IsPendingKill() || !hod_state.isA('State_CoverStand'))
				{
					hod_state = new(outer) class'State_CoverStand';
					run (hod_state, true);
				}

				if (!hod_state.IsPendingKill())
				{
					waittill ('state cover stand end');
					lStatus = 'Success';
				}

				break;

			case 'Cover Crouch':
				if (hod_state == none || hod_state.IsPendingKill() || !hod_state.isA('State_CoverCrouch'))
				{
					hod_state = new(outer) class'State_CoverCrouch';
					run (hod_state, true);
				}

				if (!hod_state.IsPendingKill())
				{
					waittill ('state cover crouch end');
					lStatus = 'Success';
				}
				break;

			case 'Cover Left':
				if (hod_state == none || hod_state.IsPendingKill() || !hod_state.isA('State_CoverLeft'))
				{
					hod_state = new(outer) class'State_CoverLeft';
					run (hod_state, true);
				}

				if (!hod_state.IsPendingKill())
				{
					waittill ('state cover left end');
					lStatus = 'Success';
				}
				break;

			case 'Cover Right':
				if (hod_state == none || hod_state.IsPendingKill() || !hod_state.isA('State_CoverRight'))
				{
					hod_state = new(outer) class'State_CoverRight';
					run (hod_state, true);
				}

				if (!hod_state.IsPendingKill())
				{
					waittill ('state cover right end');
					lStatus = 'Success';
				}
				break;

			default:
				goto_state('exposed');
			}
		}

	}

	if (iState != none && !iState.IsPendingKill())
		iState.Finish(lStatus);
}
