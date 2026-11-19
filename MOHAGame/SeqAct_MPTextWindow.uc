class SeqAct_MPTextWindow extends SequenceAction
    native
    hidecategories(Object);

var() MOHAMultiplayerController.MPTextWindowTypes messagetype;
var() name MessageName;
var() string Message;

event LoadLocalizedStrings()
{
    Message = GetLocalizedStr(Message, string(MessageName), "Message", "Objectives");
    //return;    
}

defaultproperties
{
    messagetype=2
    VariableLinks=none
    ObjName="MP Text Window Message"
    ObjCategory="MPGame"
}