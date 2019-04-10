<template>
  <div class="page">
    <div class="deploy" v-show="tabIndex===0">
      <div class="environment">
        <P class="title">
          <span>Environment</span>
          <span @click="login('1')" style="padding-left: 50px;"><i style="cursor: pointer;" :class="rotates===1?'go el-icon-refresh':'el-icon-refresh'" ></i></span>
        </P>
        <ul>
          <li class="network">
            <label style="padding-right: 20px;">NetWork  ：
              <select v-model="network">
                <option :value="account.network">{{account.network}}</option>
                <option value="location">{{'location'| filts }}</option>
              </select>
            </label>
            <label v-if="network==='location'">Port ：<input type="tel" v-model="port"></label>
          </li>
          <li class="input" v-if="network==='location'">
            <label>RpcUsername ：<input type="text" v-model="user"></label>
            <label style="margin-left: 15px;">RpcPassword ：<input type="password" v-model="password"></label>
          </li>
          <li>Account ：<p id="address">{{account.address}}<i style="cursor: pointer;font-size: 16px;" data-clipboard-target="#address" @click = "copy('.address')" class="el-icon-tickets address"></i></p></li>
        </ul>
        <p style="margin: 10px auto;"><span style="font-weight: bold;font-size: 15px;">Note</span>:Can change Network and Account in WaykiMax</p>
      </div>
      <p class="deployButton" @click="deployButton">deploy</p>
      <div class="txHash">
        <p>TxHash:</p>
        <textarea v-model="txHash" id="txHash"></textarea>
        <span class="TxHashCopy"><i data-clipboard-target="#txHash" style="cursor: pointer" @click = "copy('.hash')"  class="el-icon-tickets hash"></i></span>
      </div>
    </div>
    <div class="run" v-show="tabIndex===1">
      <div class="contract">
        <div class="content">
          <P class="title">
            <span>Contract Regid:</span>
            <span @click="getContract()" style="padding-left: 50px;"><i :class="rotates===2?'go el-icon-refresh':'el-icon-refresh'" style="cursor: pointer;"></i></span>
          </P>
          <p class="regid">
            <input type="text" v-model="contractRegId" :style="{color:ifGetRegId?'#fff':'#E91E63'}" id="regId" />
            <span data-clipboard-target="#regId" @click = "copy('.REGID')" class="REGID"><i style="cursor: pointer;" class="el-icon-tickets"></i></span>
          </p>
        </div>
      </div>
      <div class="parameter">
        <div class="data">
          <ul>
            <li><label @click="setToggle('magicNum')" class="inner"><span v-if='showConfig.magicNum'></span></label> magic number
              <input type="text" :disabled="!showConfig.magicNum" v-model="magicNum" @input="setSave('magicNum')" />&nbsp;
            </li>
            <li><label @click="setToggle('method')" class="inner"><span v-if='showConfig.method' ></span></label>
              method <input type="text" :disabled="!showConfig.method" v-model="method" @input="setSave('method')" />&nbsp;</li>
            <li><label @click="setToggle('reserveBytes')" class="inner"><span v-if='showConfig.reserveBytes'></span></label>
              keep value <input style="width:40px;" type="text" :disabled="!showConfig.reserveBytes" v-model="reserveBytes" @input="setSave('reserveBytes')"></li>
          </ul>
          <div class="add">
            <div class="transfarm">
              <span>param</span>
              <select id="select" v-model="type">
                <option v-for="item in options" :key="item.value" :value="item.value">
                  {{item.label}}
                </option>
              </select>
              <span class="addBottom" @click="addParam">Add</span>
            </div>
            <div class="item">
              <p v-for="(item, index) in params" :key="index">
                <span @click="setDelete(index)" class="el-icon-close delParam"></span>
                <span style="margin-right:5px;">param{{index+1}}</span>
                <input :type="(item.type == 2 || item.type == 3) ? 'number' : 'text'" v-model="item.val" @input="setTransfer(item.type, index)" />
                <span style="margin-left:5px;">{{item.name}}</span>
              </p>
            </div>
          </div>
        </div>
      </div>
      <div class="CallCommand">
        <div class="command">
          <p>Call command:</p>
          <input type="text" readonly v-model="sampleCode" />
          <p class="wiccNum">Wicc Amount ：<input type="numbel" v-model="wiccNum" />&nbsp;&nbsp;sawi</p>
          <p class="deployButton" @click="invokeContract">call</p>
        </div>
      </div>
      <div class="runHash">
        <div>
          <p><span>Txhash:</span> <span class="TxHashCopy"><i style="cursor: pointer;" data-clipboard-target="#invokeTxHash" @click = "copy('.invokeTxHash')" class="el-icon-tickets invokeTxHash"></i></span></p>
          <textarea v-model="invokeTxHash" id="invokeTxHash"></textarea>
        </div>
      </div>
    </div>
    <v-tool v-show="tabIndex===2"></v-tool>
    <!--<div class="debug" v-show="tabIndex===3">-->
      <!--Coming soon...-->
    <!--</div>-->
    <div class="help" v-show="tabIndex===3">
      <p class="contact">Contact Us：</p>
      <div class="mailbox">
        <label>telegram group：</label>
        <p><a target="_blank" style="color: #fff" href="https://t.me/waykichaindeveng">https://t.me/waykichaindeveng</a></p>
        <label style="margin-top:10px;">contact mailbox：</label>
        <p>jiao.zheng@waykichainhk.com</p>
      </div>
    </div>
  </div>
