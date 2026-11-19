class PKAttachment_Weap_Shotgun_Base extends PainAttachment_Weap_Base
    abstract
    hidecategories(Navigation);

var float LastImpactSoundTime;

simulated function PlayImpactSounds(Actor HitActor, Vector SoundLocation, Vector FireDir, PhysicalMaterial PhysMaterial, class<EvilDmgType_Base> EvilBaseDamageType)
{
    local bool bPlaySoundThisTime;

    bPlaySoundThisTime = (WorldInfo.TimeSeconds - LastImpactSoundTime) > 0.5000000;
    // End:0x7F
    if(bPlaySoundThisTime)
    {
        super(EvilAttachment_Weap_Base).PlayImpactSounds(HitActor, SoundLocation, FireDir, PhysMaterial, EvilBaseDamageType);
    }
    LastImpactSoundTime = WorldInfo.TimeSeconds;
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
    // Reference: SkeletalMeshComponent'Default__PKAttachment_Weap_Shotgun_Base.SkeletalMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'SkeletalMeshComponent0'
    // Archetype: SkeletalMeshComponent'Default__PainAttachment_Weap_Base.SkeletalMeshComponent0'
    begin object name="SkeletalMeshComponent0"
        // Reference: UDKAnimNodeSequence'Default__PKAttachment_Weap_Shotgun_Base.SkeletalMeshComponent0.MeshSequenceA'
        // Archetype: UDKAnimNodeSequence'Default__PainAttachment_Weap_Base.SkeletalMeshComponent0.MeshSequenceA'
        begin object name="MeshSequenceA"
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    Mesh=SkeletalMeshComponent0
    WeaponClass=Class'PKWeap_Shotgun_Base'
    EvilWeapAnimType=EEvilWeapAnimType.EWWAT_Remington
    BloodBlobChance=0.7000000
}