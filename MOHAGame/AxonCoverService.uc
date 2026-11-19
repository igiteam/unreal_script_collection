class AxonCoverService extends AxonEventService;

var array<KynapseCoverNode> FoundCoverNodes;
var int NumFoundCoverNodes;
var bool bPruneOldCoverData;
var int PruneCoverSlack;

function PushEngmntDistOverrideTarget(Controller C)
{
    owningBrainState.PushEventParamObject('override_entity0', C);
    //return;    
}

function PushEngmntDistCoverConstraint(float fMinDist, float fMaxDist, float fMinPenaltyDist, float fMaxPenaltyDist, optional float fMaxPenalty = 1000.0000000, optional string agentPrefix = "FindCover", optional name instanceID = 'Default')
{
    owningBrainState.PushEventParamName('instance_id', instanceID);
    SetEngmntDistCoverConstraintParams(fMinDist, fMaxDist, fMinPenaltyDist, fMaxPenaltyDist, fMaxPenalty);
    owningBrainState.ExecuteCommand(name(agentPrefix $ "PushEngmntDistConstraint"));
    //return;    
}

function PushHideOverrideTarget(Controller C)
{
    owningBrainState.PushEventParamObject('override_entity1', C);
    //return;    
}

function PushHideCoverConstraint(optional string agentPrefix = "FindCover", optional float NPCEnemyDist = 0.0000000, optional name instanceID = 'Default')
{
    owningBrainState.PushEventParamFloat('npc_enemy_dist', NPCEnemyDist);
    owningBrainState.PushEventParamName('instance_id', instanceID);
    owningBrainState.ExecuteCommand(name(agentPrefix $ "PushHideConstraint"));
    //return;    
}

function PushIdleCoverPointConstraint(optional string agentPrefix = "FindCover", optional float fCantHidePenalty = 1000.0000000, optional float fCantShootPenalty = 1000.0000000, optional bool bDraconianCantHide = false, optional bool bDraconianCandShoot = false, optional float fHideAngleToleranceDeg = 30.0000000, optional name instanceID = 'Default')
{
    owningBrainState.PushEventParamFloat('canthide_penalty', fCantHidePenalty);
    owningBrainState.PushEventParamFloat('cantshoot_penalty', fCantShootPenalty);
    owningBrainState.PushEventParamFloat('hide_angle_tolerance', fHideAngleToleranceDeg);
    owningBrainState.PushEventParamInt('idlecoverpoint_draconian_canthide', int(bDraconianCantHide));
    owningBrainState.PushEventParamInt('idlecoverpoint_draconian_cantshoot', int(bDraconianCandShoot));
    owningBrainState.PushEventParamName('instance_id', instanceID);
    owningBrainState.ExecuteCommand(name(agentPrefix $ "PushIdleCoverPointConstraint"));
    //return;    
}

function PushCanShootOverrideTarget(Controller C)
{
    owningBrainState.PushEventParamObject('override_entity2', C);
    //return;    
}

function PushCanShootCoverConstraint(optional string agentPrefix = "FindCover", optional float NPCEnemyDist = 0.0000000, optional name instanceID = 'Default')
{
    owningBrainState.PushEventParamFloat('npc_enemy_distance', NPCEnemyDist);
    owningBrainState.PushEventParamName('instance_id', instanceID);
    owningBrainState.ExecuteCommand(name(agentPrefix $ "PushCanShootConstraint"));
    //return;    
}

function PushNearPointCoverConstraint(Vector Point, optional name instanceID = 'Default')
{
    owningBrainState.PushEventParamVector('Point', Point);
    owningBrainState.PushEventParamName('instance_id', instanceID);
    owningBrainState.ExecuteCommand('FindCoverPushNearPointConstraint');
    //return;    
}

function PushNearPlayerCoverConstraint(optional string agentPrefix = "FindCover", optional float playerDistance = 40.0000000, optional name instanceID = 'Default')
{
    owningBrainState.PushEventParamFloat('playerDistance', playerDistance);
    owningBrainState.PushEventParamName('instance_id', instanceID);
    owningBrainState.ExecuteCommand(name(agentPrefix $ "PushNearPlayerConstraint"));
    //return;    
}

