class SeqAct_SkillDropDiscovered extends SequenceAction
    native
    hidecategories(Object);

var() string Message;
var() name LocalizedName;

event LoadLocalizedStrings()
{
    Message = GetLocalizedStr(Message, string(LocalizedName), "TEXT", "UIStrings");
    //return;    
}

defaultproperties
{
    ObjName="Skill Drop Discovered"
    ObjCategory="Air Drop"
}