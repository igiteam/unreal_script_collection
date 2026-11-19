class stop_main extends CoreTask within animscripts_stop;

// parameter

// output

// local
var bool transitionedToIdle;
var name desiredPose;

state main
{
Begin:
	notify('stopScript');
	endon('killanimscript');

//	[[ self.exception[ 'stop_immediate' ] ]]();
//	// We do the exception_stop script a little late so that the AI has some animation they're playing
//	// otherwise they'd go into basepose.
//	thread delayedException();

	trackScriptState('Stop Main', "code");
	animscripts_utility.initialize('stop');
	
	animscripts_utility.randomizeIdleSet();
	
	setLastStoppedTime(true);
	
	transitionedToIdle = gettime() < 3000;
	if (!transitionedToIdle)
	{
//		if (self.a.weaponPos['right'] == 'none' && self.a.weaponPos['left'] == 'none')
//			transitionedToIdle = true;
//		else if (AngleClamp180(self getTagAngles('tag_weapon')[0]) > 20)
//			transitionedToIdle = true;
	}
	
	while (true)
	{
		desiredPose = getDesiredIdlePose();
		
		if (desiredPose == 'prone')
		{
			transitionedToIdle = true;
			ProneStill();
		}
		else
		{
//			assertex(desiredPose == 'crouch' || desiredPose == 'stand', desiredPose);
			
			if (a.pose != desiredPose)
			{
				clearAnim('root', 0.3);
				transitionedToIdle = false;
			}
			animscripts_trans.SetPoseMovement(desiredPose, 'stop');
			
			transitionedToIdle = true;
			if (!transitionedToIdle)
			{
				transitionToIdle(desiredPose, a.idleSet);
				transitionedToIdle = true;
			}
			else
			{
				playIdle(desiredPose, a.idleSet);
			}
		}

		//CheckMoveTransition();
	}
}
