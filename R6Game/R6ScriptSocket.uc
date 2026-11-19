class R6ScriptSocket extends Actor
    native
    notplaceable
    hidecategories(lighting,Object,Actor,Advanced,Attachment,Collision,Display,Fire,Heat,CubemapSample,Reticule,MPModes,Region,R6Sound,R6SoundPropagation);

var transient bool m_bParentTurn;
var transient bool m_bParentMove;

defaultproperties
{
    // Reference: SpriteComponent'Default__R6ScriptSocket.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Engine.Default__Actor.Sprite'
    begin object name="Sprite"
    end object
    Components[0]=Sprite
    // Reference: ArrowComponent'Default__R6ScriptSocket.ArrowComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="ArrowComponent0" class=Class'Engine.ArrowComponent'
        ArrowColor=(R=255,G=255,B=0,A=255)
        ArrowSize=1.5000000
    end object
    Components[1]=ArrowComponent0
    TickGroup=1
}