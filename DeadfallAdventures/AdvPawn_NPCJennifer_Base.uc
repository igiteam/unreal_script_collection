class AdvPawn_NPCJennifer_Base extends AdvPawn_NPC_Base
    config(Pawn)
    hidecategories(Navigation);

var transient EvilTypesNative.EBehaviorMode CurrentBehaviourMode;
var AnimNodeBlendDirectional WalkDirectionNode;

protected simulated function bool ShouldUseIK()
{
    return ((int(CurrentMoveMode) == int(0)) && bWantToAim) || ((int(CurrentMoveMode) == int(1)) && int(CurrentBehaviourMode) != int(1)) && (WalkDirectionNode == none) || WalkDirectionNode.Children[2].Weight < 0.1000000;
    //return ReturnValue;    
}

function MoveModeChanged(EvilTypesNative.EMoveMode InNewMode, EvilTypesNative.EMoveMode InOldMode)
{
    local bool bNewDisableIK;

    super.MoveModeChanged(InNewMode, InOldMode);
    bNewDisableIK = !ShouldUseIK();
    // End:0x6C
    if(bDisableIK != bNewDisableIK)
    {
        bDisableIK = bNewDisableIK;
        OnIKStatusUpdate();
    }
    //return;    
}

function NotifyBehaviorModeChanged(EvilTypesNative.EBehaviorMode InNewMode, EvilTypesNative.EBehaviorMode InOldMode)
{
    local bool bNewDisableIK;

    super.NotifyBehaviorModeChanged(InNewMode, InOldMode);
    CurrentBehaviourMode = InNewMode;
    bNewDisableIK = !ShouldUseIK();
    // End:0x7F
    if(bDisableIK != bNewDisableIK)
    {
        bDisableIK = bNewDisableIK;
        OnIKStatusUpdate();
    }
    //return;    
}

simulated function Tick(float DeltaTime)
{
    // End:0x3B
    if(bDisableIK == (ShouldUseIK()))
    {
        bDisableIK = !bDisableIK;
        OnIKStatusUpdate();
    }
    super.Tick(DeltaTime);
    //return;    
}

simulated event CacheAnimNodes()
{
    super(AdvPawn_Armed_Base).CacheAnimNodes();
    WalkDirectionNode = AnimNodeBlendDirectional(Mesh.FindAnimNode('AnimNodeBlendDirectional'));
    //return;    
}

