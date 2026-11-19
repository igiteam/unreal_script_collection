class SeqAct_R6Achievement extends SequenceAction
    native
    hidecategories(Object);

enum ER6ScriptAchievement
{
    ER6ScriptAchievement_None,      // 0
    ER6ScriptAchievement_KilledMarcello,// 1
    ER6ScriptAchievement_MAX        // 2
};

var() SeqAct_R6Achievement.ER6ScriptAchievement m_eAchievementToUnlock;

defaultproperties
{
    VariableLinks=none
    ObjName="Give Achievement"
    ObjCategory="Player"
}