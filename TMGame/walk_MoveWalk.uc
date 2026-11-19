class walk_MoveWalk extends CoreTask within animscripts_walk;

// local
var name lDesiredPose;
var QuadrantAnimWeight animWeights;
var name forward_anim;
var name lAnim;
var float lRate;


state main
{
Begin:
	// Decide what pose to use
	lDesiredPose = animscripts_utility.choosePose();

	switch (lDesiredPose)
	{
	case 'stand':
		if (animscripts_trans.BeginStandWalk())
			_return();

		GetStandWalkAnim(lAnim, lRate);
		DoWalkAnim(SetCustomAnim(combatrun_forward, lAnim, lRate, true));
		break;

	case 'crouch':
		if (animscripts_trans.BeginCrouchWalk()) // returns false (and does nothing) if we're already crouch-running
			_return();

		//MoveCrouchRunOverride();
		if (isDefined(crouchrun_combatanim))
		{
			endon('movemode');

			setflaggedanimknoball('runanim', SetCustomAnim(walk_and_run_loops, crouchrun_combatanim, animscripts_move.crouchrun_combatanim_rate, true), 'body', 1, 0.4, moveplaybackrate);
			animscripts_shared.DoNoteTracksForTime(0.2, 'runanim');
		}
		//MoveCrouchRunNormal();
		else
		{
			endon('movemode');

			// Play the appropriately weighted crouchrun animations for the direction he's moving
			forward_anim = animscripts_run.GetCrouchRunAnim();

			setanimknob(forward_anim, 1, 0.4);

			animWeights = animscripts_utility.QuadrantAnimWeights(getMotionAngle());
			setanim(forward_anim      , animWeights.front, 0.2, 1);
			setanim('crouch_walk_B', animWeights.back, 0.2, 1);
			setanim('crouch_walk_L', animWeights.left, 0.2, 1);
			setanim('crouch_walk_R', animWeights.right, 0.2, 1);

			setflaggedanimknoball('runanim', 'crouchrun', 'body', 1, 0.2, moveplaybackrate);

			animscripts_shared.DoNoteTracksForTime(0.2, 'runanim');
		}
		break;

	default:
//		assert(desiredPose == 'prone');
		if (animscripts_trans.BeginProneWalk()) // returns false (and does nothing) if we're already prone-running
			_return();

		//ProneCrawl();
		a.movement = 'run';
		setflaggedanimknob('runanim', 'prone_crawl', 1, 0.3, moveplaybackrate);
		animscripts_shared.DoNoteTracksForTime(0.25, 'runanim');

		break;
	}
}
