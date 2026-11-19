class MOHASquad extends KynapseSquad
    hidecategories(Navigation);

var float fLastDispatchPerformanceTime;
var float fTimeBetweenDispatchPerformances;
var int MinAssignedForDispatchPerformance;
var name PointPerformanceName;

function PostBeginPlay()
{
    local PlayerController PC;

    super.PostBeginPlay();
    // End:0x50
    foreach LocalPlayerControllers(PC)
    {
        // End:0x4F
        if(MOHAHUD(PC.myHUD) != none)
        {
            MOHAHUD(PC.myHUD).AddPostRenderedActor(self);
        }        
    }    
    //return;    
}

event FingerAdvanced(array<Controller> winningMembers)
{
    TripNamedScriptEventOnMembers(winningMembers, 'TacaffAdvanced');
    RequestCCOnMembers(SquadMembers, "TacticalAffordanceAdvance");
    //return;    
}

event FingerRetreated(array<Controller> losingMembers)
{
    TripNamedScriptEventOnMembers(losingMembers, 'TacaffRetreated');
    RequestCCOnMembers(SquadMembers, "TacticalAffordanceRetreat");
    //return;    
}

event FlankOpportunity(array<Controller> membersPreparingToFlank)
{
    //return;    
}

event FlankExecuted(array<Controller> flankingMembers)
{
    TripNamedScriptEventOnMembers(flankingMembers, 'FlankExecuted');
    //return;    
}

event StrategicAdvance()
{
    TripNamedScriptEventOnMembers(SquadMembers, 'TacaffAdvanced');
    SetTimer(5.0000000, false, 'CCStrategicAdvance');
    //return;    
}

function CCStrategicAdvance()
{
    RequestCCOnMembers(SquadMembers, "StrategicAdvance");
    //return;    
}

event StrategicRetreat()
{
    TripNamedScriptEventOnMembers(SquadMembers, 'TacaffRetreated');
    RequestCCOnMembers(SquadMembers, "StrategicRetreat");
    //return;    
}

static function PushPositionsForPerformance(name PerformanceName, AxonBrainStateStack BrainStateStack, array<Vector> newFingerPositions)
{
    local int I;
    local name makeAName;

    BrainStateStack.PushNamedScriptEventParamInt(PerformanceName, 'numNewFingers', newFingerPositions.Length);
    I = 0;
    J0x2A:

    // End:0x82 [Loop If]
    if(I < newFingerPositions.Length)
    {
        makeAName = name("finger_" $ string(I));
        BrainStateStack.PushNamedScriptEventParamVector(PerformanceName, makeAName, newFingerPositions[I]);
        I++;
        // [Loop Continue]
        goto J0x2A;
    }
    //return;    
}

static function PopPositionsForPerformance(AxonBrainState Abs, out array<Vector> newFingerPositions)
{
    local int I, Count;
    local name makeAName;
    local Vector Temp;

    // End:0x88
    if(Abs.GetCallbackParamInt('numNewFingers', Count))
    {
        I = 0;
        J0x27:

        // End:0x88 [Loop If]
        if(I < Count)
        {
            makeAName = name("finger_" $ string(I));
            // End:0x7E
            if(Abs.GetCallbackParamVector(makeAName, Temp))
            {
                newFingerPositions[newFingerPositions.Length] = Temp;
            }
            I++;
            // [Loop Continue]
            goto J0x27;
        }
    }
    //return;    
}