function PushOutsidePointCoverConstraint(Vector Point, float Radius, optional name instanceID = 'Default')
{
    owningBrainState.PushEventParamVector('avoidpoint', Point);
    owningBrainState.PushEventParamFloat('avoidradius', Radius);
    owningBrainState.PushEventParamName('instance_id', instanceID);
    owningBrainState.ExecuteCommand('FindCoverPushOutsidePointConstraint');
    //return;    
}

function PushFlankPCVCoverConstraint(optional float fFrontalDesiredMinDist = 2000.0000000, optional float fFrontalDesiredMaxDist = 3000.0000000, optional float fLateralDesiredMinDist = 1500.0000000, optional float fLateralDesiredMaxDist = 2500.0000000, optional float fAngleToEnemyPenalty = 3000.0000000, optional float fMaxPenalty = 1000.0000000, optional float fMaxDeltaDistance = 500.0000000, optional int nPCVAgeMS = 10000, optional name instanceID = 'Default')
{
    owningBrainState.PushEventParamFloat('frontal_desired_min_dist', fFrontalDesiredMinDist);
    owningBrainState.PushEventParamFloat('frontal_desired_max_dist', fFrontalDesiredMaxDist);
    owningBrainState.PushEventParamFloat('lateral_desired_min_dist', fLateralDesiredMinDist);
    owningBrainState.PushEventParamFloat('lateral_desired_max_dist', fLateralDesiredMaxDist);
    owningBrainState.PushEventParamFloat('angle_to_enemy_penalty', fAngleToEnemyPenalty);
    owningBrainState.PushEventParamFloat('max_penalty', fMaxPenalty);
    owningBrainState.PushEventParamFloat('max_delta_distance', fMaxDeltaDistance);
    owningBrainState.PushEventParamFloat('pcv_age', float(nPCVAgeMS));
    owningBrainState.PushEventParamName('instance_id', instanceID);
    owningBrainState.ExecuteCommand('FindCoverPushFlankPCVConstraint');
    //return;    
}

function PushWithinAffordanceCoverConstraint(optional string agentPrefix = "FindCover", optional float fOutsidePenalty = 2000.0000000, optional float fDistancePenalty = 300.0000000, optional bool bThrowOutOutsiders = false, optional name instanceID = 'Default')
{
    owningBrainState.PushEventParamFloat('outsider_penalty', fOutsidePenalty);
    owningBrainState.PushEventParamFloat('distance_penalty', fDistancePenalty);
    owningBrainState.PushEventParamInt('throw_out_outsiders', int(bThrowOutOutsiders));
    owningBrainState.PushEventParamName('instance_id', instanceID);
    owningBrainState.ExecuteCommand(name(agentPrefix $ "PushWithinAffordanceConstraint"));
    //return;    
}

function PushTacticalAffordanceCoverConstraint(optional string agentPrefix = "FindCover", optional float fAngleToTargetPenalty = 0.0000000, optional float fFriendlyTerritoryPenalty = 500.0000000, optional float fNeutralTerritoryPenalty = -1000.0000000, optional float fEnemyTerritoryPenalty = -3000.0000000, optional name instanceID = 'Default')
{
    owningBrainState.PushEventParamFloat('friendly_territory_penalty', fFriendlyTerritoryPenalty);
    owningBrainState.PushEventParamFloat('neutral_territory_penalty', fNeutralTerritoryPenalty);
    owningBrainState.PushEventParamFloat('enemy_territory_penalty', fEnemyTerritoryPenalty);
    owningBrainState.PushEventParamFloat('angle_penalty', fAngleToTargetPenalty);
    owningBrainState.PushEventParamName('instance_id', instanceID);
    owningBrainState.ExecuteCommand(name(agentPrefix $ "PushTacticalAffordanceConstraint"));
    //return;    
}

function PushHiddenFromEnemiesCoverConstraint(optional string agentPrefix = "FindCover", optional float fMaxHideAngle = 90.0000000, optional bool bIgnoreTrace = false, optional bool bOnlyVisibleEnemies = true, optional int maxEnemies = 3, optional float fPenaltyPerThreateningEnemy = 100.0000000, optional int bDraconian = 1, optional name instanceID = 'Default')
{
    owningBrainState.PushEventParamFloat('threatening_enemy_penalty', fPenaltyPerThreateningEnemy);
    owningBrainState.PushEventParamInt('threatening_maxenemies', maxEnemies);
    owningBrainState.PushEventParamFloat('max_hide_angle', fMaxHideAngle);
    owningBrainState.PushEventParamInt('hidden_ignoretrace', int(bIgnoreTrace));
    owningBrainState.PushEventParamInt('hidden_onlyvisibleenemies', int(bOnlyVisibleEnemies));
    owningBrainState.PushEventParamInt('draconian_hidden_from_enemies', bDraconian);
    owningBrainState.PushEventParamName('instance_id', instanceID);
    owningBrainState.ExecuteCommand(name(agentPrefix $ "PushHiddenFromEnemiesConstraint"));
    //return;    
}

