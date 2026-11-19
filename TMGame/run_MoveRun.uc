class run_MoveRun extends CoreTask within animscripts_run;

// parameter
var bool iFirst;

// output

// local
var name desiredPose;
var name runAnim;
var bool lDecidedAnimation;

var float lEnemyYaw;
var name lSideAnim;
var name lOtherSideAnim;
var float lWeight;

var QuadrantAnimWeight animWeights;
var name forward_anim;

state main
{
Begin:
	desiredPose = animscripts_utility.ChoosePose('stand');

	switch (desiredPose)
	{
	case 'stand':
		if (animscripts_trans.BeginStandRun()) // returns false (and does nothing) if we're already stand-running
			_return();

		//if (changeWeaponStandRun())
		//	_return();
		//
		//if (ReloadStandRun())
		//	_return();

		if (!iFirst && animscripts_utility.IsInCombat())
		{
			//MoveStandCombatOverride();
			if (run_combatanim != '')
			{
				ClearAnim('combatrun', 0.6);
				SetAnimKnobAll('combatrun', 'body', 1, 0.5, moveplaybackrate);
				SetFlaggedAnimKnob('runanim', SetCustomAnim(combatrun_forward, run_combatanim, animscripts_move.run_combatanim_rate, true), 1, 0.5);
				DoNoteTracksNoShootStandCombat('runanim');
			}
			else if (kCombatMood == HCM_Ambush)
			{
				endon('movemode');

				ClearAnim('combatrun', 0.6);

				SetAnimKnobAll('combatrun', 'body', 1, 0.2, moveplaybackrate);

				runAnim = SetCustomAnim(combatrun_forward, GetRunAnim(), 1.0, true);

				// changed it back to 0.3 because it pops when the AI goes from combat to noncombat
				SetFlaggedAnimKnob('runanim', runAnim, 1, 0.3); // was 0.3

				// Play the appropriately weighted animations for the direction he's moving.
				UpdateRunWeightsOnce(
					'combatrun_forward',
					'stand_run_B',
					'stand_run_L',
					'stand_run_R'
					);

				animscripts_shared.DoNoteTracksForTime(0.2, 'runanim');
			}
			//MoveStandCombatNormal();
			else
			{
				ClearAnim('walk_and_run_loops', 0.2);

				SetAnimKnob('combatrun', 1.0, 0.5, moveplaybackrate);

				lDecidedAnimation = false;

				//if (sprint)
				//{
				//	SetFlaggedAnimKnob ('runanim', 'sprint1_loop', 1, 0.5);
				//	lDecidedAnimation = true;
				//}
				//else
				if (animscripts_move.MayShootWhileMoving() && bulletsInClip > 0 && animscripts_utility.isValidEnemy(enemy) && CanSee(enemy))
				{
					runShootWhileMovingThreads();

					if (shootStyle != 'none')
					{
						if (CanShootWhileRunningForward())
						{
							lEnemyYaw = -GetPredictedYawToEnemy(0.2);
							lSideAnim = 'run_n_gun_R';
							lOtherSideAnim = 'run_n_gun_L';
							if (lEnemyYaw < 0)
							{
								lEnemyYaw = -1 * lEnemyYaw;
								lSideAnim = 'run_n_gun_L';
								lOtherSideAnim = 'run_n_gun_R';
							}
							if (lEnemyYaw > 45.0)
							{
								setAnimKnobLimited(lSideAnim, 1, 0.2);
							}
							else
							{
								lWeight = lEnemyYaw / 45.0;
								assert(lWeight >= 0 && lWeight <= 1);
								setAnimLimited('run_n_gun_F', 1.0 - lWeight, 0.2);
								setAnimLimited(lSideAnim, lWeight, 0.2);
								setAnimLimited(lOtherSideAnim, 0, 0.2);
							}

							setFlaggedAnimKnob('runanim', 'run_n_gun', 1, 0.3, 0.8);

							a.allowedPartialReloadOnTheRunTime = gettime() + 500;

							if (isplayer(enemy))
								updatePlayerSightAccuracy();

							lDecidedAnimation = true;
						}
						else if (CanShootWhileRunningBackward())
						{
							// we don't blend the running-backward animation because it
							// doesn't blend well with the run-left and run-right animations.
							// it's also easier to just play one animation than rework everything
							// to consider the possibility of multiple 'backwards' animations

							setFlaggedAnimKnob('runanim', 'run_n_gun_B', 1, 0.3);

							if (isplayer(enemy))
								updatePlayerSightAccuracy();

							DoNoteTracksNoShootStandCombat('runanim');

							stopShootWhileMovingThreads(true);

							notify('stopRunning');
							clearAnim('run_n_gun_B', 0.2);

							_return();
						}
					}
				}
				if (!lDecidedAnimation)
				{
					runAnim = SetCustomAnim(combatrun_forward, GetRunAnim(), 1.0, true);
					SetFlaggedAnimKnob ('runanim', runAnim, 1, 0.5);
				}

				// Play the appropriately weighted run animations for the direction he's moving
				UpdateRunWeightsOnce(
					'combatrun_forward',
					'stand_run_B',
					'stand_run_L',
					'stand_run_R'
					);
				DoNoteTracksNoShootStandCombat('runanim'); // does 0.2 seconds

				StopShootWhileMovingThreads(true);

				notify('stopRunning');
			}
		}
		else
		{
			//MoveStandNoncombatOverride();
			if (run_noncombatanim != '')
			{
				endon('movemode');

				clearanim('combatrun', 0.6);
				setflaggedanimknoball('runanim', SetCustomAnim(combatrun_forward, run_noncombatanim, animscripts_move.run_noncombatanim_rate, true), 'body', 1, 0.3, moveplaybackrate);
				animscripts_shared.DoNoteTracksForTime(0.2, 'runanim');
			}
			//MoveStandNoncombatNormal();
			else
			{
				endon('movemode');

				ClearAnim('combatrun', 0.6);

				SetAnimKnobAll('combatrun', 'body', 1, 0.2, moveplaybackrate);

				runAnim = SetCustomAnim(combatrun_forward, GetRunAnim(), 1.0, true);

				// changed it back to 0.3 because it pops when the AI goes from combat to noncombat
				SetFlaggedAnimKnob('runanim', runAnim, 1, 0.3); // was 0.3

				// Play the appropriately weighted animations for the direction he's moving.
				UpdateRunWeightsOnce(
					'combatrun_forward',
					'stand_run_B',
					'stand_run_L',
					'stand_run_R'
					);

				animscripts_shared.DoNoteTracksForTime(0.2, 'runanim');
			}
		}
		break;

	case 'crouch':
		if (animscripts_trans.BeginCrouchRun()) // returns false (and does nothing) if we're already crouch-running
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
			forward_anim = GetCrouchRunAnim();

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
		if (animscripts_trans.BeginProneRun()) // returns false (and does nothing) if we're already prone-running
			_return();

		//ProneCrawl();
		a.movement = 'run';
		setflaggedanimknob('runanim', 'prone_crawl', 1, 0.3, moveplaybackrate);
		animscripts_shared.DoNoteTracksForTime(0.25, 'runanim');

		break;
	}
}
