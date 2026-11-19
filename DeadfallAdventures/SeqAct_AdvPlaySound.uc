class SeqAct_AdvPlaySound extends SeqAct_Latent
    forcescriptorder(true)
    hidecategories(Object);

var Actor Player;
var() SoundCue Sound;
var() float StartPitch;
var() float TargetPitch;
var() float InterpolationStep;
var export editinline AudioComponent AudioComp;

event Activated()
{
    // End:0x85
    if(((AudioComp == none) && Sound != none) && Player != none)
    {
        AudioComp = Player.CreateAudioComponent(Sound, false, true, true, Player.Location, true);
    }
    // End:0x192
    if(AudioComp != none)
    {
        // End:0x124
        if(InputLinks[0].bHasImpulse)
        {
            // End:0x121
            if(!AudioComp.IsPlaying())
            {
                AudioComp.PitchMultiplier = StartPitch;
                AudioComp.Play();
            }            
        }
        else
        {
            // End:0x192
            if(InputLinks[1].bHasImpulse)
            {
                // End:0x192
                if(AudioComp.IsPlaying())
                {
                    AudioComp.Stop();
                    AudioComp = none;
                }
            }
        }
    }
    OutputLinks[0].bHasImpulse = true;
    //return;    
}

event bool Update(float DeltaTime)
{
    // End:0xE6
    if(AudioComp != none)
    {
        // End:0x82
        if(InputLinks[1].bHasImpulse)
        {
            // End:0x7F
            if(AudioComp.IsPlaying())
            {
                AudioComp.Stop();
                AudioComp = none;
                return false;
            }            
        }
        else
        {
            AudioComp.PitchMultiplier = FInterpTo(AudioComp.PitchMultiplier, TargetPitch, DeltaTime, InterpolationStep);
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    StartPitch=1.0000000
    TargetPitch=1.0000000
    InterpolationStep=0.1000000
    InputLinks[0]=(LinkDesc="Play",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[1]=(LinkDesc="Stop",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Object",LinkVar="None",PropertyName="Player",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Float',LinkedVariables=none,LinkDesc="Target Pitch",LinkVar="None",PropertyName="TargetPitch",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Adv Play Sound"
}