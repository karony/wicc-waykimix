<template>
  <div class="tool">
    <p class="converter">Converter</p>
    <p class="decode">Enter the hexadecimal text to decode</p>
    <div class="content">
      <ul>
        <li v-for="item in tabs" @click="tab(item)" :key="item.index" :class="item.index===tabIndex?'active':'' ">{{item.name}}</li>
      </ul>
      <textarea class="inputData" v-model="origin"></textarea>
    </div>
    <p class="convert" @click="setDecode">Convert</p>
    <div class="content">
      <textarea class="inputData" v-model="result"></textarea>
    </div>
  </div>
</template>

<script>
  export default {
    name: "debug",
    data () {
      return {
        tabs:[
          { index:0,name:'Number' },
          { index:1,name:'Char' },
          { index:2,name:'UTF-8' },
        ],
        tabIndex:0,
        origin:'',
        result:''
      }
    },
    methods:{
      tab(data){
        this.tabIndex = data.index;
        this.origin = '';
        this.result = '';
      },
      reverseString (str) {
        let temp = str.slice();
        return temp.split('').reverse().join('');
      },
      codeToNumber () {
        let reverseStr = this.reverseString(this.origin),
          i = 0, numberStr = '', arr = [];
        while (i < reverseStr.length) {
          if (reverseStr[i] != 0) {
            numberStr = reverseStr.substring(i);
            if ((numberStr.length % 2) != 0) {
              numberStr = '0' + numberStr
            }
            numberStr = this.reverseString(numberStr)
            break;
          }
          i++
        }
        for (let i = 0; i < numberStr.length; i += 2) {
          arr.push(numberStr.substr(i, 2))
        }
        this.result = parseInt(arr.reverse().join(''), 16)
      },
      codeToChar () {
        let arr = [];
        for(let i = 0; i < this.origin.length; i += 2 ) {
          let temp = parseInt(this.origin.slice(i, i + 2), 16);
          arr.push(String.fromCharCode(temp))
        }
        this.result = arr.join('')
      },
      decodeUTF8 () {
        let arr = [];
        for(let i = 0; i < this.origin.length; i += 2 ) {
          arr.push('%' + this.origin.slice(i, i + 2))
        }
        this.result = this.getUTFCode(arr.join(''))
      },
      decodeBase64 () {
        this.result = this.getUTFCode(window.atob(this.origin))
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
      setDecode () {
        switch (+this.tabIndex) {
          case 0: this.codeToNumber();break;
          case 1: this.codeToChar();break;
          case 2: this.decodeUTF8();break;
          case 3: this.decodeBase64();
        }
      }
    }
  }
</script>

<style scoped src="../assets/tool.less" lang="less"></style>
