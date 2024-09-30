pragma solidity ^0.8.2;
import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol';
contract nft is ERC721('tcoin',"TCN"){
    uint private counter=0;
    mapping(uint => string ) public tokhash;
    function pubmint(address a,string memory s) public {
        _mint(a, counter);
        tokhash[counter++]=s;
    }
    function _baseURI() internal pure override returns(string memory s){
        return "https://maroon-academic-cardinal-275.mypinata.cloud/ipfs";
    }
    function tokenURI(uint256 tokenId) public view override returns(string memory){
         string memory baseURI = _baseURI();
         string memory hash=tokhash[tokenId];
        return bytes(baseURI).length > 0 ? string.concat(baseURI,hash) : "";
    }
    function sethash(uint tokid,string memory hash) public {
        tokhash[tokid]=hash;
    }
    function transfer(address to, uint id) public {
        address auth=msg.sender;
        _approve(to, id, auth);
        transferFrom(auth, to, id);
    }
}