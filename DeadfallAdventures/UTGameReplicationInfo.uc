class UTGameReplicationInfo extends GameReplicationInfo
    config(Game)
    hidecategories(Navigation,Movement,Collision);

enum EFlagState
{
    FLAG_Home,                      // 0
    FLAG_HeldFriendly,              // 1
    FLAG_HeldEnemy,                 // 2
    FLAG_Down,                      // 3
    FLAG_MAX                        // 4
};

struct native MeshEffect
{
    var StaticMesh Mesh;
    var MaterialInterface Material;

    structdefaultproperties
    {
        Mesh=none
        Material=none
    }
};

var float WeaponBerserk;
var int MinNetPlayers;
var int BotDifficulty;
var bool bWarmupRound;
var globalconfig bool bForceDefaultCharacter;
var bool bStoryMode;
var bool bConsoleServer;
var bool bAllowKeyboardAndMouse;
var bool bAnnouncementsDisabled;
var bool bRequireReady;
var UTGameReplicationInfo.EFlagState FlagState[2];
var string MutatorList;
var string RulesString;
var array<MaterialInterface> WeaponOverlays;
var array<MeshEffect> VehicleWeaponEffects;
var() globalconfig string MessageOfTheDay;

replication
{
    // Pos:0x000
    if(bNetInitial
        BotDifficulty, MessageOfTheDay, 
        MinNetPlayers, MutatorList, 
        RulesString, WeaponBerserk, 
        bConsoleServer, bRequireReady, 
        bStoryMode;

    // Pos:0x00A
    if(bNetDirty
        FlagState, bAllowKeyboardAndMouse, 
        bAnnouncementsDisabled, bWarmupRound;
}

simulated function PostBeginPlay()
{
    local UTPowerupPickupFactory Powerup;
    local Sequence GameSequence;
    local array<SequenceObject> AllFactoryActions;
    local SeqAct_ActorFactory FactoryAction;
    local UTActorFactoryPickup Factory;
    local int I;

    super.PostBeginPlay();
    // End:0x3F
    if(int(WorldInfo.NetMode) == int(NM_Client))
    {
        MessageOfTheDay = "";
    }
    // End:0x79
    foreach DynamicActors(Class'UTPowerupPickupFactory', Powerup)
    {
        Powerup.AddWeaponOverlay(self);        
    }    
    GameSequence = WorldInfo.GetGameSequence();
    // End:0x1E8
    if(GameSequence != none)
    {
        GameSequence.FindSeqObjectsByClass(Class'Engine.SeqAct_ActorFactory', true, AllFactoryActions);
        I = 0;
        J0xEF:

        // End:0x1E8 [Loop If]
        if(I < AllFactoryActions.Length)
        {
            FactoryAction = SeqAct_ActorFactory(AllFactoryActions[I]);
            Factory = UTActorFactoryPickup(FactoryAction.Factory);
            // End:0x1DA
            if((Factory != none) && ClassIsChildOf(Factory.InventoryClass, Class'UTInventory'))
            {
                class<UTInventory>(Factory.InventoryClass).static.AddWeaponOverlay(self);
            }
            I++;
            // [Loop Continue]
            goto J0xEF;
        }
    }
    // End:0x224
    if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        SetTimer(1.0000000, false, 'CharacterProcessingComplete');
    }
    //return;    
}

simulated function bool InOrder(PlayerReplicationInfo P1, PlayerReplicationInfo P2)
{
    local LocalPlayer LP1, LP2;

    // End:0x45
    if(P1.bOnlySpectator)
    {
        return P2.bOnlySpectator;        
    }
    else
    {
        // End:0x69
        if(P2.bOnlySpectator)
        {
            return true;
        }
    }
    // End:0xAC
    if(P1.Score < P2.Score)
    {
        return false;
    }
    // End:0x2DA
    if(P1.Score == P2.Score)
    {
        // End:0x130
        if(P1.Deaths > P2.Deaths)
        {
            return false;
        }
        // End:0x2DA
        if((P1.Deaths == P2.Deaths) && PlayerController(P2.Owner) != none)
        {
            LP2 = LocalPlayer(PlayerController(P2.Owner).Player);
            // End:0x2DA
            if(LP2 != none)
            {
                // End:0x27E
                if(!Class'Engine.Engine'.static.IsSplitScreen() || LP2.ViewportClient.Outer.GamePlayers[0] == LP2)
                {
                    return false;
                }
                LP1 = LocalPlayer(PlayerController(P2.Owner).Player);
                return LP1 != none;
            }
        }
    }
    return true;
    //return ReturnValue;    
}

simulated function SortPRIArray()
{
    local int I, J;
    local PlayerReplicationInfo P1, P2;

    I = 0;
    J0x0B:

    // End:0x118 [Loop If]
    if(I < (PRIArray.Length - 1))
    {
        P1 = PRIArray[I];
        J = I + 1;
        J0x59:

        // End:0x10A [Loop If]
        if(J < PRIArray.Length)
        {
            P2 = PRIArray[J];
            // End:0xFC
            if(!InOrder(P1, P2))
            {
                PRIArray[I] = P2;
                PRIArray[J] = P1;
                P1 = P2;
            }
            J++;
            // [Loop Continue]
            goto J0x59;
        }
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

simulated function CharacterProcessingComplete()
{
    local UTPlayerController UTPC;

    // End:0x3F
    foreach LocalPlayerControllers(Class'UTPlayerController', UTPC)
    {
        UTPC.CharacterProcessingComplete();        
    }    
    //return;    
}

function SetFlagHome(int TeamIndex)
{
    FlagState[TeamIndex] = 0;
    bForceNetUpdate = true;
    //return;    
}

simulated function bool FlagIsHome(int TeamIndex)
{
    return int(FlagState[TeamIndex]) == int(0);
    //return ReturnValue;    
}

simulated function bool FlagsAreHome()
{
    return (int(FlagState[0]) == int(0)) && int(FlagState[1]) == int(0);
    //return ReturnValue;    
}

function SetFlagHeldFriendly(int TeamIndex)
{
    FlagState[TeamIndex] = 1;
    //return;    
}

simulated function bool FlagIsHeldFriendly(int TeamIndex)
{
    return int(FlagState[TeamIndex]) == int(1);
    //return ReturnValue;    
}

function SetFlagHeldEnemy(int TeamIndex)
{
    FlagState[TeamIndex] = 2;
    //return;    
}

simulated function bool FlagIsHeldEnemy(int TeamIndex)
{
    return int(FlagState[TeamIndex]) == int(2);
    //return ReturnValue;    
}

function SetFlagDown(int TeamIndex)
{
    FlagState[TeamIndex] = 3;
    //return;    
}

simulated function bool FlagIsDown(int TeamIndex)
{
    return int(FlagState[TeamIndex]) == int(3);
    //return ReturnValue;    
}

simulated function Timer()
{
    super.Timer();
    // End:0x5C
    if(int(WorldInfo.NetMode) == int(NM_Client))
    {
        // End:0x5C
        if(bWarmupRound && RemainingTime > 0)
        {
            RemainingTime--;
        }
    }
    //return;    
}

simulated function ShowMidGameMenu(UTPlayerController InstigatorPC, optional name TabTag, optional bool bEnableInput)
{
    // End:0x51
    if(TabTag == 'ScoreTab')
    {
        InstigatorPC.myHUD.SetShowScores(true);        
    }
    else
    {
        UTHUDBase(InstigatorPC.myHUD).ShowMenu();
    }
    //return;    
}

simulated function SetHudShowScores(bool bShow)
{
    local UTPlayerController PC;

    // End:0x98
    foreach WorldInfo.AllControllers(Class'UTPlayerController', PC)
    {
        // End:0x97
        if(PC.myHUD != none)
        {
            PC.myHUD.bShowScores = bShow;
        }        
    }    
    //return;    
}

function AddGameRule(string Rule)
{
    RulesString $= (((RulesString != "") ? "\n" : "") $ Rule);
    //return;    
}

defaultproperties
{
    WeaponBerserk=1.0000000
    BotDifficulty=-1
    TickGroup=ETickingGroup.TG_PreAsyncWork
}