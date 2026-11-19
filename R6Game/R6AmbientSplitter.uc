class R6AmbientSplitter extends Actor
    native
    placeable
    hidecategories(lighting);

var(AmbienceSplit) ZoneInfo ZoneA;
var(AmbienceSplit) name ZoneATag;
var(AmbienceSplit) float fRadiusZoneA;
var(AmbienceSplit) ZoneInfo ZoneB;
var(AmbienceSplit) name ZoneBTag;
var(AmbienceSplit) float fRadiusZoneB;
var(AmbienceSplit) Actor m_AttachedActor;

defaultproperties
{
    bNoDelete=true
    // Reference: SpriteComponent'Default__R6AmbientSplitter.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__Actor.Sprite'
    begin object name="Sprite"
        Sprite=Texture2D'EngineResources.S_Emitter'
    end object
    Components[0]=Sprite
}