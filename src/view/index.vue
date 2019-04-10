<template>
  <el-container style="height:100%;">
    <aside class="el-aside" style="width: auto;">
      <div v-show="fileExplorerCollapse" :style="{ height: contentHeight + 'px'}" class="coll">
        <span @click="fileExplorerCollapse = false"><i class="el-icon-d-arrow-right"></i></span>
      </div>
      <vue-draggable-resizable
        v-show="!fileExplorerCollapse"
        :draggable="false"
        :w="200"
        :min-width = "150"
        :max-width = "400"
        :handles="['mr']"
        drag-cancel=".enableFocus"
        :style="{ height: contentHeight + 'px'}"
        class="fileExplorerContainer"
        style="margin-right:6px;position: relative;"
        axis="x"
      >
        <!--@resizestop="resizestop"-->
        <div class="enableFocus left">
          <p class="tree">
            <i @click="ifShowTree=!ifShowTree" v-if="ifShowTree" class="el-icon-caret-bottom"></i>
            <i @click="ifShowTree=!ifShowTree" v-if="!ifShowTree" class="el-icon-caret-right"></i>
            <label style="font-size:17px;">lua</label>
            <span class="file">
              <input id="file" type="file" @change="jsReadFiles($event)"/>
            </span>
            <span @click="exportFile" style="margin-left:5px;"><i class="el-icon-download" style="font-size: 16px;"></i></span>
            <span @click="showShade=true" style="margin-left:5px;"><i class="el-icon-plus"></i></span>
            <span @click="fileExplorerCollapse = true"><i class="el-icon-d-arrow-left"></i></span>
          </p>
          <ul v-if="ifShowTree" class="note">
            <li v-for="(item,index) in Object.keys(localTree)" :key="index" @click="handleNodeClick(item,localTree[item])">
              <span class="textName" v-if="ifRename" @dblclick="reName(index)">{{localTree[item].label}}</span>
              <!--@dblclick="ifRename = false"-->
              <input v-else type="text" v-model="localTree[item].label" @blur="editName()" />
              <span style="float: right;"><i @click.stop="delNode(item)" class="el-icon-delete" style="color: #777;"></i></span>
            </li>
          </ul>
        </div>
      </vue-draggable-resizable>
    </aside>
    <el-container class="main el-container is-vertical">
      <el-main style="padding:0;position: relative">
        <div class="input">
          <p class="tabList" v-if="Object.keys(localTab).length">
            <span v-for="(key,index) in Object.keys(localTab)" :key="index" :style="{fontSize: fontSize + 'px'}" :class="currentIndex==index?'active': ''" @click="handleClick(key,index)">
              {{localTab[key].label}} <i style="margin-left: 10px;" class="el-icon-close" @click.stop="removeTab(key)"></i>
            </span>
          </p>
          <codemirror v-if="Object.keys(localTab).length>0" ref="myCm" v-model="code" :style="{fontSize: fontSize + 'px', height: (contentHeight-110) + 'px'}" :options="cmOptions" class="code" ></codemirror>
        </div>
        <div class="line3">
          <select class="fontSize" v-model="fontSize">
            <option v-for="item in fontSizeList" :value="item">{{item}}</option>
          </select>
        </div>
      </el-main>
    </el-container>
    <el-aside width="auto">
      <vue-draggable-resizable
        :w="500"
        :min-width = "350"
        :max-width = "900"
        :handles="['ml']"
        :draggable="false"
        :style="{ height: contentHeight + 'px'}"
        class="tabContainer"
        drag-cancel=".enableFocus"
        axis="x"
        style="left:10px; margin-right:16px;position: relative;"
      >
        <div class="enableFocus right" >
          <div class="button">
            <p v-for="(item,index) in tabPage" @click="changeTab(item)" :key="index" :class="tabIndex==index?'active': ''">{{item.name}}</p>
          </div>
          <div style="color: #fff;padding:10px;">
            <v-execute :code="code" :tabIndex="tabIndex"></v-execute>
          </div>
        </div>
      </vue-draggable-resizable>
    </el-aside>
    <div v-if="showShade" class="shade">
      <header>New Lua File
        <span style="float: right;display: inline-block;padding-right: 10px;">
          <i @click="showShade=false" class="el-icon-close"></i>
        </span>
      </header>
      <div>
        <p>
          <label>Name:</label>
          <input type="text" v-model="fileName" />
        </p>
        <footer>
          <span @click="onSubmit()" style="margin-right:10px;">OK</span>
          <span @click="showShade=false">CANCEL</span>
        </footer>
      </div>
    </div>
  </el-container>
</template>

