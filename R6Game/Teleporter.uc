class Teleporter extends NavigationPoint
    native
    placeable
    hidecategories(lighting,lighting,LightColor,Force);

var() string URL;
var() name ProductRequired;
var() bool bChangesVelocity;
var() bool bChangesYaw;
var() bool bReversesX;
var() bool bReversesY;
var() bool bReversesZ;
var() bool bEnabled;
var() Vector TargetVelocity;
var float LastFired;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority))
        URL, bEnabled;

    // Pos:0x00D
    if(bNetInitial && int(Role) == int(ROLE_Authority))
        TargetVelocity, bChangesVelocity, 
        bChangesYaw, bReversesX, 
        bReversesY, bReversesZ;
}

function PostBeginPlay()
{
    // End:0x11
    if(URL ~= "")
    {
        SetCollision(false, false);
    }
    PostBeginPlay();
    return;
}

simulated function bool Accept(Actor Incoming, Actor Source)
{
    local Rotator newRot, oldRot;
    local float mag;
    local Vector oldDir;
    local PlayerController P;

    // End:0x0D
    if(Incoming == none)
    {
        return false;
    }
    Disable('Touch');
    newRot = Incoming.Rotation;
    // End:0xA0
    if(bChangesYaw)
    {
        oldRot = Incoming.Rotation;
        newRot.Yaw = Rotation.Yaw;
        // End:0xA0
        if(Source != none)
        {
            newRot.Yaw += ((32768 + Incoming.Rotation.Yaw) - Source.Rotation.Yaw);
        }
    }
    // End:0x23D
    if(Pawn(Incoming) != none)
    {
        // End:0x108
        if(int(Role) == int(ROLE_Authority))
        {
            // End:0x107
            foreach WorldInfo.AllControllers(Class'PlayerController', P)
            {
                // End:0x106
                if(P.Enemy == Incoming)
                {
                    P.LineOfSightTo(Incoming);
                }                
            }            
        }
        // End:0x126
        if(!Pawn(Incoming).SetLocation(Location))
        {
            return false;
        }
        // End:0x1C2
        if((int(Role) == int(ROLE_Authority)) || (WorldInfo.TimeSeconds - LastFired) > 0.5000000)
        {
            newRot.Roll = 0;
            Pawn(Incoming).SetRotation(newRot);
            Pawn(Incoming).SetViewRotation(newRot);
            Pawn(Incoming).ClientSetRotation(newRot);
            LastFired = WorldInfo.TimeSeconds;
        }
        // End:0x228
        if(Pawn(Incoming).Controller != none)
        {
            Pawn(Incoming).Controller.MoveTimer = -1.0000000;
            Pawn(Incoming).Anchor = self;
            Pawn(Incoming).SetMoveTarget(self);
        }
        Incoming.PlayTeleportEffect(false, true);        
    }
    else
    {
        // End:0x25D
        if(!Incoming.SetLocation(Location))
        {
            Enable('Touch');
            return false;
        }
        // End:0x278
        if(bChangesYaw)
        {
            Incoming.SetRotation(newRot);
        }
    }
    Enable('Touch');
    // End:0x29F
    if(bChangesVelocity)
    {
        Incoming.Velocity = TargetVelocity;        
    }
    else
    {
        // End:0x339
        if(bChangesYaw)
        {
            // End:0x2CD
            if(int(Incoming.Physics) == int(1))
            {
                oldRot.Pitch = 0;
            }
            oldDir = Vector(oldRot);
            mag = Incoming.Velocity Dot oldDir;
            Incoming.Velocity = (Incoming.Velocity - (mag * oldDir)) + (mag * Vector(Incoming.Rotation));
        }
        // End:0x35C
        if(bReversesX)
        {
            Incoming.Velocity.X *= -1.0000000;
        }
        // End:0x37F
        if(bReversesY)
        {
            Incoming.Velocity.Y *= -1.0000000;
        }
        // End:0x3A2
        if(bReversesZ)
        {
            Incoming.Velocity.Z *= -1.0000000;
        }
    }
    return true;
    return;
}

simulated function PostTouch(Actor other)
{
    local Teleporter D, Dest;
    local int I;

    // End:0x96
    if((InStr(URL, "/") >= 0) || InStr(URL, "#") >= 0)
    {
        // End:0x93
        if(((int(Role) == int(ROLE_Authority)) && Pawn(other) != none) && Pawn(other).IsHumanControlled())
        {
            WorldInfo.Game.SendPlayer(PlayerController(Pawn(other).Controller), URL);
        }        
    }
    else
    {
        // End:0xF5
        foreach AllActors(Class'Teleporter', D)
        {
            // End:0xF4
            if((string(D.Tag) ~= URL) && D != self)
            {
                Dest[I] = D;
                I++;
                // End:0xF4
                if(I > 16)
                {
                    // End:0xF5
                    break;
                }
            }            
        }        
        I = Rand(I);
        // End:0x155
        if(Dest[I] != none)
        {
            // End:0x139
            if(other.IsA('Pawn'))
            {
                other.PlayTeleportEffect(false, true);
            }
            Dest[I].Accept(other, self);
        }
    }
    return;
}

function Actor SpecialHandling(Pawn other)
{
    // End:0x9B
    if(((bEnabled && other.Controller.RouteCache.Length > 1) && Teleporter(other.Controller.RouteCache[1]) != none) && string(other.Controller.RouteCache[1].Tag) ~= URL)
    {
        // End:0x99
        if(TouchingActor(other))
        {
            PostTouch(other);
        }
        return self;
    }
    return none;
    return;
}

defaultproperties
{
    bChangesYaw=true
    bEnabled=true
    bPropagatesSound=false
    // Reference: CylinderComponent'Default__Teleporter.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: CylinderComponent'Default__NavigationPoint.CollisionCylinder'
    begin object name="CollisionCylinder"
        CollisionHeight=80.0000000
        CollisionRadius=40.0000000
        CollideActors=true
    end object
    CylinderComponent=CollisionCylinder
    bCollideActors=true
    // Reference: SpriteComponent'Default__Teleporter.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__NavigationPoint.Sprite'
    begin object name="Sprite"
        Sprite=Texture2D'EngineResources.S_Teleport'
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__Teleporter.PathRenderer'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: PathRenderingComponent'Default__NavigationPoint.PathRenderer'
    begin object name="PathRenderer"
    end object
    Components[2]=PathRenderer
    // Reference: ArrowComponent'Default__Teleporter.Arrow'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="Arrow" class=Class'ArrowComponent'
        ArrowColor=(R=150,G=200,B=255,A=255)
    end object
    Components[3]=Arrow
    RemoteRole=1
    CollisionComponent=CollisionCylinder
}