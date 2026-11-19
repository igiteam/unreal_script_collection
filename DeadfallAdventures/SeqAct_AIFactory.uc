class SeqAct_AIFactory extends SeqAct_Latent
    abstract
    native(Sequence)
    forcescriptorder(true)
    hidecategories(Object);

enum ESpawnPointSelection
{
    SPS_Normal,                     // 0
    SPS_Random,                     // 1
    SPS_MAX                         // 2
};

struct native AITypeInfo
{
    var string ControllerClassName;
    var array<string> PawnClassNameArray;
    var int TeamIdx;

    structdefaultproperties
    {
        ControllerClassName=""
        PawnClassNameArray=none
        TeamIdx=0
    }
};

struct native _PawnToPointInfo
{
    var EvilPawn P;
    var SpawnPointInterface Point;
    var bool bSpawnCompleted;

    structdefaultproperties
    {
        P=none
        Point=none
        bSpawnCompleted=false
    }
};

var() bool bRandomInventory;
var bool bPostSpawnCompleted;
var(AIFactory) bool UseSpawnAngle;
var() bool CheckSpawnCollision;
var(AIFactory) bool SeriesFromSameSpawn;
var() bool MustBeInPlayerFOV;
var() bool OverrideActionDirector;
var bool bSpawning;
var const bool bWaitingForAllDied;
var() bool bNotCountable;
var() array< class<Inventory> > InventoryList;
var() EvilTypes.ECharacterClothTypes CharacterCloth;
var byte AIType;
var(AIFactory) EvilTypesNative.EAITeam AITeam;
var() SeqAct_AIFactory.ESpawnPointSelection PointSelection;
var array<EvilPawnClothingSettings> CharacterClothArray;
var class<AIController> ControllerClass;
var init array< init class<Pawn> > PawnClassArray;
var int PawnClassIndex;
var(AIFactory) array<EvilCombatZone> CombatZones;
var private array<_PawnToPointInfo> PawnToPointInfo;
var const array<AITypeInfo> SpawnInfo;
var() array<Actor> SpawnPoints;
var(AIFactory) float SpawnStartDelay;
var(AIFactory) float SpawnDelay;
var(AIFactory) float GroupSpawnDelay;
var() export editinline SpawnMethod SpawnMethod;
var(AIFactory) int SpawnCount;
var(AIFactory) int SpawnGroupCount;
var() float MinSpawnRange;
var() float MaxSpawnRange;
var const float DelayToSpawn;
var const float DelayToGroupSpawn;
var int MaxSpawnTries;
var float LastSpawnedTime;
var int LastSpawnPointUsed;
var Actor LastUsedSpawnPointActor;
var Actor SelectedSpawnPointActor;
var Actor PreSelectedSpawnPointActor;
var int SpawnedCount;
var const int DebugSpawnedCount;
var int SpawnedGroupCount;
var delegate<SpawnCondition> SpawnpointSelectionConditions;
var Object SpawnedObject;
var AIDirectorBase AIDirector;
var array<AIFactoryObserverInterface> Observers;
//var delegate<SpawnCondition> __SpawnCondition__Delegate;

delegate bool SpawnCondition(Actor SpawnPoint, SeqAct_AIFactory AIFactory)
{
    //return ReturnValue;    
}

// Export USeqAct_AIFactory::execIsEnoughRoomToSpawnPawn(FFrame&, void* const)
native final function bool IsEnoughRoomToSpawnPawn(const Vector Location);

// Export USeqAct_AIFactory::execGetValidSpawnpoint(FFrame&, void* const)
native final function Actor GetValidSpawnpoint();

// Export USeqAct_AIFactory::execActivate(FFrame&, void* const)
native final function Activate();

// Export USeqAct_AIFactory::execDeactivate(FFrame&, void* const)
native final function Deactivate(optional bool bTriggerFinishedSpawningEvents = true);

// Export USeqAct_AIFactory::execSetPawnClassIndex(FFrame&, void* const)
native function SetPawnClassIndex(int InIdx);

