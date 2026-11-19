class R6SnipePoint extends R6InfoPoint
    native
    hidecategories(lighting,Object,Actor,Advanced,Attachment,Collision,Display,Fire,Heat,CubemapSample,Reticule,Region,R6Sound,R6SoundPropagation);

var() Color m_Color;
var R6AreaOfOperation m_pAreaOfOperation;
var R6TeamManager m_pTeamManager;
var R6Pawn m_pSniper;

defaultproperties
{
    m_Color=(R=100,G=150,B=100,A=0)
    // Reference: SpriteComponent'Default__R6SnipePoint.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Engine.Default__R6InfoPoint.Sprite'
    begin object name="Sprite"
        Sprite=Texture2D'AIIcons.AISnipePoint_Pic'
    end object
    Components[0]=Sprite
    // Reference: ArrowComponent'Default__R6SnipePoint.Arrow'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="Arrow" class=Class'Engine.ArrowComponent'
        ArrowColor=(R=150,G=200,B=255,A=255)
        ArrowSize=1.5000000
    end object
    Components[1]=Arrow
}