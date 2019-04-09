<template>
  <div>
    <codemirror ref="myCm" @input="onCmCodeChange" @gutterClick="onGutterClick" :value="code" :options="cmOptions" class="code" :style="{fontSize: fontSize + 'px'}" ></codemirror>
  </div>
</template>

<script>
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
    props:{
      codes:{
        type:String,
        default:''
      },
      fontSize:{
        type:Number,
        default:'12'
      }
    },
    data () {
      return {
        code:this.codes,
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
        }
      }
    },
    components:{
      codemirror
    },
    watch:{
      codes(val){
        this.code = val;
      }
    },
    methods:{
      onCmCodeChange(code){
        this.$emit('getCode',code)
      },
      onGutterClick(cm,n){
        const info = cm.lineInfo(n);
        cm.setGutterMarker(n, 'breakpoints', info.gutterMarkers ? null : this.makeMarker())
      },
      makeMarker() {
        const marker = document.createElement('div');
        marker.style.color = '#fff';
        marker.innerHTML = '●';
        return marker
      }
    },
    mounted () {}
}
</script>