function PushShootEnemiesCoverConstraint(optional string agentPrefix = "FindCover", optional int maxEnemies = 4, optional float fPenaltyForAllEnemiesSafe = 1000.0000000, optional int enemySeeTimeMS = 0, optional int bDraconian = 0, optional name instanceID = 'Default')
{
    owningBrainState.PushEventParamFloat('safe_enemy_penalty', fPenaltyForAllEnemiesSafe);
    owningBrainState.PushEventParamInt('safe_maxenemies', maxEnemies);
    owningBrainState.PushEventParamInt('enemy_see_time', enemySeeTimeMS);
    owningBrainState.PushEventParamInt('draconian_shoot_enemies', bDraconian);
    owningBrainState.PushEventParamName('instance_id', instanceID);
    owningBrainState.ExecuteCommand(name(agentPrefix $ "PushShootEnemiesConstraint"));
    //return;    
}

function PushShootAtLeastOneCoverConstraint(optional string agentPrefix = "FindCover", optional name instanceID = 'Default')
{
    owningBrainState.PushEventParamName('instance_id', instanceID);
    owningBrainState.ExecuteCommand(name(agentPrefix $ "PushShootAtLeastOneEnemyCoverConstraint"));
    //return;    
}

function PushWithinLeashCoverConstraint(optional string agentPrefix = "FindCover", optional name instanceID = 'Default')
{
    owningBrainState.PushEventParamName('instance_id', instanceID);
    owningBrainState.ExecuteCommand(name(agentPrefix $ "PushWithinLeashConstraint"));
    //return;    
}

function PushHiddenFromPlayerCoverConstraint(optional string agentPrefix = "FindCover", optional float fMaxHideAngle = 90.0000000, optional name instanceID = 'Default')
{
    owningBrainState.PushEventParamFloat('max_playerhide_angle', fMaxHideAngle);
    owningBrainState.PushEventParamName('instance_id', instanceID);
    owningBrainState.ExecuteCommand(name(agentPrefix $ "PushHiddenFromPlayerConstraint"));
    //return;    
}

function PushHiddenFromFlankingEnemiesCoverConstraint(optional string agentPrefix = "FindCover", optional float fMaxHideAngle = 90.0000000, optional bool bIgnoreTrace = false, optional bool bOnlyVisibleEnemies = true, optional int maxEnemies = 3, optional float fPenaltyPerThreateningEnemy = 100.0000000, optional int bDraconian = 1, optional name instanceID = 'Default')
{
    owningBrainState.PushEventParamFloat('flanking_threatening_enemy_penalty', fPenaltyPerThreateningEnemy);
    owningBrainState.PushEventParamInt('flanking_threatening_maxenemies', maxEnemies);
    owningBrainState.PushEventParamFloat('flanking_max_hide_angle', fMaxHideAngle);
    owningBrainState.PushEventParamInt('flanking_hidden_ignoretrace', int(bIgnoreTrace));
    owningBrainState.PushEventParamInt('flanking_hidden_onlyvisibleenemies', int(bOnlyVisibleEnemies));
    owningBrainState.PushEventParamInt('flanking_draconian_hidden_from_enemies', bDraconian);
    owningBrainState.PushEventParamName('instance_id', instanceID);
    owningBrainState.ExecuteCommand(name(agentPrefix $ "PushHiddenFromFlankingEnemiesConstraint"));
    //return;    
}

function PushNearEnemyEdgeConstraint(optional float fNearDist = -1.0000000, optional name instanceID = 'Default')
{
    // End:0x40
    if(fNearDist > float(0))
    {
        owningBrainState.PushEventParamFloat('neardist', fNearDist);
    }
    owningBrainState.PushEventParamName('instance_id', instanceID);
    owningBrainState.ExecuteCommand('FindCoverPushNearEnemyEdgeConstraint');
    //return;    
}

