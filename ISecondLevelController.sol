// SPDX-License-Identifier: MIT
pragma solidity ~0.8.17;

interface ISecondLevelController {
    function registerSubnode(address owner, string memory label) external;
    function setNodeAdmin(bytes32 node, address admin) external;
} 