<script>
  import VueDraggableResizable from 'vue-draggable-resizable'
  import FileSaver from 'file-saver'
  import execute from '../components/execute'

  import { codemirror } from 'vue-codemirror'
  import "codemirror/theme/ambiance.css";
  import "codemirror/lib/codemirror.css";
  import "codemirror/addon/hint/show-hint.css";
  import 'codemirror/theme/monokai.css'
  import 'codemirror/mode/javascript/javascript'
  import 'codemirror/mode/lua/lua.js'
  import'codemirror/addon/selection/active-line.js'

  // hint
  import'codemirror/addon/hint/javascript-hint.js'
  import'codemirror/addon/selection/active-line.js'
  // highlightSelectionMatches
  import'codemirror/addon/search/searchcursor.js'
  import'codemirror/addon/search/match-highlighter.js'
  // keyMap
  import'codemirror/addon/search/searchcursor.js'
  import'codemirror/addon/search/search.js'
  import'codemirror/keymap/sublime.js'

  export default {
    components: {
      VueDraggableResizable,
      'v-execute':execute,
      codemirror
    },
    data () {
      return {
        fileExplorerCollapse:false,
        cmOptions:{
          tabSize:4,
          styleActiveLine: true,
          line: true,
          mode: 'text/x-lua',
          indentWithTabs: true,
          foldGutter: true,
          highlightSelectionMatches: { showToken: /\w/, annotateScrollbar: true },
          smartIndent: true,
          lineNumbers: true,//显示行数
          theme: 'monokai',//主题色
          matchBrackets:true, //匹配括号
          keyMap: "sublime",
          hintOptions:{
            // 当匹配只有一项的时候是否自动补全
            completeSingle: true
          },
          showCursorWhenSelecting: true,
          gutters: ['CodeMirror-linenumbers', 'breakpoints'],
          extraKeys: {'Ctrl': 'autocomplete'},//自定义快捷键
        },
        contentHeight:window.innerHeight,
        ifShowTree:true,
        localTree:JSON.parse(localStorage.getItem("localTree"))||{},
        localTab:JSON.parse(localStorage.getItem("localTab"))||{},
        currentTabHash:localStorage.getItem("currentTabHash"),
        ifRename:true,
        fontSizeList:[12,13,14,15,16,17,18,19,20],
        fontSize:13,//默认字号
        tabPage:[
          {index:1,name:'Deploy'},{index:2,name:'Run'},{index:3,name:'Tool'},{index:4,name:'Help'} //{index:4,name:'Debug'},
        ],
        tabIndex:parseInt(localStorage.getItem("tabIndex")) || 0,
        showShade:false,
        code:'',
        currentIndex:localStorage.getItem("currentIndex") || 0,
        fileName:'',
      }
    },
    watch:{
      code(val){
        this.localTab[this.currentTabHash].content = val;
        this.localTree[this.currentTabHash].content = val;
        localStorage.setItem("localTab", JSON.stringify(this.localTab));
        localStorage.setItem("localTree", JSON.stringify(this.localTree));
        this.localTree = JSON.parse(localStorage.getItem("localTree"));
        this.localTab = JSON.parse(localStorage.getItem("localTab"));
      }
    },
    mounted () {
      if(JSON.stringify(this.localTab)==='{}'){
        this.code = ''
      }else{
        this.code = this.localTab[parseInt(this.currentTabHash)].content
      }
      this.getDefault()
    },
    methods:{
      reName(index){
        alert(index)
      },
      getDefault(){
        let _this = this;
        if(!JSON.parse(localStorage.getItem("localTree"))){
          _this.code='mylib = require "mylib"\n' + '\n' + 'Main = function()\n' + '\n' + 'end\n' + '\n' + 'Main()';
          let time = new Date().getTime();
          _this.localTab[time]={label:'demo.lua',content:_this.code};
          _this.localTree[time]={label:'demo.lua',content:_this.code};
          localStorage.setItem("localTab", JSON.stringify(_this.localTab));
          localStorage.setItem("localTree", JSON.stringify(_this.localTree));
          this.currentTabHash = time ;
          localStorage.setItem("currentTabHash",_this.currentTabHash);
        }
      },
      exportFile(){
        let name = this.localTab[this.currentTabHash].label;
        const data = this.code;
        const blob = new Blob([data], {type: "text/plain;charset=utf-8"});
        FileSaver.saveAs(blob, name)
      },
      editName(){
        this.ifRename = true;
        localStorage.setItem("localTab", JSON.stringify(this.localTab));
        localStorage.setItem("localTree", JSON.stringify(this.localTree));
      },
      changeTab(item){
        this.tabIndex = item.index-1;
        localStorage.setItem("tabIndex",this.tabIndex);
      },
      handleNodeClick(key,obj) {
        let _this = this;
        this.currentIndex = 0;
        this.code = obj.content;
        localStorage.setItem("currentIndex",this.currentIndex);
        if(_this.localTab[key]){
          delete _this.localTab[key];
        }
        _this.localTab = {[key]:obj, ...(_this.localTab)};
        _this.currentTabHash = key;
        localStorage.setItem("currentTabHash", key);
        localStorage.setItem("localTab", JSON.stringify(this.localTab));
      },
      handleClick(hash,index) {
        this.currentIndex = index;
        this.currentTabHash = hash;
        localStorage.setItem("currentTabHash", hash);
        localStorage.setItem("currentIndex",this.currentIndex);
        this.code = this.localTab[hash].content;
      },
      //删除树节点
      delNode(data){
        this.localTree = JSON.parse(localStorage.getItem("localTree"));
        delete this.localTree[data];
        localStorage.setItem("localTree", JSON.stringify(this.localTree));
        //this.getNextHash(data);
        //同时移除对应的打开的tab节点
        this.removeTab(data)
      },
      removeTab(data){
        this.localTab = JSON.parse(localStorage.getItem("localTab"));
        this.currentIndex = parseInt(this.currentIndex);
        let keyArr = Object.keys(this.localTab);
        let hash = keyArr.indexOf(data);
        if(hash===-1){
          return false;
        }
        if(hash<this.currentIndex){
          this.currentIndex = this.currentIndex-1;
          this.currentTabHash = data;
        }else if(hash===parseInt(this.currentIndex)){
          if(hash+1===keyArr.length){
            if(keyArr.length>1){
              this.currentTabHash = keyArr[hash-1];
              this.currentIndex = this.currentIndex-1;
              this.code = this.localTab[this.currentTabHash].content;
              localStorage.setItem("currentIndex",this.currentIndex);
            }else{
              this.code='';
            }
          }else{
            this.currentTabHash = keyArr[this.currentIndex+1];
            this.code = this.localTab[keyArr[this.currentIndex+1]].content;
          }
        }else{
          console.log(this.currentTabHash)
        }
        delete this.localTab[data];
        localStorage.setItem("currentIndex",this.currentIndex);
        localStorage.setItem("currentTabHash",  this.currentTabHash);
        localStorage.setItem("localTab", JSON.stringify(this.localTab));
      },
      getResult(fileName){
        let _this = this;
        let result = Object.keys(_this.localTree).some((item, index) => {
          return _this.localTree[item].label === fileName+'.lua';
        });
        return result
      },
      onSubmit(){
        let _this = this;
        if(_this.fileName===''){
          this.$message('Please enter the name of the file.');
          return false ;
        }
        _this.fileName = _this.fileName.split('.')[0];
        if(_this.getResult(_this.fileName)){
          this.$message('The file name you entered already exists. Please re-enter it.');
          return false ;
        }
        _this.code= '';
        _this.showShade = false;
        let time = new Date().getTime();
        _this.localTab = {[time]: {label:_this.fileName+'.lua',content:''}, ...(_this.localTab)};
        (_this.localTree)[time]={label:_this.fileName+'.lua',content:''};
        localStorage.setItem("localTab", JSON.stringify(_this.localTab));
        localStorage.setItem("localTree", JSON.stringify(_this.localTree));
        this.currentTabHash = time ;
        localStorage.setItem("currentTabHash",_this.currentTabHash);
        this.fileName='';
      },
      jsReadFiles(ev) {
        let _this = this;
        let file = ev.currentTarget.files[0];
        let reader = new FileReader();//new一个FileReader实例
        if (/lua+/.test(file.name)) {//判断文件类型，是不是text类型
          reader.onload = function () {
            let time = new Date().getTime();
            _this.currentTabHash = time ;
            _this.localTree[time]={label:file.name,content:this.result};
            _this.localTab = {[time]: {label:file.name,content:this.result}, ...(_this.localTab)};
            _this.code= this.result;
            _this.currentIndex =0 ;
            localStorage.setItem("localTab", JSON.stringify(_this.localTab));
            localStorage.setItem("currentTabHash",_this.currentTabHash);
            localStorage.setItem("localTree", JSON.stringify(_this.localTree));
          };
          reader.readAsText(file);
          let files = document.getElementById('file');
          files.value = '';
        } else {
          this.$message('Please open a Lua file');
        }
      }
    }
  }
</script>
<style scoped src="../assets/index.less" lang='less'></style>
