class SkySeqAct_FollowSpline extends SequenceAction
    native;

struct native s_FollowSplineData
{
    var InterpTrackSplinePath SplinePath;
    var() protectedwrite string SplinePathName;
    var(Roll) bool bOverideUseSplineRoll;
    var(Roll) bool bUseSplineRoll;
    var(Tolerance) bool bOverideTolerance;
    var(Tolerance) float ToleranceOveride;
    var(Looping) bool bOverideLooping;
    var(Looping) bool bLooping;
    var(SeeEnemy) bool bQuitSplineWhenSeeEnemyOveride;
    var(SeeEnemy) bool bQuitSplineWhenSeeEnemy;
    var(Precision) bool bOverideUseAggressivePrecision;
    var(Precision) bool bUseAggressivePrecision;
    var(PrecisionLowestMPH) bool bOverideLowestDesiredMPH;
    var(PresisionLowestMPH) float LowestDesiredMPH;
    var() bool bFollowSplineReversed;
    var bool bSlowDownIfNeededOveride;
    var bool bSlowDownIfNeeded;

    structdefaultproperties
    {
        SplinePath=none
        SplinePathName=""
        bOverideUseSplineRoll=false
        bUseSplineRoll=false
        bOverideTolerance=false
        ToleranceOveride=0.0000000
        bOverideLooping=false
        bLooping=false
        bQuitSplineWhenSeeEnemyOveride=false
        bQuitSplineWhenSeeEnemy=false
        bOverideUseAggressivePrecision=false
        bUseAggressivePrecision=false
        bOverideLowestDesiredMPH=false
        LowestDesiredMPH=35.0000000
        bFollowSplineReversed=false
        bSlowDownIfNeededOveride=false
        bSlowDownIfNeeded=true
    }
};

var() bool bExitSplineFollowing;
var() array<s_FollowSplineData> Data;
