class MOHACheatManager extends CheatManager within PlayerController
    native;

var bool bHeadShotsOnly;

// Export UMOHACheatManager::execlistcommands(FFrame&, void* const)
native function listcommands(string S);

// Export UMOHACheatManager::execPrintMemActor(FFrame&, void* const)
native function PrintMemActor(Actor A);

// Export UMOHACheatManager::execBatchPrintMemory(FFrame&, void* const)
native function BatchPrintMemory(array<Object> ObjArray);

// Export UMOHACheatManager::execEnableAILogging(FFrame&, void* const)
native exec function EnableAILogging(optional bool Val);

exec function commandlist(string S)
{
    listcommands(S);
    //return;    
}

// Export UMOHACheatManager::execSetGammaLevels(FFrame&, void* const)
native final exec function SetGammaLevels(float Gamma, float Brightness, float Contrast);

exec function Ghost()
{
    // End:0x57
    if(Outer.IsInState('PlayerFlying'))
    {
        Walk();
        Outer.ClientMessage("You are no longer ethereal");        
    }
    else
    {
        super.Ghost();
    }
    //return;    
}

function MOHAAIController GetLocalController(MOHAAIPawn P)
{
    local MOHAAIController localController;

    // End:0x52
    if(P.Controller == none)
    {
        // End:0x4F
        if(P.Owner != none)
        {
            localController = MOHAAIController(Pawn(P.Owner).Controller);
        }        
    }
    else
    {
        localController = MOHAAIController(P.Controller);
    }
    return localController;
    //return ReturnValue;    
}

function KillAllAffordance(int TeamIndex)
{
    local MOHAPlayerController mpc;
    local MOHAAIPawn Pawn;
    local MOHAAIController localController;

    mpc = MOHAPlayerController(Outer);
    // End:0xD0
    if((mpc != none) && mpc.CurrentAffordanceNode != none)
    {
        // End:0xCF
        foreach Outer.DynamicActors(Class'MOHAAIPawn', Pawn)
        {
            localController = GetLocalController(Pawn);
            // End:0xCE
            if(((localController != none) && localController.CurrentAffordanceNode == mpc.CurrentAffordanceNode) && localController.TeamIndex == TeamIndex)
            {
                Pawn.Died(none, Class'Engine.DmgType_Suicided', Pawn.Location);
            }            
        }        
    }
    //return;    
}

exec function AlliesWinAffordance()
{
    KillAllAffordance(1);
    //return;    
}

exec function AxisWinAffordance()
{
    KillAllAffordance(0);
    //return;    
}

exec function SetHealth(int NewValue)
{
    Outer.Pawn.SetHealth(NewValue);
    //return;    
}

exec function GiveFullHealth()
{
    MOHAPlayerController(Outer.Pawn.Controller).bUsedCheat = true;
    Outer.Pawn.SetHealth(Outer.Pawn.default.Health);
    //return;    
}

exec function SetHeadShotsOnly()
{
    bHeadShotsOnly = !bHeadShotsOnly;
    //return;    
}

exec function ToggleCheat(MOHAIncludeClass.ECheatType CheatType)
{
    MOHAPlayerController(Outer).ToggleCheat(CheatType);
    //return;    
}

exec function BoydTraversWasHere()
{
    MOHAPlayerController(Outer).ToggleCheat(6);
    Class'Engine.SaveLoadSystem'.static.SaveCheats("");
    //return;    
}

exec function Branola()
{
    local MOHAPlayerController PC;

    PC = MOHAPlayerController(Outer);
    // End:0x4E
    if(PC.IsCheatActive(6))
    {
        PC.ToggleCheat(0);
        Class'Engine.SaveLoadSystem'.static.SaveCheats("");
    }
    //return;    
}

exec function Knave()
{
    local MOHAPlayerController PC;

    PC = MOHAPlayerController(Outer);
    // End:0x4E
    if(PC.IsCheatActive(6))
    {
        PC.ToggleCheat(1);
        Class'Engine.SaveLoadSystem'.static.SaveCheats("");
    }
    //return;    
}

exec function QuickFix()
{
    local MOHAPlayerController PC;

    PC = MOHAPlayerController(Outer);
    // End:0x32
    if(PC.IsCheatActive(6))
    {
        GiveFullAmmo();
    }
    //return;    
}

exec function JacobsClip()
{
    local MOHAPlayerController PC;

    PC = MOHAPlayerController(Outer);
    // End:0x43
    if(PC.IsCheatActive(6))
    {
        SetInfiniteAmmo();
        Class'Engine.SaveLoadSystem'.static.SaveCheats("");
    }
    //return;    
}

exec function Flush()
{
    local MOHAPlayerController PC;

    PC = MOHAPlayerController(Outer);
    // End:0x4E
    if(PC.IsCheatActive(6))
    {
        PC.ToggleCheat(3);
        Class'Engine.SaveLoadSystem'.static.SaveCheats("");
    }
    //return;    
}

exec function RunnethOver()
{
    local MOHAPlayerController PC;

    PC = MOHAPlayerController(Outer);
    // End:0x34
    if(PC.IsCheatActive(6))
    {
        UpgradeWeapon();
    }
    //return;    
}

exec function Endeavor()
{
    local MOHAPlayerController PC;

    PC = MOHAPlayerController(Outer);
    // End:0x4E
    if(PC.IsCheatActive(6))
    {
        PC.ToggleCheat(5);
        Class'Engine.SaveLoadSystem'.static.SaveCheats("");
    }
    //return;    
}

