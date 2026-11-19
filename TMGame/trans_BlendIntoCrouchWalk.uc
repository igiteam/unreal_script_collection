class trans_BlendIntoCrouchWalk extends CoreTask within animscripts_trans;

var name lwalk_and_run_loops_slot;

state main
{
Begin:
	if (isDefined(crouchrun_combatanim))
	{
		lwalk_and_run_loops_slot = SetCustomAnim(walk_and_run_loops, crouchrun_combatanim, animscripts_move.crouchrun_combatanim_rate, true);
		setanimknoball(lwalk_and_run_loops_slot, 'body', 1, 0.4);
		PlayBlendTransition(lwalk_and_run_loops_slot, 0.6, 'crouch', 'walk', false);
		notify ('BlendIntoCrouchWalk');
	}
	else
	{
		PlayBlendTransition('crouch_walk_F', 0.8, 'crouch', 'walk', true);
	}
}
