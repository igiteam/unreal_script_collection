class UTKismetAnnouncement extends UTObjectiveSpecificMessage;

static function ObjectiveAnnouncementInfo GetObjectiveAnnouncement(byte MessageIndex, Object Objective, PlayerController PC)
{
    local UTSeqAct_PlayAnnouncement Action;
    local ObjectiveAnnouncementInfo EmptyAnnouncement;

    Action = UTSeqAct_PlayAnnouncement(Objective);
    return ((Action != none) ? Action.Announcement : EmptyAnnouncement);
    //return ReturnValue;    
}

static function byte AnnouncementLevel(byte MessageIndex)
{
    return 1;
    //return ReturnValue;    
}

defaultproperties
{
    Lifetime=2.5000000
    DrawColor=(R=0,G=160,B=255,A=255)
    FontSize=2
}