event FriendlyDispatch(int numAssigned, array<Vector> newFingerPositions)
{
    local MOHAAIController bestPerformer;

    // End:0xD5
    if((numAssigned >= MinAssignedForDispatchPerformance) && WorldInfo.TimeSeconds > (fLastDispatchPerformanceTime + fTimeBetweenDispatchPerformances))
    {
        bestPerformer = FindBestPerformanceGiver(SquadMembers);
        // End:0xD2
        if(bestPerformer != none)
        {
            fLastDispatchPerformanceTime = WorldInfo.TimeSeconds;
            PushPositionsForPerformance(PointPerformanceName, bestPerformer.ABSS, newFingerPositions);
            bestPerformer.ABSS.PushNamedScriptEventParamName(PointPerformanceName, 'CCStimulus', 'AffordanceDispatch');
            bestPerformer.ABSS.TripNamedScriptEvent(PointPerformanceName);
        }        
    }
    else
    {
        // End:0x103
        if(numAssigned > 1)
        {
            RequestCCOnMembers(SquadMembers, "AffordanceDispatch");
        }
    }
    //return;    
}

event EnemyDispatch(int numAssigned)
{
    // End:0x33
    if(numAssigned > 1)
    {
        RequestCCOnMembers(SquadMembers, "EnemyAffordanceDispatch");
    }
    //return;    
}

function RequestCCOnMembers(array<Controller> mems, string stim)
{
    local int I;
    local MOHAScriptAIController C;

    I = 0;
    J0x07:

    // End:0x73 [Loop If]
    if(I < mems.Length)
    {
        C = MOHAScriptAIController(mems[I]);
        // End:0x3B
        if(C == none)
        {
            // [Explicit Continue]
            goto J0x69;
        }
        // End:0x50
        if(C.bPerformingCustomPerformance)
        {
            // [Explicit Continue]
            goto J0x69;
        }
        C.SendCCStimulus(stim);
        J0x69:

        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function float EvaluatePerformanceGiver(MOHAPlayerController PC, MOHAAIController C)
{
    //return ReturnValue;    
}

function MOHAAIController FindBestPerformanceGiver(array<Controller> mems)
{
    local float fScore, fBestScore;
    local int bestIndex, I;
    local Controller C;
    local MOHAPlayerController PC;

    PC = Class'MOHAUtilities'.static.GetLocalPlayerController(self);
    // End:0x3D
    if((PC == none) || PC.Pawn == none)
    {
        return none;
    }
    bestIndex = -1;
    I = 0;
    J0x4F:

    // End:0xF3 [Loop If]
    if(I < mems.Length)
    {
        fScore = 0.0000000;
        C = mems[I];
        // End:0xA4
        if((MOHAAIController(C) == none) || C.Pawn == none)
        {
            // [Explicit Continue]
            goto J0xE9;
        }
        fScore += (EvaluatePerformanceGiver(PC, MOHAAIController(C)));
        // End:0xE9
        if(fScore > fBestScore)
        {
            fBestScore = fScore;
            bestIndex = I;
        }
        J0xE9:

        I++;
        // [Loop Continue]
        goto J0x4F;
    }
    // End:0x113
    if(bestIndex != -1)
    {
        return MOHAAIController(mems[bestIndex]);
    }
    return none;
    //return ReturnValue;    
}

defaultproperties
{
    fLastDispatchPerformanceTime=-10.0000000
    fTimeBetweenDispatchPerformances=10.0000000
    MinAssignedForDispatchPerformance=3
    PointPerformanceName="PerformancePoint"
    // Reference: KynapseEntityComponent'Default__MOHASquad.KynapseEnt0'
    begin object name=KynapseEnt0
    end object
    KynEntityComponent=KynapseEnt0
    // Reference: AxonBrainStateStack'Default__MOHASquad.ABSS0'
    begin object name=ABSS0 class=Class'EAKynapse.AxonBrainStateStack'
    end object
    ABSS=ABSS0
    Components[0]=KynapseEnt0
    // Reference: SpriteComponent'Default__MOHASquad.Sprite'
    begin object name=Sprite class=Class'Engine.SpriteComponent'
        Sprite=Texture2D'EngineResources.S_NavP'
        AlwaysLoadOnClient=false
        AlwaysLoadOnServer=false
    end object
    Components[1]=Sprite
    ActorType=20
    bHidden=true
}