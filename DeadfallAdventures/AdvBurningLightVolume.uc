class AdvBurningLightVolume extends AdvDamageVolume
    hidecategories(Navigation,Object,Movement,Display);

var array<EvilPawn> EvilPawnsInVolume;

simulated function OnToggle(SeqAct_Toggle inAction)
{
    // End:0x50
    if(inAction.InputLinks[0].bHasImpulse)
    {
        bEnabled = true;
        SetLightAffectionForPawnsInVolume();        
    }
    else
    {
        // End:0xA0
        if(inAction.InputLinks[1].bHasImpulse)
        {
            bEnabled = false;
            SetLightAffectionForPawnsInVolume();            
        }
        else
        {
            // End:0xF9
            if(inAction.InputLinks[2].bHasImpulse)
            {
                bEnabled = !bEnabled;
                SetLightAffectionForPawnsInVolume();
            }
        }
    }
    super.OnToggle(inAction);
    //return;    
}

event PawnEnteredVolume(Pawn Other)
{
    local EvilPawn P;

    // End:0xA1
    if(Other != none)
    {
        P = EvilPawn(Other);
        // End:0xA1
        if((P != none) && P.bCanBeAffectedByLight)
        {
            EvilPawnsInVolume.AddItem(P);            
            // End:0xA1
            if(bEnabled)
            {
                P.SetLightAffectionFromVolume(true);
            }
        }
    }
    //return;    
}

function SetLightAffectionForPawnsInVolume()
{
    local EvilPawn P;

    // End:0x6E
    if(bEnabled)
    {
        // End:0x6A
        foreach EvilPawnsInVolume(P)
        {
            P.SetLightAffectionFromVolume(((P.bCanBeAffectedByLight) ? true : false));            
        }                
    }
    else
    {
        // End:0xA6
        foreach EvilPawnsInVolume(P)
        {
            P.SetLightAffectionFromVolume(false);            
        }        
    }
    //return;    
}

event PawnLeavingVolume(Pawn Other)
{
    local EvilPawn P;

    // End:0x70
    if(Other != none)
    {
        P = EvilPawn(Other);
        // End:0x70
        if(P != none)
        {
            EvilPawnsInVolume.RemoveItem(P);            
            P.SetLightAffectionFromVolume(false);
        }
    }
    //return;    
}

function CausePainTo(Actor Other)
{
    local class<EvilDmgType_Base> EvilDamageType;

    EvilDamageType = class<EvilDmgType_Base>(DamageType);
    // End:0xAD
    if(!((EvilDamageType.default.bIsLightDmgType && Other != none) && AdvPawn(Other) != none) && !AdvPawn(Other).bCanBeAffectedByLight)
    {
        super.CausePainTo(Other);
    }
    //return;    
}

defaultproperties
{
    bPainCausing=false
    bEntryPain=false
    bPhysicsOnContact=true
    // Reference: BrushComponent'Default__AdvBurningLightVolume.BrushComponent0'
    begin object name=BrushComponent0
        ReplacementPrimitive=none
    end object
    BrushComponent=BrushComponent0
    Components[0]=BrushComponent0
    CollisionComponent=BrushComponent0
}