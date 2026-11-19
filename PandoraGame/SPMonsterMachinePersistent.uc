class SPMonsterMachinePersistent extends SkeletalMeshActor
    abstract
    native;

enum EMPTeamThatOwnsMachine
{
    EMPTeamThatOwnsMachine_1,       // 0
    EMPTeamThatOwnsMachine_2,       // 1
    EMPTeamThatOwnsMachine_MAX      // 2
};

enum EMPMonsterMachineState
{
    EMPMonsterMachineStateOff,      // 0
    EMPMonsterMachineStateOn,       // 1
    EMPMonsterMachineStateBeingFed, // 2
    EMPMonsterMachineState_MAX      // 3
};

var MaterialInstanceConstant matInstance;
/** Does this monster machine belong to team 1 or team 2. */
var() repnotify SPMonsterMachinePersistent.EMPTeamThatOwnsMachine OwningTeam;
var repnotify SPMonsterMachinePersistent.EMPMonsterMachineState MaterialState;
var bool IsActivated;
var float OnCurrValue;
var float OnDestValue;
var float OnChangeRate;
var float FeedCurrValue;
var float FeedDestValue;
var float FeedChangeRate;
var MonsterMachineLFHolder LFHolder;

replication
{
    // Pos:0x000
    if((int(Role) == int(ROLE_Authority)) && bNetDirty
        FeedDestValue, IsActivated, 
        MaterialState, OnDestValue, 
        OwningTeam;
}

event SetOwningTeam(SPMonsterMachinePersistent.EMPTeamThatOwnsMachine NewValue)
{
    OwningTeam = NewValue;
    UpdateOwningTeam();
    //return;    
}

event SetMaterialState(SPMonsterMachinePersistent.EMPMonsterMachineState NewValue)
{
    MaterialState = NewValue;
    UpdateMaterialState();
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    super.ReplicatedEvent(VarName);
    // End:0x2B
    if(VarName == 'OwningTeam')
    {
        UpdateOwningTeam();        
    }
    else
    {
        // End:0x48
        if(VarName == 'MaterialState')
        {
            UpdateMaterialState();
        }
    }
    //return;    
}

simulated function bool IsOwnedByPlayersTeam(PlayerPawn P)
{
    local TeamInfo TI;

    TI = P.GetTeam();
    // End:0x27
    if(TI == none)
    {
        return false;
    }
    // End:0x7A
    if(((int(OwningTeam) == int(0)) && TI.TeamIndex == 1) || (int(OwningTeam) == int(1)) && TI.TeamIndex == 2)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    UpdateOwningTeam();
    UpdateMaterialState();
    CreateMonsterMachineLFHolder();
    //return;    
}

function CreateMonsterMachineLFHolder()
{
    LFHolder = Spawn(Class'MonsterMachineLFHolder', self, 'MonsterMachineLF', Location, Rotation);
    //return;    
}

simulated function Tick(float DeltaTime)
{
    local MaterialInstanceConstant theMatInstance;
    local float onValAtStart, feedValAtStart;

    onValAtStart = OnCurrValue;
    feedValAtStart = FeedCurrValue;
    // End:0x55
    if(OnCurrValue < OnDestValue)
    {
        OnCurrValue += (DeltaTime * OnChangeRate);
        // End:0x52
        if(OnCurrValue > OnDestValue)
        {
            OnCurrValue = OnDestValue;
        }        
    }
    else
    {
        // End:0x91
        if(OnCurrValue > OnDestValue)
        {
            OnCurrValue -= (DeltaTime * OnChangeRate);
            // End:0x91
            if(OnCurrValue < OnDestValue)
            {
                OnCurrValue = OnDestValue;
            }
        }
    }
    // End:0xD0
    if(FeedCurrValue < FeedDestValue)
    {
        FeedCurrValue += (DeltaTime * FeedChangeRate);
        // End:0xCD
        if(FeedCurrValue > FeedDestValue)
        {
            FeedCurrValue = FeedDestValue;
        }        
    }
    else
    {
        // End:0x10C
        if(FeedCurrValue > FeedDestValue)
        {
            FeedCurrValue -= (DeltaTime * FeedChangeRate);
            // End:0x10C
            if(FeedCurrValue < FeedDestValue)
            {
                FeedCurrValue = FeedDestValue;
            }
        }
    }
    // End:0x19E
    if((OnCurrValue != onValAtStart) || FeedCurrValue != feedValAtStart)
    {
        theMatInstance = GetMatInst();
        // End:0x16D
        if(OnCurrValue != onValAtStart)
        {
            theMatInstance.SetScalarParameterValue('MP_Machine_On', OnCurrValue);
        }
        // End:0x19E
        if(FeedCurrValue != feedValAtStart)
        {
            theMatInstance.SetScalarParameterValue('MP_Machine_Feed', FeedCurrValue);
        }
    }
    //return;    
}

simulated function MaterialInstanceConstant GetMatInst()
{
    // End:0x63
    if(matInstance == none)
    {
        matInstance = new (none) Class'Engine.MaterialInstanceConstant';
        matInstance.SetParent(Material(SkeletalMeshComponent.GetMaterial(0)));
        SkeletalMeshComponent.SetMaterial(0, matInstance);
    }
    return matInstance;
    //return ReturnValue;    
}

simulated event UpdateOwningTeam()
{
    local MaterialInstanceConstant theMatInstance;

    theMatInstance = GetMatInst();
    // End:0x45
    if(int(OwningTeam) == int(0))
    {
        theMatInstance.SetScalarParameterValue('Color_change', 1.0000000);        
    }
    else
    {
        theMatInstance.SetScalarParameterValue('Color_change', 0.0000000);
    }
    //return;    
}

simulated function UpdateMaterialState()
{
    switch(MaterialState)
    {
        // End:0x26
        case 0:
            OnDestValue = 0.0000000;
            FeedDestValue = 0.0000000;
            // End:0x65
            break;
        // End:0x44
        case 1:
            OnDestValue = 1.0000000;
            FeedDestValue = 0.0000000;
            // End:0x65
            break;
        // End:0x62
        case 2:
            OnDestValue = 0.0000000;
            FeedDestValue = 1.0000000;
            // End:0x65
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}

simulated function name GetStage(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    local int fillLevel;
    local PandoraGRI PGRI;
    local SPPointEventMachineBonusPersistent theMachineBonus;

    PGRI = PandoraGRI(WorldInfo.GRI);
    theMachineBonus = PGRI.GetPointEventMachineBonus();
    fillLevel = theMachineBonus.GetLevelForFillPercent(int(PGRI.GetMonsterMachineValue(int(OwningTeam) + int(1))));
    fillLevel += 1;
    switch(fillLevel)
    {
        // End:0x8F
        case 0:
            return 'Stage0';
        // End:0x9D
        case 1:
            return 'Stage1';
        // End:0xAC
        case 2:
            return 'Stage2';
        // End:0xBB
        case 3:
            return 'Stage3';
        // End:0xFFFF
        default:
            return 'Stage0';
            break;
    }
    //return ReturnValue;    
}

simulated function name GetActivatingOrActivated(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    // End:0x13
    if(IsActivated)
    {
        return 'Activated';
    }
    return 'Activating';
    //return ReturnValue;    
}

simulated function name BeginActivating(SPAnimGenericFunctionMonitorNode Node)
{
    IsActivated = false;
    return 'None';
    //return ReturnValue;    
}

simulated function FinishedActivating()
{
    IsActivated = true;
    //return;    
}
