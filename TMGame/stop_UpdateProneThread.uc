class stop_UpdateProneThread extends CoreTask within animscripts_stop;

state main
{
Begin:
	endon('killanimscript');
	endon('kill UpdateProneThread');
	
	while (true)
	{
		animscripts_cover_prone.UpdateProneWrapper(0.1);
		wait(0.1);
	}
}
