class trans_StandToCrouchRun extends CoreTask within animscripts_trans;

state main
{
Begin:
	BlendIntoStandRun();
	BlendIntoCrouchRun();
}
