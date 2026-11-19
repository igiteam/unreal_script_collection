class PKElectroBeamLightActor extends Actor
    notplaceable
    hidecategories(Navigation);

var export editinline PointLightComponent BeamLight;

defaultproperties
{
    // Reference: PointLightComponent'Default__PKElectroBeamLightActor.LightComponentB'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'LightComponentB'
    begin object name="LightComponentB" class=Class'Engine.PointLightComponent'
        Radius=190.0000000
        FalloffExponent=5.0000000
        Brightness=5.0000000
        LightColor=(R=78,G=78,B=171,A=255)
        CastShadows=false
    end object
    BeamLight=LightComponentB
    Components[0]=LightComponentB
    bGameRelevant=true
}