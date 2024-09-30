pragma solidity ^0.8.2;


interface IERC721{
    function transferFrom(address,address,uint) external ;
    function transfer(address,uint) external;
    function name() external returns(string memory);
    function ownerOf(uint256 tokenId) external view returns (address);
}
interface IERC20{
    function transfer1(address,address,uint) external;
}
contract auction{
    IERC20 public coins;
    constructor(IERC20 _coins)
    {   coins=_coins;
    }
    event auctionstarted(uint,uint );
    event auctionended(uint ,address ,uint);
    event bidmade(uint,address,uint);
    enum auctionstat{goingon,ended}
    struct nftdet{
        IERC721 nft;
        uint id;
        address owner;
        uint baseamount;
        uint started_at;
        uint end_at;
        address soldto;
        uint sold_amount;
        auctionstat status;
            }
    nftdet[] public  listnftauction;
    mapping(uint => mapping(address => uint)) public biddet;
    mapping(uint => address) public hbidder;
    mapping(uint => uint) public hbid;
    mapping(uint => address[]) public bidders;
    function startauction(IERC721 _nft,uint id,uint baseamount) public {
        require(_nft.ownerOf(id)==msg.sender,"u r not the owner of the nft");
        nftdet memory tempnft;
        tempnft.nft=_nft;
        tempnft.id=id;
        tempnft.owner=msg.sender;
        tempnft.baseamount=baseamount;
        tempnft.started_at=block.timestamp;
        tempnft.end_at=block.timestamp+1 days;
        listnftauction.push(tempnft);
        hbid[listnftauction.length-1]=baseamount;
        _nft.transferFrom(msg.sender,address(this),id);
        emit auctionstarted(listnftauction.length-1, baseamount);
        }
    function bid(uint saleid,uint value) public {
        require(saleid<listnftauction.length,"invalid id");
        require(block.timestamp<listnftauction[saleid].end_at," invalid bid out of time window");
        require(value>hbid[saleid],"pls bid high");
        emit bidmade(saleid,msg.sender,value);
        coins.transfer1(msg.sender,address(this) ,value );
        hbid[saleid]=value;
        hbidder[saleid]=msg.sender;
        if(biddet[saleid][msg.sender]==0){
            bidders[saleid].push(msg.sender);
        }
        biddet[saleid][msg.sender]+=value;
    }
    function withdraw(uint saleid) public{
        require(saleid<listnftauction.length,"invalid id");  
        require(block.timestamp<listnftauction[saleid].end_at,"invaild withdraw request out of time window");
        require(msg.sender!=hbidder[saleid],"ur the hishest bidder u cant withdraw");
        require(biddet[saleid][msg.sender]!=0,"u did not bid");
        coins.transfer1(address(this),msg.sender ,biddet[saleid][msg.sender]);   
        biddet[saleid][msg.sender]=0;
    }
    function endauction(uint saleid) public {
        require(listnftauction[saleid].status==auctionstat.goingon,"already ended");
        require(msg.sender==listnftauction[saleid].owner,"ur r not the seller");
        //require(block.timestamp>=end_at,"auction did not end");
        emit auctionended(saleid,hbidder[saleid],hbid[saleid]);
        listnftauction[saleid].sold_amount=hbid[saleid];
        listnftauction[saleid].soldto=hbidder[saleid];
        listnftauction[saleid].nft.transfer(hbidder[saleid],listnftauction[saleid].id);
        coins.transfer1(address(this),listnftauction[saleid].owner,hbid[saleid]);
        biddet[saleid][hbidder[saleid]]-=hbid[saleid];
        for (uint i=0;i<bidders[saleid].length;i++){
                coins.transfer1(address(this),bidders[saleid][i],biddet[saleid][bidders[saleid][i]]);
        }
        listnftauction[saleid].status=auctionstat.ended;
        delete bidders[saleid];
        delete hbidder[saleid];
        delete hbid[saleid];
    }
}