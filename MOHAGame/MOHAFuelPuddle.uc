class MOHAFuelPuddle extends Actor
    notplaceable
    hidecategories(Navigation);

var const editconst export editinline StaticMeshComponent StaticMeshComponent;
var export editinline transient CylinderComponent CylinderComponent;
var transient MOHAFuelContainer myFuelContainer;
var transient MaterialInstanceConstant MIC;
var transient Vector igniteLocation;
var transient Emitter BurningEmitter;
var transient bool bCanIgnite;

function Init(MOHAFuelContainer Parent)
{
    MIC = new (none) Class'Engine.MaterialInstanceConstant';
    MIC.SetParent(StaticMeshComponent.GetMaterial(0));
    StaticMeshComponent.SetMaterial(0, MIC);
    MIC.SetScalarParameterValue('StartTime', WorldInfo.TimeSeconds);
    myFuelContainer = Parent;
    //return;    
}

function Ignite(Vector Loc)
{
    //return;    
}

function PropogateFlameTimer()
{
    //return;    
}

function FlammableTimer()
{
    bCanIgnite = true;
    //return;    
}

auto state Idle
{
    function TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
    {
        local Vector Delta;
        local MOHAPlayerPawn playerInstigator;

        // End:0x15
        if(float(Damage) <= 0.0000000)
        {
            return;
        }
        // End:0x168
        if(bCanIgnite)
        {
            playerInstigator = ((InstigatedBy != none) ? MOHAPlayerPawn(InstigatedBy.Pawn) : none);
            // End:0x64
            if((MOHAFuelContainer(DamageCauser) == none) && playerInstigator == none)
            {
                return;
            }
            // End:0xA8
            if(!ClassIsChildOf(DamageType, Class'MOHAExplosiveDamageType'))
            {
                // End:0xA8
                if((playerInstigator != none) && VSize(playerInstigator.Location - Location) > float(4000))
                {
                    return;
                }
            }
            // End:0xC7
            if(myFuelContainer != none)
            {
                myFuelContainer.PuddleDamaged(self);
            }
            // End:0x159
            if(HitInfo.HitComponent == none)
            {
                HitLocation.Z = Location.Z;
                Delta = HitLocation - Location;
                // End:0x159
                if(VSize(Delta) > (CylinderComponent.CollisionRadius * 0.9000000))
                {
                    HitLocation = Location + ((Normal(Delta) * CylinderComponent.CollisionRadius) * 0.9000000);
                }
            }
            Ignite(HitLocation);
        }
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        SetTimer(1.0000000, false, 'FlammableTimer');
        //return;        
    }

    function Ignite(Vector Loc)
    {
        igniteLocation = Loc;
        bCanIgnite = false;
        GotoState('Burning');
        //return;        
    }
    stop;    
}

state Burning
{
    function BeginState(name PreviousStateName)
    {
        // End:0x94
        if(myFuelContainer != none)
        {
            // End:0x80
            if(myFuelContainer.BurningPuddleTemplate != none)
            {
                // End:0x3B
                if(VSize(igniteLocation) == 0.0000000)
                {
                    igniteLocation = Location;
                }
                BurningEmitter = __NFUN_278__(Class'MOHAExplodeEmitter',,, igniteLocation);
                // End:0x80
                if(BurningEmitter != none)
                {
                    BurningEmitter.SetTemplate(myFuelContainer.BurningPuddleTemplate, true);
                }
            }
            SetTimer(0.5000000, false, 'PropogateFlameTimer');
        }
        //return;        
    }

    function PropogateFlameTimer()
    {
        // End:0x24
        if(myFuelContainer != none)
        {
            myFuelContainer.PropogateFlame(self, igniteLocation);
        }
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: StaticMeshComponent'Default__MOHAFuelPuddle.StaticMeshComponent0'
    begin object name=StaticMeshComponent0 class=Class'Engine.StaticMeshComponent'
        bAllowApproximateOcclusion=true
        bForceDirectLightMap=true
        bCastDynamicShadow=false
    end object
    StaticMeshComponent=StaticMeshComponent0
    // Reference: CylinderComponent'Default__MOHAFuelPuddle.CollisionCylinder'
    begin object name=CollisionCylinder class=Class'Engine.CylinderComponent'
        CollisionHeight=5.0000000
        CollisionRadius=80.0000000
        CollideActors=true
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Components[1]=StaticMeshComponent0
    bTakesRadiusDamage=true
    bCollideActors=true
    bCollideWorld=true
    bProjTarget=true
    CollisionComponent=CollisionCylinder
    CollisionType=0
}