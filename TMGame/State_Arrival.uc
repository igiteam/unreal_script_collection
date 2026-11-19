class State_Arrival extends CoreTask within HodAI;

state main
{
Begin:
	notify ('killanimscript');
	endon ('killanimscript');
	AnimMode('zonly_physics');
	OrientMode('face angle', angles.yaw);
	animscripts_cover_arrival.main();
	notify ('state arrival end');
}
