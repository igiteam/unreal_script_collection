class AdvFocusHighlightComponent extends ParticleSystemComponent
    editinlinenew
    hidecategories(Object,Physics,Collision);

const FADE_STEP = 0.03;

var() const float PostDehighlightDecayTime;
var() const float PostDeactivationDetachDelay;
var() const float FadeSpeed;
var() const MaterialInterface HighlightMaterial;
var() const MaterialInterface SkeletalHighlightMaterial;
var() name NormalParamName;
var export editinline array<export editinline MeshComponent> Overlays;
var transient float Opacity;

static function AdvFocusHighlightComponent GetForActor(Actor A)
{
    local editinline AdvFocusHighlightComponent FHC;

    // End:0x40
    foreach A.ComponentList(Class'AdvFocusHighlightComponent', FHC)
    {        
        return FHC;        
    }    
    return none;
    //return ReturnValue;    
}

protected static simulated function class<AdvFocusHighlightComponent> GetComponentClass()
{
    return Class'AdvFocusHighlightComponent';
    //return ReturnValue;    
}

static function HighlightActor(Actor A, optional bool bInstant = false)
{
    local editinline AdvFocusHighlightComponent Comp;
    local editinline MeshComponent MC, OverlayMesh;
    local MaterialInstanceConstant Mat;
    local bool hiddenHack;

    Comp = GetForActor(A);
    // End:0x7A
    if(Comp == none)
    {
        Comp = new (A) GetComponentClass();
        A.AttachComponent(Comp);
    }
    Comp.KillTimers(A);
    hiddenHack = A.IsA('EvilUsableTriggerWithText');
    // End:0x159
    if(hiddenHack)
    {
        Comp.SetIgnoreOwnerHidden(true);
        Comp.SetHidden(EvilUsableTriggerWithText(A).MeshComp.HiddenGame);        
    }
    else
    {
        Comp.SetHidden(false);
    }
    // End:0x305
    if(Comp.Overlays.Length < 1)
    {
        // End:0x304
        foreach A.ComponentList(Class'Engine.MeshComponent', MC)
        {
            Mat = MaterialInstanceConstant(MC.GetMaterial(0));
            // End:0x274
            if((Mat != none) && (Mat.Parent == default.HighlightMaterial) || Mat.Parent == default.SkeletalHighlightMaterial)
            {
                continue;                
            }
            OverlayMesh = Comp.CreateOverlayFor(MC, hiddenHack);
            Comp.Overlays.AddItem(OverlayMesh);            
            A.AttachComponent(OverlayMesh);            
        }        
    }
    // End:0x358
    if(bInstant)
    {
        Comp.Opacity = 1.0000000;
        Comp.UpdateOverlayOpacity();        
    }
    else
    {
        Comp.FadeIn();
    }
    Comp.ActivateSystem();
    //return;    
}

function Dehighlight(optional bool bInstant = false)
{
    // End:0x29
    if(bInstant)
    {
        DeactivateSystem();
        DetachSelf();        
    }
    else
    {
        FadeOut();
        SetTimer(PostDehighlightDecayTime, false, 'DeactivatePSC');
    }
    //return;    
}

protected function FadeIn()
{
    // End:0x2B
    if(Opacity < 0.0000000)
    {
        Opacity = -Opacity;        
    }
    else
    {
        Opacity = 0.0000000;
    }
    UpdateOverlayOpacity();
    SetTimer(0.0300000, true, 'UpdateOverlayOpacity');
    //return;    
}

protected function FadeOut()
{
    // End:0x28
    if(Opacity > 0.0000000)
    {
        Opacity = -Opacity;
    }
    SetTimer(0.0300000, true, 'UpdateOverlayOpacity');
    //return;    
}

protected function DeactivatePSC()
{
    DeactivateSystem();
    SetTimer(PostDeactivationDetachDelay, false, 'DetachSelf');
    //return;    
}

protected function DetachSelf()
{
    KillTimers(Owner);
    KillOverlays();
    SetHidden(true);
    Owner.DetachComponent(self);
    //return;    
}

protected function KillTimers(Actor A)
{
    ClearTimer('UpdateOverlayOpacity');
    ClearTimer('DeactivatePSC');
    ClearTimer('DetachSelf');
    ClearTimer('UpdateOverlayOpacity');
    //return;    
}

protected function KillOverlays()
{
    local editinline MeshComponent MC;

    // End:0x19
    if(Owner == none)
    {
        ScriptTrace();
    }
    // End:0x84
    foreach Overlays(MC)
    {
        MC.SetHidden(true);
        Owner.DetachComponent(MC);
        MC = none;        
    }    
    Overlays.Length = 0;
    //return;    
}

