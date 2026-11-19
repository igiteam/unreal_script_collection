class AxonEnemyService extends AxonEventService;

function ClearThreatAssessments()
{
    owningBrainState.ExecuteCommand('ClearThreatAssessment');
    //return;    
}

function AddDistanceThreatAssessment(optional float fCanSeeThreat = 500.0000000, optional float fTooCloseDistance = 1500.0000000, optional float fTooCloseThreat = 500.0000000)
{
    owningBrainState.PushEventParamFloat('can_see_threat', fCanSeeThreat);
    owningBrainState.PushEventParamFloat('too_close_distance', fTooCloseDistance);
    owningBrainState.PushEventParamFloat('too_close_threat', fTooCloseThreat);
    owningBrainState.ExecuteCommand('DistanceThreatAssessment');
    //return;    
}

function AddWithinAffordanceThreatAssessment(optional float fNodeMemberThreat = 1000.0000000, optional float fTacaffThreat = 100.0000000)
{
    owningBrainState.PushEventParamFloat('node_member_threat', fNodeMemberThreat);
    owningBrainState.PushEventParamFloat('tacaff_member_threat', fTacaffThreat);
    owningBrainState.ExecuteCommand('WithinAffordanceThreatAssessment');
    //return;    
}

function AddPlayerShotAtMeThreatAssessment(optional float fPlayerShotAtMeThreat = 2000.0000000)
{
    owningBrainState.PushEventParamFloat('player_threat', fPlayerShotAtMeThreat);
    owningBrainState.ExecuteCommand('PlayerShotAtMeThreatAssessment');
    //return;    
}

function AddWithinFiringArcThreatAssessment(optional float fInFiringArcAngle = 60.0000000, optional float fInFiringArcThreatMin = 500.0000000, optional float fInFiringArcThreatMax = 500.0000000)
{
    owningBrainState.PushEventParamFloat('in_firing_arc_angle', fInFiringArcAngle);
    owningBrainState.PushEventParamFloat('in_firing_arc_threat_min', fInFiringArcThreatMin);
    owningBrainState.PushEventParamFloat('in_firing_arc_threat_max', fInFiringArcThreatMax);
    owningBrainState.ExecuteCommand('WithinFiringArcThreatAssessment');
    //return;    
}

function AddCoverBlowerThreatAssessment(optional float fThreat = 1000.0000000)
{
    owningBrainState.PushEventParamFloat('cover_blower_threat', fThreat);
    owningBrainState.ExecuteCommand('CoverBlowerThreatAssessment');
    //return;    
}

function AddCoverFiringArcAssessment(optional float fThreat = 750.0000000)
{
    owningBrainState.PushEventParamFloat('cover_firing_arc_threat', fThreat);
    owningBrainState.ExecuteCommand('CoverFiringArcThreatAssessment');
    //return;    
}

function RegisterAxonActivationHasEnemy(delegate<AxonDelegate> callback, optional int Level = 0, optional name instanceID = 'Default')
{
    owningBrainState.PushEventParamDelegate('OnHasEnemy', callback);
    owningBrainState.PushEventParamName('instance_id', instanceID);
    owningBrainState.RegisterActivationEvent('HasEnemy', Level);
    //return;    
}

function RegisterAxonActivationEnemyChanged(delegate<AxonDelegate> callback, optional int Level = 0, optional name instanceID = 'Default')
{
    owningBrainState.PushEventParamDelegate('onenemychanged', callback);
    owningBrainState.PushEventParamName('instance_id', instanceID);
    owningBrainState.RegisterActivationEvent('EnemyChanged', Level);
    //return;    
}

function RegisterAxonActivationNoLongerSeeEnemy(delegate<AxonDelegate> callback, optional int Level = 0, optional int Timeout = 1000, optional name instanceID = 'Default')
{
    owningBrainState.PushEventParamInt('Timeout', Timeout);
    owningBrainState.PushEventParamDelegate('onnolongerseeenemy', callback);
    owningBrainState.PushEventParamName('instance_id', instanceID);
    owningBrainState.RegisterActivationEvent('NoLongerSeeEnemy', Level);
    //return;    
}

