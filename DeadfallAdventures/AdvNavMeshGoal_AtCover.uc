class AdvNavMeshGoal_AtCover extends NavMeshGoal_At;

static function bool FindCoverNearActor(NavigationHandle NavHandle, Actor GoalActor, float Radius, optional float Dist, optional bool bReturnPartial, optional out CoverInfo out_Cover, optional EvilPawn InMyEvilPawn, optional bool bOverrideSearchStartLocation, optional Vector SearchStartLocation)
{
    local Controller GoalController, MyController;
    local float Rad, Height;
    local Vector TargetLoc;

    // End:0x1F6
    if(NavHandle != none)
    {
        GoalController = Controller(GoalActor);
        // End:0x68
        if(GoalController != none)
        {
            GoalActor = GoalController.Pawn;
        }
        // End:0x1F6
        if(GoalActor != none)
        {
            MyController = Controller(NavHandle.Outer);
            NavHandle.PopulatePathfindingParamCache();
            TargetLoc = GoalActor.GetDestination(MyController);
            GoalActor.GetBoundingCylinder(Rad, Height);
            TargetLoc.Z -= (Height - NavHandle.CachedPathParams.SearchExtent.Z);
            return FindCoverNearLocation(NavHandle, TargetLoc, Radius, Dist, bReturnPartial,, out_Cover, InMyEvilPawn, bOverrideSearchStartLocation, SearchStartLocation);
        }
    }
    return false;
    //return ReturnValue;    
}

