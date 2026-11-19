class trans_BlendIntoStandRun extends CoreTask within animscripts_trans;

// parameter

// output

// local
var float runAnimTransTime;

state main
{
Begin:
	if (animscripts_utility.IsInCombat())
	{
		if (run_combatanim != '')
		{
			PlayBlendTransitionStandRun(SetCustomAnim(combatrun_forward, run_combatanim, animscripts_move.run_combatanim_rate, true));
		}
		else
		{
			// Set the specific forward animation we are using to weight 1 immediately
			// we will make sure it is blended smoothly by blending in its parent, combatrun_forward
			runAnimTransTime = 0.0;
			if (a.movement != 'stop')
				runAnimTransTime = 0.5;
			SetAnimKnobLimited(SetCustomAnim(combatrun_forward, animscripts_run.GetRunAnim(), 1.0, true), 1, runAnimTransTime, 1);
			
			animscripts_run.UpdateRunWeights(
				'BlendIntoStandRun', 
				'combatrun_forward', 
				'stand_run_B', 
				'stand_run_L',
				'stand_run_R',
				true
				);
			PlayBlendTransitionStandRun('combatrun');
		}
	}
	else
	{
		if (run_noncombatanim != '')
		{
			PlayBlendTransitionStandRun(SetCustomAnim(combatrun_forward, run_noncombatanim, animscripts_move.run_noncombatanim_rate, true));
		}
		else
		{
			// Set the specific forward animation we are using to weight 1 immediatley
			// we will make sure it is blended smoothly by blending in its parent, combatrun_forward
			runAnimTransTime = 0.0;
			if (a.movement != 'stop')
				runAnimTransTime = 0.5;
			SetAnimKnobLimited(SetCustomAnim(combatrun_forward, animscripts_run.GetRunAnim(), 1.0, true), 1, runAnimTransTime, 1);
			
			animscripts_run.UpdateRunWeights(
				'BlendIntoStandRun', 
				'combatrun_forward', 
				'stand_run_B', 
				'stand_run_L',
				'stand_run_R',
				true
				);
			PlayBlendTransitionStandRun('combatrun');
		}
	}
	notify ('BlendIntoStandRun');
}