function RegisterAxonActivationLostEnemy(delegate<AxonDelegate> callback, optional int Level = 0, optional name instanceID = 'Default')
{
    owningBrainState.PushEventParamDelegate('OnLostEnemy', callback);
    owningBrainState.PushEventParamName('instance_id', instanceID);
    owningBrainState.RegisterActivationEvent('LostEnemy', Level);
    //return;    
}

function RegisterAxonActivationLostPlayerEnemy(delegate<AxonDelegate> callback, optional int Level = 0, optional name instanceID = 'Default')
{
    owningBrainState.PushEventParamDelegate('onlostplayerenemy', callback);
    owningBrainState.PushEventParamName('instance_id', instanceID);
    owningBrainState.RegisterActivationEvent('onlostplayerenemy', Level);
    //return;    
}

function ActivationOnCanSeeEnemy(delegate<AxonDelegate> callback, optional int Level = 0, optional name instanceID = 'Default')
{
    owningBrainState.PushEventParamDelegate('OnCanSeeEnemy', callback);
    owningBrainState.PushEventParamName('instance_id', instanceID);
    owningBrainState.RegisterActivationEvent('OnCanSeeEnemy', Level);
    //return;    
}

function ActivationCanThrowGrenade(MOHAScriptAIController C, delegate<AxonDelegate> callback, optional int Level = 0, optional float minRethrowTime = -1.0000000, optional float minFriendlyRethrowTime = -1.0000000, optional float maxVariance = 1.0000000, optional name instanceID = 'Default')
{
    // End:0x52
    if(minRethrowTime == float(-1))
    {
        minRethrowTime = C.fMinGrenadeThrowTimeInSec;
    }
    // End:0x77
    if(minFriendlyRethrowTime == float(-1))
    {
        minFriendlyRethrowTime = C.fMinFriendlyThrowTimeInSec;
    }
    // End:0x9C
    if(maxVariance == float(-1))
    {
        maxVariance = C.fMaxGrenadeThrowVarianceInSec;
    }
    owningBrainState.PushEventParamFloat('min_rethrow_time', minRethrowTime);
    owningBrainState.PushEventParamFloat('min_friendly_rethrow_time', minFriendlyRethrowTime);
    owningBrainState.PushEventParamFloat('max_variance', maxVariance);
    owningBrainState.PushEventParamDelegate('throw_grenade', callback);
    owningBrainState.PushEventParamName('instance_id', instanceID);
    owningBrainState.RegisterActivationEvent('Grenade', Level);
    //return;    
}

function RegisterAxonActivationEnemyExposed(delegate<AxonDelegate> callback, optional int Level = 0, optional name instanceID = 'Default')
{
    owningBrainState.PushEventParamDelegate('OnEnemyExposed', callback);
    owningBrainState.PushEventParamName('instance_id', instanceID);
    owningBrainState.RegisterActivationEvent('OnEnemyExposed', Level);
    //return;    
}

function SubstateHasEnemy(delegate<AxonDelegate> callback, optional name instanceID = 'Default', optional name Key = 'stack')
{
    owningBrainState.PushEventParamDelegate('OnHasEnemy', callback);
    owningBrainState.PushEventParamName('instance_id', instanceID);
    owningBrainState.RegisterSubstateEvent('HasEnemy', Key);
    //return;    
}

function SubstateEnemyChanged(delegate<AxonDelegate> callback, optional name instanceID = 'Default', optional name Key = 'stack')
{
    owningBrainState.PushEventParamDelegate('onenemychanged', callback);
    owningBrainState.PushEventParamName('instance_id', instanceID);
    owningBrainState.RegisterSubstateEvent('EnemyChanged', Key);
    //return;    
}

function SubstateNoLongerSeeEnemy(delegate<AxonDelegate> callback, optional int Timeout = 1000, optional name instanceID = 'Default', optional name Key = 'stack')
{
    owningBrainState.PushEventParamInt('Timeout', Timeout);
    owningBrainState.PushEventParamDelegate('onnolongerseeenemy', callback);
    owningBrainState.PushEventParamName('instance_id', instanceID);
    owningBrainState.RegisterSubstateEvent('NoLongerSeeEnemy', Key);
    //return;    
}