function ClearCoverConstraints(optional string agentPrefix = "FindCover", optional name instanceID = 'Default')
{
    owningBrainState.PushEventParamName('instance_id', instanceID);
    owningBrainState.ExecuteCommand(name(agentPrefix $ "ClearCoverConstraint"));
    //return;    
}

function PushBasicDefensiveFindCoverConstraints(MOHAScriptAIController Controller, coerce optional string agent = "FindCover", optional name instanceID = 'Default', optional bool bClearConstraints = true)
{
    // End:0x3E
    if(bClearConstraints)
    {
        ClearCoverConstraints(agent, instanceID);
    }
    PushWithinLeashCoverConstraint(agent, instanceID);
    PushEngmntDistCoverConstraint(Controller.fMinEngageDist, Controller.fMaxEngageDist, Controller.fMinEngagePenaltyDist, Controller.fMaxEngagePenaltyDist,, agent, instanceID);
    // End:0xD5
    if(Controller.TeamIndex == 1)
    {
        PushHiddenFromPlayerCoverConstraint(agent, Controller.fMaxHideAngle, instanceID);
    }
    PushHiddenFromEnemiesCoverConstraint(agent, Controller.fMaxHideAngle, false, false,,,, instanceID);
    PushNearEnemyEdgeConstraint(, instanceID);
    //return;    
}

function TeamSpecificPushShootEnemiesConstraint(MOHAScriptAIController Controller, string agent, name instanceID)
{
    local int enemySeeTimeMS, bDraconian;

    enemySeeTimeMS = 0;
    bDraconian = 0;
    // End:0x34
    if(Controller.TeamIndex == 0)
    {
        enemySeeTimeMS = 1000;
        bDraconian = 1;
    }
    PushShootEnemiesCoverConstraint(agent,,, enemySeeTimeMS, bDraconian, instanceID);
    //return;    
}

function PushBasicAggressorFindCoverConstraints(MOHAScriptAIController Controller, coerce optional string agent = "FindCover", optional name instanceID = 'Default')
{
    ClearCoverConstraints(agent, instanceID);
    PushTacticalAffordanceCoverConstraint(agent, 500.0000000,, 5000.0000000,, instanceID);
    PushWithinAffordanceCoverConstraint(agent,,,, instanceID);
    PushBasicDefensiveFindCoverConstraints(Controller, agent, instanceID, false);
    PushShootEnemiesCoverConstraint(agent,,,,, instanceID);
    PushNearPlayerCoverConstraint(agent,, instanceID);
    //return;    
}

function PushBasicAggressorCoverBlownConstraints(MOHAScriptAIController Controller, optional name instanceID = 'Default')
{
    ClearCoverConstraints("CoverBlown", instanceID);
    PushWithinLeashCoverConstraint("CoverBlown", instanceID);
    PushEngmntDistCoverConstraint(Controller.fMinEngageDist * (1.0000000 - Controller.fBlownFudgeFactor), Controller.fMaxEngageDist * (1.0000000 + Controller.fBlownFudgeFactor), Controller.fMinEngagePenaltyDist, Controller.fMaxEngagePenaltyDist,, "CoverBlown", instanceID);
    // End:0x102
    if(Controller.TeamIndex == 1)
    {
        PushHiddenFromPlayerCoverConstraint("CoverBlown", Controller.fMaxHideAngle, instanceID);
    }
    PushHiddenFromEnemiesCoverConstraint("CoverBlown", Controller.fMaxHideAngle, false, true,,,, instanceID);
    PushShootEnemiesCoverConstraint("CoverBlown",,,,, instanceID);
    //return;    
}

function PushFlankingAggressorCoverBlownContraints(MOHAScriptAIController Controller, optional float fMaxHideAngle = -1.0000000, optional bool bOnlyVisibleEnemies = true, optional name instanceID = 'Default')
{
    ClearCoverConstraints("CoverBlown", instanceID);
    // End:0x5B
    if(fMaxHideAngle == float(-1))
    {
        fMaxHideAngle = Controller.fMaxHideAngle;
    }
    PushHiddenFromFlankingEnemiesCoverConstraint("CoverBlown", fMaxHideAngle, false, bOnlyVisibleEnemies,,,, instanceID);
    //return;    
}

