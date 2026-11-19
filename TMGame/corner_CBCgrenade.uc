class corner_CBCgrenade extends CBCGrenade;

function Execute(HodEntity iTarget)
{
	current_corner_script.tryThrowingGrenade(iTarget, false);
}
