class trans_StandRunToProneRun extends CoreTask within animscripts_trans;

state main
{
Begin:
	CrouchRunToProne();
	ProneToProneRun();
}
