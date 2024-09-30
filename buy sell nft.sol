pragma solidity ^0.8.2;
interface IERC721{
    function transferFrom(address,address,uint) external ;
    function transfer(address,uint) external;
    function name() external returns(string memory);

    }
interface IERC20{
    function transfer1(address,address,uint) external;
}
contract buysell{
    IERC20 public _currcoin;
    constructor(IERC20 currcoin_){
        _currcoin=currcoin_;
    }
    IERC721 public nft;
    struct  nftin{
        address owner;
        IERC721 nftinf;
        uint nftid;
        uint value;
        string name;
        // status 
    }
    nftin[] public salesinfo;
    function sellnft(IERC721 _nft,uint tokenid,uint value) public {
        nftin memory tempnft;
        tempnft.owner=msg.sender;
        tempnft.nftinf=_nft;
        tempnft.nftid=tokenid;
        tempnft.value=value;
        tempnft.name=_nft.name();
        salesinfo.push(tempnft);
        _nft.transferFrom(msg.sender,address(this) ,tokenid );

    }
    function buynft(uint saleno,uint currcoins ) public payable {
        require(currcoins==salesinfo[saleno].value,"pay right amount of coins nft");
        require(saleno<=salesinfo.length,"this nft is not avilable for sale");
        _currcoin.transfer1(msg.sender,salesinfo[saleno].owner,currcoins );
        salesinfo[saleno].nftinf.transfer(msg.sender,salesinfo[saleno].nftid);



    }

}