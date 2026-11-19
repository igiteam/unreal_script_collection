class SPStaticMeshComponent extends StaticMeshComponent
    native
    editinlinenew
    hidecategories(Collision,Rendering,Lighting);

/** This changes the FOV used for rendering the skeletal mesh component. A value of 0 means to use the default. */
var() private float FOV;
