class stop_ProneStill extends CoreTask within animscripts_stop;

// parameter

// output

// local
var name ltransAnim;
var array<name> twitches;
var name twitchAnim;

state main
{
Begin:
	if (a.pose != 'prone')
	{
		ltransAnim = SetCustomAnim(exposed_modern, 'stand_2_prone');
		if (a.pose == 'crouch')
			ltransAnim = SetCustomAnim(exposed_modern, 'crouch_2_prone');
//		assertex(isdefined(ltransAnim), a.pose);
		assert(animHasNotetrack(ltransAnim, name("anim_pose = prone")));
		
		setFlaggedAnimKnobAllRestart('trans', ltransAnim, 'body', 1, 0.2, 1.0);
		animscripts_shared.DoNoteTracks('trans');
		
		assert(a.pose == 'prone');
		a.movement = 'stop';
		
		setProneAnimNodes(-45, 45, 'prone_legs_down', 'exposed_modern', 'prone_legs_up');
		
		_return(); // in case we need to change our pose again for whatever reason
	}
	
	UpdateProneThread(true);
	
	if (randomint(10) < 3)
	{
//		twitches = [];
		twitches[0] = 'prone_twitch_ammocheck';
		twitches[1] = 'prone_twitch_ammocheck2';
		twitches[2] = 'prone_twitch_look';
		twitches[3] = 'prone_twitch_lookfast';
		twitches[4] = 'prone_twitch_lookup';
		twitches[5] = 'prone_twitch_scan';
		twitches[6] = 'prone_twitch_scan2';
		
		twitchAnim = twitches[ randomint(twitches.length) ];
		setFlaggedAnimKnobAll('prone_idle', twitchAnim, 'exposed_modern', 1, 0.2);
	}
	else
	{
		setAnimKnobAll('prone_aim', 'exposed_modern', 1, 0.2);
		setFlaggedAnimKnob('prone_idle', 'prone_idle', 1, 0.2); // (additive idle on top)
	}
	waittillmatch('prone_idle', 'end');
	
	notify('kill UpdateProneThread');
}
