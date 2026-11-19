class trans_BlendIntoCrouchRun extends CoreTask within animscripts_trans;

var name lwalk_and_run_loops_slot;
state main
{
Begin:
	if (isDefined(crouchrun_combatanim))
	{
		lwalk_and_run_loops_slot = SetCustomAnim(walk_and_run_loops, crouchrun_combatanim, animscripts_move.crouchrun_combatanim_rate, true);
		setanimknoball(lwalk_and_run_loops_slot, 'body', 1, 0.4);
		PlayBlendTransition(lwalk_and_run_loops_slot, 0.6, 'crouch', 'run', false);
		notify ('BlendIntoCrouchRun');
	}
	else
	{
		setanimknob(animscripts_run.GetCrouchRunAnim(), 1, 0.4);
		animscripts_run.UpdateRunWeights
			( 'BlendIntoCrouchRun'
			, 'crouch_walk_F'
			, 'crouch_walk_B'
			, 'crouch_walk_L'
			, 'crouch_walk_R'
			, true
			);
		PlayBlendTransition('crouchrun', 0.6, 'crouch', 'run', false);
		notify ('BlendIntoCrouchRun');
	}
}
