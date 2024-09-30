pragma solidity ^0.8.2;

import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol';
 contract erc is ERC20("tcoin","TC"){
    address company_owner;
    constructor(){
        company_owner=msg.sender;
    }

    modifier onlycompanyowner{
        require(msg.sender==company_owner);
        _;
    }
    function mintpub(uint x, address a) public onlycompanyowner {
        _mint(a,x);
    }
    function  approve(address spender, uint256 value) public override returns (bool) {
        _approve(company_owner, spender, value);
        return true;}
   function transferFrom(address spender,address from, address to, uint256 value) public  returns (bool) {
        _spendAllowance(from, spender, value);
        _transfer(from, to, value);
        return true;}
     //function allowance(address owner, address spender) public view virtual returns (uint256) {
       // return _allowance[owner][spender];}
    
 }
 interface tcoincompany{
    function approve(address spender, uint256 value) external  ;
    function allowance(address owner, address spender) external view returns (uint256) ;
    function transferFrom(address spender,address from, address to, uint256 value) external  returns (bool) ;


 }
 
contract company {
    uint public baseamount;
    address public comauth;
    tcoincompany public erccomp;
    modifier onlyowner{
        require(msg.sender==comauth);
        _;
    }
    constructor(tcoincompany _caddress){
        erccomp=_caddress;
        comauth=msg.sender;
        
    }
    function setbaseallowance(uint x) public onlyowner{
        baseamount=x;
    }

    function rquestallowance(address off) public onlyowner{
        erccomp.approve(off,baseamount);
    }
    function transferallowance(address to,uint a) public {
        erccomp.transferFrom(msg.sender,comauth,to,a);
    }
    function seeallowance(address a) public view returns(uint d){
        return erccomp.allowance(comauth,a);
    }
}