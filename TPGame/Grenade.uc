
class Grenade extends Grenade_Persistent;

static function float GetDefaultImpulseForce()
{
	return default.ImpulseForce;
}
static function float GetDefaultAffectedRadius()
{
	return default.AffectedRadius;
}
static function float GetDefaultDamageCaused()
{
	return default.DamageCaused;
}
static function float GetDefaultDamageCaused_AI()
{
	return default.DamageCaused_AI;
}

simulated function ConsumeAmmo( byte FireModeNum )
{
	if ( !bInfiniteAmmo )
		Super.ConsumeAmmo( FireModeNum );
}

