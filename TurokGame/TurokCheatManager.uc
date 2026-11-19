class TurokCheatManager extends CheatManager within PlayerController;

exec function StartActorTick(name ClassName)
{
    local @NULL tickingActor;

    // End:0x69
    foreach Outer.AllActors(Class'Engine.Actor', tickingActor)
    {
        // End:0x68
        if(tickingActor.IsA(ClassName))
        {
            Outer.ClientMessage("Start Ticking" @ string(tickingActor));
            tickingActor.StartTicking();
        }        
    }    
    //return;    
}

exec function StopActorTick(name ClassName)
{
    local @NULL tickingActor;

    // End:0x68
    foreach Outer.AllActors(Class'Engine.Actor', tickingActor)
    {
        // End:0x67
        if(tickingActor.IsA(ClassName))
        {
            Outer.ClientMessage("Stop Ticking" @ string(tickingActor));
            tickingActor.StopTicking();
        }        
    }    
    //return;    
}

exec function KillHumanNPCs()
{
    KillAllPawns(Class'TurokPawnHumanNpcNative');
    //return;    
}

exec function KillCompanions()
{
    local @NULL tPawn;

    // End:0xAD
    foreach Outer.AllActors(Class'TurokPawnHumanNpcNative', tPawn)
    {
        // End:0xAC
        if((tPawn.Controller != none) && TurokAIControllerHumanWc(tPawn.Controller) != none)
        {
            // End:0x88
            if(int(Outer.Role) == int(ROLE_Authority))
            {
                tPawn.Died(none, Class'Engine.DmgType_Suicided', tPawn.Location);
            }
            Outer.LifeSpan = FMin(Outer.LifeSpan, 1.0000000);
        }        
    }    
    //return;    
}

exec function KillCreatures()
{
    KillAllPawns(Class'TurokPawnDino');
    //return;    
}

function KillAllPawns(class<Class> aClass)
{
    local @NULL P;

    // End:0xB1
    foreach Outer.AllActors(Class'Engine.Pawn', P)
    {
        // End:0xB0
        if(ClassIsChildOf(P.Class, aClass) && !P.IsPlayerPawn())
        {
            // End:0x8C
            if(int(Outer.Role) == int(ROLE_Authority))
            {
                P.Died(none, Class'Engine.DmgType_Suicided', P.Location);
            }
            Outer.LifeSpan = FMin(Outer.LifeSpan, 1.0000000);
        }        
    }    
    //return;    
}

exec function ClearDebugLines()
{
    Outer.Pawn.FlushPersistentDebugLines();
    //return;    
}

exec function GodAllNPCs()
{
    local @NULL tPawn;

    // End:0x63
    foreach Outer.AllActors(Class'TurokPawn', tPawn)
    {
        // End:0x62
        if((tPawn.Controller != none) && TurokPlayerController(tPawn.Controller) == none)
        {
            tPawn.Controller.bGodMode = true;
        }        
    }    
    //return;    
}

exec function MortalAllNPCs()
{
    local @NULL tPawn;

    // End:0x63
    foreach Outer.AllActors(Class'TurokPawn', tPawn)
    {
        // End:0x62
        if((tPawn.Controller != none) && TurokPlayerController(tPawn.Controller) == none)
        {
            tPawn.Controller.bGodMode = false;
        }        
    }    
    //return;    
}

exec function SteerAcc()
{
    local @NULL tPawn;

    // End:0x146
    foreach Outer.AllActors(Class'TurokPawn', tPawn)
    {
        // End:0xC3
        if(int(tPawn.mSteer.mAccumulationType) == int(0))
        {
            tPawn.mSteer.mAccumulationType = 1;
            Outer.Pawn.ClientMessage((" " $ string(tPawn.Name)) $ ": AccumulationType: STEERACC_Prioritized", tPawn.Name);
            // End:0x145
            continue;
        }
        tPawn.mSteer.mAccumulationType = 0;
        Outer.Pawn.ClientMessage((" " $ string(tPawn.Name)) $ ": AccumulationType: STEERACC_Weighted", tPawn.Name);        
    }    
    //return;    
}

exec function AlwaysAmmo()
{
    TurokInventoryManager(Outer.Pawn.InvManager).SetInfiniteAmmo(!TurokInventoryManager(Outer.Pawn.InvManager).InfiniteAmmo());
    //return;    
}