protected function MeshComponent CreateOverlayFor(MeshComponent MC, bool hiddenHack)
{
    local editinline MeshComponent OverlayMesh;
    local int I;
    local bool bIsSkeletalMesh;
    local int MCNumElements;

    OverlayMesh = new (Outer) MC.Class;
    OverlayMesh.SetScale(MC.Scale);
    OverlayMesh.SetScale3D(MC.Scale3D);
    // End:0x238
    if(OverlayMesh.IsA('SkeletalMeshComponent'))
    {
        SkeletalMeshComponent(OverlayMesh).SetSkeletalMesh(SkeletalMeshComponent(MC).SkeletalMesh);
        SkeletalMeshComponent(OverlayMesh).AnimSets = SkeletalMeshComponent(MC).AnimSets;
        SkeletalMeshComponent(OverlayMesh).SetParentAnimComponent(SkeletalMeshComponent(MC));
        SkeletalMeshComponent(OverlayMesh).bUpdateSkelWhenNotRendered = false;
        SkeletalMeshComponent(OverlayMesh).bIgnoreControllersWhenNotRendered = true;
        SkeletalMeshComponent(OverlayMesh).bOverrideAttachmentOwnerVisibility = true;
        bIsSkeletalMesh = true;        
    }
    else
    {
        StaticMeshComponent(OverlayMesh).SetStaticMesh(StaticMeshComponent(MC).StaticMesh);
        OverlayMesh.SetTranslation(MC.Translation);
        OverlayMesh.SetRotation(MC.Rotation);
        bIsSkeletalMesh = false;
    }
    OverlayMesh.SetOwnerNoSee(false);
    OverlayMesh.SetOnlyOwnerSee(false);
    // End:0x399
    if(hiddenHack)
    {
        OverlayMesh.SetIgnoreOwnerHidden(MC.bIgnoreOwnerHidden);
    }
    OverlayMesh.SetHidden(MC.HiddenGame);
    MCNumElements = MC.GetNumElements();
    // End:0x41A
    if(MCNumElements == 0)
    {
        MCNumElements = 1;
    }
    I = 0;
    J0x425:

    // End:0x4AE [Loop If]
    if(I < MCNumElements)
    {
        OverlayMesh.SetMaterial(I, CreateMICFor(MC.GetMaterial(I), bIsSkeletalMesh));
        ++I;
        // [Loop Continue]
        goto J0x425;
    }
    return OverlayMesh;
    //return ReturnValue;    
}

protected function MaterialInstanceConstant CreateMICFor(MaterialInterface M, bool bSkeletalMesh)
{
    local MaterialInstanceConstant MIC;
    local Texture nm;

    MIC = new (Owner) Class'Engine.MaterialInstanceConstant';
    // End:0x58
    if(bSkeletalMesh)
    {
        MIC.SetParent(SkeletalHighlightMaterial);        
    }
    else
    {
        MIC.SetParent(HighlightMaterial);
    }
    // End:0x1E8
    if(M != none)
    {
        M.GetTextureParameterValue('NormalMap', nm);
        // End:0x103
        if(nm != none)
        {
            MIC.SetTextureParameterValue(NormalParamName, nm);            
        }
        else
        {
            M.GetTextureParameterValue('Normal_Main', nm);
            // End:0x177
            if(nm != none)
            {
                MIC.SetTextureParameterValue(NormalParamName, nm);                
            }
            else
            {
                M.GetTextureParameterValue('Main_Normal', nm);
                // End:0x1E8
                if(nm != none)
                {
                    MIC.SetTextureParameterValue(NormalParamName, nm);
                }
            }
        }
    }
    return MIC;
    //return ReturnValue;    
}

function UpdateOverlayOpacity()
{
    local editinline MeshComponent MC;
    local int I;
    local MaterialInstanceConstant MIC;

    // End:0x72
    if(Opacity < 0.0000000)
    {
        Opacity += (0.0300000 * FadeSpeed);
        // End:0x6F
        if(Opacity > 0.0000000)
        {
            KillOverlays();
            ClearTimer('UpdateOverlayOpacity');
            Opacity = 0.0000000;
            return;
        }        
    }
    else
    {
        Opacity += (0.0300000 * FadeSpeed);
        // End:0xC2
        if(Opacity > 1.0000000)
        {
            ClearTimer('UpdateOverlayOpacity');
            Opacity = 1.0000000;
        }
    }
    // End:0x1A9
    foreach Overlays(MC)
    {
        I = 0;
        J0xE4:

        // End:0x1A8 [Loop If]
        if(I < MC.GetNumElements())
        {
            MIC = MaterialInstanceConstant(MC.GetMaterial(I));
            // End:0x15E
            if(MIC == none)
            {                
            }
            else
            {
                MIC.SetScalarParameterValue('Opacity', Opacity * Opacity);
            }
            ++I;
            // [Loop Continue]
            goto J0xE4;
        }        
    }    
    //return;    
}

protected function SetTimer(float InRate, optional bool inbLoop, optional name inTimerFunc = 'Timer')
{
    Class'Engine.WorldInfo'.static.GetWorldInfo().GetALocalPlayerController().SetTimer(InRate, inbLoop, inTimerFunc, self);
    //return;    
}

protected function ClearTimer(optional name inTimerFunc = 'Timer')
{
    Class'Engine.WorldInfo'.static.GetWorldInfo().GetALocalPlayerController().super(AdvFocusHighlightComponent).ClearTimer(inTimerFunc, self);
    //return;    
}

defaultproperties
{
    PostDehighlightDecayTime=3.0000000
    PostDeactivationDetachDelay=2.5000000
    FadeSpeed=0.7500000
    HighlightMaterial=Material'adv_fx_FocusMode.Materials.m_FocusHighlight'
    SkeletalHighlightMaterial=Material'adv_fx_FocusMode.Materials.m_FocusHighlightSkeletal'
    NormalParamName="Main_Normal"
    bAutoActivate=false
    ReplacementPrimitive=none
    AbsoluteRotation=true
    AbsoluteScale=true
}