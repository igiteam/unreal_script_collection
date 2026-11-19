class trans_PlayBlendTransitionStandRun extends CoreTask within animscripts_trans;

// parameter
var name animname;

// output

// local
var float transtime;

state main
{
Begin:
	// if we're blending into stand run from stop,
	// we probably just did utility::initialize's clearAnim(body, .3)
	// so we don't have to spend more than .3 seconds here.
	// (then we can do fun things like shooting or reloading.)
	transtime = 0.3;
	if (a.movement != 'stop')
	{
		endon('movemode');
		transtime = 1.0;
	}
	
	PlayBlendTransition(animname, transtime, 'stand', 'run', false);
}
