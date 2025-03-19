// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Semaphore} from "./Semaphore.sol";
import {ISemaphoreVerifier} from "./ISemaphoreVerifier.sol";
import {ISemaphore} from "./ISemaphore.sol";
import {SemaphoreGroups} from "./SemaphoreGroups.sol";
import {MIN_DEPTH, MAX_DEPTH} from "./Constants.sol";
import {ISecondLevelController} from "./ISecondLevelController.sol";
import "../../wrapper/Controllable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract ProviderMerkleTree is Ownable {
    ISecondLevelController public secondLevelController;
    ISemaphore public semaphore;
    uint scope = 12055883547725688507598382652213303367251128561332258200425165377290225199166;
    mapping(uint256 => bytes32) public groupIdToNode;

    constructor(address _secondLevelController, ISemaphore _semaphore) Ownable(msg.sender) {
        semaphore = _semaphore;
        secondLevelController = ISecondLevelController(_secondLevelController);
    }

    function createProduct(bytes32 node) public returns (uint256 groupId) {
        groupId = semaphore.createGroup(msg.sender);
        groupIdToNode[groupId] = node;
    }

    function setSecondLevelController(address _secondLevelController) public onlyOwner {
        secondLevelController = ISecondLevelController(_secondLevelController);
    }

    function setNodeAdminIn2LD(bytes32 node) public onlyOwner {
        secondLevelController.setNodeAdmin(node, address(this));
    }

    function registerSubnode(address owner, string memory label) internal {
        secondLevelController.registerSubnode(owner, label);
    }
    // add payable fee
    function insertCommitment(uint256 groupId, uint256 commitment) public {
        semaphore.addMember(groupId, commitment);
    }

    function registerProduct(uint256 groupId, ISemaphore.SemaphoreProof calldata proof, string memory label, address owner) public {
        require(proof.scope == scope, "Invalid scope");
        semaphore.validateProof(groupId, proof);
        registerSubnode(owner, label);
    }


}