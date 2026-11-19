class UTClientSideWeaponPawn extends UTWeaponPawn
    config(Game)
    hidecategories(Navigation);

simulated function PreBeginPlay()
{
    //return;    
}

simulated function AttachDriver(Pawn P)
{
    Driver = P;
    bDriving = true;
    super.AttachDriver(P);
    //return;    
}

simulated function DetachDriver(Pawn P)
{
    super(UDKVehicleBase).DetachDriver(P);
    Destroy();
    //return;    
}

simulated function Tick(float DeltaTime)
{
    super(Actor).Tick(DeltaTime);
    // End:0x6F
    if(((Driver == none) || Driver.bDeleteMe) || Driver.DrivenVehicle != self)
    {
        Destroy();
    }
    //return;    
}

defaultproperties
{
    // Reference: RB_StayUprightSetup'Default__UTClientSideWeaponPawn.MyStayUprightSetup'
    // Archetype: RB_StayUprightSetup'Default__UTWeaponPawn.MyStayUprightSetup'
    begin object name="MyStayUprightSetup"
    end object
    StayUprightConstraintSetup=MyStayUprightSetup
    // Reference: RB_ConstraintInstance'Default__UTClientSideWeaponPawn.MyStayUprightConstraintInstance'
    // Archetype: RB_ConstraintInstance'Default__UTWeaponPawn.MyStayUprightConstraintInstance'
    begin object name="MyStayUprightConstraintInstance"
    end object
    StayUprightConstraintInstance=MyStayUprightConstraintInstance
    // Reference: SkeletalMeshComponent'Default__UTClientSideWeaponPawn.SVehicleMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'SVehicleMesh'
    // Archetype: SkeletalMeshComponent'Default__UTWeaponPawn.SVehicleMesh'
    begin object name="SVehicleMesh"
        ReplacementPrimitive=none
    end object
    Mesh=SVehicleMesh
    // Reference: CylinderComponent'Default__UTClientSideWeaponPawn.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__UTWeaponPawn.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Components[1]=SVehicleMesh
    CollisionComponent=SVehicleMesh
}