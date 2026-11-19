class arrival_DoCoverExitAnimation extends CoreTask within animscripts_cover_arrival;

// parameter
var name iexittype;
var int iapproachNumber;

// output

// local
var int exittypeid;
var Angle lookaheadAngles;
var float transTime;
var bool hasExitAlign;
var bool hasCodeMoveNoteTrack;
var float curfrac;
var vector remainingMoveDelta;
var float remainingAngleDelta;
var float faceYaw;
var Angle langle;
var vector forward;
var vector right;
var name leaveAnim;
var vector endPoint;
var float timeLeft;

state main
{
Begin:
	exittypeid = TransTypeID(iexittype);
	leaveAnim = anim.coverExit[exittypeid].data[iapproachnumber];

	switch (iexittype)
	{
	case 'exposed':
	case 'exposed_crouch':
		leaveAnim = SetCustomAnim(exposed_modern, leaveAnim);
		break;

	case 'crouch':
	case 'stand':
	case 'left_crouch':
	case 'right_crouch':
	case 'left':
	case 'right':
		leaveAnim = SetCustomAnim(misc_modern, leaveAnim);
		break;

	default:
		break;
	}
	
	assert(leaveAnim != '');

	lookaheadAngles = vectortoangles(lookaheaddir);
	
	if (a.pose == 'prone')
		_return();

	transTime = 0.2;
	
	//pawn.SetPreviousRMM(RMM_Ignore);
	animMode('zonly_physics', false);
	OrientMode('face angle', angles.yaw);
	setFlaggedAnimKnobAllRestart('coverexit', leaveAnim, 'body', 1, transTime, 1);
	
	hasExitAlign = animHasNotetrack(leaveAnim, 'exit_align');

	DoNoteTracksForExit('coverexit', hasExitAlign, true);
	
	waittillmatch('coverexit', 'exit_align');
	
	exitingCover = true;
	
	a.pose = 'stand';
	a.movement = 'run';

	hasCodeMoveNoteTrack = animHasNotetrack(leaveAnim, 'code_move');

	while (true)
	{
		curfrac = getAnimTime(leaveAnim);
		remainingMoveDelta = getMoveDelta(leaveAnim, curfrac, 1);
		remainingAngleDelta = getAngleDelta(leaveAnim, curfrac, 1);
		faceYaw = lookaheadAngles.yaw - remainingAngleDelta;
		
		// make sure we can complete the animation in this direction
		langle.pitch = 0;
		langle.yaw = faceYaw;
		langle.roll = 0;
		forward = anglesToForward(langle);
		right = anglesToRight(langle);
		endPoint = origin + vectorScale(forward, remainingMoveDelta.x) - vectorScale(right, remainingMoveDelta.y);
		
		if (mayMoveToPoint(endPoint))
		{
			OrientMode('face angle', faceYaw);
			break;
		}

		if (hasCodeMoveNoteTrack)
			break;
		
		// wait a bit or until the animation is over, then try again
		
		timeLeft = getAnimLength(leaveAnim) * (1 - curfrac) - 0.05;
		
		if (timeLeft < 0.05)
			break;
		
		if (timeLeft > 0.4)
			timeleft = 0.4;
		
		wait(timeleft);
	}

	if (hasCodeMoveNoteTrack)
	{
		if (animHasNotetrack(leaveAnim, 'code_move', GetAnimTime(leaveAnim)))
			waittillmatch('coverexit', 'code_move');
		OrientMode('face default');
		animmode('normal', false);
	}

	waittillmatch('coverexit', 'end');

	//while (true)
	//{
	//	OrientMode('face angle', angles.yaw);
	//	animMode('zonly_physics', false);
	//	setFlaggedAnimRestart('test', leaveAnim, 1, 0/*, 0.5*/);
	//	//waittillmatch( 'test', 'exit_align' );

	//	//waittillmatch( 'test', 'code_move' );
	//	//guy OrientMode( 'face default' );
	//	//guy animmode( 'none', false );

	//	waittillmatch('test', 'end');
	//	clearanim('root', 0);
	//	//setAnimRestart('stand_run_F', 1, 0);
	//	OrientMode('face motion');
	//	animMode('normal', false);
	//	wait(1);
	//}

	clearanim('root', 0.1);

	// the end of the exit animations (should) line up *exactly* with the start of the run animations.
	// Play a run animation immediately so that if we blend to something other than a run, we don't pop.
	setAnimRestart(SetCustomAnim(combatrun_forward, 'stand_run_F', 1.0, true), 1, 0.1);
	
	OrientMode('face motion');
	faceEnemyOrMotionAfterABit(true);
	animMode('normal', false);
}
