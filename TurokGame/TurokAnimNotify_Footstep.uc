class TurokAnimNotify_Footstep extends AnimNotify
    native
    editinlinenew
    collapsecategories
    hidecategories(Object);

var() @NULL SoundCue;
var() bool bFollowActor;
var() name BoneName;

simulated event Notify(@NULL Owner, @NULL SkelComponent)
{
    // End:0x87
    if(TurokPawn(Owner) != none)
    {
        // End:0x30
        if(int(TurokPawn(Owner).Physics) == int(2))
        {
            return;
        }
        // End:0x67
        if(BoneName == 'None')
        {
            TurokPawn(Owner).TryPlayFootStepSound('jt_Cog_C');            
        }
        else
        {
            TurokPawn(Owner).TryPlayFootStepSound(BoneName);
        }        
    }
    else
    {
        Owner.PlaySound(default.SoundCue, true, false, false, Owner.Location);
    }
    //return;    
}

defaultproperties
{
    SoundCue=SoundCue'SndCreatureHumanFeetDirt.CreatureHumanFeetDirtLeft_3P'
    bFollowActor=true
}