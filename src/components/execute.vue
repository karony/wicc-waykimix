<template>
  <div class="page">
    <div class="deploy" v-show="tabIndex===0">
      <div class="environment">
        <P class="title">
          <span>Environment</span>
          <span @click="login('1')" style="padding-left: 20px;">
            <i style="cursor: pointer;" :class="rotates===1?'go el-icon-refresh':'el-icon-refresh'"></i>
          </span>
        </P>
        <ul>
          <li class="network">
            <label style="padding-right: 20px;">
              NetWork ：{{account.network}}
              <!--<select v-model="network">-->
              <!--<option :value="account.network">{{account.network}}</option>-->
              <!--<option value="location">{{'location'| filts }}</option>-->
              <!--</select>-->
            </label>
            <label v-if="network==='location'">
              Port ：
              <input type="tel" v-model="port">
            </label>
          </li>
          <li class="input" v-if="network==='location'">
            <label>
              RpcUsername ：
              <input type="text" v-model="user">
            </label>
            <label style="margin-left: 15px;">
              RpcPassword ：
              <input type="password" v-model="password">
            </label>
          </li>
          <li>
            <p>Account：</p>
            <p id="address">{{account.address}}</p>
            <img
              style="cursor: pointer;"
              data-clipboard-target="#address"
              @click="copy('.copyAddress')"
              class="copyAddress"
              src="../assets/copy.svg"
            >
          </li>
          <li>
            <p>Balance：</p>
            <p id="address">{{account.balance ? account.balance : 0}}</p>
            <p class="wicc">WICC</p>
          </li>
        </ul>
        <p style="margin: 12px auto;color:#7F8CA3">
          <span style>Note：Can change Network and Account in</span>
          <span style="color:#008DFF">WaykiMax</span>
        </p>
      </div>
      <p class="deployButton" @click="deployButton">Deploy</p>
    </div>
    <div class="run" v-show="tabIndex===1">
      <div class="contract">
        <div class="txHash">
          <p>TxHash:</p>
          <textarea v-model="txHash" id="txHash"></textarea>
          <span class="TxHashCopy" data-clipboard-target="#txHash" @click="copy('.TxHashCopy')">
            <img style="cursor: pointer" src="../assets/copy.svg">
          </span>
        </div>
        <div class="content">
          <P class="title">
            <span>Contract Regid:</span>
            <span @click="getContract()" style="padding-left: 10px;">
              <i
                :class="rotates===2?'go el-icon-refresh':'el-icon-refresh'"
                style="cursor: pointer;"
              ></i>
            </span>
          </P>
          <p class="regid">
            <input
              type="text"
              v-model="contractRegId"
              :style="{color:ifGetRegId?'#6D7789':'#E91E63'}"
              id="regId"
            >
            <span data-clipboard-target="#regId" @click="copy('.REGID')" class="REGID">
              <img style="cursor: pointer;" src="../assets/copy.svg">
            </span>
          </p>
        </div>
      </div>
      <div class="parameter">
        <div class="add">
          <div class="transfarm">
            <div>
              <span class="title">Param</span>
            </div>
            <div style="box-sizing: border-box;">
              <select id="select" v-model="type">
                <option v-for="item in options" :key="item.value" :value="item.value">{{item.label}}</option>
              </select>
              <img class="addBottom" @click="addParam" src="../assets/add.svg">
            </div>
          </div>
          <div class="item">
            <div class="cell" v-for="(item, index) in params" :key="index">
              <img class="delParam" @click="setDelete(index)" src="../assets/delete.svg">
              <p class="typeStr">{{item.name}}</p>
              <input
                :type="(item.type == 2 || item.type == 3) ? 'number' : 'text'"
                v-model="item.val"
                @input="setTransfer(item.type, index)"
              >
              <p class="typeStr" style="width:42px;margin-left:30px;">toHex</p>
              <p class="result">{{item.transferVal}}</p>
            </div>
            <div class="btnDiv">
              <div class="save" style="background:#343E53;" @click="SaveParam">
                <span>Save</span>
              </div>
              <div class="save" @click="Gen">
                <span>Gen</span>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="CallCommand">
        <div class="command">
          <p>Call Contract:</p>
          <div class="contractStr">
            <span class="t">Param</span>
            <label id="contractValue">{{sampleCode}}</label>
            <span
              data-clipboard-target="#contractValue"
              @click="copy('.contractTagert')"
              class="contractTagert"
            >
              <img style="cursor: pointer;" src="../assets/copy.svg">
            </span>
          </div>
          <div class="contractStr">
            <span class="t">Amount</span>
            <label id="contractValue">{{wiccNum}}</label>
            <span>sawi</span>
          </div>
          <div class="btnDiv">
            <div class="save" @click="invokeContract">
              <span>Call</span>
            </div>
          </div>
        </div>
      </div>
      <div class="CollectionsDiv">
        <p class="tabTitle">Collections</p>
        <div>
          <div class="Collection_cell" v-for="(item,index) in savedParams" :key="index">
            <img src="../assets/delete.svg" @click="deleteSavedParam(index)">
            <label class="paramT">Param{{index+1}}</label>
            <label class="paramV">{{item.param}}</label>
            <div class="location">
              <img src="../assets/edit.svg" @click="editSavedParam(item)">
              <label class="call" @click="callSavedParam(item)">Call</label>
            </div>
          </div>
        </div>
      </div>

      <div class="CallCommand">
        <div class="command">
          <div class="GetContractHeader">
            <p>Getcontractadata</p>
            <select id="select" v-model="returnType">
              <option v-for="(item,index) in returnTypes" :key="index" :value="item">{{item}}</option>
            </select>
          </div>

          <div class="contractStr">
            <span class="t">Key</span>
            <input id="contractValue" v-model="GetcontractadataKey">
            <span style="color: #1C9AFF;cursor: pointer;" @click="GetDataOnline">Get</span>
          </div>
          <div class="contractStr">
            <span class="t">Value</span>
            <label id="invokeTxHash">{{returnType}}</label>
            <span
              data-clipboard-target="#invokeTxHash"
              @click="copy('.contractTagert')"
              class="contractTagert"
            >
              <img style="cursor: pointer;" src="../assets/copy.svg">
            </span>
          </div>
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
        <p>
          <a
            target="_blank"
            style="color: #fff"
            href="https://t.me/waykichaindeveng"
          >https://t.me/waykichaindeveng</a>
        </p>
        <label style="margin-top:10px;">contact mailbox：</label>
        <p>jiao.zheng@waykichainhk.com</p>
      </div>
    </div>
  </div>
