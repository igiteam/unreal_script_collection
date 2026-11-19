class trans_CrouchToStandWalk extends CoreTask within animscripts_trans;

state main
{
Begin:
	CrouchToCrouchWalk();
	BlendIntoStandWalk();
}
