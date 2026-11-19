class cover_wall_CBCgrenade extends CBCGrenade;

function Execute(HodEntity iTarget)
{
	animscripts_cover_wall.tryThrowingGrenade(iTarget, false);
}