</template>

<script>
import Clipboard from "clipboard";
import { Base64 } from "js-base64";
import Tool from "./tool";
import Vue from "vue";
Vue.use(Base64);
export default {
  name: "execute",
  components: {
    "v-tool": Tool
  },
  props: {
    code: String,
    tabIndex: Number
  },
  filters: {
    filts: function(arg) {
      return "Local Testnet Node";
    }
  },
  watch: {
    tabIndex(val) {
      return (this.tabIndex = parseInt(val));
      if (this.tabIndex === 1 && this.txHash === "") {
        this.contractRegId = "";
      }
    }
  },
  data() {
    return {
      GetcontractadataKey:"",
      returnType: "STRING",
      returnTypes: ["STRING", "NUMBER", "HEX"],
      ifShowN: false,
      port: localStorage.getItem("port")
        ? localStorage.getItem("port")
        : "6968",
      password: localStorage.getItem("password")
        ? localStorage.getItem("password")
        : "wicc123",
      user: localStorage.getItem("user")
        ? localStorage.getItem("user")
        : "waykichain",
      network: "",
      account: {},
      rotates: 0,
      options: [
        { value: "1", label: "StrToHex" },
        { value: "2", label: "IntToHex(4b)" },
        { value: "3", label: "IntToHex(8b)" },
        { value: "4", label: "UTF-8ToHex" },
        { value: "5", label: "Hex" }
      ],
      txHash: "",
      contractRegId: "",

      sampleCode: localStorage.getItem("sampleCode")
        ? localStorage.getItem("sampleCode")
        : "",
      type: "1",
      params: localStorage.getItem("params")
        ? JSON.parse(localStorage.getItem("params"))
        : [],
      invokeTxHash: "",
      wiccNum: 0,
      ifGetRegId: false,
      savedParams: localStorage.getItem("savedParam")
        ? JSON.parse(localStorage.getItem("savedParam"))
        : []
    };
  },
  mounted() {
    window.onload = () => {
      try {
        WiccWallet.getDefaultAccount().then(
          data => {
            this.network = data.network;
            this.account = data;
            this.login("0");
          },
          error => {
            this.login("0");
          }
        );
      } catch (error) {
        this.$emit("errorLog", "Please install WaykiMax at first.");
      }
    };
  },
  methods: {
    addParam() {
      this.params.push({
        type: this.type,
        name: this.getName(this.type),
        val: "",
        transferVal: ""
      });
      localStorage.setItem("params", JSON.stringify(this.params));
    },
    getName(type) {
      let name = "";
      switch (+type) {
        case 1:
          name = "StrToHex";
          break;
        case 2:
          name = "IntToHex(4b)";
          break;
        case 3:
          name = "IntToHex(8b)";
          break;
        case 4:
          name = "UTF-8ToHex";
          break;
        case 5:
          name = "Hex";
      }
      return name;
    },
    setSave(type) {
      localStorage.setItem(type, this[type]);
      this.getValue();
    },
    setTransfer(type, index) {
      switch (+type) {
        case 1:
          this.charToCode(index);
          break;
        case 2:
          this.numberToCode(index, 8);
          break;
        case 3:
          this.numberToCode(index, 16);
          break;
        case 4:
          this.strToutf8(index);
          break;
        case 5:
          this.params[index].transferVal = this.params[index].val;
      }
      this.getValue();
    },
    //char
    charToCode(index) {
      let result = "";
      let charVal = this.params[index].val.slice();
      charVal.split("").map(item => {
        result += item.charCodeAt().toString(16);
      });
      this.params[index].transferVal = result;
    },
    //byte number
    numberToCode(index, length) {
      let patch = "00000000000000000000000000",
        arr = [],
        tempStr = "",
        result = "";
      tempStr = (+this.params[index].val.slice()).toString(16);
      tempStr = tempStr.length % 2 === 0 ? tempStr : "0" + tempStr;

      for (let i = 0; i < tempStr.length; i += 2) {
        arr.push(tempStr.substr(i, 2));
      }
      result = arr.reverse().join("");
      result += patch.substr(0, length - result.length);
      this.params[index].transferVal = result;
    },
    //utf-8
    strToutf8(index) {
      let str = this.params[index].val.slice();
      this.params[index].transferVal = this.getUTFCode(str);
    },
    getUTFCode(str) {
      let back = [];
      for (let i = 0; i < str.length; i++) {
        let code = str.charCodeAt(i);
        if (0x00 <= code && code <= 0x7f) {
          back.push(code);
        } else if (0x80 <= code && code <= 0x7ff) {
          back.push(192 | (31 & (code >> 6)));
          back.push(128 | (63 & code));
        } else if (
          (0x800 <= code && code <= 0xd7ff) ||
          (0xe000 <= code && code <= 0xffff)
        ) {
          back.push(224 | (15 & (code >> 12)));
          back.push(128 | (63 & (code >> 6)));
          back.push(128 | (63 & code));
        }
      }
      for (let i = 0; i < back.length; i++) {
        back[i] &= 0xff;
        back[i] = back[i].toString(16);
      }
      return back.join("");
    },
    setDelete(index) {
      this.params.splice(index, 1);
      this.getValue();
    },
    getValue() {
      localStorage.setItem("params", JSON.stringify(this.params));
    },
    SaveParam() {
      this.Gen();
      let Obj = {
        param: this.sampleCode,
        params: this.params
      };
      this.savedParams.push(Obj);
      localStorage.setItem("savedParam", JSON.stringify(this.savedParams));
      this.$emit("errorLog", "Yes", "Record add successfully");
    },
    deleteSavedParam(index) {
      this.savedParams.splice(index, 1);
      localStorage.setItem("savedParam", JSON.stringify(this.savedParams));
    },
    editSavedParam(item) {
      this.params = item.params;
    },
    callSavedParam(item) {
      this.sampleCode = item.param;
      this.invokeContract();
    },
    Gen() {
      let str = "";
      let start = "";
      for (let item in this.showConfig) {
        if (this.showConfig[item]) {
          start += this[item];
        }
      }
      this.params.map(item => {
        str += item.transferVal;
      });
      this.sampleCode = start + str;
    },
    GetDataOnline(){
      if (this.contractRegId === "") {
        this.$emit("errorLog", "Please entry smart contract regid");
        return false;
      }
      let url = "https://baas.wiccdev.org/v2/api/contract/getcontractdata";
      let para = {
          "key": this.GetcontractadataKey,
          "regid": this.contractRegId,
          "returndatatype": this.returnType
      };
      this.$http.post(url, para).then(res => {
        this.$emit("errorLog",'Yes', res.data);
      }).catch(err=>{
        this.$emit("errorLog", error);
      })
    },
    invokeContract() {
      let _this = this;
      if (this.contractRegId === "") {
        this.$emit("errorLog", "Please entry smart contract regid");
        return false;
      }
      if (this.sampleCode === "") {
        this.$emit("errorLog", "Please entry smart contract regid");
        return false;
      }
      try {
        WiccWallet.callContract(
          this.contractRegId,
          this.sampleCode,
          parseInt(this.wiccNum),
          (error, data) => _this.check(error, data, "InvokeContract")
        ).then(
          () => {},
          error => {
            this.$emit("errorLog", error.message);
          }
        );
      } catch (error) {
        this.$emit("errorLog", "Please install WaykiMax at first.");
      }
    },
    //复制hash值
    copy(name) {
      let _this = this;
      let clipboard = new Clipboard(name);
      clipboard.on("success", function(e) {
        _this.$message({
          message: "Copy Success",
          type: "success"
        });
        e.clearSelection();
      });
    },
    //登录
    login(index) {
      let _this = this;
      if (index === "1") {
        _this.rotates = 1;
      }
      _this.$nextTick(() => {
        try {
          WiccWallet.getDefaultAccount().then(
            data => {
              //_this.network = data.network;
              _this.account = data;
            },
            error => {
              _this.$emit("errorLog", error.message);
              // _this.network = null;
              _this.account = {};
            }
          );
        } catch (error) {
          _this.$emit("errorLog", "Please install WaykiMax at first.");
        }
      });
      setTimeout(function() {
        _this.rotates = 0;
      }, 1100);
    },
    deployButton() {
      let _this = this;
      let url = "http://runcode-api2-ng.dooccn.com/compile2";
      let para = {
        language: 25,
        code: Base64.encode(_this.code),
        stdin: 123
      };
      _this.$http.post(url, para).then(res => {
        let errorMsg = res.data.errors;

        if (errorMsg != "") {
          let iii = errorMsg.indexOf("module");
          if (iii == -1) {
            this.$emit("errorLog", errorMsg);
            return;
          }
          _this.deploy(_this);
          return;
        }
        _this.deploy(_this);
      });
    },
    deploy(_this) {
      _this.login("0");
      setTimeout(() => {
        try {
          WiccWallet.publishContract(_this.code, "", (error, data) =>
            _this.check(error, data, "deploy")
          ).then(
            () => {},
            error => {
              this.$emit("errorLog", error.message);
            }
          );
        } catch (error) {
          this.$emit("errorLog", "Please install WaykiMax at first.");
        }
      }, 100);
    },
    getContract() {
      let _this = this;
      _this.rotates = 2;
      if (!_this.account.network) {
        this.login("0");
      } else {
        if (_this.txHash === "") {
          this.$emit(
            "errorLog",
            "Please get the contract deployment transaction hash first"
          );
        } else {
          if (_this.account.network === "mainnet") {
            _this.reAPI = "https://baas.wiccdev.org/v1/api/contract/regid";
          } else {
            _this.reAPI = "https://baas-test.wiccdev.org/v1/api/contract/regid";
          }
          _this.$http
            .post(_this.reAPI, { hash: _this.txHash })
            .then(function(response) {
              let data = response.data;
              if (data.code === 0) {
                if (data.data.result) {
                  _this.contractRegId = data.data.result.regid;
                  _this.ifGetRegId = true;
                  _this.$emit(
                    "errorLog",
                    "Yes",
                    "publish contract txhash:" +
                      _this.txHash +
                      ",\ncontract regid: " +
                      _this.contractRegId
                  );
                } else {
                  _this.ifGetRegId = false;
                  _this.contractRegId = data.data.error.message;
                }
              } else {
                _this.$emit("errorLog", data.message);
              }
            })
            .catch(function(error) {
              _this.$emit("errorLog", error.message);
            });
        }
        setTimeout(function() {
          _this.rotates = 0;
        }, 1100);
      }
    },
    check(error, data, from) {
      if (error === null) {
        if (from === "deploy") {
          this.txHash = data.txid;
          this.$emit("errorLog", "Yes", this.txHash);
        } else {
          this.invokeTxHash = data.txid;
          this.$emit("errorLog", "Yes", this.invokeTxHash);
        }
      } else {
        this.$emit("errorLog", error.message);
        if (from === "deploy") {
          this.txHash = "";
        } else {
          this.invokeTxHash = "";
        }
      }
    }
  }
};
</script>

<style scoped src="../assets/execute.less" lang="less"></style>