</template>

<script>
  import Clipboard from 'clipboard'
  import Tool from './tool'
  export default {
    name: "execute",
    components:{
      'v-tool':Tool,
    },
    props: {
      code: String,
      tabIndex:Number
    },
    filters:{
      filts:function(arg){
        return 'Local Testnet Node'
      }
    },
    watch:{
      tabIndex(val){
        return this.tabIndex = parseInt(val);
        if(this.tabIndex===1 && this.txHash===''){
         this.contractRegId = '' ;
        }
      }
    },
    data () {
      return {
        ifShowN:false,
        port:localStorage.getItem('port')?localStorage.getItem('port'):'6968',
        password:localStorage.getItem('password')?localStorage.getItem('password'):'wicc123',
        user:localStorage.getItem('user')?localStorage.getItem('user'):'waykichain',
        network:'location',
        account:{},
        rotates:0,
        options:[
          { value:'1',label:'char'},
          { value:'2',label:'4 byte number'},
          { value:'3',label:'8 byte number'},
          { value:'4',label:'UTF-8'},
          { value:'5',label:'hex'}
        ],
        txHash:'',
        contractRegId:'',
        magicNum: localStorage.getItem('magicNum') ? localStorage.getItem('magicNum') : 'f0',
        method: localStorage.getItem('method') ? localStorage.getItem('method'): '07',
        reserveBytes: localStorage.getItem('reserveBytes') ? localStorage.getItem('reserveBytes') : '0000',
        sampleCode: localStorage.getItem('sampleCode') ? localStorage.getItem('sampleCode') : 'f0070000',
        showConfig: localStorage.getItem('showConfig') ? JSON.parse(localStorage.getItem('showConfig')) : {magicNum: true, method: true, reserveBytes: true},
        type:'1',
        params: localStorage.getItem('params') ? JSON.parse(localStorage.getItem('params')) : [],
        invokeTxHash:'',
        wiccNum:0,
        ifGetRegId:false
      }
    },
    mounted() {
      window.onload = () =>{
        try{
          WiccWallet.getDefaultAccount().then((data) => {
            this.network = data.network;
            this.account = data;
            this.login('0');
          },(error) => {
            this.login('0');
          })
        }catch(error){
          this.$message.error("Please install WaykiMax at first.")
        }
      }
    },
    methods:{
      addParam() {
        this.params.push({
          type: this.type,
          name: this.getName(this.type),
          val: '',
          transferVal: ''
        });
        localStorage.setItem('params', JSON.stringify(this.params))
      },
      getName(type){
        let name = '';
        switch (+type) {
          case 1: name = 'char';break;
          case 2: name = '4 byte number';break;
          case 3: name = '8 byte number';break;
          case 4: name = 'UTF-8';break;
          case 5: name = 'hex';
        }
        return name
      },
      setSave(type) {
        localStorage.setItem(type, this[type]);
        this.getValue();
      },
      setToggle(item) {
        this.showConfig[item] = !this.showConfig[item];
        localStorage.setItem('showConfig', JSON.stringify(this.showConfig));
        this.getValue();
      },
      setTransfer(type, index) {
        switch (+type) {
          case 1: this.charToCode(index);break;
          case 2: this.numberToCode(index, 8);break;
          case 3: this.numberToCode(index, 16);break;
          case 4: this.strToutf8(index);break;
          case 5: this.params[index].transferVal = this.params[index].val
        }
        this.getValue();
      },
      //char
      charToCode(index) {
        let result = '';
        let charVal = this.params[index].val.slice();
        charVal.split('').map(item => {
          result += item.charCodeAt().toString(16)
        });
        this.params[index].transferVal = result
      },
      //byte number
      numberToCode(index, length) {
        let patch = "00000000000000000000000000",
          arr = [],
          tempStr = '',
          result = '';
        tempStr = (+this.params[index].val.slice()).toString(16);
        tempStr = tempStr.length % 2 === 0 ? tempStr : '0' + tempStr;

        for (let i = 0; i < tempStr.length; i += 2) {
          arr.push(tempStr.substr(i, 2))
        }
        result = arr.reverse().join('');
        result += patch.substr(0, length - result.length);
        this.params[index].transferVal = result;
      },
      //utf-8
      strToutf8(index) {
        let str = this.params[index].val.slice();
        this.params[index].transferVal = this.getUTFCode(str);
      },
      getUTFCode (str) {
        let back = [];
        for (let i = 0; i < str.length; i++) {
          let code = str.charCodeAt(i);
          if (0x00 <= code && code <= 0x7f) {
            back.push(code);
          } else if (0x80 <= code && code <= 0x7ff) {
            back.push((192 | (31 & (code >> 6))));
            back.push((128 | (63 & code)))
          } else if ((0x800 <= code && code <= 0xd7ff)
            || (0xe000 <= code && code <= 0xffff)) {
            back.push((224 | (15 & (code >> 12))));
            back.push((128 | (63 & (code >> 6))));
            back.push((128 | (63 & code)))
          }
        }
        for (let i = 0; i < back.length; i++) {
          back[i] &= 0xff;
          back[i] = back[i].toString(16)
        }
        return back.join('')
      },
      setDelete (index) {
        this.params.splice(index, 1);
        this.getValue();
        localStorage.setItem('sampleCode', this.sampleCode);
        localStorage.setItem('params', JSON.stringify(this.params))
      },
      getValue() {
        let str = '';
        let start = '';
        for (let item in this.showConfig) {
          if (this.showConfig[item]) {
            start += this[item]
          }
        }
        this.params.map(item => {
          str += item.transferVal
        });
        this.sampleCode = start + str;
        localStorage.setItem('params', JSON.stringify(this.params));
        localStorage.setItem('sampleCode', this.sampleCode)
      },
      invokeContract(){
        let _this = this;
        if(this.contractRegId ===''){
          this.$message({
            message: 'Please entry smart contract regid ',
            type: 'warning'
          });
          return false
        }
        if(this.sampleCode ===''){
          this.$message({
            message: 'Please entry smart contract regid ',
            type: 'warning'
          });
          return false
        }
        if(_this.network === 'location'){
          let par=[this.account.address,this.contractRegId,parseInt(this.wiccNum),this.sampleCode,1000000];
          _this.getSubmittx(par,'callcontracttx')
        }else{
          try{
          WiccWallet.callContract(this.contractRegId,this.sampleCode,parseInt(this.wiccNum), (error, data) => _this.check(error, data,'InvokeContract')).then(() => {

            }, (error) => {
              this.$message.error(error.message)
            })
          }catch(error){
            this.$message.error("Please install WaykiMax at first.");
          }
        }
      },
      //复制hash值
      copy(name) {
        let _this = this;
        let clipboard = new Clipboard(name);
        clipboard.on('success', function (e) {
          _this.$message({
            message: 'Copy Success',
            type: 'success'
          });
          e.clearSelection();
        });
      },
      //登录
      login(index){
        let _this = this;
        if(index==='1'){
          _this.rotates = 1;
        }
        _this.$nextTick(() => {
          try{
            WiccWallet.getDefaultAccount().then((data) => {
              _this.network = data.network;
              _this.account = data;
            },(error) => {
              _this.$message.error(error.message);
              _this.network = null;
              _this.account = {};
            })
          }catch(error){
            _this.$message.error("Please install WaykiMax at first.");
          }
        });
        setTimeout(function(){
          _this.rotates = 0;
        },1100)
      },
      deployButton(){
        let _this = this;
        if(_this.network !== 'location'){
          this.login('0');
          setTimeout(function(){
            try{
              WiccWallet.publishContract(_this.code, '', (error, data) => _this.check(error, data,'deploy')).then(() => {
              }, (error) => {
                _this.$message.error(error.message);
              })
            }catch(error){
              _this.$message.error("Please install WaykiMax at first.");
            }
          },100);
        }else{
          localStorage.setItem("port",_this.port);
          localStorage.setItem("password",_this.password);
          localStorage.setItem("user",_this.user);
          try{
            WiccWallet.genPublishContractRaw('mylib = require "mylib"', '', (error, data) => _this.check(error, data,'contractRaw')).then(() => {

            }, (error) => {
              _this.$message.error(error.message);
            });
          }catch(error){
            _this.$message.error("Please install WaykiMax at first.");
          }
        }
      },
      getContract(){
        let _this = this;
        _this.rotates = 2;
        if(_this.network==='location'){
          //this.login('0')
          let txh=[_this.txHash];
          _this.getSubmittx(txh,'getcontractregid')
        }else{
          if(_this.txHash===''){
            this.$message(' Please get the contract deployment transaction hash first');
          }else{
            if(_this.network==='mainnet'){
              _this.reAPI = 'https://baas.wiccdev.org/v1/api/contract/regid';
            }else{
              _this.reAPI = 'https://baas-test.wiccdev.org/v1/api/contract/regid';
            }
            _this.$http.post(_this.reAPI, {hash:_this.txHash}).then(function (response) {
              let data = response.data;
              if(data.code===0){
                if(data.data.result){
                  _this.contractRegId = data.data.result.regid;
                  _this.ifGetRegId = true;
                  _this.$message({
                    message:"publish contract txhash:" +  _this.txHash + ",\ncontract regid: " +  _this.contractRegId ,
                    type: 'success'
                  });
                }else{
                  _this.ifGetRegId = false;
                  _this.contractRegId = data.data.error.message;
                }
              }else{
                _this.$message.error(data.message)
              }
            }).catch(function (error) {
              _this.$message.error(error.message)
            });
          }
          setTimeout(function(){
            _this.rotates = 0;
          },1100)
        }
      },
      getSubmittx(rawtx,methodName){
        let _this = this;
        let url =`http://127.0.0.1:${this.port}`;
        _this.$http.post(url,{
          'jsonrpc':"2.0",'id':"curltext",'method':methodName,'params':rawtx
        },{
          auth:{
            username:_this.user,password:_this.password
          }
        }).then(function (response) {
          let res = response.data;
          if(res.result){
            _this.$message({
              message: 'Success!!!',
              type: 'success'
            });
            if(methodName==='submittx'){
              _this.txHash = res.result.hash;
            }else if(methodName==='getcontractregid'){
              _this.contractRegId = res.result.regid;
            }else{
              this.invokeTxHash = res.result.txid;
            }
          }else{
            if(methodName==='submittx'){
              _this.$message.error(res.error.message)
            }else if(methodName==='getcontractregid'){
              _this.contractRegId = res.error.message;
            }else{
              _this.$message.error(res.error.message)
            }
          }
        }).catch(function (error) {
          _this.$message.error(error.message)
        });
      },
      check(error, data,from){
        if(error===null){
          if(this.network !== 'location'){
            this.$message({
              message: 'Success!!!',
              type: 'success'
            });
          }
          if(from==='deploy'){
            this.txHash = data.txid;
          }else if(from==='contractRaw'){
            let rawtx = [data.rawtx];
            this.getSubmittx(rawtx,'submittx')
          }else{
            this.invokeTxHash = data.txid;
          }
        }else{
          this.$message.error(error.message);
          if(from==='deploy'){
            this.txHash = '';
          }else if(from==='contractRaw'){
            this.contractRegId = '';
          }else{
            this.invokeTxHash='';
          }
        }
      }
    }
  }
</script>

<style scoped src="../assets/execute.less" lang="less"></style>
