class trans_StandToCrouchWalk extends CoreTask within animscripts_trans;

state main
{
Begin:
	BlendIntoStandWalk();
	BlendIntoCrouchWalk();
}
