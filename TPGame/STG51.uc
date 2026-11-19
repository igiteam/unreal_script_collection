class STG51 extends TPWeapon
	deprecated;


simulated function float FireRecoilProcess (float Percent, float FireAngle)
{
    FireAngle = Super.FireRecoilProcess (Percent, FireAngle);
    return FireAngle / Percent;
}

simulated function PlayFireEffects( byte FireModeNum, optional vector HitLocation )
{
	super.PlayFireEffects(FireModeNum, HitLocation);
}

