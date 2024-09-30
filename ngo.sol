pragma solidity ^0.8.2;
interface votinginterface{
        function search(address a,address[] memory,uint c) external view returns(bool g);
}
contract ngo{
    votinginterface public c;
    constructor(votinginterface _c){
        _c=c;
    }
    struct proposal{
        uint id;
        address a;
        uint amount;
        uint votes;
    }
    address[] public vottemp;
    uint v;
    uint vc;
    bool getfundcalled=false;
    event fundsanctioned();
    event fundnotsanctioned();
    event fund_requested(uint);
    proposal[] public proposals;
    mapping(address => uint) donorinfo;
    address[] public donors;
    modifier onlyoncedoner(){
        require(c.search(msg.sender,donors,donors.length),"u r not a donor");
        require(!c.search(msg.sender,vottemp,vottemp.length),"already voted");
        _;
    }
    function donatefunds() public payable{
        require(msg.value!=0," send more");
        donorinfo[msg.sender] +=msg.value;
        donors.push(payable(msg.sender));
    }
    function requestfunds(uint fund) public  {
        getfundcalled=true;
        proposal memory p;
        p.id=proposals.length;
        p.a=msg.sender;
        p.amount=fund;
        require(fund<=address(this).balance,"not enough balance");
        emit fund_requested(fund);
        while(v!=donors.length){}
        p.votes=vc;
        proposals.push(p);
        if (vc==donors.length){
        payable(msg.sender).transfer(fund);
        emit fundsanctioned();
        delete vottemp;
        vc=0;
        v=0;}
        else{
             emit fundnotsanctioned();
             delete vottemp;
             v=0;
             vc=0;
        }
    }
    function vote(uint q) public onlyoncedoner {
        require(getfundcalled,"no request raised");
        vottemp.push(msg.sender);
        vc+=q;
        v++;
    }
}