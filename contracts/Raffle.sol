// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/interfaces/KeeperCompatibleInterface.sol";

error Raffle__NotEnoughETHEntered();
error Raffle__TransferFailed();
error Raffle__NotOpen();
error Raffle__UpKeepNotNeeded(uint256 currentBalance, uint256 numPlayers, uint256 raffleState);

/**
 * @title A sample of a Raffle Contract
 * @author Eugenio Flores
 * @notice This contract is for creating an untamperable decentralized smart contract lottery
 * @dev This contract implements Chainlink VRF v2 and Chainlink Keepers
 */

/**
 * THIS IS AN EXAMPLE CONTRACT THAT USES UN-AUDITED CODE.
 * DO NOT USE THIS CODE IN PRODUCTION.
 */

contract Raffle is VRFConsumerBaseV2, KeeperCompatibleInterface {
    /*Type declarations */
    enum RaffleState {
        OPEN, //tested
        CALCULATING
    } // creating an enum like this is secretly equivalent to
    // uint256 0 = OPEN, 1 = CALCULATING

    /*State Variables */
    // since the entrance Fee will be established one time, this variable can be immutable to save gas.
    uint256 private immutable i_entranceFee;
    // s_player is going to be in storage because the size of this array is variable.
    address payable[] private s_players;
    VRFCoordinatorV2Interface private immutable i_vrfCoordinator;
    bytes32 private immutable i_gasLane;
    uint64 private immutable i_subscriptionId;
    uint32 private immutable i_callbackGasLimit;
    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint32 private constant NUM_WORDS = 1;

    //Lottery Variables
    address private s_recentWinner;
    RaffleState private s_raffleState;
    uint256 private s_lastTimeStamp;
    uint256 private immutable i_interval;

    /*Events */
    event RaffleEnter(address indexed player);
    event RequestedRaffleWinner(uint256 indexed requestId);
    event winnerPicked(address indexed winner);

    // vrfCoordinatorV2 is the adreess of the vrfCoordinator that makes the random number verification.

    /*Functions */
    constructor(
        address vrfCoordinatorV2,
        uint256 entranceFee,
        bytes32 gasLane, //keyHash
        uint64 subscriptionId,
        uint32 callbackGasLimit,
        uint256 interval
    ) VRFConsumerBaseV2(vrfCoordinatorV2) {
        i_entranceFee = entranceFee;
        i_vrfCoordinator = VRFCoordinatorV2Interface(vrfCoordinatorV2);
        i_gasLane = gasLane;
        i_subscriptionId = subscriptionId;
        i_callbackGasLimit = callbackGasLimit;
        s_raffleState = RaffleState.OPEN;
        s_lastTimeStamp = block.timestamp;
        i_interval = interval;
    }

    function enterRaffle() public payable {
        if (msg.value < i_entranceFee) {
            revert Raffle__NotEnoughETHEntered();
        }
        if (s_raffleState != RaffleState.OPEN) {
            revert Raffle__NotOpen();
        }
        s_players.push(payable(msg.sender));
        // Emit an event when we update a dynamic array or mapping
        // Name events with the function name reversed
        emit RaffleEnter(msg.sender);
    }

    /**
     * @dev checkUpkeep is the function that the Chainlink Keepers nodes will call to know if performUpKeep()
     * should be call by them. They look for the `upKeepNeeded` to return true.
     * The following need should be true in order for `upKeepNeeded` to return true:
     * 1. Our time interval should have passed
     * 2. The lottery should have al least 1 player and have some ETH
     * 3. Our subscription is funded with LINK
     * 4. The lottery should be in an "open" state
     */

    function checkUpkeep(
        // checkData allows to specify anything when the checkUpKeep is called. Having checkData of type
        // bytes allows to specify it to call other functions.
        // checkData can be commented out but I still need to specify the parameter it is.
        bytes memory /*checkData*/
    )
        public
        view
        override
        returns (
            // even though checkUpKeep is identified as external, it was change to public so I can call it with my contract
            bool upkeepNeeded,
            bytes memory /*performData */
        )
    {
        bool isOpen = (RaffleState.OPEN == s_raffleState);
        bool timePassed = ((block.timestamp - s_lastTimeStamp) > i_interval);
        bool hasPlayers = (s_players.length > 0);
        bool hasBalance = address(this).balance > 0;
        upkeepNeeded = (isOpen && timePassed && hasPlayers && hasBalance);
        return (upkeepNeeded, "0x0");
    }

    /**
     * @dev performUpkeep() is the function the Chainlink nodes will call to kick off an Chainlink VRF request.
     * This function can only be call if upkeepNeeded is true and this function will emit an event requesting for randomness.
     * requestId is the randomness order to be fulfilled by the Chainlink VFR service.
     */

    // equivalent to requestRandomWords() and was renamed to performUpKeep()
    function performUpkeep(
        bytes calldata /*performData */
    ) external override {
        // Since I'm passing an empty string to checkUpKeep("") and this function requires a calldata and calldata doesn't work with strings,
        // I need to specify performData as memory in checkUpkeep.
        (bool upkeepNeeded, ) = checkUpkeep("");
        if (!upkeepNeeded) {
            revert Raffle__UpKeepNotNeeded(
                address(this).balance,
                s_players.length,
                uint256(s_raffleState)
            );
        }
        s_raffleState = RaffleState.CALCULATING;
        uint256 requestId = i_vrfCoordinator.requestRandomWords(
            i_gasLane, //keyHash
            i_subscriptionId,
            REQUEST_CONFIRMATIONS,
            i_callbackGasLimit,
            NUM_WORDS
        );
        emit RequestedRaffleWinner(requestId);
    }

    /**
     * @dev After the Chainlink nodes fulfilled the randomness order by generating the random words in an off-chain calculation,
     * they will call fulfillRandomWords() in this contract and pass to it the requestId and the randomWords array as parameters.
     * An event will be triggered after the on-chain calculation of selecting a winner and sending the prize (balance) to the winner
     * of the lottery.
     */

    /* think of this function as fullfiled random numbers*/
    function fulfillRandomWords(
        uint256, /* requestId not use in this contract*/
        uint256[] memory randomWords
    ) internal override {
        //Once we got the random number we want to pick a random winner from the array of players using the Modulo function
        uint256 indexOfWinner = randomWords[0] % s_players.length;
        address payable recentWinner = s_players[indexOfWinner];
        s_recentWinner = recentWinner;
        s_raffleState = RaffleState.OPEN;
        s_players = new address payable[](0);
        s_lastTimeStamp = block.timestamp;
        (bool success, ) = recentWinner.call{value: address(this).balance}("");
        if (!success) {
            revert Raffle__TransferFailed();
        }
        emit winnerPicked(recentWinner);
    }

    /*View and pure functions */
    function getEntranceFee() public view returns (uint256) {
        return i_entranceFee;
    }

    function getPlayer(uint256 index) public view returns (address) {
        return s_players[index];
    }

    function getRecentWinner() public view returns (address) {
        return s_recentWinner;
    }

    function getRaffleState() public view returns (RaffleState) {
        return s_raffleState;
    }

    // since NUM_WORDS is in the byte codes and is not strictly reading from storage, therefore, it can be a pure function
    function getNumWords() public pure returns (uint256) {
        return NUM_WORDS;
    }

    function getNumberOfPlayers() public view returns (uint256) {
        return s_players.length;
    }

    function getLatestTimeStamp() public view returns (uint256) {
        return s_lastTimeStamp;
    }

    function getRequestConfirmations() public pure returns (uint256) {
        return REQUEST_CONFIRMATIONS;
    }

    function getInterval() public view returns (uint256) {
        return i_interval;
    }

    function getGasLane() public view returns (bytes32) {
        return i_gasLane;
    }

    function getCallbackGasLimit() public view returns (uint32) {
        return i_callbackGasLimit;
    }
}