exec function Succor()
{
    local MOHAPlayerController PC;

    PC = MOHAPlayerController(Outer);
    // End:0x32
    if(PC.IsCheatActive(6))
    {
        GiveFullHealth();
    }
    //return;    
}

exec function TakeDamage(int Damage)
{
    Outer.Pawn.TakeDamage(Damage, Outer.Pawn.Controller, vect(0.0000000, 0.0000000, 0.0000000), vect(0.0000000, 0.0000000, 0.0000000), Class'MOHABulletDamageType');
    //return;    
}

exec function PrintCoverInvalidateStats()
{
    local KynapseAIController Kyn;

    // End:0x29
    foreach Outer.DynamicActors(Class'EAKynapse.KynapseAIController', Kyn)
    {
        Kyn.super(MOHACheatManager).PrintCoverInvalidateStats();        
    }    
    //return;    
}

exec function PrintCoverBlownStats()
{
    local KynapseAIController Kyn;

    // End:0x29
    foreach Outer.DynamicActors(Class'EAKynapse.KynapseAIController', Kyn)
    {
        Kyn.super(MOHACheatManager).PrintCoverBlownStats();        
    }    
    //return;    
}

exec function CreateMonkeySpawn(string ClassName)
{
    local Vector SpawnLoc;
    local Rotator Rot;

    // End:0x34
    if(Outer.Pawn != none)
    {
        SpawnLoc = Outer.Pawn.Location;        
    }
    else
    {
        SpawnLoc = Outer.Location;
    }
    Rot = Outer.Rotation;
    Rot.Pitch = 0;
    SpawnLoc = (SpawnLoc + (float(72) * Vector(Rot))) + (vect(0.0000000, 0.0000000, 1.0000000) * float(15));
    CreateMonkeySpawnInternal(ClassName, SpawnLoc, Rot);
    //return;    
}

function CreateMonkeySpawnInternal(string ClassName, Vector SpawnLoc, Rotator Rot)
{
    local MonkeySpawner Spawner;
    local class<MOHAAIPawn> NewClass;
    local int TeamIndex;

    NewClass = class<MOHAAIPawn>(DynamicLoadObject(ClassName, Class'Core.Class'));
    // End:0xBC
    if(NewClass != none)
    {
        Spawner = Outer.__NFUN_278__(Class'MonkeySpawner',,, SpawnLoc, Rot);
        Spawner.SpawnClass = NewClass;
        TeamIndex = NewClass.default.KynapseControllerClass.default.TeamIndex;
        // End:0xBC
        if(TeamIndex == 0)
        {
            Spawner.TeamName = "Allies";
            Spawner.Sprite.Sprite = Texture2D'EditorMonkeySpawner.AlliedMonkey';
        }
    }
    //return;    
}

