class trans_ProneToStand extends CoreTask within animscripts_trans;

// parameter

// output

// local

state main
{
Begin:
	//assertEx(self.a.pose == 'prone', self.a.pose);
	
	OrientMode ('face current');	// We don't want to rotate arbitrarily until we've actually stood up.
	animscripts_utility.ExitProneWrapper(1.0); // make code stop lerping in the prone orientation to ground
	ProneLegsStraightTree(0.1);
	animscripts_cover_prone.UpdateProneWrapper(0.1);
	PlayTransitionAnimation(SetCustomAnim(exposed_modern, 'prone_2_stand'), 'stand', 'stop', true);
}
