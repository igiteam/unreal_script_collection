class SeqAct_ChangeAggressionLevel extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() EvilTypes.EAggressionLevel AggressionLevel;

defaultproperties
{
    AggressionLevel=EAggressionLevel.AL_Normal
    ObjName="Change Aggresion Level"
}