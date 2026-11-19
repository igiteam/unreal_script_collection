class trans_PlayBlendTransitionStandWalk extends CoreTask within animscripts_trans;

// parameter
var name iAnimName;

// output

// local

state main
{
Begin:
	if (a.movement != 'stop')
		endon('movemode');

	PlayBlendTransition(iAnimName, 0.6, 'stand', 'walk', true);
}
