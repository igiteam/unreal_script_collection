class SPAnimBlendByValueEvaluator extends SPAnimBaseNode
    native;

struct native SPAnimBlendByValueEvaluatorConstarints
{
    var() float m_Value;
    var() float m_percentOverlapWithPrevious;

    structdefaultproperties
    {
        m_Value=0.0000000
        m_percentOverlapWithPrevious=100.0000000
    }
};

var float m_maxRateOfChange;
var float m_Value;
var float m_ClampMin;
var float m_ClampMax;
/** Variable Declaration */
var() export editinline SPValueEvaluate SPValueEvaluator;
var() editfixedsize export editinline array<export editinline SPAnimBlendByValueEvaluatorConstarints> Constraints;