function ClaimCover(int covernode_id, delegate<AxonDelegate> callback, optional name Key = 'stack')
{
    owningBrainState.PushEventParamInt('cover_id', covernode_id);
    owningBrainState.PushEventParamDelegate('claimcoverresult', callback);
    owningBrainState.RegisterSubstateEvent('ClaimCover', Key);
    //return;    
}

function ClaimCoverActivationEvent(int covernode_id, delegate<AxonDelegate> callback, optional int Level = 0)
{
    owningBrainState.PushEventParamInt('cover_id', covernode_id);
    owningBrainState.PushEventParamDelegate('claimcoverresult', callback);
    owningBrainState.RegisterActivationEvent('ClaimCover', Level);
    //return;    
}

function bool GetClaimResult()
{
    local int success;

    owningBrainState.GetCallbackParamInt('success', success);
    return success == 1;
    //return ReturnValue;    
}

function GetCover(delegate<AxonDelegate> callback, optional name Key = 'stack')
{
    owningBrainState.PushEventParamDelegate('getcovercallback', callback);
    owningBrainState.RegisterSubstateEvent('GetCoverNode', Key);
    //return;    
}

function GetCoverActivation(delegate<AxonDelegate> callback, optional int Level = 0)
{
    owningBrainState.PushEventParamDelegate('getcovercallback', callback);
    owningBrainState.RegisterActivationEvent('GetCoverNode', Level);
    //return;    
}

