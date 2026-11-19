class MOHAWindVolume extends Volume
    native
    hidecategories(Navigation,Object,Movement,Display);

enum EWindVolumeType
{
    WINDVOLUME_Normal,              // 0
    WINDVOLUME_NoVerticalForce,     // 1
    WINDVOLUME_MAX                  // 2
};

var() bool bHardConstraint;
var() bool bDeadenController;
var() bool bLogCollisionsWithRearFace;
var() float WindStrength;
var() float WindMaxStrengthVolumeRatio;
var() int WindRearFace;
var() MOHAWindVolume.EWindVolumeType WindVolumeType;
var int WindFrontFace;
var export editinline ArrowComponent WindVolumeEditorDirectionArrow;
var export editinline MOHADrawWindVolumeComponent DrawComponent;

// Export UMOHAWindVolume::execInitializeWindVolume(FFrame&, void* const)
native function InitializeWindVolume();

// Export UMOHAWindVolume::execGetWindForce(FFrame&, void* const)
native function Vector GetWindForce(Vector locationToTest, out float Strength);

// Export UMOHAWindVolume::execRenderWindVolume(FFrame&, void* const)
native function RenderWindVolume();

// Export UMOHAWindVolume::execValidateProperties(FFrame&, void* const)
native function ValidateProperties();

simulated event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    local MOHAPawn touchedMOHAPawn;

    super(Actor).Touch(Other, OtherComp, HitLocation, HitNormal);
    touchedMOHAPawn = MOHAPawn(Other);
    // End:0x49
    if(none != touchedMOHAPawn)
    {
        touchedMOHAPawn.TouchedWindVolume(self);
    }
    //return;    
}

simulated event UnTouch(Actor Other)
{
    local MOHAPawn touchedMOHAPawn;

    super(Actor).UnTouch(Other);
    touchedMOHAPawn = MOHAPawn(Other);
    // End:0x3A
    if(none != touchedMOHAPawn)
    {
        touchedMOHAPawn.UntouchedWindVolume(self);
    }
    //return;    
}

defaultproperties
{
    WindStrength=2048.0000000
    WindFrontFace=2
    // Reference: ArrowComponent'Default__MOHAWindVolume.ArrowComponent0'
    begin object name=ArrowComponent0 class=Class'Engine.ArrowComponent'
        ArrowColor=(R=0,G=255,B=0,A=255)
        Scale=256.0000000
    end object
    WindVolumeEditorDirectionArrow=ArrowComponent0
    // Reference: MOHADrawWindVolumeComponent'Default__MOHAWindVolume.DrawComponent0'
    begin object name=DrawComponent0 class=Class'MOHADrawWindVolumeComponent'
        AlwaysLoadOnClient=false
        AlwaysLoadOnServer=false
    end object
    DrawComponent=DrawComponent0
    // Reference: BrushComponent'Default__MOHAWindVolume.BrushComponent0'
    begin object name=BrushComponent0
    end object
    BrushComponent=BrushComponent0
    Components[0]=BrushComponent0
    Components[1]=ArrowComponent0
    Components[2]=DrawComponent0
    CollisionComponent=BrushComponent0
}