class SeqAct_ActionDirector extends SeqAct_Latent
    forcescriptorder(true)
    hidecategories(Object)
    implements(AIDirectorController_Interface);

struct ParamsTimelineInfo
{
    var() float TimePercent;
    var() AIDirectorParams Parameters;

    structdefaultproperties
    {
        TimePercent=0.0000000
        Parameters=(DesiredGameIntensity=1.0000000,GameIntensityTreshold=0.5000000,MinTimeBetweenSpawns=2.0000000,PreferSpawnsInPlayerFOV=true,AgrressionLevel=EAggressionLevel.AL_High)
    }
};

var() array<ParamsTimelineInfo> ParametersTimeline;
var() float ActionTime;
var float CurrentActionTime;
var float StartTime;
var int SpawnedCount;
var float LastSpawnTime;
var int CurrentParamsIdx;
var EvilGame CurrentGame;
var AIDirectorBase AIDirector;
var int NextFactoryIdx;

function SetAIDirector(AIDirectorBase AIDirectorObject)
{
    AIDirector = AIDirectorObject;
    //return;    
}

function SetAIDParams(AIDirectorParams Params)
{
    AIDirector.UpdateParameters(Params);
    //return;    
}

function ActivateAIDirector()
{
    // End:0xBA
    if(ParametersTimeline.Length > 0)
    {
        SetAIDirector(CurrentGame.AIDirectorInstance);
        AIDirector.Activate(AIDirectorController_Interface(self), ParametersTimeline[0].Parameters);
        AIDirector.SetSpawnDelegate(ActivateSpawners);
        NextFactoryIdx = 0;
    }
    //return;    
}

function DeactivateAIDirector()
{
    AIDirector.Deactivate();
    //return;    
}

function DisplayParams()
{
    //return;    
}

function AIDirectorParams GetParams()
{
    return CurrentGame.AIDirectorInstance.ActualParameters;
    //return ReturnValue;    
}

event Activated()
{
    local WorldInfo WI;

    WI = GetWorldInfo();
    CurrentGame = EvilGame(WI.Game);
    StartTime = WI.TimeSeconds;
    ActivateAIDirector();
    //return;    
}

function Deactivaded()
{
    DeactivateAIDirector();
    //return;    
}

function UpdateParameters()
{
    // End:0xAB
    if(ActionTime > float(0))
    {
        // End:0xAB
        if((CurrentParamsIdx < (ParametersTimeline.Length - 1)) && (CurrentActionTime / ActionTime) > ParametersTimeline[CurrentParamsIdx + 1].TimePercent)
        {
            ++CurrentParamsIdx;
            SetAIDParams(ParametersTimeline[CurrentParamsIdx].Parameters);
        }
    }
    //return;    
}

event bool Update(float DeltaTime)
{
    local WorldInfo WI;

    WI = GetWorldInfo();
    CurrentActionTime = WI.TimeSeconds - StartTime;
    // End:0xEC
    if(InputLinks[1].bHasImpulse || (ActionTime > float(0)) && CurrentActionTime > ActionTime)
    {
        CurrentGame.AIDirectorInstance.Deactivate();
        OutputLinks[0].bHasImpulse = true;
        return false;
    }
    UpdateParameters();
    return true;
    //return ReturnValue;    
}

function bool ActivateSpawners()
{
    local SeqAct_AIFactory FTC;
    local int Idx, FactoryNum;

    FactoryNum = OutputLinks[2].Links.Length;
    // End:0x148
    if(FactoryNum > 0)
    {
        Idx = NextFactoryIdx;
        J0x4C:

        // End:0x148 [Loop If]
        if(Idx < FactoryNum)
        {
            FTC = SeqAct_AIFactory(OutputLinks[2].Links[Idx].LinkedOp);
            // End:0x13A
            if(FTC != none)
            {
                // End:0x137
                if(TryToSpawnWithAIFactory(FTC, CurrentGame.AIDirectorInstance.GameIntensity))
                {
                    NextFactoryIdx = (Idx + Rand(FactoryNum)) % FactoryNum;
                    return true;
                }                
            }
            ++Idx;
            // [Loop Continue]
            goto J0x4C;
        }
    }
    NextFactoryIdx = Rand(FactoryNum) % FactoryNum;
    return false;
    //return ReturnValue;    
}

function bool TestConditionDelegate(Actor SpawnPoint, SeqAct_AIFactory AIFactory)
{
    local EvilPawn Player;
    local float DistToSpawn;
    local bool MustBeInFOV;

    Player = CurrentGame.AIDirectorInstance.FindPlayer();
    // End:0x7A
    if(CurrentGame.AIDirectorInstance.Players.Length == 0)
    {
        return false;
    }
    // End:0xC9
    if(AIFactory.OverrideActionDirector)
    {
        MustBeInFOV = AIFactory.MustBeInPlayerFOV;        
    }
    else
    {
        MustBeInFOV = GetParams().PreferSpawnsInPlayerFOV;
    }
    // End:0x235
    foreach CurrentGame.AIDirectorInstance.Players(Player)
    {
        DistToSpawn = VSize(Player.Location - SpawnPoint.Location);
        // End:0x1D7
        if(MustBeInFOV && !Player.Controller.IsAimingAt(SpawnPoint, 0.2000000))
        {
            continue;            
        }
        else
        {
            // End:0x234
            if((DistToSpawn >= AIFactory.MinSpawnRange) && DistToSpawn <= AIFactory.MaxSpawnRange)
            {                
                return true;
            }            
        }
    }    
    return false;
    //return ReturnValue;    
}

function bool TryToSpawnWithAIFactory(SeqAct_AIFactory FCT, float Intensity)
{
    local float EnemyIntensity;

    EnemyIntensity = class<EvilPawn>(FCT.static.GetPawnClassClass()).default.GameIntesityFactor;
    // End:0x1AA
    if(FCT.CanSpawn() && AIDirector.ValidateAdditionalIntensity(EnemyIntensity * float(FCT.SpawnCount)))
    {
        FCT.SetSpawnpointConditionDelagate(TestConditionDelegate);
        FCT.PreSelectedSpawnPointActor = FCT.GetValidSpawnpoint();
        // End:0x14C
        if(FCT.PreSelectedSpawnPointActor == none)
        {
            return false;
        }
        FCT.SetAIDirector(AIDirector);
        FCT.Activate();
        ++SpawnedCount;
        PublishLinkedVariableValues();
        return true;
    }
    return false;
    //return ReturnValue;    
}

static event int GetObjClassVersion()
{
    return super(SequenceObject).GetObjClassVersion() + 8;
    //return ReturnValue;    
}

defaultproperties
{
    ParametersTimeline[0]=(TimePercent=0.0000000,Parameters=(DesiredGameIntensity=1.0000000,GameIntensityTreshold=1.0000000,MinTimeBetweenSpawns=1.0000000,PreferSpawnsInPlayerFOV=false,AgrressionLevel=EAggressionLevel.AL_High))
    ActionTime=60.0000000
    LastSpawnTime=-1.0000000
    InputLinks[0]=(LinkDesc="In",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[1]=(LinkDesc="Stop",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    OutputLinks[0]=(Links=none,LinkDesc="Finished",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    OutputLinks[1]=(Links=none,LinkDesc="Aborted",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    OutputLinks[2]=(Links=none,LinkDesc="Spawns",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Int',LinkedVariables=none,LinkDesc="Spawn Count",LinkVar="None",PropertyName="SpawnedCount",bWriteable=true,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Float',LinkedVariables=none,LinkDesc="Action Time",LinkVar="None",PropertyName="CurrentActionTime",bWriteable=true,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="AI Action Director"
}