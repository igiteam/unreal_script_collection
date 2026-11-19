class R6ScriptSocketsActor extends Actor
    native
    placeable
    hidecategories(lighting,Object,Actor,Advanced,Attachment,Collision,Display,Fire,Heat,CubemapSample,Reticule,MPModes,Region,R6Sound,R6SoundPropagation);

var() R6ScriptedSequenceSockets m_pScriptSocketsInfo;
var array<R6ScriptSocket> m_Sockets;

defaultproperties
{
    // Reference: SpriteComponent'Default__R6ScriptSocketsActor.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Engine.Default__Actor.Sprite'
    begin object name="Sprite"
        Sprite=Texture2D'AIIcons.AIPatrolPoint_Pic'
    end object
    Components[0]=Sprite
    // Reference: ArrowComponent'Default__R6ScriptSocketsActor.ArrowComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="ArrowComponent0" class=Class'Engine.ArrowComponent'
        ArrowColor=(R=0,G=255,B=0,A=255)
        ArrowSize=1.5000000
    end object
    Components[1]=ArrowComponent0
    // Reference: ArrowComponent'Default__R6ScriptSocketsActor.ArrowComponent1'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="ArrowComponent1" class=Class'Engine.ArrowComponent'
        ArrowSize=1.5000000
        Rotation=(Pitch=0,Yaw=16384,Roll=0)
    end object
    Components[2]=ArrowComponent1
    // Reference: ArrowComponent'Default__R6ScriptSocketsActor.ArrowComponent2'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="ArrowComponent2" class=Class'Engine.ArrowComponent'
        ArrowColor=(R=0,G=0,B=255,A=255)
        ArrowSize=1.5000000
        Rotation=(Pitch=16384,Yaw=0,Roll=0)
    end object
    Components[3]=ArrowComponent2
    TickGroup=1
}