class ForceFeedbackWaveform extends Object
    native
    editinlinenew
    noexport;

enum EWaveformFunction
{
    WF_Constant,                    // 0
    WF_LinearIncreasing,            // 1
    WF_LinearDecreasing,            // 2
    WF_Sin0to90,                    // 3
    WF_Sin90to180,                  // 4
    WF_Sin0to180,                   // 5
    WF_Noise,                       // 6
    WF_MAX                          // 7
};

struct WaveformSample
{
    var() byte LeftAmplitude;
    var() byte RightAmplitude;
    var() ForceFeedbackWaveform.EWaveformFunction LeftFunction;
    var() ForceFeedbackWaveform.EWaveformFunction RightFunction;
    var() float Duration;

    structdefaultproperties
    {
        LeftAmplitude=0
        RightAmplitude=0
        LeftFunction=0
        RightFunction=0
        Duration=0.0000000
    }
};

var() bool bIsLooping;
var() array<WaveformSample> Samples;