function CreateMonkeySpawnCocktail(array<string> classes, Vector SpawnLoc, Rotator Rot)
{
    local Vector boom;
    local Rotator boomRot;
    local int I;

    I = 0;
    J0x07:

    // End:0x84 [Loop If]
    if(I < classes.Length)
    {
        boom = float((classes.Length * 25) + 200) * Vector(boomRot);
        CreateMonkeySpawnInternal(classes[I], SpawnLoc + boom, Rot);
        boomRot.Yaw += (65535 / classes.Length);
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function SelectFromMonkeySpawnCocktail(array<string> classes, int Index, Vector SpawnLoc, Rotator Rot)
{
    // End:0x6A
    if((Index >= 0) && Index < classes.Length)
    {
        Outer.ClientMessage("Spawning: " $ classes[Index]);
        CreateMonkeySpawnInternal(classes[Index], SpawnLoc, Rot);
    }
    //return;    
}

exec function CreateAlliedMonkeySpawnCocktail()
{
    CreateAlliedMonkeySpawnCocktailInternal();
    //return;    
}

exec function AlliedMonkey(int Num)
{
    // End:0x1D
    if(Num == 0)
    {
        CreateAlliedMonkeySpawnCocktailInternal(-2);        
    }
    else
    {
        CreateAlliedMonkeySpawnCocktailInternal(Num - 1);
    }
    //return;    
}

exec function lm(int Num)
{
    AlliedMonkey(Num);
    //return;    
}

function CreateAlliedMonkeySpawnCocktailInternal(optional int Index = -1)
{
    local array<string> classes;
    local Vector SpawnLoc;
    local Rotator Rot;
    local int I;

    // End:0x3D
    if(Outer.Pawn != none)
    {
        SpawnLoc = Outer.Pawn.Location;        
    }
    else
    {
        SpawnLoc = Outer.Location;
    }
    Rot = Outer.Rotation;
    Rot.Pitch = 0;
    classes[classes.Length] = "MOHAGameNonNative.MOHA82ndAirborneGarandPawn";
    classes[classes.Length] = "MOHAGameNonNative.MOHA82ndAirborneThompsonPawn";
    classes[classes.Length] = "MOHAGameNonNative.MOHA82ndAirborneBARPawn";
    classes[classes.Length] = "MOHAGameNonNative.MOHA1stArmy5thInfantryThompsonPawn";
    classes[classes.Length] = "MOHAGameNonNative.MOHA17thAirborneGarandPawn";
    classes[classes.Length] = "MOHAGameNonNative.MOHA17thAirborneThompsonPawn";
    classes[classes.Length] = "MOHAGameNonNative.MOHA17thAirborneBARPawn";
    // End:0x27F
    if(Index == -2)
    {
        I = 0;
        J0x22F:

        // End:0x27C [Loop If]
        if(I < classes.Length)
        {
            Outer.ClientMessage((string(I + 1) $ " - ") $ classes[I]);
            I++;
            // [Loop Continue]
            goto J0x22F;
        }        
    }
    else
    {
        // End:0x2AA
        if(Index == -1)
        {
            CreateMonkeySpawnCocktail(classes, SpawnLoc, Rot);            
        }
        else
        {
            SelectFromMonkeySpawnCocktail(classes, Index, SpawnLoc, Rot);
        }
    }
    //return;    
}

exec function CreateAxisMonkeySpawnCocktail()
{
    CreateAxisMonkeySpawnCocktailInternal();
    //return;    
}

exec function AxisMonkey(int Num)
{
    // End:0x1D
    if(Num == 0)
    {
        CreateAxisMonkeySpawnCocktailInternal(-2);        
    }
    else
    {
        CreateAxisMonkeySpawnCocktailInternal(Num - 1);
    }
    //return;    
}

exec function am(int Num)
{
    AxisMonkey(Num);
    //return;    
}

function CreateAxisMonkeySpawnCocktailInternal(optional int Index = -1)
{
    local array<string> classes;
    local Vector SpawnLoc;
    local Rotator Rot;
    local int I;

    // End:0x3D
    if(Outer.Pawn != none)
    {
        SpawnLoc = Outer.Pawn.Location;        
    }
    else
    {
        SpawnLoc = Outer.Location;
    }
    Rot = Outer.Rotation;
    Rot.Pitch = 0;
    classes[classes.Length] = "MOHAGameNonNative.MOHAItalianBlackShirtK98Pawn";
    classes[classes.Length] = "MOHAGameNonNative.MOHAItalianBlackShirtMP40Pawn";
    classes[classes.Length] = "MOHAGameNonNative.MOHAHeerInfantryTropicalMP40Pawn";
    classes[classes.Length] = "MOHAGameNonNative.MOHAHeerInfantryEuropeG43RiflePawn";
    classes[classes.Length] = "MOHAGameNonNative.MOHAHeerOfficerMP40Pawn";
    classes[classes.Length] = "MOHAGameNonNative.MOHAWaffenSSInfantryMP40Pawn";
    classes[classes.Length] = "MOHAGameNonNative.MOHAWaffenSSOfficerSTG44Pawn";
    classes[classes.Length] = "MOHAGameNonNative.MOHAWaffenSSOfficerG43SniperPawn";
    classes[classes.Length] = "MOHAGameNonNative.MOHAFallshirmjagerSTG44Pawn";
    classes[classes.Length] = "MOHAGameNonNative.MOHAFallshirmjagerG43RiflePawn";
    classes[classes.Length] = "MOHAGameNonNative.MOHAFallshirmjagerG43SniperPawn";
    classes[classes.Length] = "MOHAGameNonNative.MOHANaziEliteSTG44Pawn";
    classes[classes.Length] = "MOHAGameNonNative.MOHANaziElitePortableMG42Pawn";
    classes[classes.Length] = "MOHAGameNonNative.MOHAPanzergrenadierPanzerschreckPawn";
    // End:0x443
    if(Index == -2)
    {
        I = 0;
        J0x3F3:

        // End:0x440 [Loop If]
        if(I < classes.Length)
        {
            Outer.ClientMessage((string(I + 1) $ " - ") $ classes[I]);
            I++;
            // [Loop Continue]
            goto J0x3F3;
        }        
    }
    else
    {
        // End:0x46E
        if(Index == -1)
        {
            CreateMonkeySpawnCocktail(classes, SpawnLoc, Rot);            
        }
        else
        {
            SelectFromMonkeySpawnCocktail(classes, Index, SpawnLoc, Rot);
        }
    }
    //return;    
}

exec function MonkeySpawn(string Team)
{
    local MonkeySpawner Spawner;

    // End:0x53
    foreach Outer.DynamicActors(Class'MonkeySpawner', Spawner)
    {
        // End:0x52
        if((Team == "") || Team == Spawner.TeamName)
        {
            Spawner.SpawnMyGuy();
        }        
    }    
    //return;    
}

exec function ClearMonkeySpawn(string Team)
{
    local MonkeySpawner Spawner;

    // End:0x4C
    foreach Outer.DynamicActors(Class'MonkeySpawner', Spawner)
    {
        // End:0x4B
        if((Team == "") || Team == Spawner.TeamName)
        {
            Spawner.Destroy();
        }        
    }    
    //return;    
}

exec function KillAxis()
{
    local MOHAAxisAIPawn Pawn;

    // End:0x55
    foreach Outer.DynamicActors(Class'MOHAAxisAIPawn', Pawn)
    {
        // End:0x54
        if(Pawn.Health > 0)
        {
            Pawn.Died(none, Class'Engine.DmgType_Suicided', Pawn.Location);
        }        
    }    
    //return;    
}

exec function KillAllies()
{
    local MOHAAlliedAIPawn Pawn;

    // End:0x55
    foreach Outer.DynamicActors(Class'MOHAAlliedAIPawn', Pawn)
    {
        // End:0x54
        if(Pawn.Health > 0)
        {
            Pawn.Died(none, Class'Engine.DmgType_Suicided', Pawn.Location);
        }        
    }    
    //return;    
}

function KynapseAIController GetSelectedController()
{
    local MOHAPlayerController mpc;
    local MOHAPawn picked;

    mpc = MOHAPlayerController(Outer);
    // End:0x58
    if(mpc != none)
    {
        picked = MOHAPawn(mpc.PickerGetCurrent());
        // End:0x58
        if(picked != none)
        {
            return KynapseAIController(picked.Controller);
        }
    }
    return none;
    //return ReturnValue;    
}

exec function AiOff()
{
    local KynapseAIController Kyn;

    // End:0x2B
    foreach Outer.DynamicActors(Class'EAKynapse.KynapseAIController', Kyn)
    {
        Kyn.bAIOff = true;        
    }    
    //return;    
}

exec function AiOn()
{
    local KynapseAIController Kyn;

    // End:0x2B
    foreach Outer.DynamicActors(Class'EAKynapse.KynapseAIController', Kyn)
    {
        Kyn.bAIOff = false;        
    }    
    //return;    
}

exec function ThisAIOn()
{
    local KynapseAIController C;

    C = GetSelectedController();
    // End:0x2C
    if(C != none)
    {
        C.bAIOff = false;
    }
    //return;    
}

exec function Vaporize()
{
    local KynapseAIController C;

    C = GetSelectedController();
    // End:0x30
    if(C != none)
    {
        C.Pawn.Destroy();
    }
    //return;    
}

exec function PrintSelectedPawnName()
{
    local KynapseAIController C;

    C = GetSelectedController();
    // End:0x40
    if(C != none)
    {
        Outer.ClientMessage(string(C.Pawn));
    }
    //return;    
}

exec function PrintMissingTransitions()
{
    local MOHAPlayerController mpc;
    local KynapseAIController C;
    local MOHAAIPawn Pawn;

    C = GetSelectedController();
    mpc = MOHAPlayerController(Outer);
    MOHAHUD(mpc.myHUD).MissingTransitionPawn = none;
    // End:0xDF
    if((C != none) && MOHAAIPawn(C.Pawn) != none)
    {
        // End:0x8F
        foreach Outer.DynamicActors(Class'MOHAAIPawn', Pawn)
        {
            Pawn.bLogMissingTransitions = false;            
        }        
        MOHAHUD(mpc.myHUD).MissingTransitionPawn = MOHAAIPawn(C.Pawn);
        MOHAAIPawn(C.Pawn).bLogMissingTransitions = true;
    }
    //return;    
}

exec function DebugAIState()
{
    local KynapseAIController C;

    C = GetSelectedController();
    // End:0x3C
    if(C != none)
    {
        C.bDrawStateTransitions = !C.bDrawStateTransitions;
    }
    //return;    
}

exec function DumpSelectedNPCBrainState(optional bool WriteToLog = false)
{
    local KynapseAIController C;

    C = GetSelectedController();
    // End:0x5C
    if(C != none)
    {
        // End:0x44
        if(WriteToLog)
        {
            C.ABSS.DumpStateRecordToLog();            
        }
        else
        {
            C.ABSS.DumpStateRecordToFile();
        }
    }
    //return;    
}

exec function DumpClosestRagdoll()
{
    local MOHAAIPawn Pawn;
    local PlayerController PC;
    local float DistanceToPlayerSquared;
    local MOHAAIPawn ClosestPawn;

    // End:0x53
    foreach Outer.WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
    {
        // End:0x52
        if((PC.Pawn != none) && PC.PlayerCamera != none)
        {
            // End:0x53
            break;
        }        
    }    
    DistanceToPlayerSquared = 100000.0000000;
    // End:0xFE
    foreach Outer.AllActors(Class'MOHAAIPawn', Pawn)
    {
        // End:0xFD
        if(Pawn.IsInState('Dying'))
        {
            // End:0xFD
            if(VSizeSq(Pawn.Location - PC.Pawn.Location) < DistanceToPlayerSquared)
            {
                ClosestPawn = Pawn;
                DistanceToPlayerSquared = VSizeSq(Pawn.Location - PC.Location);
            }
        }        
    }    
    MOHARagdollSkelComponent(ClosestPawn.Mesh).DumpRagdollRecordToFile();
    //return;    
}

exec function DumpNPCBrainStates()
{
    local KynapseAIController Kyn;

    // End:0x32
    foreach Outer.DynamicActors(Class'EAKynapse.KynapseAIController', Kyn)
    {
        Kyn.ABSS.DumpStateRecordToFile();        
    }    
    //return;    
}

exec function DumpSquadBrainStates()
{
    local KynapseSquad sq;

    // End:0x32
    foreach Outer.DynamicActors(Class'EAKynapse.KynapseSquad', sq)
    {
        sq.ABSS.DumpStateRecordToFile();        
    }    
    //return;    
}

exec function DebugCCState()
{
    local MOHAPlayerController mpc;
    local editinline CCPerformer CCP;
    local Actor picked;

    mpc = MOHAPlayerController(Outer);
    // End:0x90
    if(mpc != none)
    {
        picked = mpc.PickerGetCurrent();
        // End:0x90
        if(picked != none)
        {
            // End:0x6B
            if(CCPerformerPawn(picked) != none)
            {
                CCP = CCPerformerPawn(picked).CCP;                
            }
            else
            {
                CCP = none;
            }
            // End:0x90
            if(CCP != none)
            {
                CCP.DebugCCState();
            }
        }
    }
    //return;    
}

exec function ToggleDrawSkeleton()
{
    local MOHAPlayerController mpc;
    local Pawn P;
    local Actor picked;

    mpc = MOHAPlayerController(Outer);
    // End:0x93
    if(mpc != none)
    {
        picked = mpc.PickerGetCurrent();
        // End:0x93
        if(picked != none)
        {
            // End:0x93
            if(Pawn(picked) != none)
            {
                P = Pawn(picked);
                P.Mesh.bDisplayBones = int(P.Mesh.bDisplayBones == 0);
            }
        }
    }
    //return;    
}

exec function DebugAllCCState()
{
    local CCDirector Director;

    Director = CCDirector(MOHAGameInfo(Outer.Pawn.WorldInfo.Game).GlobalCCDirector);
    // End:0x65
    if(Director != none)
    {
        Director.bDebugDrawAll = !Director.bDebugDrawAll;
    }
    //return;    
}

exec function ToggleCCEnabled()
{
    local CCDirector Director;

    Director = CCDirector(MOHAGameInfo(Outer.Pawn.WorldInfo.Game).GlobalCCDirector);
    // End:0x57
    if(Director != none)
    {
        Director.ToggleCCEnabled();
    }
    //return;    
}

exec function ToggleCCLogToCSV()
{
    local CCDirector Director;

    Director = CCDirector(MOHAGameInfo(Outer.Pawn.WorldInfo.Game).GlobalCCDirector);
    // End:0x57
    if(Director != none)
    {
        Director.ToggleCCLogToCSV();
    }
    //return;    
}

exec function TogglePALogToCSV()
{
    local MOHAPlayerController mpc;
    local editinline CCPerformer CCP;
    local Actor picked;

    mpc = MOHAPlayerController(Outer);
    // End:0x90
    if(mpc != none)
    {
        picked = mpc.PickerGetCurrent();
        // End:0x90
        if(picked != none)
        {
            // End:0x6B
            if(CCPerformerPawn(picked) != none)
            {
                CCP = CCPerformerPawn(picked).CCP;                
            }
            else
            {
                CCP = none;
            }
            // End:0x90
            if(CCP != none)
            {
                CCP.TogglePALogToCSV();
            }
        }
    }
    //return;    
}

exec function UpgradeWeapon(optional int iNumUpgrades, optional bool bCheated = false)
{
    local float fExperienceNeeded;
    local int iNextUpgradeLevel;
    local MOHAPlayerController PlayerController;
    local EALAWeapon PlayerWeapon;

    // End:0x18
    if(iNumUpgrades < 1)
    {
        iNumUpgrades = 1;
    }
    PlayerController = MOHAPlayerController(Outer.Pawn.Controller);
    PlayerWeapon = EALAWeapon(Outer.Pawn.Weapon);
    // End:0x76
    if(bCheated)
    {
        PlayerController.bUsedCheat = true;
    }
    // End:0x139
    if(PlayerWeapon.CurrentUpgradeLevel < PlayerWeapon.GetMaxUpgradeLevel())
    {
        iNextUpgradeLevel = Clamp(PlayerWeapon.CurrentUpgradeLevel + iNumUpgrades, 0, PlayerWeapon.GetMaxUpgradeLevel());
        fExperienceNeeded = PlayerController.playerStats.CurrentExpComponent.ExperienceLevelPoints[iNextUpgradeLevel] - PlayerController.playerStats.CurrentExpComponent.ExperiencePoints;
        // End:0x139
        if(fExperienceNeeded > 0.0000000)
        {
            GiveWeapExp(fExperienceNeeded);
        }
    }
    //return;    
}

exec function GiveWeapExp(float fPoints)
{
    MOHAPlayerController(Outer.Pawn.Controller).playerStats.CurrentExpComponent.AddExperiencePoints(fPoints);
    //return;    
}

exec function HitReactions()
{
    local MOHAAIPawn aPawn;
    local bool started, Value;

    started = false;
    Value = false;
    // End:0x6B
    foreach Outer.DynamicActors(Class'MOHAAIPawn', aPawn)
    {
        // End:0x54
        if(!started)
        {
            Value = !aPawn.bNoHitReactions;
            started = true;
        }
        aPawn.bNoHitReactions = Value;        
    }    
    //return;    
}

exec function GiveAmmo(optional name AmmoType, optional int Amount)
{
    // End:0x15
    if(0 >= Amount)
    {
        Amount = 100;
    }
    // End:0x37
    if('None' == AmmoType)
    {
        AmmoType = 'All';
    }
    switch(AmmoType)
    {
        // End:0x82
        case 'smg':
            MOHAInventoryManager(Outer.Pawn.InvManager).AddReserveAmmo(Class'MOHASMGAmmoClass', Amount);
            // End:0x491
            break;
        // End:0xC6
        case 'rifle':
            MOHAInventoryManager(Outer.Pawn.InvManager).AddReserveAmmo(Class'MOHARifleAmmoClass', Amount);
            // End:0x491
            break;
        // End:0x10A
        case 'pistol':
            MOHAInventoryManager(Outer.Pawn.InvManager).AddReserveAmmo(Class'MOHAPistolAmmoClass', Amount);
            // End:0x491
            break;
        // End:0x14E
        case 'ShotGun':
            MOHAInventoryManager(Outer.Pawn.InvManager).AddReserveAmmo(Class'MOHAShotgunAmmoClass', Amount);
            // End:0x491
            break;
        // End:0x192
        case 'sniper':
            MOHAInventoryManager(Outer.Pawn.InvManager).AddReserveAmmo(Class'MOHASniperAmmoClass', Amount);
            // End:0x491
            break;
        // End:0x1D6
        case 'frag':
            MOHAInventoryManager(Outer.Pawn.InvManager).AddReserveAmmo(Class'MOHAMKIIFragGrenadeAmmoClass', Amount);
            // End:0x491
            break;
        // End:0x21A
        case 'gammon':
            MOHAInventoryManager(Outer.Pawn.InvManager).AddReserveAmmo(Class'MOHAGammonGrenadeAmmoClass', Amount);
            // End:0x491
            break;
        // End:0x25E
        case 'stick':
            MOHAInventoryManager(Outer.Pawn.InvManager).AddReserveAmmo(Class'MOHAStickGrenadeAmmoClass', Amount);
            // End:0x491
            break;
        // End:0x2A2
        case 'rocket':
            MOHAInventoryManager(Outer.Pawn.InvManager).AddReserveAmmo(Class'MOHARocketAmmoClass', Amount);
            // End:0x491
            break;
        // End:0x2AE
        case 'All':
        // End:0xFFFF
        default:
            MOHAInventoryManager(Outer.Pawn.InvManager).AddReserveAmmo(Class'MOHASMGAmmoClass', Amount);
            MOHAInventoryManager(Outer.Pawn.InvManager).AddReserveAmmo(Class'MOHARifleAmmoClass', Amount);
            MOHAInventoryManager(Outer.Pawn.InvManager).AddReserveAmmo(Class'MOHAPistolAmmoClass', Amount);
            MOHAInventoryManager(Outer.Pawn.InvManager).AddReserveAmmo(Class'MOHAShotgunAmmoClass', Amount);
            MOHAInventoryManager(Outer.Pawn.InvManager).AddReserveAmmo(Class'MOHASniperAmmoClass', Amount);
            MOHAInventoryManager(Outer.Pawn.InvManager).AddReserveAmmo(Class'MOHAMKIIFragGrenadeAmmoClass', Amount);
            MOHAInventoryManager(Outer.Pawn.InvManager).AddReserveAmmo(Class'MOHAGammonGrenadeAmmoClass', Amount);
            MOHAInventoryManager(Outer.Pawn.InvManager).AddReserveAmmo(Class'MOHAStickGrenadeAmmoClass', Amount);
            MOHAInventoryManager(Outer.Pawn.InvManager).AddReserveAmmo(Class'MOHARocketAmmoClass', Amount);
            // End:0x491
            break;
            break;
    }
    //return;    
}

exec function GiveFullAmmo()
{
    local MOHAInventoryManager InvManager;

    InvManager = MOHAInventoryManager(Outer.Pawn.InvManager);
    // End:0x53
    if(InvManager != none)
    {
        InvManager.GiveFullGunAmmo();
        InvManager.GiveFullGrenadeAmmo();
    }
    MOHAPlayerController(Outer.Pawn.Controller).bUsedCheat = true;
    //return;    
}

exec function SetInfiniteAmmo()
{
    local bool bInfiniteAmmo;
    local MOHAInventoryManager InvManager;

    InvManager = MOHAInventoryManager(Outer.Pawn.InvManager);
    // End:0x67
    if(InvManager != none)
    {
        bInfiniteAmmo = MOHAPlayerController(Outer).ToggleCheat(2);
        InvManager.SetInfiniteAmmo(bInfiniteAmmo);
    }
    //return;    
}

exec function SetPlayerPosition(float X, float Y, float Z)
{
    local Vector vDest;

    vDest.X = X;
    vDest.Y = Y;
    vDest.Z = Z;
    // End:0xDF
    if(Outer.Pawn.SetLocation(vDest) == false)
    {
        Outer.ClientMessage(("Tried to set player position to " $ string(vDest)) $ " but SetLocation returned FALSE! (is this a valid position?)");
    }
    //return;    
}

exec function DebugCover()
{
    local class<MOHAAIPawn> NewClass;
    local SpawnerNodeVolume snv;
    local MOHAAIPawn Pawn;
    local array<Actor> SpawnPoints;
    local int I;

    NewClass = class<MOHAAIPawn>(DynamicLoadObject("MOHAGameNonNative.MOHACoverTestPawn", Class'Core.Class'));
    // End:0x22B
    if(NewClass != none)
    {
        // End:0xB5
        foreach Outer.DynamicActors(Class'EAKynapse.SpawnerNodeVolume', snv)
        {
            snv.bForceDisable = true;
            snv.bEnabled = false;
            // End:0xB4
            if(snv.SpawnPoints.Length > 0)
            {
                SpawnPoints[SpawnPoints.Length] = snv.SpawnPoints[0];
            }            
        }        
        MOHAGameInfo(Outer.WorldInfo.Game).bKillNewlySpawnedPawns = true;
        // End:0x104
        foreach Outer.DynamicActors(Class'MOHAAIPawn', Pawn)
        {
            Pawn.Destroy();            
        }                
        Outer.ConsoleCommand("SUPPRESS ALL");        
        Outer.ConsoleCommand("UNSUPPRESS " $ string(Class'MOHAAIPawn'.default.CoverTestChannelName));        
        Outer.ConsoleCommand("AILOD DISABLE");        
        Outer.ConsoleCommand("SHOW POSTPROCESS");        
        Outer.ConsoleCommand("SHOWPOINTCHECK");
        I = 0;
        J0x1E7:

        // End:0x22B [Loop If]
        if(I < SpawnPoints.Length)
        {
            Outer.__NFUN_278__(NewClass,,, SpawnPoints[I].Location);
            I++;
            // [Loop Continue]
            goto J0x1E7;
        }
    }
    //return;    
}

// Export UMOHACheatManager::execToggleCCD(FFrame&, void* const)
native final function int ToggleCCD();

exec function CCD()
{
    // End:0x3D
    if(ToggleCCD() != 0)
    {
        Outer.ClientMessage("Continuous Collision On");        
    }
    else
    {
        Outer.ClientMessage("Continuous Collision Off");
    }
    //return;    
}

exec function PulseStimulus(name StimulusTemplate)
{
    MOHAPlayerController(Outer).Stimulus.AttachSender('TEMPPULSE', StimulusTemplate, vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0),,, true);
    //return;    
}

exec function PulseNamedScriptEvent(name nse)
{
    local KynapseAIController C;

    C = GetSelectedController();
    // End:0x38
    if(C != none)
    {
        C.ABSS.TripNamedScriptEvent(nse);
    }
    //return;    
}

exec function BroadcastStimulus(string StimulusName)
{
    local CCStimulus CCS;

    CCS.StimulusType = CCStimulusType(DynamicLoadObject(StimulusName, Class'CCStimulusType', false));
    CCS.SourceActor = Outer.Pawn;
    MOHAGameInfo(Outer.WorldInfo.Game).GlobalCCDirector.BroadcastStimulus(CCS, 10000.0000000, 0);
    //return;    
}

exec function FireCinematicSkipEvents()
{
    local array<SequenceObject> AllSeqEvents;
    local Sequence GameSeq;
    local int idx;
    local SeqEvent_SkipCinematicEvent pressedEvent;
    local array<int> ActivationImpulses;

    // End:0x17
    if(Outer.bCinematicMode != true)
    {
        return;
    }
    GameSeq = Outer.WorldInfo.GetGameSequence();
    // End:0xBA
    if(GameSeq != none)
    {
        GameSeq.FindSeqObjectsByClass(Class'SeqEvent_SkipCinematicEvent', true, AllSeqEvents);
        ActivationImpulses[0] = 0;
        idx = 0;
        J0x6A:

        // End:0xBA [Loop If]
        if(idx < AllSeqEvents.Length)
        {
            pressedEvent = SeqEvent_SkipCinematicEvent(AllSeqEvents[idx]);
            pressedEvent.CheckActivate(Outer, Outer, false, ActivationImpulses);
            idx++;
            // [Loop Continue]
            goto J0x6A;
        }
    }
    //return;    
}

exec function FireDebugButtonComboEvents()
{
    local array<SequenceObject> AllSeqEvents;
    local Sequence GameSeq;
    local int idx;
    local SeqEvent_DebugButtonComboPressed pressedEvent;
    local array<int> ActivationImpulses;

    // End:0x21
    if(Outer.PlayerInput.PressedKeys.Length != 3)
    {
        return;
    }
    // End:0xB0
    if(!((Outer.PlayerInput.PressedKeys.Find('XboxTypeS_RightShoulder') != -1) && Outer.PlayerInput.PressedKeys.Find('XboxTypeS_LeftShoulder') != -1) && Outer.PlayerInput.PressedKeys.Find('XboxTypeS_A') != -1)
    {
        return;
    }
    GameSeq = Outer.WorldInfo.GetGameSequence();
    // End:0x153
    if(GameSeq != none)
    {
        GameSeq.FindSeqObjectsByClass(Class'SeqEvent_DebugButtonComboPressed', true, AllSeqEvents);
        ActivationImpulses[0] = 0;
        idx = 0;
        J0x103:

        // End:0x153 [Loop If]
        if(idx < AllSeqEvents.Length)
        {
            pressedEvent = SeqEvent_DebugButtonComboPressed(AllSeqEvents[idx]);
            pressedEvent.CheckActivate(Outer, Outer, false, ActivationImpulses);
            idx++;
            // [Loop Continue]
            goto J0x103;
        }
    }
    //return;    
}

function PrintConstituentsOfPawn(MOHAAIPawn Pawn)
{
    local array<Object> ObjArray;

    ObjArray[0] = Pawn;
    ObjArray[ObjArray.Length] = Pawn.Controller;
    ObjArray[ObjArray.Length] = Pawn.Weapon;
    ObjArray[ObjArray.Length] = Pawn.CurrentWeaponAttachment;
    ObjArray[ObjArray.Length] = Pawn.InvManager;
    BatchPrintMemory(ObjArray);
    //return;    
}

exec function PrintPawnMembers()
{
    local MOHAAIPawn Pawn;

    // End:0x2C
    foreach Outer.DynamicActors(Class'MOHAAIPawn', Pawn)
    {
        PrintMemActor(Pawn);        
        return;        
    }    
    //return;    
}

exec function PrintNonStasisPawn()
{
    local MOHAAIPawn Pawn;

    // End:0x2C
    foreach Outer.DynamicActors(Class'MOHAAIPawn', Pawn)
    {
        PrintConstituentsOfPawn(Pawn);        
        return;        
    }    
    //return;    
}

exec function PrintStasisPawn()
{
    local MOHAAIPawn Pawn;

    // End:0x5F
    foreach Outer.DynamicActors(Class'MOHAAIPawn', Pawn)
    {
        // End:0x5E
        if((Pawn.Mesh != none) && Pawn.Mesh.Animations == none)
        {
            PrintConstituentsOfPawn(Pawn);            
            return;
        }        
    }    
    //return;    
}

exec function DebugVehicles()
{
    local MOHAVehicle V;

    // End:0x3B
    foreach Outer.DynamicActors(Class'MOHAVehicle', V)
    {
        V.bDebugVehicles = !V.bDebugVehicles;        
    }    
    //return;    
}

exec function RootMotion(int mode)
{
    local MOHAPawn P;

    // End:0x4C
    foreach Outer.DynamicActors(Class'MOHAPawn', P)
    {
        // End:0x33
        if(P.IsPlayerPawn())
        {
            continue;            
        }
        P.SetRootMotion(mode);        
    }    
    //return;    
}

exec function Speed(float Speed)
{
    local Pawn P;

    // End:0x48
    foreach Outer.DynamicActors(Class'Engine.Pawn', P)
    {
        // End:0x33
        if(P.IsPlayerPawn())
        {
            continue;            
        }
        P.GroundSpeed = Speed;        
    }    
    //return;    
}

exec function Accel(float Accel)
{
    local Pawn P;

    // End:0x48
    foreach Outer.DynamicActors(Class'Engine.Pawn', P)
    {
        // End:0x33
        if(P.IsPlayerPawn())
        {
            continue;            
        }
        P.AccelRate = Accel;        
    }    
    //return;    
}

exec function Posture(int Posture)
{
    local MOHAPawn P;

    // End:0x48
    foreach Outer.DynamicActors(Class'MOHAPawn', P)
    {
        // End:0x33
        if(P.IsPlayerPawn())
        {
            continue;            
        }
        P.PostureOverride = Posture;        
    }    
    //return;    
}

exec function SetStarRating(int Level, int Difficulty, int Rating)
{
    local PlayerController PC;
    local MOHAPlayerController mpc;

    // End:0x7D
    foreach Outer.LocalPlayerControllers(PC)
    {
        mpc = MOHAPlayerController(PC);
        // End:0x36
        if(mpc == none)
        {
            continue;            
        }
        mpc.playerStats.PRI.SPStatsGlobal.MissionRatingStats[Level].iRating[Difficulty] = Rating;        
    }    
    //return;    
}

exec function UnlockAllLevels()
{
    local PlayerController PC;
    local MOHAPlayerController mpc;
    local int nLevelIndex;

    // End:0x6E
    foreach Outer.LocalPlayerControllers(PC)
    {
        mpc = MOHAPlayerController(PC);
        // End:0x36
        if(mpc == none)
        {
            continue;            
        }
        nLevelIndex = 0;
        J0x3D:

        // End:0x6D [Loop If]
        if(nLevelIndex < 6)
        {
            mpc.UnlockLevel(nLevelIndex, 2);
            nLevelIndex++;
            // [Loop Continue]
            goto J0x3D;
        }        
    }    
    //return;    
}

exec function UnlockLevels(int Level, int Difficulty)
{
    local PlayerController PC;
    local MOHAPlayerController mpc;

    // End:0x54
    foreach Outer.LocalPlayerControllers(PC)
    {
        mpc = MOHAPlayerController(PC);
        // End:0x36
        if(mpc == none)
        {
            continue;            
        }
        mpc.UnlockLevel(Level, Difficulty);        
    }    
    //return;    
}

exec function GiveMedals(optional int medalNum = -1)
{
    local PlayerController PC;
    local MOHAPlayerController mpc;

    // End:0x20A
    foreach Outer.LocalPlayerControllers(PC)
    {
        mpc = MOHAPlayerController(PC);
        // End:0x3F
        if(mpc == none)
        {
            continue;            
        }
        // End:0x8A
        if((medalNum == -1) || medalNum == 0)
        {
            mpc.playerStats.PRI.SPStatsMedal[0].bHasMedal = true;
        }
        // End:0xD5
        if((medalNum == -1) || medalNum == 1)
        {
            mpc.playerStats.PRI.SPStatsMedal[1].bHasMedal = true;
        }
        // End:0x122
        if((medalNum == -1) || medalNum == 2)
        {
            mpc.playerStats.PRI.SPStatsMedal[2].bHasMedal = true;
        }
        // End:0x16F
        if((medalNum == -1) || medalNum == 3)
        {
            mpc.playerStats.PRI.SPStatsMedal[3].bHasMedal = true;
        }
        // End:0x1BC
        if((medalNum == -1) || medalNum == 4)
        {
            mpc.playerStats.PRI.SPStatsMedal[4].bHasMedal = true;
        }
        // End:0x209
        if((medalNum == -1) || medalNum == 5)
        {
            mpc.playerStats.PRI.SPStatsMedal[5].bHasMedal = true;
        }        
    }    
    //return;    
}

exec function TakeMedals()
{
    local PlayerController PC;
    local MOHAPlayerController mpc;

    // End:0x155
    foreach Outer.LocalPlayerControllers(PC)
    {
        mpc = MOHAPlayerController(PC);
        // End:0x36
        if(mpc == none)
        {
            continue;            
        }
        mpc.playerStats.PRI.SPStatsMedal[0].bHasMedal = false;
        mpc.playerStats.PRI.SPStatsMedal[1].bHasMedal = false;
        mpc.playerStats.PRI.SPStatsMedal[2].bHasMedal = false;
        mpc.playerStats.PRI.SPStatsMedal[3].bHasMedal = false;
        mpc.playerStats.PRI.SPStatsMedal[4].bHasMedal = false;
        mpc.playerStats.PRI.SPStatsMedal[5].bHasMedal = false;        
    }    
    //return;    
}

exec function HRForce(float Force)
{
    local MOHAAIPawn Pawn;

    // End:0x3C
    foreach Outer.AllActors(Class'MOHAAIPawn', Pawn)
    {
        MOHARagdollSkelComponent(Pawn.Mesh).fHitReactionImpactForceMax = Force;        
    }    
    //return;    
}
