class trans_ProneToStandRun extends CoreTask within animscripts_trans;

state main
{
Begin:
	ProneToCrouchRun();
	BlendIntoStandRun();
}