exec function Loaded()
{
    // End:0x24
    if(int(Outer.WorldInfo.NetMode) != int(NM_Standalone))
    {
        return;
    }
    TurokInventoryManager(Outer.Pawn.InvManager).mbUnlimitedWeaponCapacity = true;
    AllAmmo();
    AllWeapons();
    Grenades();
    //return;    
}

exec function AllAmmo()
{
    TurokInventoryManager(Outer.Pawn.InvManager).CreateAmmoPool(Class'TurokAmmoPoolArrow', 999, 999);
    TurokInventoryManager(Outer.Pawn.InvManager).CreateAmmoPool(Class'TurokAmmoPoolArrowExploding', 999, 999);
    TurokInventoryManager(Outer.Pawn.InvManager).CreateAmmoPool(Class'TurokAmmoPoolHandgun', 999, 999);
    TurokInventoryManager(Outer.Pawn.InvManager).CreateAmmoPool(Class'TurokAmmoPoolSmg', 999, 999);
    TurokInventoryManager(Outer.Pawn.InvManager).CreateAmmoPool(Class'TurokAmmoPoolShotgun', 999, 999);
    TurokInventoryManager(Outer.Pawn.InvManager).CreateAmmoPool(Class'TurokAmmoPoolRailgun', 999, 999);
    TurokInventoryManager(Outer.Pawn.InvManager).CreateAmmoPool(Class'TurokAmmoPoolRocket', 999, 999);
    TurokInventoryManager(Outer.Pawn.InvManager).CreateAmmoPool(Class'TurokAmmoPoolChaingun', 999, 999);
    TurokInventoryManager(Outer.Pawn.InvManager).CreateAmmoPool(Class'TurokAmmoPoolFlameThrower', 999, 999);
    TurokInventoryManager(Outer.Pawn.InvManager).CreateAmmoPool(Class'TurokAmmoPoolRailGrenade', 999, 999);
    TurokInventoryManager(Outer.Pawn.InvManager).CreateAmmoPool(Class'TurokAmmoPoolNapalmGrenade', 999, 999);
    TurokInventoryManager(Outer.Pawn.InvManager).CreateAmmoPool(Class'TurokAmmoPoolSniperRifle', 999, 999);
    TurokInventoryManager(Outer.Pawn.InvManager).CreateAmmoPool(Class'TurokAmmoPoolStickyGun', 999, 999);
    //return;    
}

exec function AllWeapons()
{
    local class<Class> InvClass;

    GiveWeapon("TurokGameNonNative.TurokWeapSmg");
    GiveWeapon("TurokGameNonNative.TurokWeapKnife");
    GiveWeapon("TurokGameNonNative.TurokWeapBow");
    GiveWeapon("TurokGameNonNative.TurokWeapHandgun");
    GiveWeapon("TurokGameNonNative.TurokWeapRailgun");
    GiveWeapon("TurokGameNonNative.TurokWeapFireblade");
    GiveWeapon("TurokGameNonNative.TurokWeapShotgun");
    GiveWeapon("TurokGameNonNative.TurokWeapChaingun");
    GiveWeapon("TurokGameNonNative.TurokWeapSniperRifle");
    GiveWeapon("TurokGameNonNative.TurokWeapRpg");
    GiveWeapon("TurokGameNonNative.TurokWeapStickyGun");
    InvClass = class<Inventory>(DynamicLoadObject("TurokGameNonNative.TurokFragGrenadeInventoryItem", Class'Core.Class'));
    // End:0x2AE
    if(InvClass != none)
    {
        Outer.Pawn.CreateInventory(InvClass);
        Outer.Pawn.CreateInventory(InvClass);
        Outer.Pawn.CreateInventory(InvClass);
    }
    //return;    
}

exec function LoadWeapon(name weapname)
{
    GiveWeapon("TurokGameNonNative." $ string(weapname));
    //return;    
}

exec function Grenades()
{
    local class<Class> InvClass;
    local int I;

    InvClass = class<Inventory>(DynamicLoadObject("TurokGameNonNative.TurokFragGrenadeInventoryItem", Class'Core.Class'));
    // End:0x8F
    if(InvClass != none)
    {
        I = 0;
        J0x5B:

        // End:0x8F [Loop If]
        if(I < 50)
        {
            Outer.Pawn.CreateInventory(InvClass);
            ++I;
            // [Loop Continue]
            goto J0x5B;
        }
    }
    //return;    
}

