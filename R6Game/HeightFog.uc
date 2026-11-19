class HeightFog extends Info
    placeable
    hidecategories(lighting,Movement,Collision);

var() const editconst export editinline HeightFogComponent Component;

defaultproperties
{
    // Reference: HeightFogComponent'Default__HeightFog.HeightFogComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="HeightFogComponent0" class=Class'HeightFogComponent'
    end object
    Component=HeightFogComponent0
    bStatic=true
    // Reference: SpriteComponent'Default__HeightFog.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__Info.Sprite'
    begin object name="Sprite"
    end object
    Components[0]=Sprite
    Components[1]=HeightFogComponent0
}