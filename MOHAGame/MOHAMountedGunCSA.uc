class MOHAMountedGunCSA extends MOHACSASpawnable
    hidecategories(Navigation);

var(MG42) float MountAreaRadius;
var MOHAMountedGun MountedGun;
var MOHAPawn GunUser;
var MOHAMountedGunWeapon Weapon;
var const localized string MountedGunMsg;

function Vector GetGunPosition()
{
    return MountedGun.GetWeaponAttachmentLocation();
    //return ReturnValue;    
}

simulated event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    // End:0x42
    if((MountedGun != none) && !MountedGun.GetIsMounted())
    {
        super(MOHACSA).Touch(Other, OtherComp, HitLocation, HitNormal);        
    }
    else
    {
        CheckReMount();
    }
    //return;    
}

function CheckTouching()
{
    local MOHAPlayerPawn P;

    // End:0x33
    foreach TouchingActors(Class'MOHAPlayerPawn', P)
    {
        Touch(P, none, Location, vect(0.0000000, 0.0000000, 1.0000000));        
    }    
    //return;    
}

function CheckReMount()
{
    SetTimer(0.5000000, false, 'CheckTouching');
    //return;    
}

event bool UsedBy(Pawn User)
{
    local MOHAPlayerController LocalPlayer;
    local MOHAPlayerPawn localPawn;

    // End:0x0B
    if(bDirty)
    {
        return false;
    }
    LocalPlayer = MOHAPlayerController(User.Controller);
    localPawn = MOHAPlayerPawn(User.Controller.Pawn);
    // End:0x182
    if(LocalPlayer != none)
    {
        // End:0x9F
        if((MountedGun.GetIsMounted() || int(localPawn.eCurrentStance) != int(0)) || int(localPawn.eDesiredStance) != int(0))
        {
            return false;
        }
        // End:0xDB
        if(MountedGun.GetIsClaimed())
        {
            MountedGun.PlayerOverride();
            MountedGun.ClearClaim();
        }
        Weapon = MOHAMountedGunWeapon(MountedGun.Weapon);
        // End:0x101
        if(Weapon == none)
        {
            return false;
        }
        LocalPlayer.RemoveCSA(self);
        MountedGun.Claim(MOHAPawn(User));
        // End:0x164
        if(bDisplayed)
        {
            MOHAHUD(LocalPlayer.myHUD).RemoveCSA();
            bDisplayed = false;
        }
        GunUser = MOHAPawn(User);
        GotoState('InUse');
    }
    return false;
    //return ReturnValue;    
}

function LeaveGun(Pawn User)
{
    //return;    
}

function MGWeaponRaising()
{
    MountedGun.HideStand(true);
    //return;    
}

function TakeWeaponFromMG()
{
    GunUser.CurrentWeaponAttachment = MountedGun.CurrentWeaponAttachment;
    MountedGun.EnablePlayerUse(MOHAPlayerPawn(GunUser));
    MountedGun.InvManager.RemoveFromInventory(Weapon);
    Weapon.GotoState('Inactive');
    Weapon.GiveTo(GunUser);
    Weapon.InitSkeletalControls();
    //return;    
}

function ReturnWeaponToMG()
{
    MountedGun.DisablePlayerUse();
    // End:0x3F
    if(GunUser != none)
    {
        GunUser.InvManager.RemoveFromInventory(Weapon);
    }
    Weapon.GiveTo(MountedGun);
    MountedGun.ResetMG();
    // End:0x8F
    if(!MountedGun.bHideStand)
    {
        MountedGun.HideStand(false);
    }
    Weapon.InitSkeletalControls();
    Weapon.FaceDefault();
    //return;    
}

function PostBeginPlay()
{
    super(MOHACSA).PostBeginPlay();
    CylinderComponent.SetCylinderSize(MountAreaRadius, 30.0000000);
    //return;    
}

simulated function bool IsUsableBy(MOHAPlayerController PlayerController)
{
    local MOHAPlayerPawn PlayerPawn;
    local EALASmallArms PlayerWeapon;

    PlayerPawn = MOHAPlayerPawn(PlayerController.Pawn);
    // End:0x7A
    if((((PlayerPawn.Health <= 0) || int(PlayerPawn.eCurrentStance) == int(1)) || PlayerPawn.IsAirdropActive()) || PlayerController.IsMountedMGState())
    {
        return false;
    }
    // End:0x95
    if(int(PlayerPawn.Physics) != int(1))
    {
        return false;
    }
    PlayerWeapon = EALASmallArms(PlayerPawn.Weapon);
    // End:0xD3
    if((PlayerWeapon != none) && PlayerWeapon.IsScopeActive())
    {
        return false;
    }
    return super(MOHACSA).IsUsableBy(PlayerController);
    //return ReturnValue;    
}

function LoadLocalizedStrings()
{
    csaText = MountedGunMsg;
    //return;    
}

state InUse
{
    function LeaveGun(Pawn User)
    {
        GunUser = none;
        CheckReMount();
        GotoState('None');
        MountedGun.ClearClaim();
        //return;        
    }

    function BeginState(name PreviousName)
    {
        MOHAPlayerController(GunUser.Controller).MountMG(self);
        MountedGun.SetIsMounted(true);
        MountedGun.SetIsClaimed(true);
        MountedGun.Gunner = GunUser;
        super(Object).BeginState(PreviousName);
        //return;        
    }

    simulated event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
    {
        return;
        //return;        
    }
    stop;    
}

defaultproperties
{
    MountAreaRadius=100.0000000
    MountedGunMsg="Hold %b to Use MMG"
    bLookAt=false
    bOneShot=false
    fLookAtThreshold=0.8500000
    fWeightScale=3.0000000
    // Reference: CylinderComponent'Default__MOHAMountedGunCSA.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__MOHAMountedGunCSA.Sprite'
    begin object name=Sprite
        HiddenGame=true
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    bHidden=false
    CollisionComponent=CollisionCylinder
    SupportedEvents=/* Array type was not detected. */
}