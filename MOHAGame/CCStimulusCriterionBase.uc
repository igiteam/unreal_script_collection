class CCStimulusCriterionBase extends Object
    native
    editinlinenew;

enum ECCComparison
{
    CC_COMPARISON_LESS_THAN,        // 0
    CC_COMPARISON_EQUALS,           // 1
    CC_COMPARISON_GREATER_THAN,     // 2
    CC_COMPARISON_MAX               // 3
};

function bool StimulusMatches(CCPerformerNative Performer, CCStimulus Stimulus)
{
    return true;
    //return ReturnValue;    
}
