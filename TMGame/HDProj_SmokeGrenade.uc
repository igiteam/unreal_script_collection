//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDProj_SmokeGrenade extends HDProj_GrenadeBase;

// always spawn somke effect
simulated function bool EffectIsRelevant(vector SpawnLocation, bool bForceDedicated, optional float VisibleCullDistance=5000.0, optional float HiddenCullDistance=350.0 )
{
    return true;
}

