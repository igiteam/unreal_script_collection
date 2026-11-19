class AdvFocusHighlightComponent_Survival extends AdvFocusHighlightComponent
    editinlinenew
    hidecategories(Object,Physics,Collision);

var array<MaterialInstanceConstant> MaterialInstances;

protected static simulated function class<AdvFocusHighlightComponent> GetComponentClass()
{
    return Class'AdvFocusHighlightComponent_Survival';
    //return ReturnValue;    
}

static simulated function HighlightActor(Actor A, optional bool bInstant = false)
{
    local editinline AdvFocusHighlightComponent tmpComp;
    local editinline AdvFocusHighlightComponent_Survival Comp;
    local editinline MeshComponent MC;
    local MaterialInstanceConstant Mat;
    local bool hiddenHack;
    local int I;

    tmpComp = GetForActor(A);
    // End:0x7A
    if(tmpComp == none)
    {
        tmpComp = new (A) GetComponentClass();
        A.AttachComponent(tmpComp);
    }
    Comp = AdvFocusHighlightComponent_Survival(tmpComp);
    Comp.KillTimers(A);
    hiddenHack = A.IsA('EvilUsableTriggerWithText');
    // End:0x175
    if(hiddenHack)
    {
        Comp.SetIgnoreOwnerHidden(true);
        Comp.SetHidden(EvilUsableTriggerWithText(A).MeshComp.HiddenGame);        
    }
    else
    {
        Comp.SetHidden(false);
    }
    // End:0x2E7
    if(Comp.MaterialInstances.Length <= 0)
    {
        // End:0x2E6
        foreach A.ComponentList(Class'Engine.MeshComponent', MC)
        {
            I = 0;
            J0x1F9:

            // End:0x2E5 [Loop If]
            if(I < MC.GetNumElements())
            {
                Mat = MaterialInstanceConstant(MC.GetMaterial(I));
                // End:0x2D7
                if(Mat.Parent == Material'adv_en_multi_levels_02.Materials.m_en_mayan_Base_WallDetail')
                {
                    Comp.MaterialInstances.AddItem(MC.CreateAndSetMaterialInstanceConstant(I));                    
                }
                ++I;
                // [Loop Continue]
                goto J0x1F9;
            }            
        }        
    }
    // End:0x341
    foreach Comp.MaterialInstances(Mat)
    {
        Mat.SetScalarParameterValue('ifShow', 1.0000000);        
    }    
    //return;    
}

simulated function Dehighlight(optional bool bInstant = false)
{
    local MaterialInstanceConstant Mat;

    // End:0x4A
    foreach MaterialInstances(Mat)
    {
        Mat.SetScalarParameterValue('ifShow', 0.0000000);        
    }    
    //return;    
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
                MIC.SetScalarParameterValue('ifShow', Opacity * Opacity);
            }
            ++I;
            // [Loop Continue]
            goto J0xE4;
        }        
    }    
    //return;    
}

defaultproperties
{
    HighlightMaterial=Material'adv_en_multi_levels_02.Materials.m_en_mayan_Base_WallDetail'
    SkeletalHighlightMaterial=Material'adv_en_multi_levels_02.Materials.m_en_mayan_Base_WallDetail'
    ReplacementPrimitive=none
}