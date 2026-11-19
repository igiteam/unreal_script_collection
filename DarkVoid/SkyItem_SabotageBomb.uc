class SkyItem_SabotageBomb extends SkyHandoffItem
    native
    config(Game);

var const localized string YouHaveBombString;
var const localized string ArmBombString;
var const localized string ArmingString;
var const localized string BoomString;
var() Color YouHaveBombColor;
var() bool bExplodeEndsGame;
var() bool bAutoArming;
var transient bool bInSabotageVolume;
var transient bool bArming;
var() float ArmTime;
var transient float ArmTimeSoFar;
var() float DroppedLifetime;
var transient SkyPickup_SabotageBomb Factory;
var transient DroppedPickup Pickup;
var transient SkySabotageVolume Volume;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority)
        bArming, bInSabotageVolume;
}

simulated function PostBeginPlay()
{
    local SkySabotageVolume Vol;

    super(SkyWeapon).PostBeginPlay();
    // End:0x5C
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x5B
        foreach AllActors(Class'SkySabotageVolume', Vol)
        {
            Vol.AssociatedActor = self;
            Vol.GotoState('AssociatedTouch');
            Volume = Vol;            
        }        
    }
    // End:0x9C
    if(SkyGameReplicationInfo(WorldInfo.GRI) != none)
    {
        SkyGameReplicationInfo(WorldInfo.GRI).SetCurrentObjective(self);
    }
    //return;    
}

simulated event Destroyed()
{
    // End:0x8A
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x1D
        if(Factory == none)
        {
            return;
        }
        Factory.TheBomb = none;
        Factory.GotoState('Pickup');
        // End:0x8A
        if(SkyGameReplicationInfo(WorldInfo.GRI) != none)
        {
            SkyGameReplicationInfo(WorldInfo.GRI).SetCurrentObjective(Factory);
        }
    }
    //return;    
}

// Export USkyItem_SabotageBomb::execHasAnyAmmo(FFrame&, void* const)
native simulated function bool HasAnyAmmo();

simulated function float GetWeaponRating()
{
    return 20.0000000;
    //return ReturnValue;    
}

reliable server function Handoff()
{
    super.Handoff();
    // End:0x46
    if(SkyGameReplicationInfo(WorldInfo.GRI) != none)
    {
        SkyGameReplicationInfo(WorldInfo.GRI).SetCurrentObjective(self);
    }
    //return;    
}

function AnnouncePickup(Pawn Other)
{
    super(Inventory).AnnouncePickup(Other);
    Pickup = none;
    // End:0x52
    if(SkyGameReplicationInfo(WorldInfo.GRI) != none)
    {
        SkyGameReplicationInfo(WorldInfo.GRI).SetCurrentObjective(self);
    }
    //return;    
}

function DroppedPickup DropFromEx(Vector StartLocation, Rotator StartRotation, Vector StartVelocity, Vector StartAngularVelocity, optional bool bAuxiliary, optional int auxIndex)
{
    // End:0x31
    if((Instigator != none) && Instigator.IsInState('RoundEnded'))
    {
        Destroy();
        return none;        
    }
    else
    {
        Pickup = super(SkyWeapon).DropFromEx(StartLocation, StartRotation, StartVelocity, StartAngularVelocity);
        // End:0x101
        if((Pickup != none) && !Pickup.bDeleteMe)
        {
            Pickup.LifeSpan = DroppedLifetime;
            // End:0xBE
            if(SkyPickup(Pickup) != none)
            {
                SkyPickup(Pickup).Team = Factory.Team;
            }
            // End:0xFE
            if(SkyGameReplicationInfo(WorldInfo.GRI) != none)
            {
                SkyGameReplicationInfo(WorldInfo.GRI).SetCurrentObjective(self);
            }            
        }
        else
        {
            Pickup = none;
        }
        return Pickup;
    }
    //return ReturnValue;    
}

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    // End:0x22
    if(Other == Instigator)
    {
        bInSabotageVolume = true;
        ArmTimeSoFar = 0.0000000;
    }
    //return;    
}

event UnTouch(Actor Other)
{
    // End:0x1F
    if(Other == Instigator)
    {
        bInSabotageVolume = false;
        bArming = false;
    }
    //return;    
}

function AdjustObjective(out Actor Objective, out string Text, PlayerReplicationInfo PRI)
{
    // End:0x4F
    if((Instigator != none) && PRI == Instigator.PlayerReplicationInfo)
    {
        Objective = Volume;
        Text = "Deliver the Package";        
    }
    else
    {
        // End:0x104
        if(Instigator != none)
        {
            Objective = Instigator;
            Text = Instigator.PlayerReplicationInfo.PlayerName $ " has the bomb.";
            // End:0xE7
            if(int(PRI.GetTeamNum()) == int(Instigator.GetTeamNum()))
            {
                Text = Text $ "  Protect him.";                
            }
            else
            {
                Text = Text $ "  Stop him.";
            }            
        }
        else
        {
            // End:0x17A
            if(Pickup != none)
            {
                Objective = Pickup;
                // End:0x15F
                if(int(PRI.GetTeamNum()) == Factory.Team)
                {
                    Text = "Go get the bomb.";                    
                }
                else
                {
                    Text = "Defend the bomb.";
                }                
            }
            else
            {
                // End:0x1F0
                if(Factory != none)
                {
                    Objective = Factory;
                    // End:0x1D5
                    if(int(PRI.GetTeamNum()) == Factory.Team)
                    {
                        Text = "Go get the bomb.";                        
                    }
                    else
                    {
                        Text = "Defend the bomb.";
                    }                    
                }
                else
                {
                    Text = ((("Bad Objective: " $ string(PRI)) @ string(Instigator)) @ string(Pickup)) @ string(Factory);
                }
            }
        }
    }
    //return;    
}

simulated state Active
{
    simulated function EndState(name NextStateName)
    {
        bArming = false;
        bCanHandoff = true;
        super.EndState(NextStateName);
        //return;        
    }

    simulated function BeginFire(byte FireModeNum)
    {
        // End:0x31
        if(bInSabotageVolume && !bAutoArming)
        {
            ArmTimeSoFar = 0.0000000;
            bArming = true;
            bCanHandoff = false;
        }
        //return;        
    }

    simulated function EndFire(byte FireModeNum)
    {
        bArming = false;
        bCanHandoff = true;
        //return;        
    }

    simulated function Tick(float DeltaTime)
    {
        // End:0xE5
        if((bArming || bAutoArming) && ArmTimeSoFar < ArmTime)
        {
            // End:0xDD
            if(bInSabotageVolume)
            {
                ArmTimeSoFar += DeltaTime;
                // End:0xDA
                if(ArmTimeSoFar >= ArmTime)
                {
                    // End:0xDA
                    if(int(Role) == int(ROLE_Authority))
                    {
                        // End:0x99
                        if(SkyGameReplicationInfo(WorldInfo.GRI) != none)
                        {
                            SkyGameReplicationInfo(WorldInfo.GRI).SetCurrentObjective(self);
                        }
                        // End:0xDA
                        if(bExplodeEndsGame)
                        {
                            WorldInfo.Game.EndGame(Instigator.PlayerReplicationInfo, "triggered");
                        }
                    }
                }                
            }
            else
            {
                bArming = false;
            }
        }
        super(SkyWeapon).Tick(DeltaTime);
        //return;        
    }
    stop;    
}
