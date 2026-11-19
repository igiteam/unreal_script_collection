class shoot_RunOnShootBehaviorEnd extends CoreTask within animscripts_shoot_behavior;

// parameter

// output

// local
var array<name> waited_notifies;

state main
{
Begin:
	endon ('death');
	
	waited_notifies.Add(2);
	waited_notifies[0] = 'killanimscript';
	waited_notifies[1] = 'stop_deciding_how_to_shoot';
	waittill_any(waited_notifies);
	
	a.laserOn = false;
	animscripts_shared.updateLaserStatus();
}
