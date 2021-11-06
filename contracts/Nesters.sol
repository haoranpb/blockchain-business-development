// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Nesters {
    // For simplicity, we use the contract owner (the platform) as the "Government" for now
    address public contractOwner;
    uint256[] activeHouses = new uint256[](15);
    mapping(uint256 => House) public houses;
    mapping(address => User) users;
    mapping(uint256 => Transaction) public histories;
    uint256 historySize;

    modifier onlyGov() {
        require(
            msg.sender == contractOwner,
            'Only the Government can mint (verify) houses'
        );
        _;
    }

    constructor() {
        contractOwner = msg.sender;
        historySize = 0;
    }

    struct Transaction {
        uint256 ID;
        uint256 houseID;
        address tenant;
        uint256 price;
        uint256 colateral;
        uint256 startDate;
        uint256 rentingPeriod;
        bool voted;
        int256 tenantColateral;
        int256 landlordColateral;
        int256 votedColateral;
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
        // some other fields may need to be verified when minted
        bool active; // fileds below need to be instantiated before active
        uint256 price;
        uint256 colateral;
        bool offer;
        address tenant;
        uint256 startDate; // set by the tenant
        uint256 rentingPeriod; // timestamp per second
        uint256[] history;
    }

    function registerUser(address _addr, string memory _name) public {
        require(len(_name) > 0, 'Name cannot be empty');
        require(len(users[_addr].name) == 0, 'User already exists');

        User memory user = User(_name, new uint256[](15), 0, 0);
        users[_addr] = user;
    }

    function mintHouse(
        address _owner,
        string memory _physicalAddr,
        uint256 _id
    ) public onlyGov {
        require(houses[_id].ID == 0, 'House already exists');
        require(len(users[_owner].name) > 0, 'User does not exist');

        uint256[] memory _history;
        House memory house = House(
            _id,
            _owner,
            _physicalAddr,
            false,
            0,
            0,
            false,
            address(0),
            0,
            0,
            _history
        );
        houses[_id] = house;
        users[_owner].properties.push(_id);
    }

    function getUser(address _addr) public view returns (User memory) {
        return users[_addr];
    }

    function getActiveHouses(uint256 _now) public returns (uint256[] memory) {
        // Do the Lazy Evaluation here, since only houses that are once active can be returned
        // Also remove those houses that are not active anymore, set to 0
        for (uint256 i = 0; i < activeHouses.length; i++) {
            if (activeHouses[i] > 0 && !houses[activeHouses[i]].active) {
                checkHouse(activeHouses[i], _now);
                activeHouses[i] = 0;
            }
        }
        return activeHouses;
    }

    function getToVoted() public view returns (Transaction[] memory) {
        Transaction[] memory toBeVoted = new Transaction[](historySize);
        uint256 j = 0;

        for (uint256 i = 0; i < historySize; i++) {
            if (!histories[i].voted) {
                toBeVoted[j] = histories[i];
                j++;
            }
        }
        return toBeVoted;
    }

    /**
     * _role: 0 for tenant, 1 for landlord
     */
    function setColateral(
        uint256 _tranID,
        int256 _price,
        int256 _role
    ) public {
        if (_role == 0) {
            histories[_tranID].tenantColateral = _price;
        } else if (_role == 1) {
            histories[_tranID].landlordColateral = _price;
        } else {
            require(false, 'Only tenant and landlord can set colateral');
        }

        // the tenant and the landlord agreed on the same colateral
        if (
            histories[_tranID].tenantColateral >= 0 &&
            histories[_tranID].landlordColateral >= 0 &&
            histories[_tranID].tenantColateral ==
            histories[_tranID].landlordColateral
        ) {
            histories[_tranID].voted = true;
            users[histories[_tranID].tenant].reputationToken += 1;
            users[houses[histories[_tranID].houseID].owner]
                .reputationToken += 1;

            if (users[histories[_tranID].tenant].votingToken == 0) {
                users[histories[_tranID].tenant].votingToken = 1;
            }

            if (
                users[houses[histories[_tranID].houseID].owner].votingToken == 0
            ) {
                users[houses[histories[_tranID].houseID].owner].votingToken = 1;
            }
        }
    }

    /**
    Check if the house renting period has expired, set the values correspondingly
     */
    function checkHouse(uint256 _id, uint256 _now) private {
        if (!houses[_id].offer) {
            if (_now - houses[_id].startDate > houses[_id].rentingPeriod) {
                // renting period has expired, remove the property from the tenant list
                for (
                    uint256 i = 0;
                    i < users[houses[_id].tenant].properties.length;
                    i++
                ) {
                    if (users[houses[_id].tenant].properties[i] == _id) {
                        users[houses[_id].tenant].properties[i] = 0;
                    }
                }

                Transaction memory t = Transaction(
                    historySize,
                    _id,
                    houses[_id].tenant,
                    houses[_id].price,
                    houses[_id].colateral,
                    houses[_id].startDate,
                    houses[_id].rentingPeriod,
                    false,
                    -1,
                    -1,
                    -1
                );

                houses[_id].history.push(historySize);
                histories[historySize] = t;
                historySize++;

                houses[_id].tenant = address(0);
                houses[_id].price = 0;
                houses[_id].colateral = 0;
                houses[_id].startDate = 0;
                houses[_id].rentingPeriod = 0;
            }
        }
    }

    /**
    Landlords set the renting price, the house is now active
    Actived house can be seen on website
     */
    function activeHouse(
        uint256 _id,
        uint256 _price,
        uint256 _colateral
    ) public {
        require(
            houses[_id].owner == msg.sender,
            'Only the landlord can activate the house'
        );

        houses[_id].price = _price;
        houses[_id].colateral = _colateral;
        houses[_id].active = true;
        activeHouses.push(_id);
    }

    function makeOffer(
        uint256 _id,
        uint256 _startDate,
        uint256 _rentingPeriod
    ) public {
        houses[_id].tenant = msg.sender;
        houses[_id].startDate = _startDate;
        houses[_id].rentingPeriod = _rentingPeriod;
        houses[_id].offer = true;
    }

    function acceptOffer(uint256 _id) public {
        require(
            houses[_id].owner == msg.sender,
            'Only the landlord can accept the offer'
        );

        // put houses also into tennant's list
        users[houses[_id].tenant].properties.push(_id);

        houses[_id].active = false;
        houses[_id].offer = false;
    }

    /**
     * Helper Function: Returns the length of a string
     * Need to use "bytes" cuz https://ethereum.stackexchange.com/a/46254
     */
    function len(string memory _str) private pure returns (uint256) {
        return bytes(_str).length;
    }
}
