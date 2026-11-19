class cover_wall_idle extends CoreTask within animscripts_cover_wall;

// parameter

// output

// local
var bool lUseTwitch;
var name lIdleAnim;

state main
{
Begin:
	endon('end_idle');
	
	while (true)
	{
		lUseTwitch = (randomint(2) == 0 && animscripts_utility.animArrayAnyExist('hide_idle_twitch'));
		if (lUseTwitch)
			lIdleAnim = animscripts_utility.animArrayPickRandom('hide_idle_twitch');
		else
			lIdleAnim = animscripts_utility.animarray('hide_idle');
		
		playIdleAnimation(SetCustomAnim(misc_modern, lIdleAnim), lUseTwitch);
	}
}