function SubstateLostEnemy(delegate<AxonDelegate> callback, optional name instanceID = 'Default', optional name Key = 'stack')
{
    owningBrainState.PushEventParamDelegate('OnLostEnemy', callback);
    owningBrainState.PushEventParamName('instance_id', instanceID);
    owningBrainState.RegisterSubstateEvent('LostEnemy', Key);
    //return;    
}

function SubstateOnCanSeeEnemy(delegate<AxonDelegate> callback, optional name instanceID = 'Default', optional name Key = 'stack')
{
    owningBrainState.PushEventParamDelegate('OnCanSeeEnemy', callback);
    owningBrainState.PushEventParamName('instance_id', instanceID);
    owningBrainState.RegisterSubstateEvent('OnCanSeeEnemy', Key);
    //return;    
}

function SubstateLostPlayerEnemy(delegate<AxonDelegate> callback, optional name instanceID = 'Default', optional name Key = 'stack')
{
    owningBrainState.PushEventParamDelegate('onlostplayerenemy', callback);
    owningBrainState.PushEventParamName('instance_id', instanceID);
    owningBrainState.RegisterSubstateEvent('onlostplayerenemy', Key);
    //return;    
}

function SubstateCanThrowGrenade(MOHAScriptAIController C, delegate<AxonDelegate> callback, optional float minRethrowTime = -1.0000000, optional float minFriendlyRethrowTime = -1.0000000, optional float maxVariance = -1.0000000, optional name instanceID = 'Default', optional name Key = 'stack')
{
    // End:0x5A
    if(minRethrowTime == float(-1))
    {
        minRethrowTime = C.fMinGrenadeThrowTimeInSec;
    }
    // End:0x7F
    if(minFriendlyRethrowTime == float(-1))
    {
        minFriendlyRethrowTime = C.fMinFriendlyThrowTimeInSec;
    }
    // End:0xA4
    if(maxVariance == float(-1))
    {
        maxVariance = C.fMaxGrenadeThrowVarianceInSec;
    }
    owningBrainState.PushEventParamFloat('min_rethrow_time', minRethrowTime);
    owningBrainState.PushEventParamFloat('min_friendly_rethrow_time', minFriendlyRethrowTime);
    owningBrainState.PushEventParamFloat('max_variance', maxVariance);
    owningBrainState.PushEventParamDelegate('throw_grenade', callback);
    owningBrainState.PushEventParamName('instance_id', instanceID);
    owningBrainState.RegisterSubstateEvent('Grenade', Key);
    //return;    
}

function SubstateEnemyExposed(delegate<AxonDelegate> callback, optional name instanceID = 'Default', optional name Key = 'stack')
{
    owningBrainState.PushEventParamDelegate('OnEnemyExposed', callback);
    owningBrainState.PushEventParamName('instance_id', instanceID);
    owningBrainState.RegisterSubstateEvent('OnEnemyExposed', Key);
    //return;    
}

function ResetGrenadeTimer(optional name instanceID = 'Default')
{
    owningBrainState.PushEventParamName('instance_id', instanceID);
    owningBrainState.ExecuteCommand('Grenade_ResetTimer');
    //return;    
}

function ClearGrenadeConstraints(optional name instanceID = 'Default')
{
    owningBrainState.PushEventParamName('instance_id', instanceID);
    owningBrainState.ExecuteCommand('Grenade_ClearConstraints');
    //return;    
}

function NotifyJustThrewGrenade(optional name instanceID = 'Default')
{
    owningBrainState.PushEventParamName('instance_id', instanceID);
    owningBrainState.ExecuteCommand('JustThrew_Grenade');
    //return;    
}

function NotifyFriendlyJustThrewGrenade(optional name instanceID = 'Default')
{
    owningBrainState.PushEventParamName('instance_id', instanceID);
    owningBrainState.ExecuteCommand('FriendlyJustThrew_Grenade');
    //return;    
}

function RegisterDefaultGrenadeConstraints(optional name instanceID = 'Default')
{
    ClearGrenadeConstraints(instanceID);
    PushEnemyInRangeGrenadeConstraint(,, instanceID);
    PushEnemyClusterGrenadeConstraint(500.0000000, 4, instanceID);
    PushEnemyTrajectoryClearGrenadeConstraint(10, instanceID);
    //return;    
}

