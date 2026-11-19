class MOHABulletDamageType extends MOHADamageType
    abstract;

var(Damage) float InstantKillDistance;

static function AdjustDamageNPCtoNPC(MOHAAIPawn DamageTarget, out int inDamage, out Vector Momentum, Controller InstigatedBy, Vector HitLocation, class<DamageType> DamageType, optional TraceHitInfo HitInfo)
{
    local float DamageDistance;
    local int origDamage;

    origDamage = inDamage;
    super.AdjustDamageNPCtoNPC(DamageTarget, inDamage, Momentum, InstigatedBy, HitLocation, DamageType, HitInfo);
    // End:0x137
    if(((!DamageTarget.bNPCImmune && KynapseAIController(InstigatedBy) != none) && DamageTarget.Controller != none) && KynapseAIController(DamageTarget.Controller).TeamIndex != KynapseAIController(InstigatedBy).TeamIndex)
    {
        DamageDistance = VSize(InstigatedBy.Pawn.Location - HitLocation);
        // End:0xF3
        if(DamageDistance < default.InstantKillDistance)
        {
            inDamage = DamageTarget.Health;            
        }
        else
        {
            // End:0x10F
            if(FRand() < DamageTarget.NPCBulletFilterPct)
            {
                inDamage = 0;
            }
        }
        inDamage = DamageTarget.AdjustCloseRangeDamageFor(InstigatedBy, origDamage, inDamage);
    }
    //return;    
}

defaultproperties
{
    InstantKillDistance=650.0000000
    KDamageImpulse=80.0000000
    KImpulseRadius=0.0000000
}