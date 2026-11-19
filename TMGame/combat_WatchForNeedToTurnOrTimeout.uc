class combat_WatchForNeedToTurnOrTimeout extends CoreTask within animscripts_combat;

// parameter

// output

// local
var int lEndTime;

state main
{
Begin:
	endon('killanimscript');
	endon('stop_watching_for_need_to_turn');
	
	lEndTime = gettime() + 4000 + randomint(2000);
	
	while (true)
	{
		if (gettime() > lEndTime || needToTurn())
		{
			notify('need_to_turn');
			break;
		}
		wait (0.1);
	}
}
