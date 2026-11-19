class R6PatrolPoint extends R6InfoPoint
    native
    hidecategories(lighting,Object,Actor,Advanced,Attachment,Collision,Display,Fire,Heat,CubemapSample,Reticule,Region,R6Sound,R6SoundPropagation);

var() Actor m_pWaitFocus;
var() float m_fSleepTime;
var() float m_fRandomStopPercentage;
var() float m_fMoveSpeedRatio;
var() Actor.ER6MoveFlags m_eMoveFlag;
var() Actor m_pMoveFocus;

defaultproperties
{
    m_fMoveSpeedRatio=1.0000000
    m_eMoveFlag=1
    // Reference: SpriteComponent'Default__R6PatrolPoint.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Engine.Default__R6InfoPoint.Sprite'
    begin object name="Sprite"
        Sprite=Texture2D'AIIcons.AIPatrolPoint_Pic'
    end object
    Components[0]=Sprite
    SupportedEvents=/* Array type was not detected. */
}