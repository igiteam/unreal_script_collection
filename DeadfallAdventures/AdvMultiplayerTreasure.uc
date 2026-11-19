class AdvMultiplayerTreasure extends EvilTouchPickUp_Base
    hidecategories(Navigation);

var int Lifetime;
var int TeamIndex;
var EvilPawn TouchingPawn;
var array<MaterialInstanceConstant> EnemyTreasureMI;
var array<MaterialInstanceConstant> TeamTreasureMI;

replication
{
    // Pos:0x000
    if(bNetDirty
        TeamIndex;
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    SetTimer(float(Lifetime), false, 'DestroyDelayed');
    SetTimer(0.0100000, false, 'SetProperMaterials');
    //return;    
}

simulated function SetProperMaterials()
{
    local AdvPlayerControllerMP PC;
    local MaterialInstance MI;
    local int NumElements, I;

    // End:0x208
    foreach WorldInfo.LocalPlayerControllers(Class'AdvPlayerControllerMP', PC)
    {
        // End:0x14A
        if(PC.PlayerReplicationInfo.Team.TeamIndex == TeamIndex)
        {
            NumElements = PickupMesh.GetNumElements();
            I = 0;
            J0xBE:

            // End:0x147 [Loop If]
            if(I < NumElements)
            {
                MI = PickupMesh.CreateAndSetMaterialInstanceConstant(I);
                MI.SetParent(TeamTreasureMI[I]);
                I++;
                // [Loop Continue]
                goto J0xBE;
            }
            // End:0x207
            continue;
        }
        NumElements = PickupMesh.GetNumElements();
        I = 0;
        J0x17E:

        // End:0x207 [Loop If]
        if(I < NumElements)
        {
            MI = PickupMesh.CreateAndSetMaterialInstanceConstant(I);
            MI.SetParent(EnemyTreasureMI[I]);
            I++;
            // [Loop Continue]
            goto J0x17E;
        }        
    }    
    //return;    
}

function SetTeamIndex(int PlayerTeamIndex)
{
    TeamIndex = PlayerTeamIndex;
    bForceNetUpdate = true;
    //return;    
}

simulated function Tick(float DeltaTime)
{
    local Rotator NewRotation;

    NewRotation = Rotation;
    NewRotation.Yaw += int(float(4000) * DeltaTime);
    SetRotation(NewRotation);
    //return;    
}

function Pickup(EvilPawn P)
{
    // End:0xBD
    if((!P.IsAliveAndWell() || AdvPlayerPawnMP(P).bIsMummy && class<AdvGameTeamTreasureHuntBase>(WorldInfo.GRI.GameClass) != none) || P.Controller == none)
    {
        return;
    }
    // End:0x177
    if(AdvGameSurvivalBase(WorldInfo.Game) != none)
    {
        // End:0x164
        if(!AdvGameMP_Base(WorldInfo.Game).PerkManager.IncreaseKillStrikeScore(1, P.Controller))
        {
            return;
        }
        super.Pickup(P);
    }
    // End:0x369
    if(TeamIndex >= 0)
    {
        // End:0x2F3
        if(((WorldInfo.Game != none) && P != none) && P.Controller != none)
        {
            // End:0x26A
            if(AdvGameTreasureHuntBase(WorldInfo.Game) != none)
            {
                AdvGameTreasureHuntBase(WorldInfo.Game).ScoreTreasurePickUp(P.Controller, self);
            }
            // End:0x2F3
            if(AdvGameTeamTreasureHuntBase(WorldInfo.Game) != none)
            {
                AdvGameTeamTreasureHuntBase(WorldInfo.Game).ScoreTreasurePickUp(P.Controller, self);
            }
        }
        // End:0x353
        if(PickupSound != none)
        {
            AdvPlayerController(P.Controller).ClientPlaySound(PickupSound);
            PickupSound = none;
        }
        super.Pickup(P);        
    }
    else
    {
        TouchingPawn = P;
        SetTimer(0.0100000, false, 'RetryPickup');
    }
    //return;    
}

function RetryPickup()
{
    // End:0x2B
    if(IsTimerActive('RetryPickup'))
    {
        ClearTimer('RetryPickup');
    }
    Pickup(TouchingPawn);
    //return;    
}

defaultproperties
{
    Lifetime=200
    TeamIndex=-1
    EnemyTreasureMI[0]=MaterialInstanceConstant'adv_en_mayan_Treasures_01.Materials.mi_TreasureMP_02_01g'
    EnemyTreasureMI[1]=MaterialInstanceConstant'adv_en_mayan_Treasures_01.Materials.mi_TreasureMP_02_02g'
    TeamTreasureMI[0]=MaterialInstanceConstant'adv_en_mayan_Treasures_01.Materials.mi_TreasureMP_02_01s'
    TeamTreasureMI[1]=MaterialInstanceConstant'adv_en_mayan_Treasures_01.Materials.mi_TreasureMP_02_02s'
    // Reference: CylinderComponent'Default__AdvMultiplayerTreasure.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: StaticMeshComponent'Default__AdvMultiplayerTreasure.PickupMeshComp'
    begin object name=PickupMeshComp
        StaticMesh=StaticMesh'adv_en_mayan_Treasures_01.Meshes.sm_en_Treasure_02_01'
        ReplacementPrimitive=none
        bAcceptsStaticDecals=false
        bAcceptsDynamicDecals=false
    end object
    PickupMesh=PickupMeshComp
    PickupSound=SoundCue'a_Accents.Cue.a_TreasureTH'
    // Reference: EvilCaptionComponent'Default__AdvMultiplayerTreasure.CaptionComp'
    begin object name=CaptionComp
    end object
    CaptionComponent=CaptionComp
    // Reference: DynamicLightEnvironmentComponent'Default__AdvMultiplayerTreasure.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=CollisionCylinder
    Components[1]=PickupMeshComp
    Components[2]=MyLightEnvironment
    Components[3]=CaptionComp
    Components[4]=PickupMeshComp
    DrawScale=0.5000000
    bCollideWorld=false
    CollisionComponent=CollisionCylinder
}