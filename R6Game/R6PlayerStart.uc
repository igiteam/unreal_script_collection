class R6PlayerStart extends PlayerStart
    native
    hidecategories(lighting,lighting,LightColor,Force);

struct TeammateStart
{
    var() R6EngineEnums.ERainbowMembers m_eTeammate;
    var() Vector m_vRelativeLocation;
    var() R6EquipmentTemplate m_TeammateEquipment;
    var() R6CharacterTemplate m_TeammateCharacterTemplate;

    structdefaultproperties
    {
        m_eTeammate=0
        m_vRelativeLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_TeammateEquipment=none
        m_TeammateCharacterTemplate=none
    }
};

var(Teammate) array<TeammateStart> m_TeammateStarts;
var(Player) R6CharacterTemplate m_PlayerCharacterTemplate;
var(HelicopterStart) bool m_bPlayerStartInHelicopter;
var(HelicopterStart) bool m_bTeammateStartInHelicopter;
var(HelicopterStart) R6Helicopter m_Helicopter;
var(TeamGame) R6GameEnums.ETEAMIDENTITY m_eTeamNumber;
var array<Texture2D> m_CustomSprites;

simulated function byte GetTeamNum()
{
    return m_eTeamNumber;
    return;
}

defaultproperties
{
    m_eTeamNumber=2
    m_CustomSprites[0]=Texture2D'KellerResource.R6spawn_a'
    m_CustomSprites[1]=Texture2D'KellerResource.R6spawn_b'
    m_CustomSprites[2]=Texture2D'KellerResource.R6spawn_default'
    bStatic=false
    m_bDeleteOnReset=false
    TickGroup=1
}