function bool GetGetCoverResult(out KynapseCoverNode Result)
{
    local Object CoverNodeObj;

    // End:0x24
    if(!owningBrainState.GetCallbackParamObject('cover_node', CoverNodeObj))
    {
        return false;
    }
    // End:0x56
    if(KynapseCoverNode(CoverNodeObj) != none)
    {
        Result = KynapseCoverNode(CoverNodeObj);
        SetAnimSetOnNode(Result);        
    }
    else
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function GetAlternateCover(delegate<AxonDelegate> callback, optional bool bBest = false, optional name Key = 'stack')
{
    owningBrainState.PushEventParamInt('getbest', int(bBest));
    owningBrainState.PushEventParamDelegate('getalternatecovercallback', callback);
    owningBrainState.RegisterSubstateEvent('GetAlternateCoverNode', Key);
    //return;    
}

function bool GetGetAlternateCoverResult(out KynapseCoverNode Result)
{
    local Object CoverNodeObj;

    // End:0x24
    if(!owningBrainState.GetCallbackParamObject('alternate_cover_node', CoverNodeObj))
    {
        return false;
    }
    // End:0x56
    if(KynapseCoverNode(CoverNodeObj) != none)
    {
        Result = KynapseCoverNode(CoverNodeObj);
        SetAnimSetOnNode(Result);        
    }
    else
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function ClearCover(optional int lock_time = 3000)
{
    owningBrainState.PushEventParamInt('release_lock_time', lock_time);
    owningBrainState.ExecuteCommand('ClearCover');
    //return;    
}

function RegisterActivationOnCoverUnmounted(delegate<AxonDelegate> callback, optional int Level = 0, optional name instanceID = 'Default')
{
    owningBrainState.PushEventParamName('instance_id', instanceID);
    owningBrainState.PushEventParamDelegate('OnCoverUnMounted', callback);
    owningBrainState.RegisterActivationEvent('OnCoverUnMounted', Level);
    //return;    
}

function SubstateOnCoverUnmounted(delegate<AxonDelegate> callback, optional name instanceID = 'Default', optional name Key = 'stack')
{
    owningBrainState.PushEventParamName('instance_id', instanceID);
    owningBrainState.PushEventParamDelegate('OnCoverUnMounted', callback);
    owningBrainState.RegisterSubstateEvent('OnCoverUnMounted', Key);
    //return;    
}

function RegisterActivationOnCoverMounted(delegate<AxonDelegate> callback, optional int Level = 0, optional name instanceID = 'Default')
{
    owningBrainState.PushEventParamName('instance_id', instanceID);
    owningBrainState.PushEventParamDelegate('OnCoverMounted', callback);
    owningBrainState.RegisterActivationEvent('OnCoverMounted', Level);
    //return;    
}

function SubstateOnCoverMounted(delegate<AxonDelegate> callback, optional name instanceID = 'Default', optional name Key = 'stack')
{
    owningBrainState.PushEventParamName('instance_id', instanceID);
    owningBrainState.PushEventParamDelegate('OnCoverMounted', callback);
    owningBrainState.RegisterSubstateEvent('OnCoverMounted', Key);
    //return;    
}

function SubstateOnEnemyOutsideCoverFiringArc(int enemyOutsideArcTimeMS, delegate<AxonDelegate> callback, optional name instanceID = 'Default', optional name Key = 'stack')
{
    owningBrainState.PushEventParamName('instance_id', instanceID);
    owningBrainState.PushEventParamInt('timeoutms', enemyOutsideArcTimeMS);
    owningBrainState.PushEventParamDelegate('onenemyoutsidearc', callback);
    owningBrainState.RegisterSubstateEvent('OnEnemyOutsideCoverFiringArc', Key);
    //return;    
}

function RegisterActivationOnEnemyOutsideCoverFiringArc(int enemyOutsideArcTimeMS, delegate<AxonDelegate> callback, optional int Level = 0, optional name instanceID = 'Default')
{
    owningBrainState.PushEventParamName('instance_id', instanceID);
    owningBrainState.PushEventParamInt('timeoutms', enemyOutsideArcTimeMS);
    owningBrainState.PushEventParamDelegate('onenemyoutsidearc', callback);
    owningBrainState.RegisterActivationEvent('OnEnemyOutsideCoverFiringArc', Level);
    //return;    
}

function RegisterAxonActivationFindCover(int maxnodes, int maxedges, Vector traversalStartPos, delegate<AxonDelegate> callback, optional int Level = 0, optional name instanceID = 'Default')
{
    SetFindCoverParams(maxnodes, 1, maxedges, traversalStartPos, callback);
    owningBrainState.PushEventParamName('instance_id', instanceID);
    owningBrainState.RegisterActivationEvent('FindCover', Level);
    //return;    
}

function SubstateFindCover(int maxnodes, int maxedges, Vector traversalStartPos, delegate<AxonDelegate> callback, optional name instanceID = 'Default', optional name Key = 'stack')
{
    SetFindCoverParams(maxnodes, 1, maxedges, traversalStartPos, callback);
    owningBrainState.PushEventParamName('instance_id', instanceID);
    owningBrainState.RegisterSubstateEvent('FindCover', Key);
    //return;    
}

function OnFindCoverCallback()
{
    PruneCoverList();
    NumFoundCoverNodes = InternalGetNumCoverNodesFound();
    GetAllCoverNodes(FoundCoverNodes);
    //return;    
}

function int GetNumNodesFound()
{
    return NumFoundCoverNodes;
    //return ReturnValue;    
}

function KynapseCoverNode GetCoverNode(int idx)
{
    // End:0x1E
    if((idx < 0) || idx >= NumFoundCoverNodes)
    {
        return none;
    }
    return FoundCoverNodes[idx];
    //return ReturnValue;    
}

function RegisterAxonActivationCoverBlown(delegate<AxonDelegate> callback, optional int Level = 0, optional float fDistThreshold = 25.0000000, optional name instanceID = 'Default')
{
    owningBrainState.PushEventParamFloat('distance_threshold', fDistThreshold);
    owningBrainState.PushEventParamDelegate('CoverBlown', callback);
    owningBrainState.PushEventParamName('instance_id', instanceID);
    owningBrainState.RegisterActivationEvent('CoverBlown', Level);
    //return;    
}

function SubstateCoverBlown(delegate<AxonDelegate> callback, optional float fDistThreshold = 25.0000000, optional name instanceID = 'Default', optional name Key = 'stack')
{
    owningBrainState.PushEventParamFloat('distance_threshold', fDistThreshold);
    owningBrainState.PushEventParamDelegate('CoverBlown', callback);
    owningBrainState.PushEventParamName('instance_id', instanceID);
    owningBrainState.RegisterSubstateEvent('CoverBlown', Key);
    //return;    
}

function SuppressCoverBlown()
{
    owningBrainState.SuppressSubstateEvent('CoverBlown');
    //return;    
}

function IsCoverValid(delegate<AxonDelegate> callback, KynapseCoverNode CoverNode, optional name instanceID = 'Default', optional name Key = 'stack')
{
    owningBrainState.PushEventParamObject('CoverNode', CoverNode);
    owningBrainState.PushEventParamDelegate('iscovervalidcallback', callback);
    owningBrainState.PushEventParamName('instance_id', instanceID);
    owningBrainState.RegisterSubstateEvent('IsCoverValid', Key);
    //return;    
}

function IsCoverValidActivation(delegate<AxonDelegate> callback, KynapseCoverNode CoverNode, optional int Level = 0, optional name instanceID = 'Default')
{
    owningBrainState.PushEventParamObject('CoverNode', CoverNode);
    owningBrainState.PushEventParamDelegate('iscovervalidcallback', callback);
    owningBrainState.PushEventParamName('instance_id', instanceID);
    owningBrainState.RegisterActivationEvent('IsCoverValid', Level);
    //return;    
}

function bool GetIsCoverValidResult()
{
    local int I;

    owningBrainState.GetCallbackParamInt('Result', I);
    return I == 1;
    //return ReturnValue;    
}

protected function PruneCoverList()
{
    // End:0x0D
    if(!bPruneOldCoverData)
    {
        return;
    }
    FoundCoverNodes.Length = PruneCoverSlack;
    //return;    
}

protected function int InternalGetNumCoverNodesFound()
{
    local int iNumNodes;

    // End:0x24
    if(!owningBrainState.GetCallbackParamInt('numnodes', iNumNodes))
    {
        return 0;
    }
    return iNumNodes;
    //return ReturnValue;    
}

protected function bool GetAllCoverNodes(out array<KynapseCoverNode> List)
{
    local int iNumNodes, I;
    local KynapseCoverNode Node;

    // End:0x24
    if(!owningBrainState.GetCallbackParamInt('numnodes', iNumNodes))
    {
        return false;
    }
    I = 0;
    J0x2B:

    // End:0xBB [Loop If]
    if(I < iNumNodes)
    {
        // End:0x5D
        if(List.Length < (I + 1))
        {
            List.Length = List.Length + 1;
        }
        Node = List[I];
        // End:0x89
        if(Node == none)
        {
            Node = new (self) Class'EAKynapse.KynapseCoverNode';
        }
        // End:0xB1
        if(GetSingleCoverNode(I, Node))
        {
            List[I] = Node;
        }
        I++;
        // [Loop Continue]
        goto J0x2B;
    }
    return true;
    //return ReturnValue;    
}

protected function bool GetSingleCoverNode(int idx, out KynapseCoverNode Node)
{
    local Object CoverNodeObj;
    local string covername;

    covername = "FoundNode" $ string(idx);
    // End:0x3C
    if(!owningBrainState.GetCallbackParamObject(name(covername), CoverNodeObj))
    {
        return false;
    }
    // End:0x5F
    if(KynapseCoverNode(CoverNodeObj) != none)
    {
        Node = KynapseCoverNode(CoverNodeObj);        
    }
    else
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

protected function SetAnimSetOnNode(out KynapseCoverNode Node)
{
    //return;    
}

protected function SetFindCoverParams(int maxnodes, int maxreturnednodes, int maxedges, Vector traversalStartPos, delegate<AxonDelegate> callback)
{
    owningBrainState.PushEventParamInt('maxedges', maxedges);
    owningBrainState.PushEventParamInt('maxnodes', maxnodes);
    owningBrainState.PushEventParamInt('maxreturnednodes', maxreturnednodes);
    owningBrainState.PushEventParamDelegate('finished', callback);
    owningBrainState.PushEventParamVector('startposition', traversalStartPos);
    //return;    
}

protected function SetEngmntDistCoverConstraintParams(float fMinDist, float fMaxDist, float fMinPenaltyDist, float fMaxPenaltyDist, float fMaxPenalty)
{
    owningBrainState.PushEventParamFloat('MinDist', fMinDist);
    owningBrainState.PushEventParamFloat('minpenaltydist', fMinPenaltyDist);
    owningBrainState.PushEventParamFloat('maxdist', fMaxDist);
    owningBrainState.PushEventParamFloat('maxpenaltydist', fMaxPenaltyDist);
    owningBrainState.PushEventParamFloat('maxPenalty', fMaxPenalty);
    //return;    
}

function SetPushHideCovConstraintParams(float fAngleTolerance)
{
    owningBrainState.PushEventParamFloat('angle_tolerance', fAngleTolerance);
    //return;    
}

defaultproperties
{
    bPruneOldCoverData=true
    PruneCoverSlack=30
}