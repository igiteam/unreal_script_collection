class move_main extends CoreTask within animscripts_move;

// local
var float rate;
var name newPose;
var float loopTime;
var float prevLoopTime;
var name mode;
var bool lFirst;

state main
{
Begin:
	//prof_begin( "move_init" );
	endon('killanimscript');


	//[[ self.exception[ 'move' ] ]]();

	trackScriptState('Move Main', "code" );

	if (a.pose == 'prone')
	{
		newPose = animscripts_utility.ChoosePose('stand');

		if (newPose != 'prone')
		{
			AnimMode('zonly_physics', false);
			rate = 1;
			if (grenade)
				rate = 2;
			animscripts_cover_prone.ProneTo(newPose, rate);
			AnimMode('none', false );
			OrientMode('face default');
		}
	}

	//previousScript = a.script;	// Grab the previous script before initialize updates it.  Used for "cover me" dialogue.
	animscripts_utility.initialize('move');
	//if (self.moveMode == "run")
	//{
	//	// Say something
	//	switch (previousScript)
	//	{
	//	case "combat": // handle most common cases first
	//	case "stop":
	//		// Say random poop.
	//		self animscripts\battleChatter_ai::evaluateMoveEvent (false);
	//		break;

	//	case "cover_crouch":
	//	case "cover_left":
	//	case "cover_prone":
	//	case "cover_right":
	//	case "cover_stand":
	//	case "concealment_crouch":
	//	case "concealment_prone":
	//	case "concealment_stand":
	//	case "cover_wide_left":
	//	case "cover_wide_right":
	//	case "stalingrad_cover_crouch":
	//	case "hide":
	//	case "turret":
	//		// Leaving cover.  Say something like "cover me".
	//		self animscripts\battleChatter_ai::evaluateMoveEvent (true);
	//		break;

	//	default:
	//		// Say random poop.
	//		self animscripts\battleChatter_ai::evaluateMoveEvent (false);
	//		break;
	//	}
	//}
	//self animscripts\battlechatter::playBattleChatter();

	animscripts_combat_utility.attackEnemyWhenFlashed(true);

	//prof_end( "move_init" );

	// approach/exit stuff
	animscripts_cover_arrival.startMoveTransition();
	animscripts_cover_arrival.setupApproachNode(true, true);

	cqb_track_thread = false;
	shoot_while_moving_thread = false;

	// need fixed
	AnimMode('normal');
	OrientMode('face default');
	lFirst = true;

	//MoveMainLoop();
MovMainLoop:
	prevLoopTime = GetAnimTime('walk_and_run_loops');
	a.runLoopCount = randomint( 10000 ); // integer that is incremented each time we complete a run loop

	// need fix
	if (moveMode != 'walk')
		moveMode = 'run';

	// if initial destination is closer than 64 walk to it.
	mode = moveMode;
	if (pathGoalPos != invalid_vector && distanceSquared( origin, pathGoalPos ) < 4096*FInchSq)
		mode = 'walk';
	
	while (true)
	{
		//prof_begin("MoveMainLoop");
		loopTime = GetAnimTime('walk_and_run_loops');
		if ( loopTime < prevLoopTime )
			a.runLoopCount++;
		prevLoopTime = loopTime;
		
		//self animscripts\face::SetIdleFaceDelayed( anim.alertface );
		
		//if ( self animscripts\cqb::shouldCQB() )
		//{
		//	self animscripts\cqb::MoveCQB();
		//}
		//else
		//{
			if ( moveMode != 'run' )
			{
				mode = moveMode;
			}
			// if walking, check that the destination is close by, and if not, switch to actual self.moveMode
			else if ( mode == 'walk' )
			{
				if (pathGoalPos == invalid_vector || distanceSquared(origin, pathGoalPos ) > 4096*FInchSq )
					mode = moveMode;
			}
		
			if ( mode == 'run' )
			{
				animscripts_run.MoveRun(lFirst);
			}
			else
			{
				assert( mode == 'walk' );
				animscripts_walk.MoveWalk();
			}
		//}
		lFirst = false;
		exitingCover = false;
		//prof_end("MoveMainLoop");
	}
}
