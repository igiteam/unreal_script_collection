class AnimNotify_BulletTime extends AnimNotify_Scripted
    editinlinenew
    collapsecategories
    hidecategories(Object);

var() float TimeMultiplier;
var() float BlendTime;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    //return;    
}

event NotifyEnd(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    //return;    
}

defaultproperties
{
    TimeMultiplier=0.3000000
    BlendTime=0.2000000
}