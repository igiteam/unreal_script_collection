class MOHAGrenadeDamageType extends MOHAExplosiveDamageType;

static function AdjustDamageNPCtoNPC(MOHAAIPawn DamageTarget, out int inDamage, out Vector Momentum, Controller InstigatedBy, Vector HitLocation, class<DamageType> DamageType, optional TraceHitInfo HitInfo)
{
    local KynapseAIController kaic;

    // End:0xDD
    if(DamageTarget != none)
    {
        // End:0x25
        if(DamageTarget.bNPCImmune)
        {
            inDamage = 0;
        }
        // End:0x55
        if(DamageTarget.Controller != none)
        {
            kaic = KynapseAIController(DamageTarget.Controller);            
        }
        else
        {
            // End:0xB9
            if((Pawn(DamageTarget.Owner) != none) && Pawn(DamageTarget.Owner).Controller != none)
            {
                kaic = KynapseAIController(Pawn(DamageTarget.Owner).Controller);
            }
        }
        // End:0xDD
        if(kaic != none)
        {
            // End:0xDD
            if(kaic.bStalemated)
            {
                inDamage = 0;
            }
        }
    }
    //return;    
}