exec function @NULL GiveWeapon(string WeaponClassStr)
{
    local @NULL Weap;
    local class<Class> WeaponClass;

    WeaponClass = class<Weapon>(DynamicLoadObject(WeaponClassStr, Class'Core.Class'));
    Weap = Weapon(Outer.Pawn.FindInventoryType(WeaponClass));
    // End:0x56
    if(Weap != none)
    {
        return Weap;
    }
    return Weapon(Outer.Pawn.CreateInventory(WeaponClass));
    //return ReturnValue;    
}

exec function OneShotKill()
{
    local @NULL Player;

    Player = TurokPawnPlayer(Outer.Pawn);
    // End:0x45
    if(Player != none)
    {
        Player.mbPlayerCanOneShotKill = !Player.mbPlayerCanOneShotKill;
    }
    //return;    
}

exec function ShowPOVMeshes()
{
    local @NULL Player;

    Player = TurokPawnPlayer(Outer.Pawn);
    // End:0x38
    if(Player != none)
    {
        Player.SetPOVMeshVisibility(false);
    }
    //return;    
}

exec function HidePOVMeshes()
{
    local @NULL Player;

    Player = TurokPawnPlayer(Outer.Pawn);
    // End:0x38
    if(Player != none)
    {
        Player.SetPOVMeshVisibility(true);
    }
    //return;    
}

exec function Friend()
{
    ToggleFriendlyCheat();
    //return;    
}

exec function ToggleFriendlyCheat()
{
    local @NULL Player;

    Player = TurokPawnPlayer(Outer.Pawn);
    // End:0x37
    if(Player != none)
    {
        Player.ToggleFriendlyCheat();
    }
    //return;    
}

exec function SetPlayersOnly()
{
    Outer.WorldInfo.bPlayersOnly = true;
    //return;    
}

exec function ClearPlayersOnly()
{
    Outer.WorldInfo.bPlayersOnly = false;
    //return;    
}

exec function SetMPBaseLookSpeedPS3(float Speed)
{
    TurokPlayerInput(PlayerController(Outer.Pawn.Controller).PlayerInput).mPS3MPBaseMaxATurn = Speed;
    //return;    
}

exec function SetMPAimAssistStickPS3(float stick)
{
    TurokPlayerInput(PlayerController(Outer.Pawn.Controller).PlayerInput).mPS3MinRotSlowDownPctMP = stick;
    //return;    
}

exec function SetMPAimAssistFadeNearDist(float dist)
{
    TurokPlayerInput(PlayerController(Outer.Pawn.Controller).PlayerInput).mPS3AimAssistFadeDistNear = dist;
    //return;    
}

exec function SetMPAimAssistFadeFarDist(float dist)
{
    TurokPlayerInput(PlayerController(Outer.Pawn.Controller).PlayerInput).mPS3AimAssistFadeDistFar = dist;
    //return;    
}

exec function SetDebugCameraFree()
{
    TurokPlayerInput(PlayerController(Outer.Pawn.Controller).PlayerInput).SetDebugCameraFree();
    //return;    
}

exec function SetDebugCameraLocked()
{
    TurokPlayerInput(PlayerController(Outer.Pawn.Controller).PlayerInput).SetDebugCameraLocked();
    //return;    
}

exec function SetDebugCameraOff()
{
    TurokPlayerInput(PlayerController(Outer.Pawn.Controller).PlayerInput).SetDebugCameraOff();
    //return;    
}

exec function TurokDebugCam()
{
    TurokPlayerInput(PlayerController(Outer.Pawn.Controller).PlayerInput).ToggleDebugCameraInput();
    //return;    
}

exec function ToggleCameraShake()
{
    local @NULL ShakeEffect;

    ShakeEffect = new (Outer.Pawn.Owner) Class'TurokParametricShake';
    ShakeEffect.Init();
    ShakeEffect.AddCameraModifier(Outer.PlayerCamera);
    //return;    
}

exec function SloMo(float T)
{
    local @NULL Player;

    Player = TurokPawnPlayer(Outer.Pawn);
    // End:0x58
    if(Player != none)
    {
        // End:0x47
        if(T == 1.0000000)
        {
            Player.mCheatSloMo = false;            
        }
        else
        {
            Player.mCheatSloMo = true;
        }
    }
    Outer.WorldInfo.Game.SetGameSpeed(T);
    Outer.WorldInfo.Game.SaveConfig();
    Outer.WorldInfo.Game.GameReplicationInfo.SaveConfig();
    //return;    
}

