class TurokTestMessage extends TurokCommentaryMessage
    transient;

function Init(@NULL ctrl, @NULL PRI1, @NULL PRI2, @NULL Object, optional int Switch = 0)
{
    super(TurokLocalizedMessage).Init(ctrl, PRI1, PRI2, Object, Switch);
    //return;    
}

function string GetText()
{
    return "This is a Test String";
    //return ReturnValue;    
}
