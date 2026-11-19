class trans_CrouchRunToStand extends CoreTask within animscripts_trans;

state main
{
Begin:
	CrouchRunToCrouch();
	CrouchToStand();
}
