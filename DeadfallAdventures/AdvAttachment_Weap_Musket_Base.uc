class AdvAttachment_Weap_Musket_Base extends AdvAttachment_Weap_Base
    abstract
    hidecategories(Navigation);

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__AdvAttachment_Weap_Musket_Base.SkeletalMeshComponent0'
    begin object name=SkeletalMeshComponent0
        ReplacementPrimitive=none
    end object
    Mesh=SkeletalMeshComponent0
    MuzzleFlashSocket="MuzzleFlashSocket"
    WeaponClass=Class'AdvWeap_Musket_Base'
    EvilWeapAnimType=EEvilWeapAnimType.EEWAT_Vector
}