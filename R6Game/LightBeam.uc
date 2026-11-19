class LightBeam extends Actor
    native
    placeable
    hidecategories(lighting);

var() noclear export editinline LightBeamSpotLightComponent m_SpotLight;
var() noclear export editinline LightBeamComponent m_LightBeam;

defaultproperties
{
    // Reference: LightBeamSpotLightComponent'Default__LightBeam.LightBeamSpotLightComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="LightBeamSpotLightComponent0" class=Class'LightBeamSpotLightComponent'
    end object
    m_SpotLight=LightBeamSpotLightComponent0
    // Reference: LightBeamComponent'Default__LightBeam.LightBeamComponent0'
    begin object name="LightBeamComponent0" class=Class'Engine.LightBeamComponent'
    end object
    m_LightBeam=LightBeamComponent0
    bStatic=true
    // Reference: SpriteComponent'Default__LightBeam.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__Actor.Sprite'
    begin object name="Sprite"
        Sprite=Texture2D'KellerResource.r6_LightBeams'
    end object
    Components[0]=Sprite
    Components[1]=LightBeamSpotLightComponent0
    Components[2]=LightBeamComponent0
    // Reference: ArrowComponent'Default__LightBeam.ArrowComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="ArrowComponent0" class=Class'ArrowComponent'
    end object
    Components[3]=ArrowComponent0
    TickGroup=1
    Rotation=(Pitch=-16384,Yaw=0,Roll=0)
}