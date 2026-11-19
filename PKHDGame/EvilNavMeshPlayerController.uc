class EvilNavMeshPlayerController extends EvilPlayerController
    config(Game)
    hidecategories(Navigation);

enum EControlledZombiesClass
{
    Pawn_NavMeshZombie,             // 0
    Pawn_GermanSoldier,             // 1
    Pawn_GermanSoldier_LeuchPistol, // 2
    Pawn_GermanMG34Soldier,         // 3
    ECZC_MAX,                       // 4
    EControlledZombiesClass_MAX     // 5
};

var Actor CursorBase;
var Vector CursorPosition;
var float CursorPositionZShift;
var Vector CursorHitNormal;
var EvilCursorHighLight CursorHighLight;
var EvilCursorHighLight CursorHighLightArch;
var export editinline ParticleSystemComponent PSC;
var export editinline ParticleSystemComponent PSCSelected;
var array<EvilPawn> ControlledZombies;
var class<EvilPawn> ControlledZombiesClass;
var class<EvilAIController> ControlledZombieControllerClass;
var EvilNavMeshPlayerController.EControlledZombiesClass ECZC;

event Possess(Pawn inPawn, bool bVehicleTransition)
{
    super.Possess(inPawn, bVehicleTransition);
    // End:0x8C
    if(EvilPawn(inPawn).ArmsMesh[0] != none)
    {
        EvilPawn(inPawn).ArmsMesh[0].SetHidden(true);
    }
    // End:0xFB
    if(EvilPawn(inPawn).ArmsMesh[1] != none)
    {
        EvilPawn(inPawn).ArmsMesh[1].SetHidden(true);
    }
    inPawn.SetCollision(false, false);
    inPawn.SetCollisionType(1);
    inPawn.bCollideWorld = false;
    //return;    
}

simulated event PostBeginPlay()
{
    ECZC = 1;
    CursorHighLight = Spawn(Class'EvilCursorHighLight', self,,,, CursorHighLightArch);
    ControlledZombiesClass = GetPawnClass(ECZC);
    bNoCrosshair = true;
    super.PostBeginPlay();
    //return;    
}

function class<EvilPawn> GetPawnClass(EvilNavMeshPlayerController.EControlledZombiesClass InPawnID)
{
    return class<EvilPawn>(DynamicLoadObject("PKHDGameContent.PKPawn_DevilMonk", Class'Core.Class'));
    //return ReturnValue;    
}

simulated function DrawHUD(HUD H)
{
    H.Canvas.SetPos(float(H.Canvas.SizeX / 2), float(H.Canvas.SizeY / 2));
    H.Canvas.SetDrawColor(255, 255, 255, 255);
    super.DrawHUD(H);
    //return;    
}

