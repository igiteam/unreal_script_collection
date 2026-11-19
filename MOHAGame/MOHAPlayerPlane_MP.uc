class MOHAPlayerPlane_MP extends MOHAPlayerPlane
    hidecategories(Navigation);

var(LightFiliment) MaterialInstanceConstant RedGlass;
var(LightFiliment) MaterialInstanceConstant RedFiliment;
var(LightFiliment) MaterialInstanceConstant RedFilimentInner;
var(LightFiliment) MaterialInstanceConstant GreenGlass;
var(LightFiliment) MaterialInstanceConstant GreenFiliment;
var(LightFiliment) MaterialInstanceConstant GreenFilimentInner;
var(LightFiliment) int RedGlassNum;
var(LightFiliment) int RedFilimentNum;
var(LightFiliment) int RedFilimentInnerNum;
var(LightFiliment) int GreenGlassNum;
var(LightFiliment) int GreenFilimentNum;
var(LightFiliment) int GreenFilimentInnerNum;
var(LightFiliment) name GreenParamName;
var(LightFiliment) name RedParamName;
var repnotify SeqAct_TogglePlaneLightMaterial_MP.enumPlaneLightMaterial_MP MyLightingState;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority)
        MyLightingState;
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x20
    if(VarName == 'MyLightingState')
    {
        SetLightMaterialBasedOnState();        
    }
    else
    {
        super(SkeletalMeshActor).ReplicatedEvent(VarName);
    }
    //return;    
}

simulated function PostBeginPlay()
{
    super(MOHAPlayerPlaneBase).PostBeginPlay();
    planeInterior.SetMaterial(RedGlassNum, RedGlass);
    planeInterior.SetMaterial(RedFilimentNum, RedFiliment);
    planeInterior.SetMaterial(RedFilimentInnerNum, RedFilimentInner);
    planeInterior.SetMaterial(GreenGlassNum, GreenGlass);
    planeInterior.SetMaterial(GreenFilimentNum, GreenFiliment);
    planeInterior.SetMaterial(GreenFilimentInnerNum, GreenFilimentInner);
    MyLightingState = 0;
    SetLightMaterialBasedOnState();
    //return;    
}

simulated function SetLightMaterialBasedOnState()
{
    local LinearColor localRed, localGreen;

    // End:0x33
    if(int(MyLightingState) == int(1))
    {
        localGreen = MakeLinearColor(1.0000000, 1.0000000, 1.0000000, 1.0000000);        
    }
    else
    {
        // End:0x63
        if(int(MyLightingState) == int(2))
        {
            localRed = MakeLinearColor(1.0000000, 1.0000000, 1.0000000, 1.0000000);
        }
    }
    RedGlass.SetVectorParameterValue(RedParamName, localRed);
    RedFiliment.SetVectorParameterValue(RedParamName, localRed);
    RedFilimentInner.SetVectorParameterValue(RedParamName, localRed);
    GreenGlass.SetVectorParameterValue(GreenParamName, localGreen);
    GreenFiliment.SetVectorParameterValue(GreenParamName, localGreen);
    GreenFilimentInner.SetVectorParameterValue(GreenParamName, localGreen);
    //return;    
}

function OnTogglePlaneLightMaterial_MP(SeqAct_TogglePlaneLightMaterial_MP Action)
{
    MyLightingState = Action.activity;
    SetLightMaterialBasedOnState();
    //return;    
}

simulated function OnToggle(SeqAct_Toggle Action)
{
    // End:0x28
    if(Action.InputLinks[0].bHasImpulse)
    {
        SetHidden(false);        
    }
    else
    {
        // End:0x50
        if(Action.InputLinks[1].bHasImpulse)
        {
            SetHidden(true);            
        }
        else
        {
            // End:0x7D
            if(Action.InputLinks[2].bHasImpulse)
            {
                SetHidden(!bHidden);
            }
        }
    }
    //return;    
}

defaultproperties
{
    RedGlass=MaterialInstanceConstant'Rem_Proto_MM_Obj.glass_instance_R1'
    RedFiliment=MaterialInstanceConstant'Rem_Proto_MM_Obj.glass_filiment_instance_R1'
    RedFilimentInner=MaterialInstanceConstant'Rem_Proto_MM_Obj.glass_filiment_inner_instance_R1'
    GreenGlass=MaterialInstanceConstant'Rem_Proto_MM_Obj.glass_instance_G1'
    GreenFiliment=MaterialInstanceConstant'Rem_Proto_MM_Obj.glass_filiment_instance_G1'
    GreenFilimentInner=MaterialInstanceConstant'Rem_Proto_MM_Obj.glass_filiment_inner_G1'
    RedGlassNum=3
    RedFilimentNum=4
    RedFilimentInnerNum=5
    GreenFilimentNum=1
    GreenFilimentInnerNum=2
    GreenParamName="Hero_C47_Green_Light"
    RedParamName="Hero_C47_Red_Light"
    // Reference: StaticMeshComponent'Default__MOHAPlayerPlane_MP.InteriorStaticMesh'
    begin object name=InteriorStaticMesh
    end object
    planeInterior=InteriorStaticMesh
    // Reference: SkeletalMeshComponent'Default__MOHAPlayerPlane_MP.ExteriorSkeletalMesh'
    begin object name=ExteriorSkeletalMesh
    end object
    planeExterior=ExteriorSkeletalMesh
    // Reference: StaticMeshComponent'Default__MOHAPlayerPlane_MP.windowMesh'
    begin object name=windowMesh
    end object
    planeWindows=windowMesh
    // Reference: SkeletalMeshComponent'Default__MOHAPlayerPlane_MP.destructionMeshComponent'
    begin object name=destructionMeshComponent
        // Reference: AnimNodeSequence'Default__MOHAPlayerPlane_MP.destructionMeshComponent.AnimNodeSeq1'
        begin object name=AnimNodeSeq1
        end object
        Animations=AnimNodeSeq1
    end object
    destructionMesh=destructionMeshComponent
    bPlayFlakSounds=false
    minEffectsPerBurst=0
    maxEffectsPerBurst=0
    normalFlakPSys=none
    heroFlakPSys=none
    // Reference: SkeletalMeshComponent'Default__MOHAPlayerPlane_MP.SkeletalMeshComponent0'
    begin object name=SkeletalMeshComponent0
        // Reference: AnimNodeSequence'Default__MOHAPlayerPlane_MP.SkeletalMeshComponent0.AnimNodeSeq0'
        begin object name=AnimNodeSeq0
        end object
        Animations=AnimNodeSeq0
        LightEnvironment=DynamicLightEnvironmentComponent'Default__MOHAPlayerPlane_MP.MyLightEnvironment'
    end object
    SkeletalMeshComponent=SkeletalMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__MOHAPlayerPlane_MP.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: AudioComponent'Default__MOHAPlayerPlane_MP.FaceAudioComponent'
    begin object name=FaceAudioComponent
    end object
    FacialAudioComp=FaceAudioComponent
    Components[0]=MyLightEnvironment
    Components[1]=SkeletalMeshComponent0
    Components[2]=FaceAudioComponent
    Components[3]=InteriorStaticMesh
    Components[4]=windowMesh
    Components[5]=destructionMeshComponent
    Components[6]=ExteriorSkeletalMesh
    RemoteRole=1
    CollisionComponent=SkeletalMeshComponent0
}