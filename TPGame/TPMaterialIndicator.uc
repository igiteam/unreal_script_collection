class TPMaterialIndicator extends Trigger;

enum MI_Type {MI_StaticMeshActor, MI_DynamicSMActor, MI_UseButton};

var() MI_Type         ActorType;
var() int             MaterialIndex;
var() StaticMeshActor FlashingActor;
var() DynamicSMActor  FlashingDSMActor;
var() UseButton       FlashingUseButton;
var() LinearColor     FlashColor;
var() float           FlashTime;
var() name            MaterialVectorParameterName;

var   MaterialInstanceConstant mic;
var   bool                     bFlash;
var   float                    accuTime;
var   float                    red;
var   float                    green;
var   float                    blue;
var   LinearColor              CurrentColor;
var   int                      PosNeg;

function MaterialInstanceConstant GetMIC()
{
    switch(ActorType)
    {
    case MI_StaticMeshActor:
        return FlashingActor.StaticMeshComponent.CreateAndSetMaterialInstanceConstant(MaterialIndex);
    case MI_DynamicSMActor:
        return FlashingDSMActor.StaticMeshComponent.CreateAndSetMaterialInstanceConstant(MaterialIndex);
    case MI_UseButton:
        return FlashingUseButton.StaticMeshComponent.CreateAndSetMaterialInstanceConstant(MaterialIndex);
    }

    return None;
}

event Touch(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal)
{
    if (PlayerPawn(Other) != None)
    {
        if (mic == None)
            mic = GetMIC();

        red   = FlashColor.r/FlashTime;
        green = FlashColor.g/FlashTime;
        blue  = FlashColor.b/FlashTime;

        bFlash   = true;
        accuTime = 0;
    }

    Super.Touch(Other, OtherComp, HitLocation, HitNormal);
}

event UnTouch(Actor Other)
{
    if (PlayerPawn(Other) != None)
    {
        if (mic != None)
        {
            CurrentColor.r = 0;
            CurrentColor.g = 0;
            CurrentColor.b = 0;
            mic.SetVectorParameterValue(MaterialVectorParameterName, CurrentColor);
        }

        bFlash = false;
    }

    Super.UnTouch(Other);
}

event Tick(float DeltaTime)
{
    if (bFlash && mic != None)
    {
        accuTime += PosNeg*DeltaTime;
        if (accuTime > FlashTime)
        {
            PosNeg  *= -1;
            accuTime = FlashTime;
            CurrentColor = FlashColor;
        }
        else if (accuTime < 0)
        {
            PosNeg  *= -1;
            accuTime = 0;
            CurrentColor.r = 0;
            CurrentColor.g = 0;
            CurrentColor.b = 0;
        }

        CurrentColor.r = FlashColor.r*accuTime;
        CurrentColor.g = FlashColor.g*accuTime;
        CurrentColor.b = FlashColor.b*accuTime;

        mic.SetVectorParameterValue(MaterialVectorParameterName, CurrentColor);
    }

    Super.Tick(DeltaTime);
}

