class trans_ProneToCrouchWalk extends CoreTask within animscripts_trans;

state main
{
Begin:
	ProneToCrouchRun();
	BlendIntoCrouchWalk();
}
