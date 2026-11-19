class corner_FastLook extends BoolTask within animscripts_corner;

state main
{
Begin:
	// corner fast look animations aren't set up right.
	_return (false);
	
	/*
	if (!isdefined(self.a.array['look']))
		return false;
	
	self setFlaggedAnimKnobAllRestart('look', animArray('look'), %body, 1, .1);
	self animscripts\shared::DoNoteTracks('look');
	
	return true;
	*/
}
