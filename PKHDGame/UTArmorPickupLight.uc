class UTArmorPickupLight extends Light
    hidecategories(Navigation);

defaultproperties
{
    // Reference: PointLightComponent'Default__UTArmorPickupLight.PointLightComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'PointLightComponent0'
    begin object name="PointLightComponent0" class=Class'Engine.PointLightComponent'
        Radius=128.0000000
        Brightness=2.0000000
        LightColor=(R=251,G=239,B=155,A=0)
        CastDynamicShadows=false
        UseDirectLightMap=true
        LightingChannels=(Dynamic=false)
        LightAffectsClassification=ELightAffectsClassification.LAC_STATIC_AFFECTING
    end object
    LightComponent=PointLightComponent0
    Components[0]=none
    Components[1]=PointLightComponent0
    DrawScale=0.2500000
}