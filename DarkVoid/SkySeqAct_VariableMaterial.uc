class SkySeqAct_VariableMaterial extends SequenceAction
    native;

struct native Parameters
{
    var() bool Active;
    var() name ParameterName;
    var() float StartTime;
    var() float EndTime;
    var() float StartValue;
    var() float EndValue;
    var() bool DisableStartValueClamp;
    var() bool DisableEndValueClamp;

    structdefaultproperties
    {
        Active=false
        ParameterName="None"
        StartTime=0.0000000
        EndTime=0.0000000
        StartValue=0.0000000
        EndValue=0.0000000
        DisableStartValueClamp=false
        DisableEndValueClamp=false
    }
};

var() MaterialInterface Material;
var() float LocX;
var() float LocY;
var() float mWidth;
var() float mHeight;
var() bool bFullScreenSizeOverride;
var bool bStarted;
var bool bCancel;
var float StartTime;
var SkyVariableMaterial skyMaterial;
var() array<Parameters> Params;

event bool IsValidUISequenceObject(optional UIScreenObject TargetObject)
{
    return true;
    //return ReturnValue;    
}

event CreateMaterial(HUD HUD)
{
    local int I;
    local SkyHUD SHud;

    SHud = SkyHUD(HUD);
    // End:0x75
    if(skyMaterial == none)
    {
        SHud.HudVariableMaterials.Insert(SHud.HudVariableMaterials.Length, 1);
        skyMaterial = new Class'SkyVariableMaterial';
        SHud.HudVariableMaterials[SHud.HudVariableMaterials.Length - 1] = skyMaterial;
    }
    skyMaterial.MaterialInstance = new (Outer) Class'Engine.MaterialInstanceConstant';
    skyMaterial.MaterialInstance.SetParent(Material);
    skyMaterial.LocX = LocX;
    skyMaterial.LocY = LocY;
    skyMaterial.mWidth = mWidth;
    skyMaterial.mHeight = mHeight;
    skyMaterial.bFullScreenSizeOverride = bFullScreenSizeOverride;
    skyMaterial.StartTime = StartTime;
    I = 0;
    J0x13D:

    // End:0x3A6 [Loop If]
    if(I < Params.Length)
    {
        skyMaterial.Params.Insert(skyMaterial.Params.Length, 1);
        skyMaterial.Params[skyMaterial.Params.Length - 1].Active = Params[I].Active;
        skyMaterial.Params[skyMaterial.Params.Length - 1].DisableStartValueClamp = Params[I].DisableStartValueClamp;
        skyMaterial.Params[skyMaterial.Params.Length - 1].DisableEndValueClamp = Params[I].DisableEndValueClamp;
        skyMaterial.Params[skyMaterial.Params.Length - 1].ParameterName = Params[I].ParameterName;
        skyMaterial.Params[skyMaterial.Params.Length - 1].StartTime = Params[I].StartTime;
        skyMaterial.Params[skyMaterial.Params.Length - 1].EndTime = Params[I].EndTime;
        skyMaterial.Params[skyMaterial.Params.Length - 1].StartValue = Params[I].StartValue;
        skyMaterial.Params[skyMaterial.Params.Length - 1].EndValue = Params[I].EndValue;
        I++;
        // [Loop Continue]
        goto J0x13D;
    }
    //return;    
}

event DestroyMaterial(HUD HUD)
{
    local int Index;
    local SkyHUD SHud;

    SHud = SkyHUD(HUD);
    // End:0x2A
    if((skyMaterial == none) || SHud == none)
    {
        return;
    }
    Index = SHud.HudVariableMaterials.Find(skyMaterial);
    SHud.HudVariableMaterials.Remove(Index, 1);
    skyMaterial = none;
    //return;    
}
