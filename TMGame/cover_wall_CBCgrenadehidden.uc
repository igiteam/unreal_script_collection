class cover_wall_CBCgrenadehidden extends CBCGrenade;

function Execute(HodEntity iTarget)
{
	animscripts_cover_wall.TryThrowingGrenadeStayHidden(iTarget);
}
