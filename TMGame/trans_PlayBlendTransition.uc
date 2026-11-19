class trans_PlayBlendTransition extends CoreTask within animscripts_trans;

// parameter
var name iTransAnim;
var float iCrossblendTime;
var name iEndPose;
var name iEndMovement;
var bool iEndAiming;

// output

// local
var float endTime;
var float waittime;

state main
{
Begin:
	endTime = gettime() + iCrossblendTime * 1000;
	
	Setflaggedanimknoball( 'blendTransition', iTransAnim, 'body', 1, iCrossblendTime, 1 );
	
	wait(iCrossblendTime / 2);
	
	a.pose = iEndPose;
	a.movement = iEndMovement;
	
	if ( iEndAiming )
		a.alertness = 'aiming';
	else
		a.alertness = 'casual';
	
	waittime = (endTime - gettime()) / 1000;
	if ( waittime < 0.05 )
		waittime = 0.05;
	
	wait(waittime);
}
