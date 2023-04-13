// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";


//another contract for beter auditing :)
contract allowanceSection is Ownable{
    mapping(address => uint) public allowance; //this mapping will enable the owner to set and enables specific people to be able to withdraw from the contract a specifc allowed amount
uint internal amountAllowed; //This will store the value of 
    //function to extend withdrawal function to some people specified in the mapping above.
       function addAllowance( address _allowedPerson, uint _amountAllowed) public onlyOwner{
        allowance[_allowedPerson] = _amountAllowed;
        amountAllowed = _amountAllowed;

    }

    modifier isallowed(){
        require(allowance[msg.sender] != 0, "You are not in the allowance list please");
        _;
    }

    //This function below will the allowed amount given by the admin or owner by the amount the allowed person withdraws every time to make sure they don't withdraw mnore than they have.
    function reduceAllowance(address _address, uint _amount) internal{
        allowance[_address] -=_amount; //This  does the reduction :)
    }

    function allowedWithdraw(address payable _to, uint _amount) payable public isallowed{
        require(_amount <= allowance[_to], "Sorry, Not even funds to be withdrawn by you:)");// to make sure the amount being withdrawn is less than or equal to the amount allowed to be withdrawn.
        reduceAllowance(_to, _amount);//This implements the reduction
        _to.transfer(_amount);
    }
    //Next, i need enable the added people/address to be able to withdraw what the owner has allowed them to  withdraw. 
    //I couild wirte a separate function for the allowed individuals only.... say 'onlyAllowed' function tha
    //with  require (allowance[msg.sender] == true)  before it executes! but that is boring to me so I will go with an advanced-ish good-looking method as shown above. Hope you like it :)
    //custom modifier

}

contract simpleWallet is allowanceSection{ //The beauty of inheritance.!
    address public ownerAddress;
    uint public amountDeposited;


    constructor(){
        ownerAddress = msg.sender;
    }

    // modifier onlyOwner() {
    //     require(msg.sender == ownerAddress, "You are not allowed to withdraw because your are not the owner of this contract");
    //     _;
    // }
    //withdraw function


    // modifier ownerOrAllowed(uint _amount){
    //     require(isOwner() || allowance[msg.sender] >_amount, "You are not in the allowance list please :)");
    //     _;
    // }
    function withDrawFunds(address payable _to, uint256 _amount) onlyOwner public payable{
        //Require only owner to be able to withdraw the funds.
        _to.transfer(_amount);
    }
    function depositFunds() public payable {
        require(msg.value > 0, "Amount is less than zero Wei");
        amountDeposited = msg.value;

    }
    //get contract balance function
    function contractBal() public view returns(uint){
        return address(this).balance;
    }

    
}
