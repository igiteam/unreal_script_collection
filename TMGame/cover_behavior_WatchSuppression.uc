class cover_behavior_WatchSuppression extends CoreTask within animscripts_cover_behavior;

// parameter

// output

// local
var int lTime;

state main
{
Begin:
	endon('killanimscript');
	
	// self.lastSuppressionTime is the last time a bullet whizzed by.
	// self.suppressionStart is the last time we were thinking it was safe when a bullet whizzed by.
	
	lastSuppressionTime = gettime() - 100000;
	suppressionStart = lastSuppressionTime;
	
	while (true)
	{
		waittill('suppression');
		
		lTime = gettime();
		if (lastSuppressionTime < lTime - 700)
			suppressionStart = lTime;
		lastSuppressionTime = lTime;
	}
}
