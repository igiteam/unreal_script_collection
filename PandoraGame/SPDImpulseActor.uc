class SPDImpulseActor extends Actor
    native
    notplaceable;

var export editinline RB_RadialImpulseComponent ImpulseComponent;
var float delay;
var int Damage;
var float DamageRadius;
var class<DamageType> DamageType;
var bool ShowDebug;
var bool bExplosive;
var float PlayerOnlyRadius;
var float PlayerOnlyDamage;
var export editinline DrawSphereComponent RenderComponent;

// Export USPDImpulseActor::execEnableDebug(FFrame&, void* const)
native function EnableDebug();

function DoDamage()
{
    //return;    
}

auto state Waiting
{
    event EndState(name NextStateName)
    {
        ClearTimer('DoDamage');
        //return;        
    }

    event PoppedState()
    {
        ClearTimer('DoDamage');
        //return;        
    }

    function DoDamage()
    {
        // End:0x45
        if(ImpulseComponent.ImpulseStrength > float(0))
        {
            RenderComponent.SphereRadius = DamageRadius;
            ImpulseComponent.FireImpulse(Location);
        }
        // End:0xC0
        if(Damage > 0)
        {
            // End:0x8E
            if(bExplosive)
            {
                ExplosiveHurtRadius(float(Damage), DamageRadius, DamageType, 1.0000000, Location,,, false, PlayerOnlyRadius, PlayerOnlyDamage);                
            }
            else
            {
                HurtRadius(float(Damage), DamageRadius, DamageType, 1.0000000, Location,,, false, PlayerOnlyRadius, PlayerOnlyDamage);
            }
        }
        Destroy();
        //return;        
    }
Begin:

    EnableDebug();
    // End:0x2D
    if(delay > float(0))
    {
        SetTimer(delay, false, 'DoDamage');        
    }
    else
    {
        DoDamage();
    }
    stop;                    
}
