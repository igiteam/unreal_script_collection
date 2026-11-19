class StateMove_Main extends CoreTask within HodAI;

state main
{
Begin:
	endon ('killanimscript');
	run (new(outer) class'StateMove_CombatBreaker', true);

	//while (true)
	//{
	//	waittill('goal');
		requestArrivalNotify = false;
		animscripts_move.main();
	//}
}
