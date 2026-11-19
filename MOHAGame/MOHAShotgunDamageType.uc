class MOHAShotgunDamageType extends MOHABulletDamageType;

static function bool HasCustomKillingBlowMomentumMultiplier(MOHAPawn Victim, Controller Instigator, Vector Momentum, out float MomentumMultiplier)
{
    local float fInstigatorDistance;

    // End:0x95
    if((Instigator != none) && Instigator.Pawn != none)
    {
        fInstigatorDistance = VSize(Victim.Location - Instigator.Pawn.Location);
        MomentumMultiplier = Lerp(Victim.RagdollThrowWeaponImpulseMultiplier, 0.0000000, fInstigatorDistance / 1000.0000000);
        // End:0x93
        if(MomentumMultiplier < 0.0000000)
        {
            MomentumMultiplier = 0.0000000;
            return false;
        }
        return true;
    }
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    bKillShouldCauseLimpRagdoll=true
}