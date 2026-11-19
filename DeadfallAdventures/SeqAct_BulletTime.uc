class SeqAct_BulletTime extends SeqAct_Latent
    forcescriptorder(true)
    hidecategories(Object);

var() float Duration;
var() float TimeMultiplier;
var() float BlendTime;
var float Time;
var transient bool bBlendingOut;

event Activated()
{
    OutputLinks[0].bHasImpulse = false;
    Time = Class'Engine.WorldInfo'.static.GetWorldInfo().AudioTimeSeconds;
    EvilGame(Class'Engine.WorldInfo'.static.GetWorldInfo().Game).BulletTimeBlendIn(TimeMultiplier, BlendTime);
    bBlendingOut = false;
    //return;    
}

event bool Update(float DeltaTime)
{
    local float D;

    D = Class'Engine.WorldInfo'.static.GetWorldInfo().AudioTimeSeconds - Time;
    // End:0x171
    if(D >= (Duration - BlendTime))
    {
        // End:0xFA
        if(D >= Duration)
        {
            // End:0xED
            if(!bBlendingOut)
            {
                EvilGame(Class'Engine.WorldInfo'.static.GetWorldInfo().Game).BulletTimeBlendOut(BlendTime);
            }
            ActivateOutputLink(0);
            return false;
        }
        // End:0x171
        if(!bBlendingOut)
        {
            EvilGame(Class'Engine.WorldInfo'.static.GetWorldInfo().Game).BulletTimeBlendOut(BlendTime);
            bBlendingOut = true;
        }
    }
    return true;
    //return ReturnValue;    
}

defaultproperties
{
    TimeMultiplier=0.3000000
    BlendTime=0.2000000
    bAutoActivateOutputLinks=false
    ObjName="Bullet Time"
}