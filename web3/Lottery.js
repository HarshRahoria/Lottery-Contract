const {Web3} = require('web3');
let web3 = new Web3(new Web3.providers.HttpProvider("HTTP://127.0.0.1:7545"))

const Accounts = async()=>{
    availableAccounts = await web3.eth.getAccounts();
    // console.log(availableAccounts)
    for(let i=0; i<availableAccounts.length; i++){
        balance = await web3.eth.getBalance(availableAccounts[i])
        console.log("Account: ", availableAccounts[i], " Balance: ", balance)
    }
}
Accounts()
const ABI = require("./ABI.json")
contractInstance = new web3.eth.Contract(ABI, "0x3FC0992C92a7c70417cF0F8D0Ec74fa38558448B")
const registerLottery  = async()=>{
    ether = web3.utils.toWei("1", "ether")
await contractInstance.methods.registerParticipant().send({
    from: "0xE63E64342b6F0035456E0F2eb3783a2881F7569d",
    to: "0x3FC0992C92a7c70417cF0F8D0Ec74fa38558448B",
    value: ether
})
}
const listParticipants = async()=>{
    const listOfParticipants = await contractInstance.methods.returnParticipantsList().call()
    console.log(listOfParticipants)
}
// registerLottery()

const selectingWinner = async()=>{
    await contractInstance.methods.selectWinner().send({
        from: "0xCF2B42496D8946c2A423D54423091125B748838c",
        to: "0x3FC0992C92a7c70417cF0F8D0Ec74fa38558448B",
    })
}

const getWinner = async()=> {
    winner = await contractInstance.methods.winner().call()
    console.log(winner)
}
// selectingWinner()
// getWinner()
listParticipants()