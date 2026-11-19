class trans_ProneToStandWalk extends CoreTask within animscripts_trans;

state main
{
Begin:
	ProneToCrouch();
	CrouchToCrouchWalk();
	BlendIntoStandWalk();
}
