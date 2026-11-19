class SeqAct_SetAIControllerParams extends SequenceAction
    hidecategories(Object);

var() float ReloadPlayRate;
var() int PawnSkill;
var() int PawnSkillMax;

defaultproperties
{
    ReloadPlayRate=0.5000000
    PawnSkill=1
    PawnSkillMax=3
    ObjName="Set AI Controller Paramaters"
    ObjCategory="Kynapse AI"
}