simulated function bool SpawnNavMeshZombie()
{
    local array<Vector> ValidPositions;
    local EvilPawn Zombie;

    NavigationHandle.GetValidPositionsForBox(CursorHighLight.Location, 100.0000000, vect(30.0000000, 30.0000000, 30.0000000), false, ValidPositions, 1);
    // End:0x17A
    if(ValidPositions.Length > 0)
    {
        Zombie = Spawn(ControlledZombiesClass, self,, ValidPositions[0]);
        Zombie.DressUp();
        // End:0x17A
        if(Zombie != none)
        {
            // End:0x162
            if(Zombie.Controller == none)
            {
                Zombie.Controller = Spawn(ControlledZombieControllerClass);
                Zombie.Controller.Possess(Zombie, false);
            }
            ControlledZombies.AddItem(Zombie);
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

exec function MeleeKick()
{
    //return;    
}

exec function Use()
{
    super(UTPlayerController).Use();
    //return;    
}

exec function SwitchWeapon(byte T)
{
    local EvilPawn P;

    P = EvilPawn(Pawn(PSCSelected.Owner));
    // End:0x4B
    if(P == none)
    {
        return;
    }
    switch(T)
    {
        // End:0x9C
        case 1:
            P.Mesh.RootMotionMode = 1;
            // End:0x11E
            break;
        // End:0xDA
        case 2:
            P.Mesh.RootMotionMode = 2;
            // End:0x11E
            break;
        // End:0x118
        case 3:
            P.Mesh.RootMotionMode = 3;
            // End:0x11E
            break;
        // End:0xFFFF
        default:
            // End:0x11E
            break;
            break;
    }
    WorldInfo.AddOnScreenDebugMessage(0, 2.0000000, MakeColor(255, 255, 255, 255), (string(P) @ "RootMotionMode") @ string(P.Mesh.RootMotionMode));
    //return;    
}

simulated exec function ToggleSize()
{
    local EvilPawn P;

    P = EvilPawn(Pawn(PSCSelected.Owner));
    // End:0x4B
    if(P == none)
    {
        return;
    }
    switch(P.SetSize)
    {
        // End:0x9C
        case 1:
            P.SetSize = 0;
            // End:0xCB
            break;
        // End:0xC5
        case 0:
            P.SetSize = 1;
            // End:0xCB
            break;
        // End:0xFFFF
        default:
            // End:0xCB
            break;
            break;
    }
    WorldInfo.AddOnScreenDebugMessage(0, 2.0000000, MakeColor(255, 255, 0, 255), (string(P) @ "ChangeSize") @ string(P.SetSize));
    //return;    
}

exec function PrevWeapon()
{
    local EvilPawn P;
    local EvilNavMeshPlayerInput EvilNavInput;

    EvilNavInput = EvilNavMeshPlayerInput(PlayerInput);
    // End:0x4F
    if(EvilNavInput.bRealtimeFocus)
    {
        CursorPositionZShift -= float(10);
        return;
    }
    // End:0x98
    if(PSCSelected != none)
    {
        P = EvilPawn(Pawn(PSCSelected.Owner));
    }
    // End:0x119
    if(P == none)
    {
        ControlledZombiesClass = GetPawnClass(ECZC);
        WorldInfo.AddOnScreenDebugMessage(0, 2.0000000, MakeColor(255, 0, 255, 255), "SpawnedZombie" @ string(ECZC));
        return;
    }
    switch(P.SetSize)
    {
        // End:0x417
        case 1:
            P.Controller.NavMeshPath_SearchExtent_Modifier.X = FMax(P.Controller.NavMeshPath_SearchExtent_Modifier.X - float(5), -P.GetCollisionRadius());
            P.Controller.NavMeshPath_SearchExtent_Modifier.Y = FMax(P.Controller.NavMeshPath_SearchExtent_Modifier.Y - float(5), -P.GetCollisionRadius());
            P.Controller.NavMeshPath_SearchExtent_Modifier.Z = FMax(P.Controller.NavMeshPath_SearchExtent_Modifier.Z - float(5), -P.GetCollisionRadius());
            WorldInfo.AddOnScreenDebugMessage(0, 2.0000000, MakeColor(0, 255, 255, 255), ((string(P) @ string(P.SetSize)) @ "Changing Size") @ string(P.Controller.NavMeshPath_SearchExtent_Modifier));
            // End:0x52D
            break;
        // End:0x527
        case 0:
            P.SetCollisionSize(FMax(P.GetCollisionRadius() - float(5), 0.0000000), FMax(P.GetCollisionRadius() - float(5), 0.0000000));
            WorldInfo.AddOnScreenDebugMessage(0, 2.0000000, MakeColor(0, 255, 255, 255), ((string(P) @ string(P.SetSize)) @ "Changing Size") @ string(P.GetCollisionExtent()));
            // End:0x52D
            break;
        // End:0xFFFF
        default:
            // End:0x52D
            break;
            break;
    }
    //return;    
}

exec function NextWeapon()
{
    //return;    
}

simulated function Vector2D GetMouseCoordinates()
{
    local Vector2D mousePos;
    local UIInteraction UIController;
    local GameUISceneClient GameSceneClient;
    local Vector2D Size;
    local LocalPlayer pl;

    UIController = GetUIController();
    // End:0x17D
    if(UIController != none)
    {
        pl = LocalPlayer(Player);
        GameSceneClient = pl.ViewportClient.UIController.SceneClient;
        // End:0x17D
        if(GameSceneClient != none)
        {
            pl.ViewportClient.GetViewportSize(Size);
            mousePos.X = float(GameSceneClient.MousePosition.X);
            mousePos.Y = float(GameSceneClient.MousePosition.Y);
        }
    }
    return mousePos;
    //return ReturnValue;    
}

function GetTarget(out Vector HitLocation, out Actor Act, out Vector HitNormal)
{
    local Vector Loc, Dir;
    local float Range;
    local Vector2D Size;
    local LocalPlayer pl;
    local Vector2D finalpos;

    Range = 10000.0000000;
    pl = LocalPlayer(Player);
    // End:0x3C
    if(pl == none)
    {
        return;
    }
    pl.ViewportClient.GetViewportSize(Size);
    finalpos.X = pl.Size.X / float(2);
    finalpos.Y = pl.Size.Y / float(2);
    LocalPlayer(Player).DeProject(finalpos, Loc, Dir);
    Act = Trace(HitLocation, HitNormal, Loc + (Dir * Range), Loc, true, vect(10.0000000, 10.0000000, 10.0000000));
    //return;    
}

function AttachPSC(Pawn P, ParticleSystem PS)
{
    PSC = WorldInfo.MyEmitterPool.SpawnEmitterCustomLifetime(PS);
    PSC.SetAbsolute(false, false, false);
    PSC.SetTranslation(vect(0.0000000, 0.0000000, 20.0000000));
    PSC.bUpdateComponentInTick = true;
    P.AttachComponent(PSC);
    //return;    
}

function AttachPSCSelected(Pawn P, ParticleSystem PS)
{
    PSCSelected = WorldInfo.MyEmitterPool.SpawnEmitterCustomLifetime(PS);
    PSCSelected.SetAbsolute(false, false, false);
    PSCSelected.SetTranslation(vect(0.0000000, 0.0000000, 20.0000000));
    PSCSelected.bUpdateComponentInTick = true;
    P.AttachComponent(PSCSelected);
    //return;    
}

function DetachPSCSelected(Pawn P)
{
    P.DetachComponent(PSCSelected);
    WorldInfo.MyEmitterPool.OnParticleSystemFinished(PSCSelected);
    PSCSelected = none;
    //return;    
}

function DetachPSC(Pawn P)
{
    P.DetachComponent(PSC);
    WorldInfo.MyEmitterPool.OnParticleSystemFinished(PSC);
    PSC = none;
    //return;    
}

simulated function UpdateRotation(float DeltaTime)
{
    local Vector HitLocation, HitNormal;

    GetTarget(HitLocation, CursorBase, HitNormal);
    CursorHitNormal = HitNormal;
    CursorPosition = HitLocation + (vect(0.0000000, 0.0000000, 1.0000000) * CursorPositionZShift);
    // End:0x14C
    if(Pawn(CursorBase) != none)
    {
        // End:0xB4
        if(PSC == none)
        {
            AttachPSC(Pawn(CursorBase), ParticleSystem'ps_CapturedCharacter.Effects.ps_CharacterHighLighted');            
        }
        else
        {
            // End:0x149
            if((Pawn(PSC.Owner) != none) && Pawn(PSC.Owner) != CursorBase)
            {
                DetachPSC(Pawn(PSC.Owner));
            }
        }        
    }
    else
    {
        // End:0x18C
        if(PSC != none)
        {
            DetachPSC(Pawn(PSC.Owner));
        }
        CursorHighLight.SetLocation(HitLocation + (HitNormal * float(50)));
    }
    super(UTConsolePlayerController).UpdateRotation(DeltaTime);
    //return;    
}

defaultproperties
{
    ControlledZombieControllerClass=Class'EvilAI_ZombieNavMesh'
    // Reference: EvilSceneCaptureHighlightComponent'Default__EvilNavMeshPlayerController.HighlightComponent'
    // Archetype: EvilSceneCaptureHighlightComponent'Default__EvilPlayerController.HighlightComponent'
    begin object name="HighlightComponent"
    end object
    HighlightSceneCaptureComponent=HighlightComponent
    // Reference: ForceFeedbackWaveform'Default__EvilNavMeshPlayerController.ForceFeedbackWaveform7'
    // Archetype: ForceFeedbackWaveform'Default__EvilPlayerController.ForceFeedbackWaveform7'
    begin object name="ForceFeedbackWaveform7"
    end object
    CameraShakeShortWaveForm=ForceFeedbackWaveform7
    // Reference: ForceFeedbackWaveform'Default__EvilNavMeshPlayerController.ForceFeedbackWaveform8'
    // Archetype: ForceFeedbackWaveform'Default__EvilPlayerController.ForceFeedbackWaveform8'
    begin object name="ForceFeedbackWaveform8"
    end object
    CameraShakeLongWaveForm=ForceFeedbackWaveform8
    bCheatFlying=true
    InputClass=Class'EvilNavMeshPlayerInput'
    // Reference: CylinderComponent'Default__EvilNavMeshPlayerController.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__EvilPlayerController.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Components[1]=HighlightComponent
    CollisionComponent=CollisionCylinder
}