class R6ActionSpot extends R6InfoPoint
    native
    hidecategories(lighting,Object,Actor,Advanced,Attachment,Collision,Display,Fire,Heat,CubemapSample,Reticule,Region,R6Sound,R6SoundPropagation);

var() editinline R6ObstacleAllowance m_pObstacleAllowance;
var() bool m_bInterruptMoveTo;
var() bool m_bFire;
var() Actor.ER6MoveFlags m_eMoveFlag;
var sObjective m_sDefaultObjective;
var transient int m_bUsed;

defaultproperties
{
    m_bFire=true
    m_eMoveFlag=4
    m_sDefaultObjective=(m_eObjectiveType=2,m_nNameId="None",m_fMaxDistanceFromStartLocation=0.0000000,m_aActors=none,m_bIsMobile=false,m_bCanBeLeader=false,m_bFollowInFormation=false,m_fFormationDistance=0.0000000,m_fFormationAngle=0.0000000,m_fAttackTimeDelay=1.0000000)
    // Reference: SpriteComponent'Default__R6ActionSpot.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Engine.Default__R6InfoPoint.Sprite'
    begin object name="Sprite"
        Sprite=Texture2D'AIIcons.AIActionSpot_Pic'
    end object
    Components[0]=Sprite
    // Reference: ArrowComponent'Default__R6ActionSpot.Arrow'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="Arrow" class=Class'Engine.ArrowComponent'
        ArrowColor=(R=150,G=200,B=255,A=255)
        ArrowSize=1.5000000
    end object
    Components[1]=Arrow
    SupportedEvents=/* Array type was not detected. */
}