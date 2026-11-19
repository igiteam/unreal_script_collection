class SkyDamageableCoverStaticMeshActor extends SkyDamageableStaticMeshActor
    native
    placeable;

struct native DamageScaleInfo
{
    var() Weapon WeaponArchetype;
    var() float DamageScale;

    structdefaultproperties
    {
        WeaponArchetype=none
        DamageScale=1.0000000
    }
};

struct native CoverDisableInfo
{
    var() CoverLink Link;
    var() array<int> SlotIndices;

    structdefaultproperties
    {
        Link=none
        SlotIndices=none
    }
};

var(Damage) array<DamageScaleInfo> DamageScalars;
var(Cover) array<CoverDisableInfo> AffectedCover;

// Export USkyDamageableCoverStaticMeshActor::execRegisterSlot(FFrame&, void* const)
native function RegisterSlot(CoverLink Link, int SlotIdx);

// Export USkyDamageableCoverStaticMeshActor::execTakeDamage(FFrame&, void* const)
native function TakeDamage(int DamageAmount, Controller InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser);

event bool ApplyEffectDamage(Vector HitLocation, int DamageApplied, int NewHealth, class<DamageType> DamageType)
{
    // End:0x15
    if(NewHealth <= 0)
    {
        DisableCover();
    }
    return super.ApplyEffectDamage(HitLocation, DamageApplied, NewHealth, DamageType);
    //return ReturnValue;    
}

function DisableCover()
{
    local int I, H, Slot;
    local CoverLink Link;
    local SkyPawnCoverUser SPCU;

    I = 0;
    J0x07:

    // End:0x136 [Loop If]
    if(I < AffectedCover.Length)
    {
        Link = AffectedCover[I].Link;
        // End:0x12C
        if(Link != none)
        {
            // End:0x8D
            foreach WorldInfo.AllPawns(Class'SkyPawnCoverUser', SPCU)
            {
                SPCU.NotifyCoverDestroyed(Link, AffectedCover[I].SlotIndices);                
            }            
            H = 0;
            J0x95:

            // End:0x12C [Loop If]
            if(H < AffectedCover[I].SlotIndices.Length)
            {
                Slot = AffectedCover[I].SlotIndices[H];
                // End:0x122
                if((Slot >= 0) && Slot < Link.Slots.Length)
                {
                    Link.Slots[Slot].bEnabled = false;
                }
                ++H;
                // [Loop Continue]
                goto J0x95;
            }
        }
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}
