class PrefabInstance extends Actor
    native
    notplaceable
    hidecategories(lighting);

var const Prefab TemplatePrefab;
var const int TemplateVersion;
var native const map{VOID,VOID} ArchetypeToInstanceMap;
var const Sequence SequenceInstance;
var const array<byte> PI_Bytes;
var const array<Object> PI_CompleteObjects;
var const array<Object> PI_ReferencedObjects;
var const array<string> PI_SavedNames;
var native const map{VOID,VOID} PI_ObjectMap;

defaultproperties
{
    // Reference: SpriteComponent'Default__PrefabInstance.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__Actor.Sprite'
    begin object name="Sprite"
        Sprite=Texture2D'EngineResources.PrefabSprite'
    end object
    Components[0]=Sprite
}