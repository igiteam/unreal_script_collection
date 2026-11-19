class trans_WaitSetStates extends CoreTask within animscripts_trans;

// parameter
var float timetowait;
var name killmestring;
var name endPose;

// output

// local
var name oldpose;

state main
{
Begin:
	endon('killanimscript');
	endon('death');
	endon(killmestring);

	oldpose = a.pose;
	wait(timetowait);

	// We called Enter/ExitProne before this function was called.  These lines should not be necessary, but 
	// for some reason the code is picking up that I'm setting pose from prone to crouch without calling 
	// exitprone().  I just hope it's not a thread leak I've missed.
	if (oldpose != 'prone' && endPose =='prone')
	{
		animscripts_cover_prone.UpdateProneWrapper(0.1);
		animscripts_utility.EnterProneWrapper(1.0); // make code start lerping in the prone orientation to ground
	}
	else if (oldpose=='prone' && endPose !='prone')
	{
		animscripts_utility.ExitProneWrapper(1.0); // make code stop lerping in the prone orientation to ground
		OrientMode('face default');	// We were most likely in "face current" while we were prone.
	}
}
