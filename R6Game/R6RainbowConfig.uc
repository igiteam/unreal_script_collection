class R6RainbowConfig extends R6Config
    native
    hidecategories(Object);

var(FormationParams) int m_iFormationAngle;
var(FormationParams) float m_fFormationDistance;
var(StackParams) float m_fStackDistance;
var(WingParams) float m_fWingDistance;

defaultproperties
{
    m_iFormationAngle=4200
    m_fFormationDistance=400.0000000
    m_fStackDistance=100.0000000
    m_fWingDistance=120.0000000
    m_szDescription="Rainbow configuration"
}