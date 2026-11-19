class AdvAttachment_Weap_Browning_Base extends AdvAttachment_Weap_Base
    abstract
    hidecategories(Navigation);

simulated function PlayImpactSounds(Actor HitActor, Vector SoundLocation, Vector FireDir, PhysicalMaterial PhysMaterial, class<EvilDmgType_Base> EvilBaseDamageType, bool bPlayerIsInstigator)
{
    // End:0x65
    if(float(ImpactSoundsQuantity) < ImpactSoundsQuantityLimit)
    {
        ImpactSoundsQuantity++;
        super(EvilAttachment_Weap_Base).PlayImpactSounds(HitActor, SoundLocation, FireDir, PhysMaterial, EvilBaseDamageType, bPlayerIsInstigator);
    }
    //return;    
}

simulated function PlayImpactEffects(Vector HitLocation, optional bool bIsLeft = false)
{
    // End:0x32
    if(FRand() < BloodBlobChance)
    {
        super(EvilAttachment_Weap_Base).PlayImpactEffects(HitLocation, bIsLeft);
    }
    //return;    
}

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__AdvAttachment_Weap_Browning_Base.SkeletalMeshComponent0'
    begin object name=SkeletalMeshComponent0
        ReplacementPrimitive=none
    end object
    Mesh=SkeletalMeshComponent0
    WeaponClass=Class'AdvWeap_Browning_Base'
    EvilWeapAnimType=EEvilWeapAnimType.EWWAT_Remington
    BloodBlobChance=0.4000000
}