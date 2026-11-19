class SPTargetVolume extends DestructibleStaticMesh;

//var delegate<OnTookDamage> __OnTookDamage__Delegate;

delegate OnTookDamage(float Damage, Controller instigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional Actor DamageCauser)
{
    //return;    
}

function DBGMessage(string Str)
{
    local PlayerController PC;

    // End:0x4D
    foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
    {
        // End:0x4C
        if(PC.Pawn != none)
        {
            PC.Pawn.ClientMessage(Str);
        }        
    }    
    //return;    
}

k2override event ServerOnlyTakeDamage(float DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    OnTookDamage(DamageAmount, EventInstigator, HitLocation, Momentum, DamageType, DamageCauser);
    //return;    
}
