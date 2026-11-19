class PKCharacterStore extends Object
    native;

struct native PKFamilyInfoToPackageName
{
    var string FamilyInfoPath;
    var string PackageName;

    structdefaultproperties
    {
        FamilyInfoPath=""
        PackageName=""
    }
};

var array< class<PKFamilyInfoBase> > LoadedClasses;
var array<string> PendingClasses;
var array<PKFamilyInfoToPackageName> FamilyInfosToPackages;
//var delegate<LoadComplete> __LoadComplete__Delegate;

// Export UPKCharacterStore::execLoadFamilyInfoClass(FFrame&, void* const)
native final function LoadFamilyInfoClass(string ClassPath);

delegate LoadComplete(class<PKFamilyInfoBase> LoadedClass)
{
    //return;    
}