// Export USeqAct_AIFactory::execInvalidatePawnClassIndex(FFrame&, void* const)
native function InvalidatePawnClassIndex();

// Export USeqAct_AIFactory::execIsPawnClassIndexValid(FFrame&, void* const)
native function bool IsPawnClassIndexValid();

// Export USeqAct_AIFactory::execGetRandomPawnClassIndex(FFrame&, void* const)
native function int GetRandomPawnClassIndex();

function class<Pawn> GetPawnClassClass()
{
    // End:0x19
    if(!IsPawnClassIndexValid())
    {
        return Class'EvilPawn';
    }
    return PawnClassArray[PawnClassIndex];
    //return ReturnValue;    
}

function SetAIDirector(AIDirectorBase InAIDirector)
{
    AIDirector = InAIDirector;
    //return;    
}

function bool CanSpawn()
{
    // End:0x20
    if(bSpawning || SelectedSpawnPointActor != none)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function SetSpawnpointConditionDelagate(delegate<SpawnCondition> dlg)
{
    SpawnpointSelectionConditions = dlg;
    //return;    
}

function bool TestSpawnPointVisibility(Actor SpawnPoint)
{
    return true;
    //return ReturnValue;    
}

event bool ValidateSpawnpoint(int Idx, optional delegate<SpawnCondition> ConditionDelegate = None)
{
    local SpawnPointInterface AFSP;
    local bool ret;

    ret = true;
    // End:0x60
    if(ConditionDelegate != none && !SpawnCondition(SpawnPoints[Idx], self))
    {
        return false;
    }
    // End:0xB4
    if((((SpawnCount > 1) && SeriesFromSameSpawn) && LastUsedSpawnPointActor != none) && SpawnPoints[Idx] != LastUsedSpawnPointActor)
    {
        return false;
    }
    AFSP = SpawnPointInterface(SpawnPoints[Idx]);
    // End:0x177
    if(ret && NotEqual_InterfaceInterface(AFSP, SpawnPointInterface(none)))
    {
        // End:0x177
        if(!AFSP.CanSpawn() || AFSP.CanOnlySpawnWhenInvisible() && TestSpawnPointVisibility(SpawnPoints[Idx]))
        {
            return false;
        }
    }
    return true;
    //return ReturnValue;    
}

event int PossibleSpawnPointsLeft()
{
    local SpawnPointInterface AFSP;
    local int Idx, PossibleNum;

    PossibleNum = 0;
    Idx = 0;
    J0x16:

    // End:0xD2 [Loop If]
    if(Idx < SpawnPoints.Length)
    {
        AFSP = SpawnPointInterface(SpawnPoints[Idx]);
        // End:0x74
        if(EqualEqual_InterfaceInterface(AFSP, SpawnPointInterface(none)))
        {
        }
        // End:0xC4
        if(NotEqual_InterfaceInterface(AFSP, SpawnPointInterface(none)) && AFSP.IsSpawnEnabled())
        {
            ++PossibleNum;
        }
        ++Idx;
        // [Loop Continue]
        goto J0x16;
    }
    return PossibleNum;
    //return ReturnValue;    
}

event SpawnPointSelected(Actor Spawn)
{
    //return;    
}

event SpawnPointActivated(Actor Spawn)
{
    local SpawnPointInterface AFSP;

    AFSP = SpawnPointInterface(Spawn);
    // End:0x5C
    if(NotEqual_InterfaceInterface(AFSP, SpawnPointInterface(none)))
    {
        AFSP.ActivateSpawn();
    }
    //return;    
}

event PostSpawned(Pawn NewPawn, Actor SpawnPoint)
{
    local SpawnPointInterface AFSP;
    local EvilPawn EP;
    local EvilCombatZone CombatZone;

    EP = EvilPawn(NewPawn);
    AddInventory(EP);
    // End:0x5E
    if(EP != none)
    {
        EP.AIFactory = self;
    }
    AddPawnToPoint(EvilPawn(NewPawn), SpawnPointInterface(SpawnPoint));
    // End:0xC6
    if(SpawnMethod != none)
    {
        SpawnMethod.PostCreateActor(NewPawn);        
    }
    else
    {
        // End:0xF9
        if(EP != none)
        {
            EP.SpawnCompleted(0);            
        }
        else
        {
            NotifyFactory(none, 0);
        }
        NewPawn.SetPhysics(2);
    }
    // End:0x1F9
    if(EP != none)
    {
        // End:0x1CF
        if(EP.MyEvilAI != none)
        {
            // End:0x1AB
            foreach CombatZones(CombatZone)
            {
                EP.MyEvilAI.CombatZones.AddItem(CombatZone);                                
            }            
            // End:0x1CF
            if((AIDirector != none) && !OverrideActionDirector)
            {                
            }
        }
        EP.PawnAIType = int(AIType);
    }
    AFSP = SpawnPointInterface(SpawnPoint);
    // End:0x2A0
    if(SpawnCount == SpawnedCount)
    {
        LastUsedSpawnPointActor = none;
        // End:0x27C
        if(NotEqual_InterfaceInterface(AFSP, SpawnPointInterface(none)))
        {
            AFSP.DeactivateSpawn(1.5000000);
        }
        OutputLinks[1].bHasImpulse = true;        
    }
    else
    {
        // End:0x30A
        if(NotEqual_InterfaceInterface(AFSP, SpawnPointInterface(none)) && AFSP.DeactivateAfterEachSpawn())
        {
            AFSP.DeactivateSpawn(2.5000000);
        }
    }
    //return;    
}

function AddInventory(EvilPawn NewPawn)
{
    local int Idx;
    local bool bRemoveNotMeleeWeapons;
    local array<Inventory> NonMeleeWeaponList;

    // End:0x11
    if(NewPawn == none)
    {
        return;
    }
    // End:0x40
    if(bRandomInventory)
    {
        NewPawn.EquipRandomInventory();        
    }
    else
    {
        // End:0x53
        if(InventoryList.Length == 0)
        {            
        }
        else
        {
            Idx = 0;
            J0x5E:

            // End:0xD8 [Loop If]
            if(Idx < InventoryList.Length)
            {
                // End:0xCA
                if(ClassIsChildOf(InventoryList[Idx], Class'EvilWeap_Base') && !ClassIsChildOf(InventoryList[Idx], Class'EvilWeap_Melee_Base'))
                {
                    bRemoveNotMeleeWeapons = true;
                }
                Idx++;
                // [Loop Continue]
                goto J0x5E;
            }
            // End:0x185
            if(bRemoveNotMeleeWeapons)
            {
                NewPawn.GetNonMeleeWeaponList(NonMeleeWeaponList);
                Idx = 0;
                J0x118:

                // End:0x185 [Loop If]
                if(Idx < NonMeleeWeaponList.Length)
                {
                    NewPawn.InvManager.RemoveFromInventory(NonMeleeWeaponList[Idx]);
                    ++Idx;
                    // [Loop Continue]
                    goto J0x118;
                }
            }
            Idx = 0;
            J0x190:

            // End:0x1E9 [Loop If]
            if(Idx < InventoryList.Length)
            {
                NewPawn.CreateInventory(InventoryList[Idx]);
                Idx++;
                // [Loop Continue]
                goto J0x190;
            }
        }
    }
    //return;    
}

event ActivateSpawnCompletedOutput(Object Spawned)
{
    SpawnedObject = Spawned;
    PopulateLinkedVariableValues();
    OutputLinks[2].bHasImpulse = true;
    //return;    
}

function AddPawnToPoint(EvilPawn P, SpawnPointInterface Point)
{
    local _PawnToPointInfo P2PInfo;

    Point.DisableSpawn();
    P2PInfo.P = P;
    P2PInfo.Point = Point;
    bPostSpawnCompleted = false;
    PawnToPointInfo.AddItem(P2PInfo);    
    //return;    
}

function NotifyFactory(EvilPawn inPawn, EvilTypes.EAIFactoryEvent EventType)
{
    local int I, validIndex;

    validIndex = -1;
    I = 0;
    J0x1A:

    // End:0x8A [Loop If]
    if(I < PawnToPointInfo.Length)
    {
        // End:0x7C
        if(PawnToPointInfo[I].P == inPawn)
        {
            validIndex = I;
            // [Explicit Break]
            goto J0x8A;
        }
        I++;
        // [Loop Continue]
        goto J0x1A;
    }
    J0x8A:

    // End:0x188
    if(validIndex != -1)
    {
        // End:0x15F
        if(!PawnToPointInfo[validIndex].bSpawnCompleted)
        {
            ActivateSpawnCompletedOutput(PawnToPointInfo[validIndex].P);
            PawnToPointInfo[validIndex].Point.EnableSpawn();
            PawnToPointInfo[validIndex].bSpawnCompleted = true;
        }
        // End:0x188
        if(int(EventType) == int(1))
        {
            PawnToPointInfo.Remove(validIndex, 1);            
        }
    }
    bPostSpawnCompleted = true;
    I = 0;
    J0x19F:

    // End:0x200 [Loop If]
    if(I < PawnToPointInfo.Length)
    {
        // End:0x1F2
        if(!PawnToPointInfo[I].bSpawnCompleted)
        {
            bPostSpawnCompleted = false;
            // [Explicit Break]
            goto J0x200;
        }
        I++;
        // [Loop Continue]
        goto J0x19F;
    }
    J0x200:

    // End:0x227
    if(int(EventType) == int(1))
    {
        NotifyObserversPawnDied(inPawn);
    }
    //return;    
}

event SetupClothes(Pawn inPawn)
{
    // End:0x6C
    if(EvilPawn(inPawn) != none)
    {
        EvilPawn(inPawn).DressUp(((int(CharacterCloth) > int(0)) ? CharacterClothArray[int(CharacterCloth)] : none));
    }
    //return;    
}

function AddObserver(AIFactoryObserverInterface Observer)
{
    local AIFactoryObserverInterface TempObserver;

    // End:0x3A
    foreach Observers(TempObserver)
    {
        // End:0x39
        if(EqualEqual_InterfaceInterface(Observer, TempObserver))
        {            
            return;
        }        
    }    
    Observers.AddItem(Observer);    
    //return;    
}

function RemoveObserver(AIFactoryObserverInterface Observer)
{
    Observers.RemoveItem(Observer);    
    //return;    
}

function NotifyObserversPawnDied(EvilPawn inPawn)
{
    local AIFactoryObserverInterface Observer;

    // End:0x62
    foreach Observers(Observer)
    {
        // End:0x61
        if(NotEqual_InterfaceInterface(Observer, AIFactoryObserverInterface(none)))
        {
            Observer.NotifyPawnDied(self, inPawn);
        }        
    }    
    //return;    
}

static event int GetObjClassVersion()
{
    return super(SequenceObject).GetObjClassVersion() + 13;
    //return ReturnValue;    
}

defaultproperties
{
    UseSpawnAngle=true
    CheckSpawnCollision=true
    SeriesFromSameSpawn=true
    SpawnCount=1
    MaxSpawnRange=9999.0000000
    MaxSpawnTries=10
    LastSpawnPointUsed=-1
    InputLinks[0]=(LinkDesc="Spawn",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    OutputLinks[0]=(Links=none,LinkDesc="One Spawned",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    OutputLinks[1]=(Links=none,LinkDesc="All Finished",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    OutputLinks[2]=(Links=none,LinkDesc="One Spawn Completed",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Spawn Points",LinkVar="None",PropertyName="SpawnPoints",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Spawned",LinkVar="None",PropertyName="SpawnedObject",bWriteable=true,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=0,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[2]=(ExpectedType=Class'Engine.SeqVar_Int',LinkedVariables=none,LinkDesc="Spawn Count",LinkVar="None",PropertyName="SpawnCount",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="AI Factory"
}