simulated function ClearAnimNodes()
{
    super(AdvPawn_Armed_Base).ClearAnimNodes();
    WalkDirectionNode = none;
    //return;    
}

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__AdvPawn_NPCJennifer_Base.SPawnSkeletalMeshComponent'
    begin object name=SPawnSkeletalMeshComponent
        ParentAnimComponent=SkeletalMeshComponent'Default__AdvPawn_NPCJennifer_Base.WPawnSkeletalMeshComponent'
        ShadowParent=SkeletalMeshComponent'Default__AdvPawn_NPCJennifer_Base.WPawnSkeletalMeshComponent'
        ReplacementPrimitive=none
    end object
    WallseeMesh=SPawnSkeletalMeshComponent
    FaceFXHeadTrackWeightScale=(X=1.7000000,Y=1.0000000)
    FaceFXHeadTrackWeightBias=(X=0.1000000,Y=0.2000000)
    RequiredAST[0]=false
    RequiredAST[1]=false
    RequiredAST[2]=false
    RequiredAST[3]=false
    RequiredAST[4]=false
    RequiredAST[5]=false
    RequiredAST[6]=false
    RequiredAST[7]=false
    RequiredAST[8]=false
    RequiredAST[9]=false
    RequiredAST[10]=false
    RequiredAST[11]=false
    RequiredAST[12]=false
    RequiredAST[13]=false
    RequiredAST[14]=false
    RequiredAST[15]=false
    RequiredAST[16]=false
    RequiredAST[17]=false
    RequiredAST[18]=false
    RequiredAST[19]=false
    RequiredAST[20]=false
    RequiredAST[21]=false
    RequiredAST[22]=true
    RequiredAST[23]=false
    RequiredAST[24]=false
    RequiredAST[25]=false
    RequiredAST[26]=false
    RequiredAST[27]=false
    RequiredAST[28]=false
    RequiredAST[29]=false
    RequiredAST[30]=false
    RequiredAST[31]=false
    RequiredAST[32]=false
    RequiredAST[33]=false
    RequiredAST[34]=false
    RequiredAST[35]=false
    RequiredAST[36]=false
    RequiredAST[37]=false
    RequiredAST[38]=true
    RequiredAST[39]=false
    RequiredAST[40]=false
    RequiredAST[41]=false
    RequiredAST[42]=false
    RequiredAST[43]=false
    RequiredAST[44]=false
    RequiredAST[45]=false
    RequiredAST[46]=false
    RequiredAST[47]=false
    RequiredAST[48]=false
    RequiredAST[49]=false
    RequiredAST[50]=false
    RequiredAST[51]=false
    RequiredAST[52]=false
    RequiredAST[53]=false
    RequiredAST[54]=false
    RequiredAST[55]=false
    RequiredAST[56]=false
    RequiredAST[57]=false
    RequiredAST[58]=false
    RequiredAST[59]=false
    RequiredAST[60]=false
    RequiredAST[61]=false
    RequiredAST[62]=false
    RequiredAST[63]=false
    RequiredAST[64]=false
    RequiredAST[65]=false
    RequiredAST[66]=false
    RequiredAST[67]=true
    RequiredAST[68]=false
    RequiredAST[69]=true
    RequiredAST[70]=true
    RequiredAST[71]=false
    RequiredAST[72]=false
    RequiredAST[73]=false
    RequiredAST[74]=false
    RequiredAST[75]=false
    RequiredAST[76]=false
    RequiredAST[77]=false
    RequiredAST[78]=false
    RequiredAST[79]=false
    RequiredAST[80]=false
    RequiredAST[81]=false
    RequiredAST[82]=false
    RequiredAST[83]=false
    RequiredAST[84]=false
    RequiredAST[85]=false
    RequiredAST[86]=false
    RequiredAST[87]=false
    RequiredAST[88]=false
    RequiredAST[89]=false
    RequiredAST[90]=false
    RequiredAST[91]=false
    RequiredAST[92]=false
    RequiredAST[93]=false
    RequiredAST[94]=false
    RequiredAST[95]=false
    RequiredAST[96]=false
    RequiredAST[97]=false
    RequiredAST[98]=false
    RequiredAST[99]=false
    RequiredAST[100]=false
    RequiredAST[101]=false
    RequiredAST[102]=false
    RequiredAST[103]=false
    RequiredAST[104]=false
    RequiredAST[105]=false
    RequiredAST[106]=false
    RequiredAST[107]=false
    RequiredAST[108]=true
    RequiredAST[109]=false
    RequiredAST[110]=false
    RequiredAST[111]=false
    RequiredAST[112]=false
    RequiredAST[113]=false
    RequiredAST[114]=false
    RequiredAST[115]=false
    RequiredAST[116]=false
    RequiredAST[117]=false
    RequiredAST[118]=false
    RequiredAST[119]=false
    RequiredAST[120]=false
    RequiredAST[121]=false
    RequiredAST[122]=false
    RequiredAST[123]=false
    RequiredAST[124]=false
    RequiredAST[125]=false
    RequiredAST[126]=false
    RequiredAST[127]=false
    RequiredAST[128]=false
    RequiredAST[129]=false
    RequiredAST[130]=false
    RequiredAST[131]=false
    RequiredAST[132]=false
    RequiredAST[133]=false
    RequiredAST[134]=false
    RequiredAST[135]=false
    RequiredAST[136]=false
    RequiredAST[137]=false
    RequiredAST[138]=false
    RequiredAST[139]=false
    RequiredAST[140]=false
    RequiredAST[141]=false
    RequiredAST[142]=false
    RequiredAST[143]=false
    RequiredAST[144]=false
    RequiredAST[145]=false
    RequiredAST[146]=false
    RequiredAST[147]=false
    RequiredAST[148]=false
    RequiredAST[149]=false
    RequiredAST[150]=false
    RequiredAST[151]=false
    RequiredAST[152]=false
    RequiredAST[153]=false
    RequiredAST[154]=false
    RequiredAST[155]=false
    RequiredAST[156]=false
    RequiredAST[157]=false
    RequiredAST[158]=false
    RequiredAST[159]=false
    RequiredAST[160]=false
    RequiredAST[161]=false
    RequiredAST[162]=false
    RequiredAST[163]=false
    RequiredAST[164]=false
    RequiredAST[165]=false
    RequiredAST[166]=false
    RequiredAST[167]=false
    RequiredAST[168]=false
    RequiredAST[169]=false
    RequiredAST[170]=false
    RequiredAST[171]=false
    RequiredAST[172]=false
    RequiredAST[173]=false
    RequiredAST[174]=false
    RequiredAST[175]=false
    RequiredAST[176]=false
    RequiredAST[177]=false
    RequiredAST[178]=false
    RequiredAST[179]=false
    RequiredAST[180]=false
    RequiredAST[181]=false
    RequiredAST[182]=false
    RequiredAST[183]=false
    RequiredAST[184]=false
    RequiredAST[185]=false
    RequiredAST[186]=false
    RequiredAST[187]=false
    RequiredAST[188]=false
    RequiredAST[189]=false
    RequiredAST[190]=false
    RequiredAST[191]=false
    RequiredAST[192]=false
    RequiredAST[193]=false
    RequiredAST[194]=false
    RequiredAST[195]=false
    RequiredAST[196]=false
    RequiredAST[197]=false
    RequiredAST[198]=false
    RequiredAST[199]=false
    RequiredAST[200]=false
    RequiredAST[201]=false
    RequiredAST[202]=false
    RequiredAST[203]=false
    RequiredAST[204]=false
    RequiredAST[205]=false
    RequiredAST[206]=false
    RequiredAST[207]=false
    RequiredAST[208]=false
    // Reference: AudioComponent'Default__AdvPawn_NPCJennifer_Base.SizzleAudioComponent0'
    begin object name=SizzleAudioComponent0
    end object
    SizzleSoundComponent=SizzleAudioComponent0
    CharacterFootStepType=ECharacterFootStepType.CFST_Jennifer
    // Reference: EvilPawnBlockingComponent'Default__AdvPawn_NPCJennifer_Base.PawnBlocker0'
    begin object name=PawnBlocker0
        ReplacementPrimitive=none
    end object
    PawnBlocker=PawnBlocker0
    // Reference: DynamicLightEnvironmentComponent'Default__AdvPawn_NPCJennifer_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: ForceFeedbackWaveform'Default__AdvPawn_NPCJennifer_Base.ForceFeedbackWaveformFall'
    begin object name=ForceFeedbackWaveformFall
    end object
    FallingDamageWaveForm=ForceFeedbackWaveformFall
    // Reference: UTAmbientSoundComponent'Default__AdvPawn_NPCJennifer_Base.AmbientSoundComponent'
    begin object name=AmbientSoundComponent
    end object
    PawnAmbientSound=AmbientSoundComponent
    // Reference: UTAmbientSoundComponent'Default__AdvPawn_NPCJennifer_Base.AmbientSoundComponent2'
    begin object name=AmbientSoundComponent2
    end object
    WeaponAmbientSound=AmbientSoundComponent2
    // Reference: SkeletalMeshComponent'Default__AdvPawn_NPCJennifer_Base.OverlayMeshComponent0'
    begin object name=OverlayMeshComponent0
        ReplacementPrimitive=none
    end object
    OverlayMesh=OverlayMeshComponent0
    // Refer[0]ence: UDKSkeletalMeshComponent'Default__AdvPawn_NPCJennifer_Base.FirstPersonArms'
    begin object name=FirstPersonArms
        // Reference: AnimNodeSequence'Default__AdvPawn_NPCJennifer_Base.FirstPersonArms.MeshSequenceA'
        begin object name=MeshSequenceA
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms
    // Reference: UDKSkeletalMeshComponent'Default__AdvPawn_NPCJennifer_Base.FirstPersonArms2'
    begin object name=FirstPersonArms2
        // Reference: AnimNodeSequence'Default__AdvPawn_NPCJennifer_Base.FirstPersonArms2.MeshSequenceB'
        begin object name=MeshSequenceB
        end object
        Animations=MeshSequenceB
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms2
    // Reference: SkeletalMeshComponent'Default__AdvPawn_NPCJennifer_Base.WPawnSkeletalMeshComponent'
    begin object name=WPawnSkeletalMeshComponent
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvPawn_NPCJennifer_Base.MyLightEnvironment'
    end object
    Mesh=WPawnSkeletalMeshComponent
    // Reference: CylinderComponent'Default__AdvPawn_NPCJennifer_Base.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: EvilAudioComponent'Default__AdvPawn_NPCJennifer_Base.FaceAudioComponent'
    begin object name=FaceAudioComponent
    end object
    FacialAudioComp=FaceAudioComponent
    Components[0]=CollisionCylinder
    Components[1]=none
    Components[2]=MyLightEnvironment
    Components[3]=WPawnSkeletalMeshComponent
    Components[4]=AmbientSoundComponent
    Components[5]=AmbientSoundComponent2
    Components[6]=FaceAudioComponent
    Components[7]=SPawnSkeletalMeshComponent
    Components[8]=SizzleAudioComponent0
    CollisionComponent=CollisionCylinder
}