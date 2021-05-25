/* Developed By LolCat Team */
pragma solidity 0.8.1;

contract LolTransfer{
    uint256 RegisterFee=1e17;
    uint256 RenameFee=2e17;
    address payable _Owner;
    mapping(string=>address payable) public Relation;
    mapping(address =>string) public RelationReverse;
    mapping(string=>bool) public IsRegisterd;
    mapping(address=>bool) public IsUsed;
    event RegisterName(string indexed,address);
    event TransferTron(string indexed,address,address);
    event ChangeName(string indexed,string indexed,address);
    constructor(){
        _Owner=payable(msg.sender);
    }
    modifier onlyowner{
        require(msg.sender==_Owner,"unauthorized access denied");
        _;
    }
    function SetFee(uint256 _RegisterFee,uint256 _RenameFee)public onlyowner{
        RegisterFee=_RegisterFee;
        RenameFee=_RenameFee;
    }
    function Register(string memory Name,address payable Wallet) public payable returns(string memory){
        require(msg.value==RegisterFee&&IsRegisterd[Name]==false&&msg.sender==Wallet&&IsUsed[msg.sender]==false,"Just Set 0.1 bnb and UnRegisterd WalletName");
        Relation[Name]=Wallet;
        RelationReverse[Wallet]=Name;
        IsRegisterd[Name]=true;
        IsUsed[msg.sender]=true;
        emit RegisterName(Name,Wallet);
        return "Register Successfully";
    }
    function ShowName(address ReqAddress) public view returns(string memory){
        return RelationReverse[ReqAddress];
    }
    function ShowNameMsgSender() public view returns(string memory){
        return RelationReverse[msg.sender];
    }
    function TransferBnb(string memory WalletName) public payable returns(string memory){
        require(IsRegisterd[WalletName]==true&&Relation[WalletName]!=address(0),"Just Tron and Correct Wallet");
        Relation[WalletName].transfer(msg.value);
        emit TransferTron(RelationReverse[Relation[WalletName]],msg.sender,Relation[WalletName]);
        return "transfer Compeleted";
    }
    function ChangeWalletName(string memory Name,address payable Wallet) public payable returns(string memory){
         require(msg.value==RenameFee&&IsRegisterd[Name]==false&&IsUsed[msg.sender]==true&&msg.sender==Wallet,"transaction faild");
         string memory Pname=RelationReverse[msg.sender];
         IsRegisterd[RelationReverse[msg.sender]]=false;
         delete Relation[RelationReverse[msg.sender]];
         delete RelationReverse[msg.sender];
         Relation[Name]=Wallet;
         RelationReverse[Wallet]=Name;
         IsRegisterd[Name]=true;
         emit ChangeName(Pname,Name,Wallet);
         return "Name Changed Successfully";
    }
    function WithdrawFee(uint256 _amount) public onlyowner{
        _Owner.transfer(_amount);
        /*just for withdraw  fee users pay for registration and dont have any relation with transferbnb function*/
    }
}