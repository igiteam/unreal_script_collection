class SoundNodeSPParamSelector extends SoundNode
    native
    editinlinenew
    collapsecategories;

struct native FloatRange
{
    var() float Min;
    var() float Max;

    structdefaultproperties
    {
        Min=0.0000000
        Max=0.0000000
    }
};

var() name Param;
var() FloatRange RestrictInput;
var() editfixedsize array<FloatRange> Ranges;
