class SPDynamicSMActor extends DynamicSMActor
    native;

/** VARIABLE DECLARATIONS */
var() export editinline array<export editinline SPGlassStaticMeshComponent> StaticMesheCompoenets;
var() int HitPoints;
var() ParticleSystem ParticleSystem;
var bool IsComponentInitialized;
var() const editconst export editinline SPStaticMeshComponent SPStaticMeshComponent;

// Export USPDynamicSMActor::execRemoveComponents(FFrame&, void* const)
native function RemoveComponents();

// Export USPDynamicSMActor::execAddComponents(FFrame&, void* const)
native function AddComponents();

simulated function PostBeginPlay()
{
    SetPhysics(7);
    //return;    
}

k2override event ServerOnlyTakeDamage(float DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local editinline SPGlassStaticMeshComponent Comp;

    Comp = SPGlassStaticMeshComponent(HitInfo.HitComponent);
    // End:0x76
    if(Comp != none)
    {
        // End:0x76
        if(Comp.HitPoints >= float(0))
        {
            Comp.ServerOnlyTakeDamage(DamageAmount, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
        }
    }
    //return;    
}

event Destroyed()
{
    RemoveComponents();
    //return;    
}
