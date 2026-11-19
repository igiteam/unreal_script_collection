class SkySeqEvent_CheckpointActivated extends SequenceEvent
    native;

var() int CheckpointNumber;

static function Activate(Sequence Seq, Actor OrigInstig, int Checkpoint)
{
    local array<SequenceObject> AllCheckpointEvents;
    local SkySeqEvent_CheckpointActivated ChkEvt;
    local int Idx;

    // End:0xA5
    if(Seq != none)
    {
        Seq.FindSeqObjectsByClass(Class'SkySeqEvent_CheckpointActivated', true, AllCheckpointEvents);
        Idx = 0;
        J0x2D:

        // End:0xA5 [Loop If]
        if(Idx < AllCheckpointEvents.Length)
        {
            ChkEvt = SkySeqEvent_CheckpointActivated(AllCheckpointEvents[Idx]);
            // End:0x9B
            if((ChkEvt != none) && ChkEvt.CheckpointNumber == Checkpoint)
            {
                // End:0x9B
                if(!ChkEvt.CheckActivate(OrigInstig, OrigInstig))
                {
                }
            }
            Idx++;
            // [Loop Continue]
            goto J0x2D;
        }
    }
    //return;    
}
