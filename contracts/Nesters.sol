// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Nesters {
    // For simplicity, we use the contract owner (the platform) as the "Government" for now
    address public contractOwner;
    mapping(uint256 => House) public houses; // Mapping from id => House
    mapping(address => User) users;

    modifier onlyGov() {
        require(
            msg.sender == contractOwner,
            "Only the Government can mint houses"
        );
        _;
    }

    constructor(address _contractOwner) {
        contractOwner = _contractOwner;
    }

    struct User {
        string name;
        uint256[] properties; // only for faster data access, ownership is defined by the House
        int256 reputationToken;
        uint256 votingToken;
    }

    struct House {
        uint256 ID;
        address owner;
        string physicalAddr;
        // some other fields need to be verified when minted
        bool active; // fileds below need to be instantiated before active
        uint256 price;
        uint256 rentingPeriod; // timestamp per second
    }

    function registerUser(address _addr, string memory _name) public {
        require(len(_name) > 0, "Name cannot be empty");
        require(len(users[_addr].name) == 0, "User already exists");

        uint256[] memory _properties;
        User memory user = User(_name, _properties, 0, 0);
        users[_addr] = user;
    }

    function mintHouse(
        address _owner,
        string memory _physicalAddr,
        uint256 _id
    ) public onlyGov {
        require(houses[_id].ID == 0, "House already exists");
        require(len(users[_owner].name) > 0, "User does not exist");

        House memory house = House(_id, _owner, _physicalAddr, false, 0, 0);
        houses[_id] = house;
        users[_owner].properties.push(_id);
    }

    /**
     * Returns the length of a string
     * Need to use "bytes" cuz https://ethereum.stackexchange.com/a/46254
     */
    function len(string memory _str) private pure returns (uint256) {
        return bytes(_str).length;
    }
}
