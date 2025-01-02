const t="3.7.7";
/**
 * @deprecated use lowercase `version`.
 */const e=t;const r=typeof Buffer==="function";const o=typeof TextDecoder==="function"?new TextDecoder:void 0;const n=typeof TextEncoder==="function"?new TextEncoder:void 0;const c="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";const a=Array.prototype.slice.call(c);const s=(t=>{let e={};t.forEach(((t,r)=>e[t]=r));return e})(a);const i=/^(?:[A-Za-z\d+\/]{4})*?(?:[A-Za-z\d+\/]{2}(?:==)?|[A-Za-z\d+\/]{3}=?)?$/;const f=String.fromCharCode.bind(String);const u=typeof Uint8Array.from==="function"?Uint8Array.from.bind(Uint8Array):t=>new Uint8Array(Array.prototype.slice.call(t,0));const _mkUriSafe=t=>t.replace(/=/g,"").replace(/[+\/]/g,(t=>t=="+"?"-":"_"));const _tidyB64=t=>t.replace(/[^A-Za-z0-9\+\/]/g,"");const btoaPolyfill=t=>{let e,r,o,n,c="";const s=t.length%3;for(let s=0;s<t.length;){if((r=t.charCodeAt(s++))>255||(o=t.charCodeAt(s++))>255||(n=t.charCodeAt(s++))>255)throw new TypeError("invalid character found");e=r<<16|o<<8|n;c+=a[e>>18&63]+a[e>>12&63]+a[e>>6&63]+a[e&63]}return s?c.slice(0,s-3)+"===".substring(s):c};
/**
 * does what `window.btoa` of web browsers do.
 * @param {String} bin binary string
 * @returns {string} Base64-encoded string
 */const l=typeof btoa==="function"?t=>btoa(t):r?t=>Buffer.from(t,"binary").toString("base64"):btoaPolyfill;const d=r?t=>Buffer.from(t).toString("base64"):t=>{const e=4096;let r=[];for(let o=0,n=t.length;o<n;o+=e)r.push(f.apply(null,t.subarray(o,o+e)));return l(r.join(""))};
/**
 * converts a Uint8Array to a Base64 string.
 * @param {boolean} [urlsafe] URL-and-filename-safe a la RFC4648 §5
 * @returns {string} Base64 string
 */const fromUint8Array=(t,e=false)=>e?_mkUriSafe(d(t)):d(t);const cb_utob=t=>{if(t.length<2){var e=t.charCodeAt(0);return e<128?t:e<2048?f(192|e>>>6)+f(128|e&63):f(224|e>>>12&15)+f(128|e>>>6&63)+f(128|e&63)}e=65536+1024*(t.charCodeAt(0)-55296)+(t.charCodeAt(1)-56320);return f(240|e>>>18&7)+f(128|e>>>12&63)+f(128|e>>>6&63)+f(128|e&63)};const h=/[\uD800-\uDBFF][\uDC00-\uDFFFF]|[^\x00-\x7F]/g;
/**
 * @deprecated should have been internal use only.
 * @param {string} src UTF-8 string
 * @returns {string} UTF-16 string
 */const utob=t=>t.replace(h,cb_utob);const A=r?t=>Buffer.from(t,"utf8").toString("base64"):n?t=>d(n.encode(t)):t=>l(utob(t))
/**
 * converts a UTF-8-encoded string to a Base64 string.
 * @param {boolean} [urlsafe] if `true` make the result URL-safe
 * @returns {string} Base64 string
 */;const encode=(t,e=false)=>e?_mkUriSafe(A(t)):A(t)
/**
 * converts a UTF-8-encoded string to URL-safe Base64 RFC4648 §5.
 * @returns {string} Base64 string
 */;const encodeURI=t=>encode(t,true);const p=/[\xC0-\xDF][\x80-\xBF]|[\xE0-\xEF][\x80-\xBF]{2}|[\xF0-\xF7][\x80-\xBF]{3}/g;const cb_btou=t=>{switch(t.length){case 4:var e=(7&t.charCodeAt(0))<<18|(63&t.charCodeAt(1))<<12|(63&t.charCodeAt(2))<<6|63&t.charCodeAt(3),r=e-65536;return f(55296+(r>>>10))+f(56320+(r&1023));case 3:return f((15&t.charCodeAt(0))<<12|(63&t.charCodeAt(1))<<6|63&t.charCodeAt(2));default:return f((31&t.charCodeAt(0))<<6|63&t.charCodeAt(1))}};
