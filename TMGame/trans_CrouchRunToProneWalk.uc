class trans_CrouchRunToProneWalk extends CoreTask within animscripts_trans;

state main
{
Begin:
	CrouchRunToProne();
	ProneToProneRun();
}
