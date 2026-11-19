class AnimNotify_BulletTime extends AnimNotify_Scripted
    editinlinenew
    collapsecategories
    hidecategories(Object);

var() float TimeMultiplier;
var() float BlendTime;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    super.Notify(Owner, AnimSeqInstigator);
    // End:0xBB
    if(Class'Engine.WorldInfo'.static.GetWorldInfo().Game != none)
    {
        EvilGame(Class'Engine.WorldInfo'.static.GetWorldInfo().Game).BulletTimeBlendIn(TimeMultiplier, BlendTime);
    }
    //return;    
}

event NotifyEnd(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    super.NotifyEnd(Owner, AnimSeqInstigator);
    // End:0xB2
    if(Class'Engine.WorldInfo'.static.GetWorldInfo().Game != none)
    {
        EvilGame(Class'Engine.WorldInfo'.static.GetWorldInfo().Game).BulletTimeBlendOut(BlendTime);
    }
    //return;    
}

defaultproperties
{
    TimeMultiplier=0.3000000
    BlendTime=0.2000000
}