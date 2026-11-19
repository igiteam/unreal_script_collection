class trans_CrouchWalkToStand extends CoreTask within animscripts_trans;

state main
{
Begin:
	CrouchWalkToCrouch();
	CrouchToStand();
}
