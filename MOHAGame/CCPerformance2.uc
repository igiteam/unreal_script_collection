class CCPerformance2 extends Object
    native
    editinlinenew
    hidecategories(Object);

enum EPauseAIRequirement
{
    CC_PAUSE_AI_NOT_REQUIRED,       // 0
    CC_PAUSE_AI_OPTIONAL,           // 1
    CC_PAUSE_AI_REQUIRED,           // 2
    CC_PAUSE_AI_MAX                 // 3
};

var(Performance) CCStimulusType StimulusType;
var(Performance) bool bOverrideAudioDuration;
var(Performance) bool bDeferOutputStim;
var(Performance) CCPerformance2.EPauseAIRequirement PauseAIRequirement;
var(Performance) int PauseImportance;
var(Channels) noclear export editinline CCChannelAudio AudioChannel;
var(Channels) noclear export editinline CCChannelPALookAt PALookAtChannel;
var(Channels) noclear export editinline CCChannelExpression ExpressionChannel;
var(Channels) noclear export editinline CCChannelOutputStim OutputStimChannel;

defaultproperties
{
    // Reference: CCChannelAudio'Default__CCPerformance2.AudioCh'
    begin object name=AudioCh class=Class'CCChannelAudio'
    end object
    AudioChannel=AudioCh
    // Reference: CCChannelPALookAt'Default__CCPerformance2.PALookAtCh'
    begin object name=PALookAtCh class=Class'CCChannelPALookAt'
    end object
    PALookAtChannel=PALookAtCh
    // Reference: CCChannelExpression'Default__CCPerformance2.ExpressionCh'
    begin object name=ExpressionCh class=Class'CCChannelExpression'
    end object
    ExpressionChannel=ExpressionCh
    // Reference: CCChannelOutputStim'Default__CCPerformance2.OutputStimCh'
    begin object name=OutputStimCh class=Class'CCChannelOutputStim'
    end object
    OutputStimChannel=OutputStimCh
}