static function bool FindCoverNearLocation(NavigationHandle NavHandle, Vector GoalLocation, float Radius, optional float Dist, optional bool bReturnPartial, optional bool bInWeightPartialByDist, optional out CoverInfo out_Cover, optional EvilPawn InMyEvilPawn, optional bool bOverrideSearchStartLocation, optional Vector SearchStartLocation)
{
    local array<CoverInfo> CoverList, CoverListPrev;
    local CoverInfo CoverInfo, BestCoverGoalInfo;
    local float BestCoverGoalRating;
    local AdvAIController_Cover CoverAI;
    local float GoalRatingModifier, GoalToCoverDistanceSq, CoverSelectEpsilon, Rating, CoverDotEnemy;

    local int I;
    local Vector SearchExtend;

    // End:0xDE3
    if(NavHandle != none)
    {
        CoverAI = AdvAIController_Cover(InMyEvilPawn.Controller);
        J0x47:

        CoverList = CoverListPrev;
        CoverListPrev.Remove(0, CoverListPrev.Length);        
        SearchExtend.X = Radius;
        SearchExtend.Y = Radius;
        SearchExtend.Z = Radius * 0.5000000;
        NavHandle.GetAllCoverSlotsInBox(((bOverrideSearchStartLocation) ? SearchStartLocation : NavHandle.CachedPathParams.SearchStart), SearchExtend, CoverListPrev);
        // End:0x267
        if((CoverAI != none) && CoverAI.HasCombatZones())
        {
            I = CoverListPrev.Length - 1;
            J0x1AE:

            // End:0x267 [Loop If]
            if(I >= 0)
            {
                // End:0x259
                if(!CoverAI.IsLocationInCombatZones(CoverListPrev[I].Link.GetSlotLocation(CoverListPrev[I].SlotIdx)))
                {
                    CoverListPrev.Remove(I, 1);                    
                }
                I--;
                // [Loop Continue]
                goto J0x1AE;
            }
        }
        // End:0x29F
        if(CoverListPrev.Length > 0)
        {
            Radius = (Radius * 10.0000000) / float(CoverListPrev.Length);
        }
        // End:0x47
        if(!((Radius < 100.0000000) || CoverListPrev.Length <= 10))
            goto J0x47;
        // End:0x2E9
        if(CoverListPrev.Length > 2)
        {
            CoverList = CoverListPrev;
        }
        J0x2E9:

        // End:0x315 [Loop If]
        if(CoverList.Length > 15)
        {
            CoverList.Remove(Rand(CoverList.Length), 1);            
            // [Loop Continue]
            goto J0x2E9;
        }
        // End:0xC9A
        foreach CoverList(CoverInfo)
        {
            // End:0xC32
            if(((CoverInfo.Link != none) && CoverInfo.Link.IsEnabled()) && CoverAI.CanClaimCover(CoverInfo.Link))
            {
                // End:0xBBA
                if(((((CoverInfo.Link.IsValidClaim(InMyEvilPawn, CoverInfo.SlotIdx) && (CoverInfo.Link.Slots[CoverInfo.SlotIdx].SlotOwner == InMyEvilPawn) || CoverInfo.Link.Slots[CoverInfo.SlotIdx].SlotOwner == none) && CoverAI != none) && CoverAI.Cover.Link != CoverInfo.Link) && CoverAI.LastCover.Link != CoverInfo.Link) && CoverAI.CheckCoverVisibilityToTarget(CoverInfo) > 0.0000000)
                {
                    GoalToCoverDistanceSq = VSizeSq(CoverInfo.Link.GetSlotLocation(CoverInfo.SlotIdx) - GoalLocation);
                    CoverSelectEpsilon = Normal(GoalLocation - InMyEvilPawn.Location) Dot Normal(CoverInfo.Link.GetSlotLocation(CoverInfo.SlotIdx) - InMyEvilPawn.Location);
                    // End:0xB3F
                    if((GoalToCoverDistanceSq > (CoverAI.EnemyDistance_CoveringThreshold * CoverAI.EnemyDistance_CoveringThreshold)) && (int(CoverAI.AcquireCover) == int(1)) || (CoverSelectEpsilon > CoverAI.CoverSearchEpsilon) && (CoverAI.LastCover.Link == none) || VSize(CoverAI.LastCover.Link.GetSlotLocation(CoverAI.LastCover.SlotIdx) - GoalLocation) > (VSize(CoverInfo.Link.GetSlotLocation(CoverInfo.SlotIdx) - GoalLocation) + InMyEvilPawn.GetCollisionRadius()))
                    {
                        GoalRatingModifier = Normal(Vector(InMyEvilPawn.Rotation)) Dot Normal(CoverInfo.Link.GetSlotLocation(CoverInfo.SlotIdx) - InMyEvilPawn.Location);
                        GoalRatingModifier = ((GoalRatingModifier > 0.7000000) ? 1.0500000 : 1.0000000);
                        // End:0xAC2
                        if(!CoverAI.IsCoverExposedToAnEnemy(CoverInfo,, CoverDotEnemy))
                        {
                            GoalRatingModifier *= -CoverDotEnemy;
                            EvaluateGoal(CoverInfo, GoalLocation, NavHandle.CachedPathParams, BestCoverGoalInfo, BestCoverGoalRating, GoalRatingModifier, Rating);
                            EvilCoverLink(CoverInfo.Link).SetAIDebug(CoverAI, CoverInfo.SlotIdx, Rating, "");                            
                        }
                        else
                        {
                            EvilCoverLink(CoverInfo.Link).SetAIDebug(CoverAI, CoverInfo.SlotIdx, 0.0000000, "CoverExposedToEnemy");
                        }                        
                    }
                    else
                    {
                        EvilCoverLink(CoverInfo.Link).SetAIDebug(CoverAI, CoverInfo.SlotIdx, 0.0000000, "SearchEpsilonFail");
                    }                    
                }
                else
                {
                    EvilCoverLink(CoverInfo.Link).SetAIDebug(CoverAI, CoverInfo.SlotIdx, 0.0000000, "VisibilityFail");
                }                
            }
            else
            {
                EvilCoverLink(CoverInfo.Link).SetAIDebug(CoverAI, CoverInfo.SlotIdx, 0.0000000, "");
            }            
        }        
        // End:0xDE3
        if(((BestCoverGoalInfo.Link != none) && BestCoverGoalInfo.Link.IsEnabled()) && (BestCoverGoalInfo.Link.Slots[BestCoverGoalInfo.SlotIdx].SlotOwner == InMyEvilPawn) || BestCoverGoalInfo.Link.Slots[BestCoverGoalInfo.SlotIdx].SlotOwner == none)
        {
            out_Cover = BestCoverGoalInfo;
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

static function bool FindCoverAnyActor(NavigationHandle NavHandle, Actor GoalActor, float Radius, optional float Dist, optional bool bReturnPartial, optional out CoverInfo out_Cover, optional EvilPawn InMyEvilPawn)
{
    local Controller GoalController, MyController;
    local float Rad, Height;
    local Vector TargetLoc;

    // End:0x1E1
    if(NavHandle != none)
    {
        GoalController = Controller(GoalActor);
        // End:0x66
        if(GoalController != none)
        {
            GoalActor = GoalController.Pawn;
        }
        // End:0x1E1
        if(GoalActor != none)
        {
            MyController = Controller(NavHandle.Outer);
            NavHandle.PopulatePathfindingParamCache();
            TargetLoc = GoalActor.GetDestination(MyController);
            GoalActor.GetBoundingCylinder(Rad, Height);
            TargetLoc.Z -= (Height - NavHandle.CachedPathParams.SearchExtent.Z);
            return FindCoverAnyLocation(NavHandle, TargetLoc, Radius, Dist, bReturnPartial,, out_Cover, InMyEvilPawn);
        }
    }
    return false;
    //return ReturnValue;    
}

static function bool FindCoverAnyLocation(NavigationHandle NavHandle, Vector GoalLocation, float Radius, optional float Dist, optional bool bReturnPartial, optional bool bInWeightPartialByDist, optional out CoverInfo out_Cover, optional EvilPawn InMyEvilPawn)
{
    local array<CoverInfo> CoverList, CoverListPrev;
    local CoverInfo CoverInfo, BestCoverGoalInfo;
    local float BestCoverGoalRating;
    local AdvAIController_Cover CoverAI;
    local float GoalRatingModifier, GoalToCoverDistanceSq, CoverSelectEpsilon, Rating, CoverDotEnemy, TempVisibilityRating;

    local CoverLink tempCoverLink;
    local int I;
    local Vector SearchExtend;

    // End:0xBED
    if(NavHandle != none)
    {
        CoverAI = AdvAIController_Cover(InMyEvilPawn.Controller);
        // End:0x5D
        if(AdvAI_Ally(CoverAI) != none)
        {
        }
        J0x5D:

        CoverList = CoverListPrev;
        CoverListPrev.Remove(0, CoverListPrev.Length);        
        SearchExtend.X = Radius;
        SearchExtend.Y = Radius;
        SearchExtend.Z = Radius * 0.2500000;
        NavHandle.GetAllCoverSlotsInBox(NavHandle.CachedPathParams.SearchStart, SearchExtend, CoverListPrev);
        // End:0x265
        if((CoverAI != none) && CoverAI.HasCombatZones())
        {
            I = CoverListPrev.Length - 1;
            J0x1AC:

            // End:0x265 [Loop If]
            if(I >= 0)
            {
                // End:0x257
                if(!CoverAI.IsLocationInCombatZones(CoverListPrev[I].Link.GetSlotLocation(CoverListPrev[I].SlotIdx)))
                {
                    CoverListPrev.Remove(I, 1);                    
                }
                I--;
                // [Loop Continue]
                goto J0x1AC;
            }
        }
        // End:0x29D
        if(CoverListPrev.Length > 0)
        {
            Radius = (Radius * 5.0000000) / float(CoverListPrev.Length);
        }
        // End:0x5D
        if(!((Radius < 10.0000000) || CoverListPrev.Length <= 10))
            goto J0x5D;
        // End:0x2E7
        if(CoverListPrev.Length > 2)
        {
            CoverList = CoverListPrev;
        }
        // End:0xAA4
        foreach CoverList(CoverInfo)
        {
            tempCoverLink = CoverInfo.Link;
            // End:0xA34
            if(((tempCoverLink != none) && tempCoverLink.IsEnabled()) && CoverAI.CanClaimCover(CoverInfo.Link))
            {
                // End:0x9BC
                if(tempCoverLink.IsValidClaim(InMyEvilPawn, CoverInfo.SlotIdx, true, true))
                {
                    TempVisibilityRating = CoverAI.CheckCoverVisibilityToTarget(CoverInfo);
                    // End:0x944
                    if(TempVisibilityRating > 0.0000000)
                    {
                        GoalToCoverDistanceSq = VSizeSq(CoverInfo.Link.GetSlotLocation(CoverInfo.SlotIdx) - GoalLocation);
                        CoverSelectEpsilon = Normal(GoalLocation - InMyEvilPawn.Location) Dot Normal(CoverInfo.Link.GetSlotLocation(CoverInfo.SlotIdx) - InMyEvilPawn.Location);
                        // End:0x8B7
                        if(GoalToCoverDistanceSq > (CoverAI.EnemyDistance_CoveringThreshold * CoverAI.EnemyDistance_CoveringThreshold))
                        {
                            // End:0x83C
                            if((int(CoverAI.AcquireCover) == int(1)) || CoverSelectEpsilon > CoverAI.CoverSearchEpsilon)
                            {
                                GoalRatingModifier = Normal(Vector(InMyEvilPawn.Rotation)) Dot Normal(CoverInfo.Link.GetSlotLocation(CoverInfo.SlotIdx) - InMyEvilPawn.Location);
                                GoalRatingModifier = ((GoalRatingModifier > 0.7000000) ? 1.0500000 : 1.0000000);
                                // End:0x7BB
                                if(!CoverAI.IsCoverExposedToAnEnemy(CoverInfo,, CoverDotEnemy))
                                {
                                    GoalRatingModifier *= -CoverDotEnemy;
                                    EvaluateNearestGoal(CoverInfo, GoalLocation, NavHandle.CachedPathParams, BestCoverGoalInfo, BestCoverGoalRating, GoalRatingModifier, Rating);
                                    EvilCoverLink(CoverInfo.Link).SetAIDebug(CoverAI, CoverInfo.SlotIdx, Rating, "");                                    
                                }
                                else
                                {
                                    EvilCoverLink(CoverInfo.Link).SetAIDebug(CoverAI, CoverInfo.SlotIdx, CoverDotEnemy, "CoverExposedToEnemy");
                                }                                
                            }
                            else
                            {
                                EvilCoverLink(CoverInfo.Link).SetAIDebug(CoverAI, CoverInfo.SlotIdx, 0.0000000, "SearchEpsilonFail");
                            }                            
                        }
                        else
                        {
                            EvilCoverLink(CoverInfo.Link).SetAIDebug(CoverAI, CoverInfo.SlotIdx, 0.0000000, "EnemyDistance_CoveringThresholdFail");
                        }                        
                    }
                    else
                    {
                        EvilCoverLink(CoverInfo.Link).SetAIDebug(CoverAI, CoverInfo.SlotIdx, 0.0000000, "VisibilityFail");
                    }                    
                }
                else
                {
                    EvilCoverLink(CoverInfo.Link).SetAIDebug(CoverAI, CoverInfo.SlotIdx, 0.0000000, "OwnershipIssue");
                }                
            }
            else
            {
                EvilCoverLink(CoverInfo.Link).SetAIDebug(CoverAI, CoverInfo.SlotIdx, 0.0000000, "Disabled");
            }            
        }        
        // End:0xBED
        if(((BestCoverGoalInfo.Link != none) && BestCoverGoalInfo.Link.IsEnabled()) && (BestCoverGoalInfo.Link.Slots[BestCoverGoalInfo.SlotIdx].SlotOwner == InMyEvilPawn) || BestCoverGoalInfo.Link.Slots[BestCoverGoalInfo.SlotIdx].SlotOwner == none)
        {
            out_Cover = BestCoverGoalInfo;
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

static function bool EvaluateGoal(CoverInfo PossibleCoverGoalInfo, Vector GoalLocation, NavMeshPathParams PathParams, out CoverInfo out_GenCoverGoalInfo, out float BestCoverGoalRating, optional float GoalRatingModifier = 1.0000000, optional out float Rating)
{
    local float PossibleCoverGoalRating, PossibleCoverGoalToPawnDistance, GoalLocationToPossibleCoverGoalDistance, GoalLocationToPawnDistance;
    local Vector PossibleCoverGoalSlotLocation;

    PossibleCoverGoalSlotLocation = PossibleCoverGoalInfo.Link.GetSlotLocation(PossibleCoverGoalInfo.SlotIdx);
    PossibleCoverGoalToPawnDistance = VSize(PossibleCoverGoalSlotLocation - PathParams.SearchStart);
    GoalLocationToPossibleCoverGoalDistance = VSize(GoalLocation - PossibleCoverGoalSlotLocation);
    GoalLocationToPawnDistance = VSize(GoalLocation - PathParams.SearchStart);
    PossibleCoverGoalRating = 100.0000000 / (PossibleCoverGoalToPawnDistance + GoalLocationToPossibleCoverGoalDistance);
    // End:0x154
    if((GoalLocationToPawnDistance > 10.0000000) && GoalLocationToPawnDistance < PossibleCoverGoalToPawnDistance)
    {
        PossibleCoverGoalRating = -1.0000000 / PossibleCoverGoalRating;
    }
    // End:0x211
    if((PossibleCoverGoalRating > 0.0000000) && PossibleCoverGoalRating < 1.5000000)
    {
        PossibleCoverGoalRating = PossibleCoverGoalRating * GoalRatingModifier;
        // End:0x1FB
        if((out_GenCoverGoalInfo.Link == none) || PossibleCoverGoalRating > BestCoverGoalRating)
        {
            out_GenCoverGoalInfo = PossibleCoverGoalInfo;
            BestCoverGoalRating = PossibleCoverGoalRating;
        }
        Rating = PossibleCoverGoalRating;        
    }
    else
    {
        Rating = 0.0000000;
    }
    return false;
    //return ReturnValue;    
}

static function bool EvaluateNearestGoal(CoverInfo TempCoverInfo, Vector GoalLocation, NavMeshPathParams PathParams, out CoverInfo BestCoverInfo, out float BestCoverRating, optional float GoalRatingModifier = 1.0000000, optional out float Rating, optional float MaxDistanceSq = 0.0000000)
{
    local float TempRating, TempCoverToPawnDistSq, TempGoalToCoverDistSq;
    local Vector TempCoverLocation;

    TempCoverLocation = TempCoverInfo.Link.GetSlotLocation(TempCoverInfo.SlotIdx);
    TempCoverToPawnDistSq = VSizeSq(TempCoverLocation - PathParams.SearchStart);
    TempGoalToCoverDistSq = VSizeSq(GoalLocation - TempCoverLocation);
    TempRating = 1.0000000 / (TempCoverToPawnDistSq * TempGoalToCoverDistSq);
    // End:0x12A
    if((MaxDistanceSq > 0.0000000) && MaxDistanceSq < TempCoverToPawnDistSq)
    {
        TempRating = -1.0000000 / TempRating;
    }
    // End:0x1E7
    if((TempRating > 0.0000000) && TempRating < 1.5000000)
    {
        TempRating = TempRating * GoalRatingModifier;
        // End:0x1D1
        if((BestCoverInfo.Link == none) || TempRating > BestCoverRating)
        {
            BestCoverInfo = TempCoverInfo;
            BestCoverRating = TempRating;
        }
        Rating = TempRating;        
    }
    else
    {
        Rating = 0.0000000;
    }
    return false;
    //return ReturnValue;    
}
