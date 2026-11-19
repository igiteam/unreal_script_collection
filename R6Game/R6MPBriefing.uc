class R6MPBriefing extends Object
    native;

enum ER6BriefingNodeType
{
    BNT_Text,                       // 0
    BNT_Voice,                      // 1
    BNT_PipObjective,               // 2
    BNT_PipClose,                   // 3
    BNT_RadarObjective,             // 4
    BNT_CloseAll,                   // 5
    BNT_MAXCOUNT,                   // 6
    BNT_MAX                         // 7
};

struct R6BriefingNode
{
    var R6MPBriefing.ER6BriefingNodeType EType;
    var float fTime;
    var int iObjective;

    structdefaultproperties
    {
        EType=0
        fTime=0.0000000
        iObjective=0
    }
};

var /*0x04000000-0x00000000*/ array<SoundCue> m_aVoiceOffTeamA;
var /*0x04000000-0x00000000*/ array<SoundCue> m_aVoiceOffTeamB;
var string m_szGameModeExtention;
var array<R6BriefingNode> m_aBriefingNode;
var array<Actor> m_aObjectives;

defaultproperties
{
    m_szGameModeExtention="None"
}