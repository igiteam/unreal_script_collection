class MOHAAnimChooseEntry extends MOHAAnimPlayByBase
    native
    hidecategories(Object,Object,Object,Object,AnimNodeBlendList);

enum CHOOSEENTRYNODE_IDX
{
    CHOOSEENTRY_NOLOCO,             // 0
    CHOOSEENTRY_LOCO,               // 1
    CHOOSEENTRY_MAX                 // 2
};

struct native EntryAnimInfoData
{
    var float StandDist;
    var float CrouchDist;

    structdefaultproperties
    {
        StandDist=0.0000000
        CrouchDist=0.0000000
    }
};

var transient array<EntryAnimInfoData> EntryAnimInfo;

event OnInit()
{
    local MOHAAIPawn Pawn;

    // End:0xC4
    if((SkelComponent != none) && SkelComponent.Owner != none)
    {
        Pawn = MOHAAIPawn(SkelComponent.Owner);
        // End:0xC4
        if((Pawn != none) && Pawn.ActiveOIR != none)
        {
            // End:0x8F
            if(Children[0].Anim != none)
            {
                Pawn.ActiveOIR.AddAvailableOIREntry(1);
            }
            // End:0xC4
            if(Children[1].Anim != none)
            {
                Pawn.ActiveOIR.AddAvailableOIREntry(2);
            }
        }
    }
    StopAnim();
    //return;    
}

event int GetChildIndexToPlay()
{
    local MOHAAIPawn Pawn;

    // End:0xD2
    if((SkelComponent != none) && SkelComponent.Owner != none)
    {
        Pawn = MOHAAIPawn(SkelComponent.Owner);
        // End:0xD2
        if(Pawn != none)
        {
            // End:0x80
            if((Pawn.ActiveOIR.DesiredOIREntry == 1) && Children[0].Anim != none)
            {
                return 0;                
            }
            else
            {
                // End:0xB9
                if((Pawn.ActiveOIR.DesiredOIREntry == 2) && Children[1].Anim != none)
                {
                    return 1;
                }
            }
            Pawn.ActiveOIR.DesiredOIREntry = 0;
        }
    }
    return 0;
    //return ReturnValue;    
}

defaultproperties
{
    Children=/* Array type was not detected. */
    bFixNumChildren=true
}