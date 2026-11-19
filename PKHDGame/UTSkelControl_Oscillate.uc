class UTSkelControl_Oscillate extends SkelControlSingleBone
    hidecategories(Object,Object,Rotation);

var() Vector MaxDelta;
var() float Period;
var() float CurrentTime;
var bool bReverseDirection;

event TickSkelControl(float DeltaTime, SkeletalMeshComponent SkelComp)
{
    // End:0x74
    if(bReverseDirection)
    {
        CurrentTime -= DeltaTime;
        // End:0x71
        if(CurrentTime <= -Period)
        {
            CurrentTime = -Period - (CurrentTime + Period);
            bReverseDirection = false;
        }        
    }
    else
    {
        CurrentTime += DeltaTime;
        // End:0xD4
        if(CurrentTime >= Period)
        {
            CurrentTime = Period - (CurrentTime - Period);
            bReverseDirection = true;
        }
    }
    BoneTranslation = MaxDelta * (CurrentTime / Period);
    //return;    
}

defaultproperties
{
    Period=0.5000000
    bApplyTranslation=true
    bAddTranslation=true
    bIgnoreWhenNotRendered=true
    bShouldTickInScript=true
}