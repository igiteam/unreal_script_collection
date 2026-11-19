class AdvFocusHighlightComponent_UpgradesMayan extends AdvFocusHighlightComponent_Upgrades
    editinlinenew
    hidecategories(Object,Physics,Collision);

protected static simulated function class<AdvFocusHighlightComponent> GetComponentClass()
{
    return Class'AdvFocusHighlightComponent_UpgradesMayan';
    //return ReturnValue;    
}

defaultproperties
{
    HighlightMaterial=MaterialInstanceConstant'adv_ps_Upgrade.Materials.mi_en_Ornaments_02_03'
    SkeletalHighlightMaterial=MaterialInstanceConstant'adv_ps_Upgrade.Materials.mi_en_Ornaments_02_03'
    ReplacementPrimitive=none
}