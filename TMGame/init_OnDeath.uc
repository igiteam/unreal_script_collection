class init_OnDeath extends CoreTask within animscripts_init;

state main
{
Begin:
	waittill('death');
	//if ( !isdefined( self ) )
	//{
	//	// we were deleted and we're not running the death script.
	//	// still safe to access our variables as a removed entity though:
	//	if ( isdefined( self.a.usingTurret ) )
	//		self.a.usingTurret delete();
	//}
}
