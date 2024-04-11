// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2;

contract transferMoney{

    address public myContract = address(this);

    struct transfer{
        uint id;
        address sender;
        address recipient;
        uint sum;
        bool status;
        string codeWord;
    }

    transfer[] public Transfers;


    function sendMoney(address _recipient, string memory _codeword) public payable {
        require(msg.value > 0, "Not money");
        require(msg.sender.balance >= msg.value, "dont have money");
        require(msg.sender != _recipient, "Can't send to yourself");
        Transfers.push(transfer(Transfers.length, msg.sender, _recipient, msg.value, false, _codeword));
    }

    function getTotransfer(uint _id, string memory _codeword) public payable {
        require(Transfers.length > _id, "There is no such transfer");
        require(Transfers[_id].status == false, "Transfer is completed" );
        require(Transfers[_id].recipient == msg.sender, "Not the recipient");
        if(keccak256(abi.encode(Transfers[_id].codeWord)) == keccak256(abi.encode(_codeword))){
            payable(Transfers[_id].recipient).transfer(Transfers[_id].sum);
        }else{
           payable(Transfers[_id].sender).transfer(Transfers[_id].sum); 
        }
        Transfers[_id].status = true;
    }

    function cancelTransfer(uint _id) public payable {
        require(Transfers.length > _id, "There is no such transfer");
        require(Transfers[_id].status == false, "Transfer is completed" );
        require(Transfers[_id].sender == msg.sender, "Not the sender");
        payable(Transfers[_id].sender).transfer(Transfers[_id].sum);
        Transfers[_id].status = true;
    }

    function getTransfers() public view returns(transfer[] memory){
        return Transfers;
    }
}
