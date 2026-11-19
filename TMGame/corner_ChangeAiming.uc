class corner_ChangeAiming extends CoreTask within animscripts_corner;

// parameter
var name iSpot;
var bool iFullbody;
var float iTransTime;

state main
{
Begin:
	assert(cornerAiming);
	SetAimingParams(iSpot, iFullbody, iTransTime, a.cornerMode == 'lean');
}
