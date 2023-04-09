pragma solidity >=0.8.0;

contract EHR {

address public Admin;

//constrcutor to assign address to Admin

constructor ()
{
 Admin=msg.sender;
}

//Modifier Definition both for Admin and Patient

modifier OnlyAdmin()
{
    require(msg.sender==Admin, "You don't have access to this function");
    _;
}

modifier OnlyRegPatient{

require (Patient[msg.sender].isRegistered,"Patient not found..! You have to register to add a disease");
_;

}


// Define struct for Doctor as Doc
struct Doc {
    string Doc_Name;
    string Doc_Qual;
    string Work_Address;
    address Doc_Address;
    bool isRegistered;
}

// Define struct for Patient as Pat
struct Pat {

   string Pat_Name;
   uint8 Pat_Age;
   address Pat_Address;
   string[] Pat_Disease;
   bool   isRegistered;
   uint[] Pat_PrescribedMed;
}

// Define struct for Medicine as Med

struct Med {
    uint Med_Id;
    string Med_Name;
    string Med_ExpiryDate;
    string Med_Dose;
    string Med_Price;
    bool isRegistered;

}

// Define the mapping
 mapping ( address => Doc) Doctor;
 mapping ( address => Pat) Patient;
 mapping ( uint => Med) Medicine;

// Funtion to Register Patient

function RegisterPatient(string memory _PatName,uint8 _PAge) public {
require (!Patient[msg.sender].isRegistered,"You are alreadey Registered (Patient)");
Patient[msg.sender].Pat_Name=_PatName;
Patient[msg.sender].Pat_Age=_PAge;
Patient[msg.sender].Pat_Address=msg.sender;
Patient[msg.sender].isRegistered=true;
}

//function to Add Medicine

function AddMedicine(uint _Id,string memory _MedName,string memory _Exp,string memory _Dos,string memory _P) public {
    require (!Medicine[_Id].isRegistered,"This Medicine Already Registred");

    Medicine[_Id]=Med(_Id,_MedName,_Exp,_Dos,_P,true);
    
}

//Function to Add Diesese
function AddNewDiseasebyPatient(string memory _PatientDisease) public OnlyRegPatient {

// require (Patient[msg.sender].isRegistered,"Patient Not found, Need to Register Patient");
    Patient[msg.sender].Pat_Disease.push(_PatientDisease);
} 


// Function to Register Doctor

function RegisterDoctor(string memory _DocName,string memory _DocQual, string memory _WAddress, address _DocAddress) public OnlyAdmin { 
    require (!Doctor[_DocAddress].isRegistered,"You are alreadey Registered (Doctor)");
    Doctor[_DocAddress]=Doc(_DocName,_DocQual,_WAddress,_DocAddress,true) ;
    
    }
// Function to Prescribe Medicine

function PrescribeMedicine(uint _MedId, address _PatAddress) public {
    Patient[_PatAddress].Pat_PrescribedMed.push(_MedId);
}

// Function to Update Age

function UpdateAge(uint8 _NewAge) public OnlyRegPatient {

    Patient[msg.sender].Pat_Age=_NewAge;
}

// Function to view Patient Record
function ViewPatientRecord() public OnlyRegPatient view returns (uint age, string memory name,string[] memory disease ,address patientAddress){

    age=Patient[msg.sender].Pat_Age;
    name=Patient[msg.sender].Pat_Name;
    disease= Patient[msg.sender].Pat_Disease;
    patientAddress=Patient[msg.sender].Pat_Address;

}

// Function to view Prescribed Medicine
function ViewPrescribedMedicines(address Paddress) public view returns (uint[]memory) {

return (Patient[Paddress].Pat_PrescribedMed);
}

// Function to view Medicine
function viewMedicine(uint MedId) public view returns (string memory, string memory, string memory, string memory) {
    return (Medicine[MedId].Med_Name, Medicine[MedId].Med_ExpiryDate, Medicine[MedId].Med_Dose, Medicine[MedId].Med_Price);
}

// Function to view Patient By Address
function ViewPatientByAddress(address EthAddress) public view returns (string memory, uint8 , string[]memory, uint[]memory){
    return(Patient[EthAddress].Pat_Name, Patient[EthAddress].Pat_Age, Patient[EthAddress].Pat_Disease, Patient[EthAddress].Pat_PrescribedMed);
}

// Function to view Doctor
function ViewDoctor(address GiveMeEthAddress) public view returns (string memory, string memory,string memory){
    return(Doctor[GiveMeEthAddress].Doc_Name, Doctor[GiveMeEthAddress].Doc_Qual, Doctor[GiveMeEthAddress].Work_Address);
}

}