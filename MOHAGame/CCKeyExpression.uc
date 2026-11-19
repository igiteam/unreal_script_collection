class CCKeyExpression extends CCKey
    editinlinenew
    hidecategories(Object,Object);

var(Expression) string ExpressionName;
var(Expression) float Strength;
var(Expression) float EaseInTime_sec;
var(Expression) float EaseOutTime_sec;

function string GetDebugString()
{
    return (((((((super.GetDebugString() $ ", FacialExpression=") $ ExpressionName) $ ", Strength=") $ string(Strength)) $ ", EaseInTime_sec=") $ string(EaseInTime_sec)) $ ", EaseOutTime_sec=") $ string(EaseOutTime_sec);
    //return ReturnValue;    
}

defaultproperties
{
    Strength=1.0000000
    EaseInTime_sec=0.5000000
    EaseOutTime_sec=0.5000000
}