class TurokSeqAct_TrackShotgun extends SequenceAction
    hidecategories(Object);

enum eTrackTag
{
    ETT_Begin,                      // 0
    ETT_End,                        // 1
    ETT_None,                       // 2
    ETT_MAX                         // 3
};

var() byte mTrackTag;

event Activated()
{
    // End:0x26
    if(int(mTrackTag) == int(0))
    {
        Class'TurokAchievementTracker'.static.BeginTrackingShotgunUse();        
    }
    else
    {
        // End:0x49
        if(int(mTrackTag) == int(1))
        {
            Class'TurokAchievementTracker'.static.EndTrackingShotgunUse();
        }
    }
    //return;    
}

defaultproperties
{
    mTrackTag=2
    ObjName="Track Shotgun Use"
    ObjCategory="Turok Achievements"
}