function PushEnemyInRangeGrenadeConstraint(optional float fMinRange = -1.0000000, optional float fMaxRange = -1.0000000, optional name instanceID = 'Default')
{
    // End:0x50
    if(fMinRange < 0.0000000)
    {
        fMinRange = AxonControllerBrainState(owningBrainState).Controller.fMinGrenadeRange;
    }
    // End:0x81
    if(fMaxRange < 0.0000000)
    {
        fMaxRange = AxonControllerBrainState(owningBrainState).Controller.fMaxGrenadeRange;
    }
    owningBrainState.PushEventParamFloat('MinDist', fMinRange);
    owningBrainState.PushEventParamFloat('maxdist', fMaxRange);
    owningBrainState.PushEventParamName('instance_id', instanceID);
    owningBrainState.ExecuteCommand('Grenade_EnemyInRangeConstraint');
    //return;    
}

function PushEnemyClusterGrenadeConstraint(optional float distanceThreshold = 500.0000000, optional int maxenemiestoconsider = 3, optional name instanceID = 'Default')
{
    owningBrainState.PushEventParamFloat('distanceThreshold', distanceThreshold);
    owningBrainState.PushEventParamInt('maxenemiestoconsider', maxenemiestoconsider);
    owningBrainState.PushEventParamName('instance_id', instanceID);
    owningBrainState.ExecuteCommand('Grenade_EnemyClusterConstraint');
    //return;    
}

function PushEnemyTrajectoryClearGrenadeConstraint(int iSegments, optional name instanceID = 'Default')
{
    owningBrainState.PushEventParamInt('numsegments', iSegments);
    owningBrainState.PushEventParamName('instance_id', instanceID);
    owningBrainState.ExecuteCommand('Grenade_EnemyTrajectoryClear');
    //return;    
}

function Pawn GetChangedEnemyResult()
{
    local Object P;

    owningBrainState.GetCallbackParamObject('changedenemy', P);
    // End:0x2A
    if(P == none)
    {
        return none;
    }
    return Pawn(P);
    //return ReturnValue;    
}

function Pawn GetHasEnemyResult()
{
    local Object P;

    owningBrainState.GetCallbackParamObject('Enemy', P);
    // End:0x2A
    if(P == none)
    {
        return none;
    }
    return Pawn(P);
    //return ReturnValue;    
}

function Pawn GetOnCanSeeEnemyOutput()
{
    local Object P;

    owningBrainState.GetCallbackParamObject('visibleenemy', P);
    // End:0x2A
    if(P == none)
    {
        return none;
    }
    return Pawn(P);
    //return ReturnValue;    
}

function GetEnemy(delegate<AxonDelegate> callback, optional int Timeout = 10000, optional name Key = 'stack')
{
    owningBrainState.PushEventParamDelegate('getenemycallback', callback);
    owningBrainState.PushEventParamInt('getenemytimeout', Timeout);
    owningBrainState.RegisterSubstateEvent('GetEnemy', Key);
    //return;    
}

function GetEnemyActivation(delegate<AxonDelegate> callback, optional int Level = 0, optional int Timeout = 10000)
{
    owningBrainState.PushEventParamDelegate('getenemycallback', callback);
    owningBrainState.PushEventParamInt('getenemytimeout', Timeout);
    owningBrainState.RegisterActivationEvent('GetEnemy', Level);
    //return;    
}

function Pawn GetGetEnemyResult()
{
    local Object P;

    owningBrainState.GetCallbackParamObject('resenemy', P);
    // End:0x2A
    if(P == none)
    {
        return none;
    }
    return Pawn(P);
    //return ReturnValue;    
}

function CanSeeEnemy(delegate<AxonDelegate> callback, optional name Key = 'stack')
{
    owningBrainState.PushEventParamDelegate('canseeenemycallback', callback);
    owningBrainState.RegisterSubstateEvent('CanSeeEnemy', Key);
    //return;    
}

