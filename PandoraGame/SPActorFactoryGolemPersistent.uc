class SPActorFactoryGolemPersistent extends ActorFactory
    abstract
    native
    config(Editor)
    editinlinenew
    collapsecategories;

/** INCLUDES MACROS STRUCT DECLARATIONS VARIABLE DECLARATIONS */
var() array<AnimSet> AnimSets;
var() const AnimTree AnimTreeTemplate;
var() bool bDisablePathBlocking;
var() bool bNoSkelUpdateWhenNotRendered;
