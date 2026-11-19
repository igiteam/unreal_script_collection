
class Colt45 extends TPWeapon;

simulated function float FireRecoilProcess (float Percent, float FireAngle)
{
    FireAngle = Super.FireRecoilProcess (Percent, FireAngle);
    return FireAngle / (Percent*Percent);
}