function bool GetCanSeeEnemyResult()
{
    local int iRes;

    owningBrainState.GetCallbackParamInt('CanSeeEnemy', iRes);
    return iRes == 1;
    //return ReturnValue;    
}

function CanShootEnemy(delegate<AxonDelegate> callback, optional bool bCheckCoverAngle = false, optional name Key = 'stack')
{
    owningBrainState.PushEventParamInt('canshootcheckcoverfiringarc', int(bCheckCoverAngle));
    owningBrainState.PushEventParamDelegate('cansshootenemycallback', callback);
    owningBrainState.RegisterSubstateEvent('CanShootEnemy', Key);
    //return;    
}

function CanShootEnemyActivation(delegate<AxonDelegate> callback, optional bool bCheckCoverAngle = false, optional int Level = 0)
{
    owningBrainState.PushEventParamInt('canshootcheckcoverfiringarc', int(bCheckCoverAngle));
    owningBrainState.PushEventParamDelegate('cansshootenemycallback', callback);
    owningBrainState.RegisterActivationEvent('CanShootEnemy', Level);
    //return;    
}

function bool GetCanShootEnemyResult()
{
    local int iRes;

    owningBrainState.GetCallbackParamInt('CanShootEnemy', iRes);
    return iRes == 1;
    //return ReturnValue;    
}

function CanSuppressEnemy(delegate<AxonDelegate> callback, optional bool bCheckCoverAngle = false, optional name Key = 'stack')
{
    owningBrainState.PushEventParamInt('cansuppresscheckcoverfiringarc', int(bCheckCoverAngle));
    owningBrainState.PushEventParamDelegate('cansuppressenemycallback', callback);
    owningBrainState.RegisterSubstateEvent('CanSuppressEnemy', Key);
    //return;    
}

function bool GetCanSuppressEnemyResult()
{
    local int iRes;

    owningBrainState.GetCallbackParamInt('CanSuppressEnemy', iRes);
    return iRes == 1;
    //return ReturnValue;    
}

function GetLKP(delegate<AxonDelegate> callback, optional name Key = 'stack')
{
    owningBrainState.PushEventParamDelegate('getlkpcallback', callback);
    owningBrainState.RegisterSubstateEvent('GetLKP', Key);
    //return;    
}

function GetActivationLKP(delegate<AxonDelegate> callback, optional int Level = 0)
{
    owningBrainState.PushEventParamDelegate('getlkpcallback', callback);
    owningBrainState.RegisterActivationEvent('GetLKP', Level);
    //return;    
}

function Vector GetGetLKPResult()
{
    local Vector V;

    owningBrainState.GetCallbackParamVector('LKP', V);
    return V;
    //return ReturnValue;    
}

function GetHuntPos(delegate<AxonDelegate> callback, optional name Key = 'stack')
{
    owningBrainState.PushEventParamDelegate('gethuntposcallback', callback);
    owningBrainState.RegisterSubstateEvent('GetHuntPos', Key);
    //return;    
}

function Vector GetGetHuntPosResult()
{
    local Vector V;

    owningBrainState.GetCallbackParamVector('HuntPos', V);
    return V;
    //return ReturnValue;    
}

function GetResetEnemy(delegate<AxonDelegate> callback, optional int Timeout = 10000, optional name Key = 'stack')
{
    owningBrainState.PushEventParamDelegate('getresetenemycallback', callback);
    owningBrainState.PushEventParamInt('getresetenemytimeout', Timeout);
    owningBrainState.RegisterSubstateEvent('GetResetEnemy', Key);
    //return;    
}

function GetActivationResetEnemy(delegate<AxonDelegate> callback, optional int Level = 0, optional int Timeout = 10000)
{
    owningBrainState.PushEventParamDelegate('getresetenemycallback', callback);
    owningBrainState.PushEventParamInt('getresetenemytimeout', Timeout);
    owningBrainState.RegisterActivationEvent('GetResetEnemy', Level);
    //return;    
}

function Pawn GetResetEnemyResult()
{
    local Object P;

    owningBrainState.GetCallbackParamObject('ResetEnemy', P);
    // End:0x2A
    if(P == none)
    {
        return none;
    }
    return Pawn(P);
    //return ReturnValue;    
}
