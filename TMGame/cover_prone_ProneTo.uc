class cover_prone_ProneTo extends CoreTask within animscripts_cover_prone;

// parameter
var name newPose;
var float rate;

// output

// local
var name ltransAnim;

state main
{
Begin:
	assert(a.pose == 'prone');
	
//	self OrientMode( 'face angle', self.angles[1] );
	ClearAnim('root', 0.3);
	
	ltransAnim = '';
	
	if ( shouldFireWhileChangingPose() )
	{
		if ( newPose == 'crouch' )
			ltransAnim = SetCustomAnim(exposed_modern, 'prone_2_crouch_firing');
		else if ( newPose == 'stand' )
			ltransAnim = SetCustomAnim(exposed_modern, 'prone_2_stand_firing');
	}
	else
	{
		if ( newPose == 'crouch' )
			ltransAnim = SetCustomAnim(exposed_modern, 'prone_2_crouch');
		else if ( newPose == 'stand' )
			ltransAnim = 'prone_2_stand_nodelta';
	}
		
	assert(ltransAnim != '');
	
	animscripts_utility.ExitProneWrapper(GetAnimLength(ltransAnim) / 2);
	SetFlaggedAnimKnobAllRestart('trans', ltransAnim, 'body', 1, 0.2, rate);
	animscripts_shared.DoNoteTracks('trans');

	ClearAnim(ltransAnim, 0.1);

	assert(a.pose == newPose);
}
