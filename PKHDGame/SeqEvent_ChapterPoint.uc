class SeqEvent_ChapterPoint extends SequenceEvent
    forcescriptorder(true)
    hidecategories(Object,SequenceEvent);

var() EvilTypes.EChapterPoint Chapter;

event Activated()
{
    super(SequenceOp).Activated();
    //return;    
}

defaultproperties
{
    bPlayerOnly=false
    VariableLinks=none
    ObjName="Chapter Point"
}