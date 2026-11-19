class trans_ProneToProneMove extends CoreTask within animscripts_trans;

// parameter
var name iMovement;

// output

// local

state main
{
Begin:
//	// (The parameter 'movement' is just used for setting the state variable, since prone guys move the same whether
//	// 'walking' or 'running'.
//	assertEX(self.a.pose == 'prone', 'SetPoseMovement::ProneToProneMove '+self.a.pose);
//	assertEX(self.a.movement == 'stop', 'SetPoseMovement::ProneToProneMove '+self.a.movement);
//	assertEX((movement == 'walk' || movement == 'run'), 'SetPoseMovement::ProneToProneMove got bad parameter '+movement);

	ProneLegsStraightTree(0.1);
	PlayTransitionAnimation('prone_aim_2_crawl', 'prone', iMovement, false, 'prone_crawl');

	animscripts_cover_prone.UpdateProneWrapper(0.1);
}