exec function FriendlyFire()
{
    local @NULL TGI;

    TGI = TurokGameInfo(Outer.WorldInfo.Game);
    // End:0x85
    if(TGI != none)
    {
        TGI.mAllowFriendlyFire = !TGI.mAllowFriendlyFire;
        Outer.ClientMessage("Friendly Fire" @ string(TGI.mAllowFriendlyFire));
    }
    //return;    
}

exec function Mute(name Group)
{
    local @NULL TPC;

    TPC = TurokPlayerController(Outer.Pawn.Controller);
    // End:0x4A
    if(TPC != none)
    {
        TPC.SetSoundGroupVolume(Group, 0.0000000);
    }
    //return;    
}

exec function ResetGroup(name Group)
{
    local @NULL TPC;

    TPC = TurokPlayerController(Outer.Pawn.Controller);
    // End:0x45
    if(TPC != none)
    {
        TPC.ResetSoundGroupVolume(Group);
    }
    //return;    
}

exec function ResetAll()
{
    local @NULL TPC;

    TPC = TurokPlayerController(Outer.Pawn.Controller);
    // End:0x3C
    if(TPC != none)
    {
        TPC.ResetSoundGroupVolumes();
    }
    //return;    
}

exec function Solo(name Group)
{
    local @NULL TPC;

    TPC = TurokPlayerController(Outer.Pawn.Controller);
    // End:0x45
    if(TPC != none)
    {
        TPC.SoloSoundGroup(Group);
    }
    //return;    
}

exec function Vart()
{
    OneShotKill();
    God();
    Loaded();
    AlwaysAmmo();
    //return;    
}

exec function Easy()
{
    God();
    OneShotKill();
    AlwaysAmmo();
    //return;    
}

exec function GodAllPlayers()
{
    local @NULL PC;

    // End:0xA2
    foreach Outer.WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
    {
        // End:0x6E
        if(PC.bGodMode)
        {
            PC.bGodMode = false;
            PC.ClientMessage("God mode off");
            // End:0xA1
            continue;
        }
        PC.bGodMode = true;
        PC.ClientMessage("God mode on");        
    }    
    //return;    
}

exec function TeleportClientTo(float X, float Y, float Z, int Id)
{
    local @NULL TPC, teleportLocation;
    local int I;

    teleportLocation.X = X;
    teleportLocation.Y = Y;
    teleportLocation.Z = Z;
    // End:0xB0
    foreach Outer.WorldInfo.AllControllers(Class'TurokPlayerController', TPC)
    {
        // End:0xAF
        if(!TPC.IsLocalPlayerController())
        {
            // End:0xA8
            if(I == Id)
            {
                TPC.ViewTarget.SetLocation(teleportLocation);
                // End:0xB0
                break;
            }
            ++I;
        }        
    }    
    //return;    
}

exec function TeleportTo(float X, float Y, float Z)
{
    local @NULL teleportLocation;

    Ghost();
    teleportLocation.X = X;
    teleportLocation.Y = Y;
    teleportLocation.Z = Z;
    Outer.ViewTarget.SetLocation(teleportLocation);
    //return;    
}

exec function EnableAllCollisionLogging()
{
    local @NULL currentActor;

    // End:0x2B
    foreach Outer.AllActors(Class'Engine.Actor', currentActor)
    {
        currentActor.mEnableCollisionLogging = true;        
    }    
    //return;    
}

exec function DisableAllCollisionLogging()
{
    local @NULL currentActor;

    // End:0x2B
    foreach Outer.AllActors(Class'Engine.Actor', currentActor)
    {
        currentActor.mEnableCollisionLogging = false;        
    }    
    //return;    
}

exec function EnableCollisionLoggingFor(name actorName)
{
    local @NULL currentActor;

    // End:0x43
    foreach Outer.AllActors(Class'Engine.Actor', currentActor)
    {
        // End:0x42
        if(currentActor.Name == actorName)
        {
            currentActor.mEnableCollisionLogging = true;
        }        
    }    
    //return;    
}

exec function DisableCollisionLoggingFor(name actorName)
{
    local @NULL currentActor;

    // End:0x43
    foreach Outer.AllActors(Class'Engine.Actor', currentActor)
    {
        // End:0x42
        if(currentActor.Name == actorName)
        {
            currentActor.mEnableCollisionLogging = false;
        }        
    }    
    //return;    
}
