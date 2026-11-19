class UTSkelControl_DamageHinge extends UDKSkelControl_DamageHinge
    hidecategories(Object,Object,Translation,Rotation,Adjustments);

simulated event BreakApart(Vector PartLocation, bool bIsVisible)
{
    local EvilGib Gib;

    // End:0x5A
    if(((!bOnDamageActive || BreakMesh == none) || OwnerVehicle == none) || bIsBroken)
    {
        bIsBreaking = false;
        bIsBroken = true;
        return;
    }
    // End:0x165
    if(bIsVisible && int(OwnerVehicle.WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        Gib = EvilVehicle_Base(OwnerVehicle).SpawnGibVehicle(PartLocation, OwnerVehicle.Rotation, BreakMesh, PartLocation, true, DefaultBreakDir, PS_DamageOnBreak, PS_DamageTrail);
        // End:0x165
        if(Gib != none)
        {
            Gib.SetDrawScale3D(DamageScale);
        }
    }
    BoneScale = DamageBoneScale;
    bIsBreaking = false;
    bIsBroken = true;
    //return;    
}

simulated event BreakApartOnDeath(Vector PartLocation, bool bIsVisible)
{
    local EvilGib Gib;

    // End:0x11
    if(!bOnDeathActive)
    {
        return;
    }
    // End:0x33
    if(DeathStaticMesh == none)
    {
        DeathStaticMesh = BreakMesh;
    }
    // End:0x82
    if((((DeathStaticMesh == none) || DeathPercentToActuallySpawn < FRand()) || OwnerVehicle == none) || bIsBroken)
    {
        bIsBroken = true;
        return;
    }
    // End:0x185
    if(bIsVisible && int(OwnerVehicle.WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        Gib = EvilVehicle_Base(OwnerVehicle).SpawnGibVehicle(PartLocation, OwnerVehicle.Rotation, DeathStaticMesh, PartLocation, true, DeathImpulseDir, none, PS_DeathTrail);
        // End:0x185
        if(Gib != none)
        {
            Gib.SetDrawScale3D(DeathScale);
        }
    }
    BoneScale = DeathBoneScale;
    bIsBroken = true;
    //return;    
}
