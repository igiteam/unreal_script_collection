class SPAttachedStaticMeshComponent extends StaticMeshComponent
    native
    editinlinenew
    hidecategories(Collision,Rendering,Lighting);

var() name m_socketName;
var() SPDestructibleProperties m_destructProperties;
var() int m_hitPoints;
var bool m_bAttached;
var bool m_bDestroyed;

function CauseDestruction(float Damage, Controller instigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local SPDProcessManager ProcessManager;

    // End:0x0D
    if(m_bDestroyed)
    {
        return;
    }
    // End:0x1A
    if(m_destructProperties == none)
    {
        return;
    }
    ProcessManager = Class'SPDProcessManager'.static.Get(Owner);
    // End:0x84
    if(ProcessManager != none)
    {
        ProcessManager.DoComponentDestruct(Owner, self, m_destructProperties, int(Damage), instigatedBy, HitLocation, Momentum, DamageType, HitInfo);
    }
    m_bDestroyed = true;
    m_hitPoints = -1;
    //return;    
}

event ComponentTakeDamage(float Damage, Controller instigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    TakeDamageAndProcEffects(Damage, instigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    //return;    
}

function int FloatingPointAdjustDamage(float Damage)
{
    local int intDamage, extraDamage;
    local float FloatDamageRemainder;

    intDamage = int(Damage);
    FloatDamageRemainder += (Damage - float(intDamage));
    extraDamage = int(FloatDamageRemainder);
    intDamage += extraDamage;
    FloatDamageRemainder = FloatDamageRemainder - float(extraDamage);
    return intDamage;
    //return ReturnValue;    
}

event TakeDamageAndProcEffects(float DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local int RemainingHitPoints;

    // End:0x0F
    if(m_destructProperties == none)
    {
        return;
    }
    DamageAmount = float(FloatingPointAdjustDamage(DamageAmount));
    RemainingHitPoints = int(float(m_hitPoints) - DamageAmount);
    m_hitPoints = RemainingHitPoints;
    // End:0x8C
    if((RemainingHitPoints <= 0) && m_destructProperties != none)
    {
        CauseDestruction(DamageAmount, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    }
    //return;    
}
