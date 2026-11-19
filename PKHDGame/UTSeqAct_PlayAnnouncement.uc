class UTSeqAct_PlayAnnouncement extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() ObjectiveAnnouncementInfo Announcement;

event Activated()
{
    local WorldInfo WI;

    WI = GetWorldInfo();
    WI.BroadcastLocalizedMessage(Class'UTKismetAnnouncement', 0, none, none, self);
    //return;    
}

defaultproperties
{
    bCallHandler=false
    VariableLinks=none
    ObjName="Play Announcement"
}