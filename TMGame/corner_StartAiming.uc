class corner_StartAiming extends CoreTask within animscripts_corner;

// parameter
var name iSpot;
var bool iFullbody;
var float iTransTime;

state main
{
Begin:
	assert(!cornerAiming);
	cornerAiming = true;
	
	SetAimingParams(iSpot, iFullbody, iTransTime, a.cornerMode == 'lean');
}
