// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "./BloodToken.sol";

contract BloodSupplyChain is AccessControl {
    BloodToken public bloodToken;

    constructor(address _bloodTokenAddress) {
        bloodToken = BloodToken(_bloodTokenAddress);
        _grantRole(ADMIN_ROLE, msg.sender);
    }

    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant TESTING_ROLE = keccak256("TESTING_ROLE");
    bytes32 public constant CAMP_ROLE = keccak256("CAMP_ROLE");
    bytes32 public constant HOSPITAL_ROLE = keccak256("HOSPITAL_ROLE");

    enum STAGE { BloodCamp, BloodTestingFac, Hospital, Donated }

    struct Entity {
        address addrss;
        uint256 id;
        string name;
        bytes32 role;
    }

    mapping(uint256 => Entity) public camps;
    mapping(uint256 => Entity) public tests;
    mapping(uint256 => Entity) public hospitals;

    uint256 public DonorCounter;
    uint256 public BloodBagCounter;
    uint256 public BloodCampCounter;
    uint256 public BloodTestingFacCounter;
    uint256 public HospitalCounter;

    struct Request {
        uint256 id;
        string name;
        string doctor;
        string hospital;
        string bloodType;
        string quantity;
        bool approved;
    }

    struct BloodBag {
        uint256 id;
        string bloodType;
        address donorAddress;
        string location;
        string donationNurse;
        string quantity;
        uint256 donationDate;
        uint256 expirationDate;
        uint256 BloodCampId;
        uint256 BloodTestingFacId;
        uint256 HospitalId;
        STAGE stage;
    }

    struct Donor {
        address _address;
        uint256 _id;
        string _name;
        string _surname;
        string _nationalId;
        string _phoneNumber;
        string _dateOfBirth;
    }

    Request[] private requestList;
    mapping(uint256 => Request) public requests;

    BloodBag[] private bloodBagList;
    mapping(uint256 => BloodBag) public BloodBatch;

    Donor[] private donorList;
    mapping(uint256 => Donor) public donors;

    modifier onlyAdmin() {
        require(hasRole(ADMIN_ROLE, msg.sender), "Not authorized");
        _;
    }

    modifier onlyCamp() {
        require(hasRole(CAMP_ROLE, msg.sender), "Not authorized");
        _;
    }

    modifier onlyTestingFacility() {
        require(hasRole(TESTING_ROLE, msg.sender) || hasRole(ADMIN_ROLE,msg.sender), "Not authorized");
        _;
    }

    modifier onlyHospital() {
        require(hasRole(HOSPITAL_ROLE, msg.sender), "Not authorized");
        _;
    }

    function registerEntity(
        string memory _roleString,
        address _address,
        string memory _name
    ) public onlyAdmin {
        bytes32 _role = keccak256(abi.encodePacked(_roleString));
        require(_role == CAMP_ROLE || _role == HOSPITAL_ROLE || _role == TESTING_ROLE, "Invalid role");

        uint256 entityId;
        if (_role == CAMP_ROLE) {
            BloodCampCounter++;
            entityId = BloodCampCounter;
        } else if (_role == HOSPITAL_ROLE) {
            HospitalCounter++;
            entityId = HospitalCounter;
            _grantRole(HOSPITAL_ROLE, _address);
        } else if (_role == TESTING_ROLE) {
            BloodTestingFacCounter++;
            entityId = BloodTestingFacCounter;
        }

        Entity memory newEntity = Entity(_address, entityId, _name, _role);

        if (_role == CAMP_ROLE) {
            camps[entityId] = newEntity;
            _grantRole(CAMP_ROLE, _address);
        } else if (_role == HOSPITAL_ROLE) {
            hospitals[entityId] = newEntity;
        } else if (_role == TESTING_ROLE) {
            tests[entityId] = newEntity;
        }
    }

    function viewEntities() public onlyAdmin view returns (Entity[] memory) {
        uint256 totalEntities = BloodCampCounter + HospitalCounter + BloodTestingFacCounter;
        Entity[] memory entities = new Entity[](totalEntities);
        uint256 index = 0;

        for (uint256 i = 1; i <= BloodCampCounter; i++) {
            entities[index] = camps[i];
            index++;
        }

        for (uint256 i = 1; i <= HospitalCounter; i++) {
            entities[index] = hospitals[i];
            index++;
        }

        for (uint256 i = 1; i <= BloodTestingFacCounter; i++) {
            entities[index] = tests[i];
            index++;
        }

        return entities;
    }

    function addRequest(
        string memory _name,
        string memory _doctor,
        string memory _hospital,
        string memory _bloodType,
        string memory _quantity
    ) public onlyHospital {
        uint requestId = requestList.length;
        requestList.push(Request(requestId, _name, _doctor, _hospital, _bloodType, _quantity, false));
    }

        function getRequests() public onlyAdmin view returns (Request[] memory) {
        return requestList;
    }

    function approveRequest(uint256 _requestId) public onlyAdmin {
        require(_requestId < requestList.length, "Not Found");
        requestList[_requestId].approved = true;
    }

    function addDonor(
        address _address,
        string memory _name,
        string memory _surname,
        string memory _nationalId,
        string memory _phoneNumber,
        string memory _dateOfBirth
    ) public payable {
        for (uint i = 0; i < donorList.length; i++) {
            require(donorList[i]._address != _address, "Donor with entered  address already exists.");
        }
        DonorCounter++;
        donorList.push(Donor(_address, DonorCounter, _name, _surname, _nationalId, _phoneNumber, _dateOfBirth));
        donors[DonorCounter] = Donor(_address, DonorCounter, _name, _surname, _nationalId, _phoneNumber, _dateOfBirth);
    }

    function viewDonors() public view returns (Donor[] memory) {
        return donorList;
    }

    function CampToTestingSupply(uint256 _bloodbagId) public onlyCamp() {
        require(_bloodbagId > 0 && _bloodbagId <= BloodBagCounter);
        uint256 _id = findbloodTestingFac(msg.sender);
        require(_id >= 0);
        require(BloodBatch[_bloodbagId].stage == STAGE.BloodCamp);
        BloodBatch[_bloodbagId].BloodTestingFacId = _id;
        BloodBatch[_bloodbagId].stage = STAGE.BloodTestingFac;
    }

    function TestingToHospitalSupply(uint256 _bloodbagId) public onlyTestingFacility() {
        require(_bloodbagId > 0 && _bloodbagId <= BloodBagCounter);
        uint256 _id = findHospital(msg.sender);
        require(_id >= 0 );
        require(BloodBatch[_bloodbagId].stage == STAGE.BloodTestingFac,"error 3");
        BloodBatch[_bloodbagId].HospitalId = _id;
        BloodBatch[_bloodbagId].stage = STAGE.Hospital;
    }

    function HospitalToPatientSupply(uint256 _bloodbagId) public onlyHospital() {
        require(_bloodbagId > 0 && _bloodbagId <= BloodBagCounter, "error1");
        uint256 _id = findHospital(msg.sender);
        require(_id >= 0 ,"error2");
        // require(_id == BloodBatch[_bloodbagId].HospitalId);
        require(BloodBatch[_bloodbagId].stage == STAGE.Hospital,"error 3");
        BloodBatch[_bloodbagId].stage = STAGE.Donated;
    }

    function addBloodBag(
        string memory _bloodType, address _donorAddress,  string memory _location,string memory _donationNurse,
        string memory _quantity, uint256 _donationDate, uint256 _expirationDate
    ) public onlyCamp(){
        require((BloodCampCounter > 0) && (BloodTestingFacCounter > 0) && (HospitalCounter > 0),
         "Register a bloodCamp, BloodTestingFacility, and Hospital");
        uint256 bloodCampId = findBloodCamp(msg.sender);
        require(bloodCampId > 0, "msg.sender is not associated with any BloodCamp");
        BloodBagCounter++;
        bloodToken.sendToken(_donorAddress, 1);
        bloodBagList.push(BloodBag( BloodBagCounter, _bloodType,
            _donorAddress,
            _location,
            _donationNurse,
            _quantity,
            _donationDate,
            _expirationDate,
            bloodCampId,
            0,
            0,
            STAGE.BloodCamp
        ));
        BloodBatch[BloodBagCounter] = BloodBag(
            BloodBagCounter,
            _bloodType,
            _donorAddress,
            _location,
            _donationNurse,
            _quantity,
            _donationDate,
            _expirationDate,
            bloodCampId,
            0,
            0,
            STAGE.BloodCamp
        );
    }

    function viewByAddress() public view returns (BloodBag[] memory) {
        require(BloodBagCounter > 0, "No blood bags available");

        BloodBag[] memory donatedBags = new BloodBag[](BloodBagCounter);
        uint256 count = 0;

        for (uint256 i = 1; i <= BloodBagCounter; i++) {
            if (BloodBatch[i].donorAddress == msg.sender) {
                donatedBags[count] = BloodBatch[i];
                count++;
            }
        }

        assembly {
            mstore(donatedBags, count)
        }

        return donatedBags;
    }

    function viewAllBloodBags() public onlyAdmin view returns (BloodBag[] memory) {
        return bloodBagList;
    }

    function getBloodBagDetails(uint256 _bloodBagId) public view returns (
        uint256 bloodBagId,
        string memory bloodType,
        address donorAddress,
        string memory location,
        string memory donationNurse,
        string memory quantity,
        uint256 donationDate,
        uint256 expirationDate,
        uint256 campId,
        uint256 testId,
        uint256 hospitalId,
        STAGE stage
    ) {
        require(_bloodBagId <= BloodBagCounter, "Blood bag with given ID does not exist");
        BloodBag memory bag = bloodBagList[_bloodBagId];
        return (
            bag.id,
            bag.bloodType,
            bag.donorAddress,
            bag.location,
            bag.donationNurse,
            bag.quantity,
            bag.donationDate,
            bag.expirationDate,
            bag.BloodCampId,
            bag.BloodTestingFacId,
            bag.HospitalId,
            bag.stage
        );
    }

    function viewTokens(address donorAddress) public view returns (uint256) {
        uint256 donorTokens = bloodToken.balanceOf(donorAddress);
        return donorTokens;
        }

    function viewBloodBagsInCamp() public view returns (BloodBag[] memory) {
        return filterBloodBags(STAGE.BloodCamp);
    }

    function viewBloodBagsInTestingFac() public view returns (BloodBag[] memory) {
        return filterBloodBags(STAGE.BloodTestingFac);
    }

    function viewBloodBagsInHospital() public view returns (BloodBag[] memory) {
        return filterBloodBags(STAGE.Hospital);
    }

    function viewBloodBagsDonated() public view returns (BloodBag[] memory) {
        return filterBloodBags(STAGE.Donated);
    }

    function filterBloodBags(STAGE _stage) internal view returns (BloodBag[] memory) {
        require(BloodBagCounter > 0, "No blood bags available");

        BloodBag[] memory filteredBags = new BloodBag[](BloodBagCounter);
        uint256 count = 0;

        for (uint256 i = 1; i <= BloodBagCounter; i++) {
            if (BloodBatch[i].stage == _stage) {
                filteredBags[count] = BloodBatch[i];
                count++;
            }
        }

        assembly {
            mstore(filteredBags, count)
        }

        return filteredBags;
    }

    function findBloodCamp(address _address) private view returns (uint256) {
        require(BloodCampCounter > 0, "No Blood Camps available");

        for (uint i = 1; i <= BloodCampCounter; i++) {
            if (camps[i].addrss == _address) {
                return camps[i].id; 
            }
        }

        return 0;
    }

    function findbloodTestingFac(address _address) private view returns (uint256) {
        require(BloodTestingFacCounter > 0, "No Blood Testing Facilities available");

        for (uint i = 1; i <= BloodTestingFacCounter; i++) {
            if (tests[i].addrss == _address) {
                return tests[i].id; 
            }
        }

        return 0;
    }

    function findHospital(address _address) private view returns (uint256) {
        require(HospitalCounter > 0, "No Hospitals available");

        for (uint i = 1; i <= HospitalCounter; i++) {
            if (hospitals[i].addrss == _address) {
                return hospitals[i].id; 
            }
        }

        return 0;
    }


}
