class CoverProbeBrainState extends AxonControllerBrainState;

var() float fMinEngageDist;
var() float fMaxEngageDist;
var() float fMaxEngageDeltaDist;
var() float fMaxEngageDistPenalty;
var() float fFrontalDesiredMinDist;
var() float fFrontalDesiredMaxDist;
var() float fLateralDesiredMinDist;
var() float fLateralDesiredMaxDist;
var() float fAngleToEnemyPenalty;
var() float fMaxPenalty;
var() float fMaxEngagePenaltyDist;
var() float fMinEngagePenaltyDist;
var() int nPCVAgeMS;
var() float fMaxHideAngle;
var() int nNumCoverNodesToFind;
var() float fWaitForCoverTime;
var() float fWaitTime;
var export editinline AxonCoverService CoverService;

function StartBrain()
{
    super(AxonBrainState).StartBrain();
    GotoState('LookForCover');
    //return;    
}

state LookForCover extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        RegisterAxonSubstateTimer(fWaitForCoverTime, TimedOut);
        CoverService.SubstateFindCover(nNumCoverNodesToFind, 250, GetBotLocation(), FoundCover);
        CoverService.ClearCoverConstraints();
        CoverService.PushEngmntDistCoverConstraint(fMinEngageDist, fMaxEngageDist, fMinEngagePenaltyDist, fMaxEngageDistPenalty);
        CoverService.PushFlankPCVCoverConstraint(fFrontalDesiredMinDist, fFrontalDesiredMaxDist, fLateralDesiredMinDist, fLateralDesiredMaxDist, fAngleToEnemyPenalty, fMaxPenalty,, nPCVAgeMS);
        CoverService.SetPushHideCovConstraintParams(fMaxHideAngle);
        CoverService.PushHideCoverConstraint();
        CoverService.PushCanShootCoverConstraint();
        CoverService.PushFlankPCVCoverConstraint();
        CoverService.PushNearEnemyEdgeConstraint();
        //return;        
    }

    function FoundCover()
    {
        CoverService.OnFindCoverCallback();
        GotoState('wait');
        //return;        
    }

    function TimedOut()
    {
        GotoState('wait');
        //return;        
    }
    stop;    
}

state wait extends AxonBaseBookshelfState
{
    function ChildBeginState(name PreviousStateName)
    {
        RegisterAxonSubstateTimer(fWaitTime, TimedOut);
        //return;        
    }

    function TimedOut()
    {
        GotoState('LookForCover');
        //return;        
    }
    stop;    
}

defaultproperties
{
    fMinEngageDist=700.0000000
    fMaxEngageDist=3000.0000000
    fMaxEngageDistPenalty=1000.0000000
    fFrontalDesiredMinDist=2000.0000000
    fFrontalDesiredMaxDist=3000.0000000
    fLateralDesiredMinDist=1500.0000000
    fLateralDesiredMaxDist=2500.0000000
    fAngleToEnemyPenalty=3000.0000000
    fMaxPenalty=1000.0000000
    fMaxEngagePenaltyDist=2500.0000000
    fMinEngagePenaltyDist=1200.0000000
    nPCVAgeMS=10000
    fMaxHideAngle=30.0000000
    nNumCoverNodesToFind=30
    fWaitForCoverTime=5.0000000
    fWaitTime=1.0000000
    // Reference: MOHACoverService'Default__CoverProbeBrainState.CoverService0'
    begin object name=CoverService0 class=Class'MOHACoverService'
    end object
    CoverService=CoverService0
    EventServices=/* Array type was not detected. */
}