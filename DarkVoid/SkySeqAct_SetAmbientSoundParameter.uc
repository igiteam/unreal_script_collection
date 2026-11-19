class SkySeqAct_SetAmbientSoundParameter extends SequenceAction;

var Keypoint AmbSound;
var() name ParameterName;
var() float ParameterValue;

event Activated()
{
    local AmbientSound Ambience;
    local SkyAmbientSoundPointToPoint PointToPointAmbience;

    Ambience = AmbientSound(AmbSound);
    // End:0x42
    if(Ambience != none)
    {
        Ambience.AudioComponent.SetFloatParameter(ParameterName, ParameterValue);        
    }
    else
    {
        PointToPointAmbience = SkyAmbientSoundPointToPoint(AmbSound);
        // End:0x81
        if(PointToPointAmbience != none)
        {
            PointToPointAmbience.Sound.SetFloatParameter(ParameterName, ParameterValue);
        }
    }
    super(SequenceOp).Activated();
    //return;    
}

static event int GetObjClassVersion()
{
    return 1;
    //return ReturnValue;    
}
