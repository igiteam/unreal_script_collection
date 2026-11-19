class MOHAMeleeDamageType extends MOHADamageType;

static function bool HasCustomKillingBlowMomentumMultiplier(MOHAPawn Victim, Controller Instigator, Vector Momentum, out float MomentumMultiplier)
{
    // End:0x43
    if(Instigator.bIsPlayer)
    {
        // End:0x36
        if(IsOnPathNetworkEdge(Victim, Momentum))
        {
            MomentumMultiplier = 2.0000000;
            return true;
        }
        MomentumMultiplier = 1.0000000;
        return true;
    }
    MomentumMultiplier = Victim.RagdollThrowWeaponImpulseMultiplier;
    return true;
    //return ReturnValue;    
}

static function bool CheckStalemated(KynapseAIController kaic)
{
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    bKillShouldCauseLimpRagdoll=true
    KDamageImpulse=5000.0000000
    KImpulseRadius=0.0000000
}