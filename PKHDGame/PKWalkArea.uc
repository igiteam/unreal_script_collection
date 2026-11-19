class PKWalkArea extends Actor
    placeable
    hidecategories(Navigation,Object);

var() array<PKNavPoint> NavPointList;
var bool bHasRegion;

defaultproperties
{
    // Reference: SpriteComponent'Default__PKWalkArea.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'Sprite'
    begin object name="Sprite" class=Class'Engine.SpriteComponent'
        ReplacementPrimitive=none
    end object
    Components[0]=Sprite
}