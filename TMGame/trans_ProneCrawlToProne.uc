class trans_ProneCrawlToProne extends CoreTask within animscripts_trans;

state main
{
Begin:
//	assertEX(self.a.pose == 'prone', 'SetPoseMovement::ProneCrawlToProne '+self.a.pose);
//	assertEX((self.a.movement=='walk' || self.a.movement=='run'), 'SetPoseMovement::ProneCrawlToProne '+self.a.movement);

	ProneLegsStraightTree(0.1);
	animscripts_cover_prone.UpdateProneWrapper(0.1);
	PlayTransitionAnimation('prone_crawl_2_aim', 'prone', 'stop', true);

//// TODO: Find out if the above lines give the same functionality as below (notably the UpdateProne bit)
////	ProneLegsStraightTree(0.1);
////	self setflaggedanimknob('animdone', %prone_crawl2aim, 1, 0.1, 1);
////	self animscripts\cover_prone::UpdateProneWrapper(0.1);
////	self waittill('animdone');
////	self.a.movement = 'stop';
////	self.a.alertness = 'aiming';
}
