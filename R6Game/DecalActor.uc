class DecalActor extends Actor
    native
    placeable
    hidecategories(lighting);

var() const editconst export editinline DecalComponent Decal;

defaultproperties
{
    // Reference: DecalComponent'Default__DecalActor.NewDecalComponent'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="NewDecalComponent" class=Class'DecalComponent'
        bStaticDecal=true
    end object
    Decal=NewDecalComponent
    bStatic=true
    bMovable=false
    // Reference: SpriteComponent'Default__DecalActor.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__Actor.Sprite'
    begin object name="Sprite"
    end object
    Components[0]=Sprite
    Components[1]=NewDecalComponent
    // Reference: ArrowComponent'Default__DecalActor.ArrowComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="ArrowComponent0" class=Class'ArrowComponent'
    end object
    Components[2]=ArrowComponent0
}