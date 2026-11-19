class Trigger extends Actor
    native
    placeable
    hidecategories(lighting);

var() const editconst export editinline CylinderComponent CylinderComponent;

defaultproperties
{
    // Reference: CylinderComponent'Default__Trigger.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="CollisionCylinder" class=Class'CylinderComponent'
        CollisionHeight=40.0000000
        CollisionRadius=40.0000000
        CollideActors=true
    end object
    CylinderComponent=CollisionCylinder
    bStatic=true
    bHidden=true
    bCollideActors=true
    // Reference: SpriteComponent'Default__Trigger.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__Actor.Sprite'
    begin object name="Sprite"
        Sprite=Texture2D'EngineResources.S_Trigger'
        HiddenGame=false
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    CollisionComponent=CollisionCylinder
    SupportedEvents[0]=Class'SeqEvent_Touch'
    SupportedEvents[1]=Class'SeqEvent_Destroyed'
    SupportedEvents[2]=Class'SeqEvent_TakeDamage'
    SupportedEvents[3]=Class'SeqEvent_R6LookedAt'
    SupportedEvents[4]=Class'SeqEvent_Used'
}