class PKPlayerOverlayComponent extends PrimitiveComponent;

const FADE_STEP = 0.03;

var() const float PostDeactivationDetachDelay;
var() const float FadeSpeed;
var MaterialInstance HighlightMaterial;
var() name NormalParamName;
var export editinline array<export editinline MeshComponent> Overlays;
var transient float Opacity;

static function PKPlayerOverlayComponent GetForActor(Actor A)
{
    local editinline PKPlayerOverlayComponent FHC;

    // End:0x40
    foreach A.ComponentList(Class'PKPlayerOverlayComponent', FHC)
    {        
        return FHC;        
    }    
    return none;
    //return ReturnValue;    
}

static function HighlightActor(Actor A, MaterialInterface Material, optional bool bInstant = false)
{
    local editinline PKPlayerOverlayComponent Comp;
    local editinline MeshComponent MC, OverlayMesh;
    local MaterialInstanceConstant Mat;
    local editinline array<editinline MeshComponent> compList;

    Comp = GetForActor(A);
    // End:0x79
    if(Comp == none)
    {
        Comp = new (A) Class'PKPlayerOverlayComponent';
        A.AttachComponent(Comp);
    }
    Comp.KillTimers(A);
    // End:0x2CA
    if(Comp.Overlays.Length < 1)
    {
        Comp.HighlightMaterial = new (Comp) Class'Engine.MaterialInstanceConstant';
        Comp.HighlightMaterial.SetParent(Material);
        // End:0x20C
        foreach A.ComponentList(Class'Engine.MeshComponent', MC)
        {
            Mat = MaterialInstanceConstant(MC.GetMaterial(0));
            // End:0x1F5
            if((Mat == none) || Mat.Parent == Comp.HighlightMaterial)
            {
                continue;                
            }
            compList.AddItem(MC);            
        }        
        // End:0x2C9
        foreach compList(MC)
        {
            OverlayMesh = Comp.CreateOverlayFor(MC, false, Comp.HighlightMaterial);
            Comp.Overlays.AddItem(OverlayMesh);
            A.AttachComponent(OverlayMesh);            
        }        
    }
    // End:0x31D
    if(bInstant)
    {
        Comp.Opacity = 1.0000000;
        Comp.UpdateOverlayOpacity();        
    }
    else
    {
        Comp.FadeIn();
    }
    //return;    
}

function Dehighlight(optional bool bInstant = false)
{
    // End:0x1F
    if(bInstant)
    {
        DetachSelf();        
    }
    else
    {
        FadeOut();
    }
    //return;    
}

function SetQuickHide(bool bNewHidden)
{
    local editinline MeshComponent MC;

    // End:0x41
    foreach Overlays(MC)
    {
        MC.SetHidden(bNewHidden);        
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
    Owner.SetTimer(0.0300000, true, 'UpdateOverlayOpacity', self);
    //return;    
}

protected function FadeOut()
{
    // End:0x28
    if(Opacity > 0.0000000)
    {
        Opacity = -Opacity;
    }
    Owner.SetTimer(0.0300000, true, 'UpdateOverlayOpacity', self);
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
    A.ClearTimer('UpdateOverlayOpacity', self);
    A.ClearTimer('DetachSelf', self);
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

protected function MeshComponent CreateOverlayFor(MeshComponent MC, bool hiddenHack, MaterialInterface Mat)
{
    local editinline MeshComponent OverlayMesh;
    local int I;

    OverlayMesh = new (Outer) MC.Class;
    // End:0x26F
    if(OverlayMesh.IsA('SkeletalMeshComponent'))
    {
        SkeletalMeshComponent(OverlayMesh).SetSkeletalMesh(SkeletalMeshComponent(MC).SkeletalMesh);
        SkeletalMeshComponent(OverlayMesh).AnimSets = SkeletalMeshComponent(MC).AnimSets;
        SkeletalMeshComponent(OverlayMesh).SetParentAnimComponent(SkeletalMeshComponent(MC));
        SkeletalMeshComponent(OverlayMesh).bUpdateSkelWhenNotRendered = false;
        SkeletalMeshComponent(OverlayMesh).bIgnoreControllersWhenNotRendered = true;
        SkeletalMeshComponent(OverlayMesh).bOverrideAttachmentOwnerVisibility = true;
        OverlayMesh.SetOwnerNoSee(true);
        OverlayMesh.SetOnlyOwnerSee(false);
        I = 0;
        J0x1FA:

        // End:0x26F [Loop If]
        if(I < MC.Materials.Length)
        {
            SkeletalMeshComponent(OverlayMesh).SetMaterial(I, Mat);
            ++I;
            // [Loop Continue]
            goto J0x1FA;
        }
    }
    return OverlayMesh;
    //return ReturnValue;    
}

function UpdateOverlayOpacity()
{
    local editinline MeshComponent MC;
    local int I;
    local MaterialInstanceConstant MIC;

    // End:0x88
    if(Opacity < 0.0000000)
    {
        Opacity += (0.0300000 * FadeSpeed);
        // End:0x85
        if(Opacity > 0.0000000)
        {
            KillOverlays();
            Owner.ClearTimer('UpdateOverlayOpacity', self);
            Opacity = 0.0000000;
            return;
        }        
    }
    else
    {
        Opacity += (0.0300000 * FadeSpeed);
        // End:0xEE
        if(Opacity > 1.0000000)
        {
            Owner.ClearTimer('UpdateOverlayOpacity', self);
            Opacity = 1.0000000;
        }
    }
    // End:0x1D5
    foreach Overlays(MC)
    {
        I = 0;
        J0x110:

        // End:0x1D4 [Loop If]
        if(I < MC.GetNumElements())
        {
            MIC = MaterialInstanceConstant(MC.GetMaterial(I));
            // End:0x18A
            if(MIC == none)
            {                
            }
            else
            {
                MIC.SetScalarParameterValue('Opacity', Opacity * Opacity);
            }
            ++I;
            // [Loop Continue]
            goto J0x110;
        }        
    }    
    //return;    
}

defaultproperties
{
    PostDeactivationDetachDelay=2.5000000
    FadeSpeed=0.7500000
    NormalParamName="Main_Normal"
    ReplacementPrimitive=none
    AbsoluteRotation=true
    AbsoluteScale=true
}