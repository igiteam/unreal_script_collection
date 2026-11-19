class combat_utility_DetachGrenadeOnScriptChange extends CoreTask within animscripts_combat_utility;

var name iModel;
var name iTag;

state main
{
Begin:
	//self endon ('death'); // don't end on death or it will hover when we die!
	endon ('stop grenade check');
	waittill ('killanimscript');

//	if (!isdefined(self)) // we may be dead but still defined. if we're not defined, we were probably deleted.
//		return;

	if (float_isdefined(oldGrenAwareness))
	{
		grenadeawareness = oldGrenAwareness;
		oldGrenAwareness = float_undefined;
	}

//	self detach(model, tag);
}