/**
 * @deprecated should have been internal use only.
 * @param {string} src UTF-16 string
 * @returns {string} UTF-8 string
 */const btou=t=>t.replace(p,cb_btou);const atobPolyfill=t=>{t=t.replace(/\s+/g,"");if(!i.test(t))throw new TypeError("malformed base64.");t+="==".slice(2-(t.length&3));let e,r,o,n="";for(let c=0;c<t.length;){e=s[t.charAt(c++)]<<18|s[t.charAt(c++)]<<12|(r=s[t.charAt(c++)])<<6|(o=s[t.charAt(c++)]);n+=r===64?f(e>>16&255):o===64?f(e>>16&255,e>>8&255):f(e>>16&255,e>>8&255,e&255)}return n};
/**
 * does what `window.atob` of web browsers do.
 * @param {String} asc Base64-encoded string
 * @returns {string} binary string
 */const y=typeof atob==="function"?t=>atob(_tidyB64(t)):r?t=>Buffer.from(t,"base64").toString("binary"):atobPolyfill;const b=r?t=>u(Buffer.from(t,"base64")):t=>u(y(t).split("").map((t=>t.charCodeAt(0))));const toUint8Array=t=>b(_unURI(t));const g=r?t=>Buffer.from(t,"base64").toString("utf8"):o?t=>o.decode(b(t)):t=>btou(y(t));const _unURI=t=>_tidyB64(t.replace(/[-_]/g,(t=>t=="-"?"+":"/")))
/**
 * converts a Base64 string to a UTF-8 string.
 * @param {String} src Base64 string.  Both normal and URL-safe are supported
 * @returns {string} UTF-8 string
 */;const decode=t=>g(_unURI(t))
/**
 * check if a value is a valid Base64 string
 * @param {String} src a value to check
  */;const isValid=t=>{if(typeof t!=="string")return false;const e=t.replace(/\s+/g,"").replace(/={0,2}$/,"");return!/[^\s0-9a-zA-Z\+/]/.test(e)||!/[^\s0-9a-zA-Z\-_]/.test(e)};const _noEnum=t=>({value:t,enumerable:false,writable:true,configurable:true});const extendString=function(){const _add=(t,e)=>Object.defineProperty(String.prototype,t,_noEnum(e));_add("fromBase64",(function(){return decode(this)}));_add("toBase64",(function(t){return encode(this,t)}));_add("toBase64URI",(function(){return encode(this,true)}));_add("toBase64URL",(function(){return encode(this,true)}));_add("toUint8Array",(function(){return toUint8Array(this)}))};const extendUint8Array=function(){const _add=(t,e)=>Object.defineProperty(Uint8Array.prototype,t,_noEnum(e));_add("toBase64",(function(t){return fromUint8Array(this,t)}));_add("toBase64URI",(function(){return fromUint8Array(this,true)}));_add("toBase64URL",(function(){return fromUint8Array(this,true)}))};const extendBuiltins=()=>{extendString();extendUint8Array()};const B={version:t,VERSION:e,atob:y,atobPolyfill:atobPolyfill,btoa:l,btoaPolyfill:btoaPolyfill,fromBase64:decode,toBase64:encode,encode:encode,encodeURI:encodeURI,encodeURL:encodeURI,utob:utob,btou:btou,decode:decode,isValid:isValid,fromUint8Array:fromUint8Array,toUint8Array:toUint8Array,extendString:extendString,extendUint8Array:extendUint8Array,extendBuiltins:extendBuiltins};export{B as Base64,e as VERSION,y as atob,atobPolyfill,l as btoa,btoaPolyfill,btou,decode,encode,encodeURI,encodeURI as encodeURL,extendBuiltins,extendString,extendUint8Array,decode as fromBase64,fromUint8Array,isValid,encode as toBase64,toUint8Array,utob,t as version};

