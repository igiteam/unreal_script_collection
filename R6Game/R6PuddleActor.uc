class R6PuddleActor extends Actor
    native
    notplaceable
    hidecategories(lighting);

var export editinline R6PuddleComponent puddleComponent;
var() MaterialInstance puddleMaterial;

// Export UR6PuddleActor::execAddLiquid(FFrame&, void* const)
native final function AddLiquid(Vector liquidLocation, float Amount);

defaultproperties
{
    // Reference: R6PuddleComponent'Default__R6PuddleActor.R6PuddleComponent0'
    begin object name="R6PuddleComponent0" class=Class'R6Game.R6PuddleComponent'
    end object
    puddleComponent=R6PuddleComponent0
    // Reference: SpriteComponent'Default__R6PuddleActor.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Engine.Default__Actor.Sprite'
    begin object name="Sprite"
    end object
    Components[0]=Sprite
    Components[1]=R6PuddleComponent0
}