pragma solidity ^0.8.2;
contract voting{
    uint public endnom;
    address public owner;
    address[] public voterlist;
    uint public vc=0;
    uint public cc=0;
    constructor()
    {
        owner=msg.sender;
      //  endnom=block.timestamp + 2 days;
    }

    enum elecdet{nomstarted,nomended,voting_started,voting_ended} elecdet public stat;
    mapping(address => uint) public voteinfo;
    address[] public candidatelist;
    function search(address a,address[] memory h,uint c) public pure returns(bool g){
        for (uint i=0;i<c;i++){
            if (h[i]==a) return true ;
         } 
         return false;
    }
    function index(address r,uint l) public view returns(uint p){
        for (uint i=0;i<l;i++){
            if (candidatelist[i]==r) return i ;
    }
    }
    function elecresult() public view returns(address w,uint v){
        require(stat==elecdet.voting_ended,"voting is still going on");
        uint h=0;
        address a;
        for (uint j=0;j<cc;j++){
            if (voteinfo[candidatelist[j]]>=h){
                h=voteinfo[candidatelist[j]];
                a=candidatelist[j];
                }
        }
        return (a,h);
    }
    function endnomination() public onlyowner {
        stat=elecdet.nomended;
    }

    
    modifier onlyonce( uint x){
        if (x==0){
        require(!search(msg.sender,candidatelist,cc),"already registered");
        _;}
        if (x==1){
        require(!search(msg.sender,voterlist,vc),"already voted");
        _;
        }
    }
    modifier onlyowner(){
        require(msg.sender==owner,"sorry voting can only be started by owner");
        _;
    }
    function participate() public onlyonce(0)  {
        require(stat==elecdet.nomstarted);
        candidatelist.push(msg.sender);
        voteinfo[msg.sender]=0;
        cc++;
    }
    function withdraw() public {
        require(stat==elecdet.nomstarted);
        require(search(msg.sender,candidatelist,cc),"no name in the nomination list");
        delete candidatelist[index(msg.sender,cc)];
        cc--;
    }
    function startvoting() public onlyowner{
        require(stat==elecdet.nomended,"nomination not ended");
        stat=elecdet.voting_started;
    }
    function castvote(address z) public onlyonce(1){
        require(stat==elecdet.voting_started,"voting did not start");
        require(search(z,candidatelist,cc),"pls vote for valid candidate");
        voterlist.push(msg.sender);
        voteinfo[z]++;
        vc++;
    }
    function endvoting() public onlyowner  {
        stat=elecdet.voting_ended;

    }  
    }


