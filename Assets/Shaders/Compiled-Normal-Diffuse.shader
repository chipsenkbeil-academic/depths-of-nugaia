Shader "Diffuse" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_MainTex ("Base (RGB)", 2D) = "white" {}
}
SubShader {
	Tags { "RenderType"="Opaque" }
	LOD 200

	
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardBase" }
Program "vp" {
// Vertex combos: 8
//   opengl - ALU: 6 to 63
//   d3d9 - ALU: 6 to 63
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 9 [unity_Scale]
Matrix 5 [_Object2World]
Vector 10 [unity_SHAr]
Vector 11 [unity_SHAg]
Vector 12 [unity_SHAb]
Vector 13 [unity_SHBr]
Vector 14 [unity_SHBg]
Vector 15 [unity_SHBb]
Vector 16 [unity_SHC]
Vector 17 [_MainTex_ST]
"!!ARBvp1.0
# 27 ALU
PARAM c[18] = { { 1 },
		state.matrix.mvp,
		program.local[5..17] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R1.xyz, vertex.normal, c[9].w;
DP3 R3.w, R1, c[6];
DP3 R2.w, R1, c[7];
DP3 R0.x, R1, c[5];
MOV R0.y, R3.w;
MOV R0.z, R2.w;
MUL R1, R0.xyzz, R0.yzzx;
MOV R0.w, c[0].x;
DP4 R2.z, R0, c[12];
DP4 R2.y, R0, c[11];
DP4 R2.x, R0, c[10];
MUL R0.y, R3.w, R3.w;
DP4 R3.z, R1, c[15];
DP4 R3.y, R1, c[14];
DP4 R3.x, R1, c[13];
MAD R0.y, R0.x, R0.x, -R0;
MUL R1.xyz, R0.y, c[16];
ADD R2.xyz, R2, R3;
ADD result.texcoord[2].xyz, R2, R1;
MOV result.texcoord[1].z, R2.w;
MOV result.texcoord[1].y, R3.w;
MOV result.texcoord[1].x, R0;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[17], c[17].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 27 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_Scale]
Matrix 4 [_Object2World]
Vector 9 [unity_SHAr]
Vector 10 [unity_SHAg]
Vector 11 [unity_SHAb]
Vector 12 [unity_SHBr]
Vector 13 [unity_SHBg]
Vector 14 [unity_SHBb]
Vector 15 [unity_SHC]
Vector 16 [_MainTex_ST]
"vs_2_0
; 27 ALU
def c17, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c8.w
dp3 r3.w, r1, c5
dp3 r2.w, r1, c6
dp3 r0.x, r1, c4
mov r0.y, r3.w
mov r0.z, r2.w
mul r1, r0.xyzz, r0.yzzx
mov r0.w, c17.x
dp4 r2.z, r0, c11
dp4 r2.y, r0, c10
dp4 r2.x, r0, c9
mul r0.y, r3.w, r3.w
dp4 r3.z, r1, c14
dp4 r3.y, r1, c13
dp4 r3.x, r1, c12
mad r0.y, r0.x, r0.x, -r0
mul r1.xyz, r0.y, c15
add r2.xyz, r2, r3
add oT2.xyz, r2, r1
mov oT1.z, r2.w
mov oT1.y, r3.w
mov oT1.x, r0
mad oT0.xy, v2, c16, c16.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "xbox360 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 15 [_MainTex_ST]
Matrix 5 [_Object2World] 3
Matrix 0 [glstate_matrix_mvp] 4
Vector 10 [unity_SHAb]
Vector 9 [unity_SHAg]
Vector 8 [unity_SHAr]
Vector 13 [unity_SHBb]
Vector 12 [unity_SHBg]
Vector 11 [unity_SHBr]
Vector 14 [unity_SHC]
Vector 4 [unity_Scale]
// Shader Timing Estimate, in Cycles/64 vertex vector:
// ALU: 25.33 (19 instructions), vertex: 32, texture: 0,
//   sequencer: 14,  5 GPRs, 31 threads,
// Performance (if enough threads): ~32 cycles per vector
// * Vertex cycle estimates are assuming 3 vfetch_minis for every vfetch_full,
//     with <= 32 bytes per vfetch_full group.

"vs_360
backbbabaaaaacciaaaaabeeaaaaaaaaaaaaaaceaaaaaaaaaaaaabnmaaaaaaaa
aaaaaaaaaaaaableaaaaaabmaaaaabkgpppoadaaaaaaaaalaaaaaabmaaaaaaaa
aaaaabjpaaaaaapiaaacaaapaaabaaaaaaaaabaeaaaaaaaaaaaaabbeaaacaaaf
aaadaaaaaaaaabceaaaaaaaaaaaaabdeaaacaaaaaaaeaaaaaaaaabceaaaaaaaa
aaaaabehaaacaaakaaabaaaaaaaaabaeaaaaaaaaaaaaabfcaaacaaajaaabaaaa
aaaaabaeaaaaaaaaaaaaabfnaaacaaaiaaabaaaaaaaaabaeaaaaaaaaaaaaabgi
aaacaaanaaabaaaaaaaaabaeaaaaaaaaaaaaabhdaaacaaamaaabaaaaaaaaabae
aaaaaaaaaaaaabhoaaacaaalaaabaaaaaaaaabaeaaaaaaaaaaaaabijaaacaaao
aaabaaaaaaaaabaeaaaaaaaaaaaaabjdaaacaaaeaaabaaaaaaaaabaeaaaaaaaa
fpengbgjgofegfhifpfdfeaaaaabaaadaaabaaaeaaabaaaaaaaaaaaafpepgcgk
gfgdhedcfhgphcgmgeaaklklaaadaaadaaaeaaaeaaabaaaaaaaaaaaaghgmhdhe
gbhegffpgngbhehcgjhifpgnhghaaahfgogjhehjfpfdeiebgcaahfgogjhehjfp
fdeiebghaahfgogjhehjfpfdeiebhcaahfgogjhehjfpfdeiecgcaahfgogjhehj
fpfdeiecghaahfgogjhehjfpfdeiechcaahfgogjhehjfpfdeiedaahfgogjhehj
fpfdgdgbgmgfaahghdfpddfpdaaadccodacodcdadddfddcodaaaklklaaaaaaaa
aaaaabeeaacbaaaeaaaaaaaaaaaaaaaaaaaacagdaaaaaaabaaaaaaadaaaaaaad
aaaaacjaaabaaaaeaaaadaafaadafaagaaaadafaaaabhbfbaaachcfcaaaababa
aaaabaapaaaababjhabfdaaeaaaabcaamcaaaaaaaaaaeaahaaaabcaameaaaaaa
aaaagaalgabbbcaabcaaaaaaaaaadabhaaaaccaaaaaaaaaaafpidaaaaaaaagii
aaaaaaaaafpibaaaaaaaaoiiaaaaaaaaafpiaaaaaaaaapmiaaaaaaaamiapaaac
aabliiaakbadadaamiapaaacaamgiiaakladacacmiapaaacaalbdejekladabac
miapiadoaagmaadekladaaacmialaaabaagfblaakbabaeaamiahaaacaalbleaa
kbabahaamiahaaabaagmlemaklabagacmiahaaadaabllemaklabafabmiahiaab
aaleleaaocadadaamiadiaaaaalalabkilaaapapceipadaeaalehcgmobadadia
miabaaacaadoanaagpaiadaamiacaaacaadoanaagpajadaamiaeaaacaadoanaa
gpakadaamiabaaaaaakhkhaakpaealaaaibcabaaaakhkhgmkpaeamadaiceabaa
aakhkhmgkpaeanadgeihaaaaaalologboaacaaabmiahiaacaablmagfklaaaoaa
aaaaaaaaaaaaaaaaaaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 256 [glstate_matrix_mvp]
Vector 467 [unity_Scale]
Matrix 260 [_Object2World]
Vector 466 [unity_SHAr]
Vector 465 [unity_SHAg]
Vector 464 [unity_SHAb]
Vector 463 [unity_SHBr]
Vector 462 [unity_SHBg]
Vector 461 [unity_SHBb]
Vector 460 [unity_SHC]
Vector 459 [_MainTex_ST]
"sce_vp_rsx // 24 instructions using 3 registers
[Configuration]
8
0000001801050300
[Microcode]
384
00001c6c009d320c013fc0c36041dffc401f9c6c011cb808010400d740619f9c
401f9c6c01d0300d8106c0c360403f80401f9c6c01d0200d8106c0c360405f80
401f9c6c01d0100d8106c0c360409f80401f9c6c01d0000d8106c0c360411f80
00011c6c0150600c008600c360411ffc00009c6c0150400c008600c360411ffc
00001c6c0150500c008600c360411ffc401f9c6c004000000286c08360411fa0
00001c6c008000000080004360403ffc40009c6c004000000086c08360409fa0
40009c6c004000000486c08360405fa000001c6c019d000c0286c0c360405ffc
00001c6c019d100c0286c0c360409ffc00001c6c019d200c0286c0c360411ffc
00001c6c010000000280017fe0203ffc00009c6c0080000d029a01436041fffc
00011c6c01dcd00d8286c0c360405ffc00011c6c01dce00d8286c0c360409ffc
00011c6c01dcf00d8286c0c360411ffc00001c6c00c0000c0086c0830121dffc
00009c6c009cc07f808600c36041dffc401f9c6c00c0000c0286c0830021dfa5
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = tmpvar_4;
  mediump vec3 tmpvar_6;
  mediump vec4 normal;
  normal = tmpvar_5;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_7;
  tmpvar_7 = dot (unity_SHAr, normal);
  x1.x = tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = dot (unity_SHAg, normal);
  x1.y = tmpvar_8;
  highp float tmpvar_9;
  tmpvar_9 = dot (unity_SHAb, normal);
  x1.z = tmpvar_9;
  mediump vec4 tmpvar_10;
  tmpvar_10 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_11;
  tmpvar_11 = dot (unity_SHBr, tmpvar_10);
  x2.x = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHBg, tmpvar_10);
  x2.y = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHBb, tmpvar_10);
  x2.z = tmpvar_13;
  mediump float tmpvar_14;
  tmpvar_14 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = (unity_SHC.xyz * vC);
  x3 = tmpvar_15;
  tmpvar_6 = ((x1 + x2) + x3);
  shlight = tmpvar_6;
  tmpvar_2 = shlight;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_1.xyz * _LightColor0.xyz) * (max (0.0, dot (xlv_TEXCOORD1, _WorldSpaceLightPos0.xyz)) * 2.0));
  c_i0_i1.w = tmpvar_1.w;
  c = c_i0_i1;
  c.xyz = (c_i0_i1.xyz + (tmpvar_1.xyz * xlv_TEXCOORD2));
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = tmpvar_4;
  mediump vec3 tmpvar_6;
  mediump vec4 normal;
  normal = tmpvar_5;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_7;
  tmpvar_7 = dot (unity_SHAr, normal);
  x1.x = tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = dot (unity_SHAg, normal);
  x1.y = tmpvar_8;
  highp float tmpvar_9;
  tmpvar_9 = dot (unity_SHAb, normal);
  x1.z = tmpvar_9;
  mediump vec4 tmpvar_10;
  tmpvar_10 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_11;
  tmpvar_11 = dot (unity_SHBr, tmpvar_10);
  x2.x = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHBg, tmpvar_10);
  x2.y = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHBb, tmpvar_10);
  x2.z = tmpvar_13;
  mediump float tmpvar_14;
  tmpvar_14 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = (unity_SHC.xyz * vC);
  x3 = tmpvar_15;
  tmpvar_6 = ((x1 + x2) + x3);
  shlight = tmpvar_6;
  tmpvar_2 = shlight;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_1.xyz * _LightColor0.xyz) * (max (0.0, dot (xlv_TEXCOORD1, _WorldSpaceLightPos0.xyz)) * 2.0));
  c_i0_i1.w = tmpvar_1.w;
  c = c_i0_i1;
  c.xyz = (c_i0_i1.xyz + (tmpvar_1.xyz * xlv_TEXCOORD2));
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_Scale]
Matrix 4 [_Object2World]
Vector 9 [unity_SHAr]
Vector 10 [unity_SHAg]
Vector 11 [unity_SHAb]
Vector 12 [unity_SHBr]
Vector 13 [unity_SHBg]
Vector 14 [unity_SHBb]
Vector 15 [unity_SHC]
Vector 16 [_MainTex_ST]
"agal_vs
c17 1.0 0.0 0.0 0.0
[bc]
adaaaaaaabaaahacabaaaaoeaaaaaaaaaiaaaappabaaaaaa mul r1.xyz, a1, c8.w
bcaaaaaaadaaaiacabaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 r3.w, r1.xyzz, c5
bcaaaaaaacaaaiacabaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 r2.w, r1.xyzz, c6
bcaaaaaaaaaaabacabaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 r0.x, r1.xyzz, c4
aaaaaaaaaaaaacacadaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.y, r3.w
aaaaaaaaaaaaaeacacaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.z, r2.w
adaaaaaaabaaapacaaaaaakeacaaaaaaaaaaaacjacaaaaaa mul r1, r0.xyzz, r0.yzzx
aaaaaaaaaaaaaiacbbaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c17.x
bdaaaaaaacaaaeacaaaaaaoeacaaaaaaalaaaaoeabaaaaaa dp4 r2.z, r0, c11
bdaaaaaaacaaacacaaaaaaoeacaaaaaaakaaaaoeabaaaaaa dp4 r2.y, r0, c10
bdaaaaaaacaaabacaaaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 r2.x, r0, c9
adaaaaaaaaaaacacadaaaappacaaaaaaadaaaappacaaaaaa mul r0.y, r3.w, r3.w
bdaaaaaaadaaaeacabaaaaoeacaaaaaaaoaaaaoeabaaaaaa dp4 r3.z, r1, c14
bdaaaaaaadaaacacabaaaaoeacaaaaaaanaaaaoeabaaaaaa dp4 r3.y, r1, c13
bdaaaaaaadaaabacabaaaaoeacaaaaaaamaaaaoeabaaaaaa dp4 r3.x, r1, c12
adaaaaaaaeaaacacaaaaaaaaacaaaaaaaaaaaaaaacaaaaaa mul r4.y, r0.x, r0.x
acaaaaaaaaaaacacaeaaaaffacaaaaaaaaaaaaffacaaaaaa sub r0.y, r4.y, r0.y
adaaaaaaabaaahacaaaaaaffacaaaaaaapaaaaoeabaaaaaa mul r1.xyz, r0.y, c15
abaaaaaaacaaahacacaaaakeacaaaaaaadaaaakeacaaaaaa add r2.xyz, r2.xyzz, r3.xyzz
abaaaaaaacaaahaeacaaaakeacaaaaaaabaaaakeacaaaaaa add v2.xyz, r2.xyzz, r1.xyzz
aaaaaaaaabaaaeaeacaaaappacaaaaaaaaaaaaaaaaaaaaaa mov v1.z, r2.w
aaaaaaaaabaaacaeadaaaappacaaaaaaaaaaaaaaaaaaaaaa mov v1.y, r3.w
aaaaaaaaabaaabaeaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov v1.x, r0.x
adaaaaaaaeaaadacadaaaaoeaaaaaaaabaaaaaoeabaaaaaa mul r4.xy, a3, c16
abaaaaaaaaaaadaeaeaaaafeacaaaaaabaaaaaooabaaaaaa add v0.xy, r4.xyyy, c16.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 9 [unity_LightmapST]
Vector 10 [_MainTex_ST]
"!!ARBvp1.0
# 6 ALU
PARAM c[11] = { program.local[0],
		state.matrix.mvp,
		program.local[5..10] };
MAD result.texcoord[0].xy, vertex.texcoord[0], c[10], c[10].zwzw;
MAD result.texcoord[1].xy, vertex.texcoord[1], c[9], c[9].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 6 instructions, 0 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_LightmapST]
Vector 9 [_MainTex_ST]
"vs_2_0
; 6 ALU
dcl_position0 v0
dcl_texcoord0 v2
dcl_texcoord1 v3
mad oT0.xy, v2, c9, c9.zwzw
mad oT1.xy, v3, c8, c8.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "xbox360 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 5 [_MainTex_ST]
Matrix 0 [glstate_matrix_mvp] 4
Vector 4 [unity_LightmapST]
// Shader Timing Estimate, in Cycles/64 vertex vector:
// ALU: 8.00 (6 instructions), vertex: 32, texture: 0,
//   sequencer: 10,  3 GPRs, 31 threads,
// Performance (if enough threads): ~32 cycles per vector
// * Vertex cycle estimates are assuming 3 vfetch_minis for every vfetch_full,
//     with <= 32 bytes per vfetch_full group.

"vs_360
backbbabaaaaabciaaaaaajmaaaaaaaaaaaaaaceaaaaaaaaaaaaaaoeaaaaaaaa
aaaaaaaaaaaaaalmaaaaaabmaaaaaalapppoadaaaaaaaaadaaaaaabmaaaaaaaa
aaaaaakjaaaaaafiaaacaaafaaabaaaaaaaaaageaaaaaaaaaaaaaaheaaacaaaa
aaaeaaaaaaaaaaiiaaaaaaaaaaaaaajiaaacaaaeaaabaaaaaaaaaageaaaaaaaa
fpengbgjgofegfhifpfdfeaaaaabaaadaaabaaaeaaabaaaaaaaaaaaaghgmhdhe
gbhegffpgngbhehcgjhifpgnhghaaaklaaadaaadaaaeaaaeaaabaaaaaaaaaaaa
hfgogjhehjfpemgjghgihegngbhafdfeaahghdfpddfpdaaadccodacodcdadddf
ddcodaaaaaaaaaaaaaaaaajmaabbaaacaaaaaaaaaaaaaaaaaaaabaecaaaaaaab
aaaaaaadaaaaaaacaaaaacjaaabaaaadaaaafaaeaadbfaafaaaadafaaaabdbfb
aaaabaakaaaabaalhabfdaadaaaabcaamcaaaaaaaaaaeaagaaaabcaameaaaaaa
aaaacaakaaaaccaaaaaaaaaaafpicaaaaaaaagiiaaaaaaaaafpiaaaaaaaaacdp
aaaaaaaaafpiaaaaaaaaapmiaaaaaaaamiapaaabaabliiaakbacadaamiapaaab
aamgiiaaklacacabmiapaaabaalbdejeklacababmiapiadoaagmaadeklacaaab
miadiaaaaabklabkilaaafafmiadiaabaalalabkilaaaeaeaaaaaaaaaaaaaaaa
aaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 256 [glstate_matrix_mvp]
Vector 467 [unity_LightmapST]
Vector 466 [_MainTex_ST]
"sce_vp_rsx // 6 instructions using 1 registers
[Configuration]
8
0000000603010100
[Microcode]
96
401f9c6c011d2808010400d740619f9c401f9c6c011d3908010400d740619fa0
401f9c6c01d0300d8106c0c360403f80401f9c6c01d0200d8106c0c360405f80
401f9c6c01d0100d8106c0c360409f80401f9c6c01d0000d8106c0c360411f81
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;

uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  c = vec4(0.0, 0.0, 0.0, 0.0);
  c.xyz = (tmpvar_1.xyz * (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD1).xyz));
  c.w = tmpvar_1.w;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;

uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  c = vec4(0.0, 0.0, 0.0, 0.0);
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (unity_Lightmap, xlv_TEXCOORD1);
  c.xyz = (tmpvar_1.xyz * ((8.0 * tmpvar_2.w) * tmpvar_2.xyz));
  c.w = tmpvar_1.w;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_LightmapST]
Vector 9 [_MainTex_ST]
"agal_vs
[bc]
adaaaaaaaaaaadacadaaaaoeaaaaaaaaajaaaaoeabaaaaaa mul r0.xy, a3, c9
abaaaaaaaaaaadaeaaaaaafeacaaaaaaajaaaaooabaaaaaa add v0.xy, r0.xyyy, c9.zwzw
adaaaaaaaaaaadacaeaaaaoeaaaaaaaaaiaaaaoeabaaaaaa mul r0.xy, a4, c8
abaaaaaaabaaadaeaaaaaafeacaaaaaaaiaaaaooabaaaaaa add v1.xy, r0.xyyy, c8.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
aaaaaaaaabaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.zw, c0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 9 [unity_LightmapST]
Vector 10 [_MainTex_ST]
"!!ARBvp1.0
# 6 ALU
PARAM c[11] = { program.local[0],
		state.matrix.mvp,
		program.local[5..10] };
MAD result.texcoord[0].xy, vertex.texcoord[0], c[10], c[10].zwzw;
MAD result.texcoord[1].xy, vertex.texcoord[1], c[9], c[9].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 6 instructions, 0 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_LightmapST]
Vector 9 [_MainTex_ST]
"vs_2_0
; 6 ALU
dcl_position0 v0
dcl_texcoord0 v2
dcl_texcoord1 v3
mad oT0.xy, v2, c9, c9.zwzw
mad oT1.xy, v3, c8, c8.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "xbox360 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 5 [_MainTex_ST]
Matrix 0 [glstate_matrix_mvp] 4
Vector 4 [unity_LightmapST]
// Shader Timing Estimate, in Cycles/64 vertex vector:
// ALU: 8.00 (6 instructions), vertex: 32, texture: 0,
//   sequencer: 10,  3 GPRs, 31 threads,
// Performance (if enough threads): ~32 cycles per vector
// * Vertex cycle estimates are assuming 3 vfetch_minis for every vfetch_full,
//     with <= 32 bytes per vfetch_full group.

"vs_360
backbbabaaaaabciaaaaaajmaaaaaaaaaaaaaaceaaaaaaaaaaaaaaoeaaaaaaaa
aaaaaaaaaaaaaalmaaaaaabmaaaaaalapppoadaaaaaaaaadaaaaaabmaaaaaaaa
aaaaaakjaaaaaafiaaacaaafaaabaaaaaaaaaageaaaaaaaaaaaaaaheaaacaaaa
aaaeaaaaaaaaaaiiaaaaaaaaaaaaaajiaaacaaaeaaabaaaaaaaaaageaaaaaaaa
fpengbgjgofegfhifpfdfeaaaaabaaadaaabaaaeaaabaaaaaaaaaaaaghgmhdhe
gbhegffpgngbhehcgjhifpgnhghaaaklaaadaaadaaaeaaaeaaabaaaaaaaaaaaa
hfgogjhehjfpemgjghgihegngbhafdfeaahghdfpddfpdaaadccodacodcdadddf
ddcodaaaaaaaaaaaaaaaaajmaabbaaacaaaaaaaaaaaaaaaaaaaabaecaaaaaaab
aaaaaaadaaaaaaacaaaaacjaaabaaaadaaaafaaeaadbfaafaaaadafaaaabdbfb
aaaabaakaaaabaalhabfdaadaaaabcaamcaaaaaaaaaaeaagaaaabcaameaaaaaa
aaaacaakaaaaccaaaaaaaaaaafpicaaaaaaaagiiaaaaaaaaafpiaaaaaaaaacdp
aaaaaaaaafpiaaaaaaaaapmiaaaaaaaamiapaaabaabliiaakbacadaamiapaaab
aamgiiaaklacacabmiapaaabaalbdejeklacababmiapiadoaagmaadeklacaaab
miadiaaaaabklabkilaaafafmiadiaabaalalabkilaaaeaeaaaaaaaaaaaaaaaa
aaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 256 [glstate_matrix_mvp]
Vector 467 [unity_LightmapST]
Vector 466 [_MainTex_ST]
"sce_vp_rsx // 6 instructions using 1 registers
[Configuration]
8
0000000603010100
[Microcode]
96
401f9c6c011d2808010400d740619f9c401f9c6c011d3908010400d740619fa0
401f9c6c01d0300d8106c0c360403f80401f9c6c01d0200d8106c0c360405f80
401f9c6c01d0100d8106c0c360409f80401f9c6c01d0000d8106c0c360411f81
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;

uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  c = vec4(0.0, 0.0, 0.0, 0.0);
  mediump vec3 lm_i0;
  lowp vec3 tmpvar_2;
  tmpvar_2 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD1).xyz);
  lm_i0 = tmpvar_2;
  mediump vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_1.xyz * lm_i0);
  c.xyz = tmpvar_3;
  c.w = tmpvar_1.w;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;

uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  c = vec4(0.0, 0.0, 0.0, 0.0);
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (unity_Lightmap, xlv_TEXCOORD1);
  mediump vec3 lm_i0;
  lowp vec3 tmpvar_3;
  tmpvar_3 = ((8.0 * tmpvar_2.w) * tmpvar_2.xyz);
  lm_i0 = tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_1.xyz * lm_i0);
  c.xyz = tmpvar_4;
  c.w = tmpvar_1.w;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_LightmapST]
Vector 9 [_MainTex_ST]
"agal_vs
[bc]
adaaaaaaaaaaadacadaaaaoeaaaaaaaaajaaaaoeabaaaaaa mul r0.xy, a3, c9
abaaaaaaaaaaadaeaaaaaafeacaaaaaaajaaaaooabaaaaaa add v0.xy, r0.xyyy, c9.zwzw
adaaaaaaaaaaadacaeaaaaoeaaaaaaaaaiaaaaoeabaaaaaa mul r0.xy, a4, c8
abaaaaaaabaaadaeaaaaaafeacaaaaaaaiaaaaooabaaaaaa add v1.xy, r0.xyyy, c8.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
aaaaaaaaabaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.zw, c0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 9 [_ProjectionParams]
Vector 10 [unity_Scale]
Matrix 5 [_Object2World]
Vector 11 [unity_SHAr]
Vector 12 [unity_SHAg]
Vector 13 [unity_SHAb]
Vector 14 [unity_SHBr]
Vector 15 [unity_SHBg]
Vector 16 [unity_SHBb]
Vector 17 [unity_SHC]
Vector 18 [_MainTex_ST]
"!!ARBvp1.0
# 32 ALU
PARAM c[19] = { { 1, 0.5 },
		state.matrix.mvp,
		program.local[5..18] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R0.xyz, vertex.normal, c[10].w;
DP3 R3.w, R0, c[6];
DP3 R2.w, R0, c[7];
DP3 R1.w, R0, c[5];
MOV R1.x, R3.w;
MOV R1.y, R2.w;
MOV R1.z, c[0].x;
MUL R0, R1.wxyy, R1.xyyw;
DP4 R2.z, R1.wxyz, c[13];
DP4 R2.y, R1.wxyz, c[12];
DP4 R2.x, R1.wxyz, c[11];
DP4 R1.z, R0, c[16];
DP4 R1.y, R0, c[15];
DP4 R1.x, R0, c[14];
MUL R3.x, R3.w, R3.w;
MAD R0.x, R1.w, R1.w, -R3;
ADD R3.xyz, R2, R1;
MUL R2.xyz, R0.x, c[17];
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].y;
MUL R1.y, R1, c[9].x;
ADD result.texcoord[2].xyz, R3, R2;
ADD result.texcoord[3].xy, R1, R1.z;
MOV result.position, R0;
MOV result.texcoord[3].zw, R0;
MOV result.texcoord[1].z, R2.w;
MOV result.texcoord[1].y, R3.w;
MOV result.texcoord[1].x, R1.w;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[18], c[18].zwzw;
END
# 32 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_Scale]
Matrix 4 [_Object2World]
Vector 11 [unity_SHAr]
Vector 12 [unity_SHAg]
Vector 13 [unity_SHAb]
Vector 14 [unity_SHBr]
Vector 15 [unity_SHBg]
Vector 16 [unity_SHBb]
Vector 17 [unity_SHC]
Vector 18 [_MainTex_ST]
"vs_2_0
; 32 ALU
def c19, 1.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1, c10.w
dp3 r3.w, r0, c5
dp3 r2.w, r0, c6
dp3 r1.w, r0, c4
mov r1.x, r3.w
mov r1.y, r2.w
mov r1.z, c19.x
mul r0, r1.wxyy, r1.xyyw
dp4 r2.z, r1.wxyz, c13
dp4 r2.y, r1.wxyz, c12
dp4 r2.x, r1.wxyz, c11
dp4 r1.z, r0, c16
dp4 r1.y, r0, c15
dp4 r1.x, r0, c14
mul r3.x, r3.w, r3.w
mad r0.x, r1.w, r1.w, -r3
add r3.xyz, r2, r1
mul r2.xyz, r0.x, c17
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c19.y
mul r1.y, r1, c8.x
add oT2.xyz, r3, r2
mad oT3.xy, r1.z, c9.zwzw, r1
mov oPos, r0
mov oT3.zw, r0
mov oT1.z, r2.w
mov oT1.y, r3.w
mov oT1.x, r1.w
mad oT0.xy, v2, c18, c18.zwzw
"
}

SubProgram "xbox360 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 17 [_MainTex_ST]
Matrix 7 [_Object2World] 3
Vector 4 [_ProjectionParams]
Vector 5 [_ScreenParams]
Matrix 0 [glstate_matrix_mvp] 4
Vector 12 [unity_SHAb]
Vector 11 [unity_SHAg]
Vector 10 [unity_SHAr]
Vector 15 [unity_SHBb]
Vector 14 [unity_SHBg]
Vector 13 [unity_SHBr]
Vector 16 [unity_SHC]
Vector 6 [unity_Scale]
// Shader Timing Estimate, in Cycles/64 vertex vector:
// ALU: 30.67 (23 instructions), vertex: 32, texture: 0,
//   sequencer: 14,  5 GPRs, 31 threads,
// Performance (if enough threads): ~32 cycles per vector
// * Vertex cycle estimates are assuming 3 vfetch_minis for every vfetch_full,
//     with <= 32 bytes per vfetch_full group.

"vs_360
backbbabaaaaackeaaaaableaaaaaaaaaaaaaaceaaaaacceaaaaacemaaaaaaaa
aaaaaaaaaaaaabpmaaaaaabmaaaaaboopppoadaaaaaaaaanaaaaaabmaaaaaaaa
aaaaabohaaaaabcaaaacaabbaaabaaaaaaaaabcmaaaaaaaaaaaaabdmaaacaaah
aaadaaaaaaaaabemaaaaaaaaaaaaabfmaaacaaaeaaabaaaaaaaaabcmaaaaaaaa
aaaaabgoaaacaaafaaabaaaaaaaaabcmaaaaaaaaaaaaabhmaaacaaaaaaaeaaaa
aaaaabemaaaaaaaaaaaaabipaaacaaamaaabaaaaaaaaabcmaaaaaaaaaaaaabjk
aaacaaalaaabaaaaaaaaabcmaaaaaaaaaaaaabkfaaacaaakaaabaaaaaaaaabcm
aaaaaaaaaaaaablaaaacaaapaaabaaaaaaaaabcmaaaaaaaaaaaaabllaaacaaao
aaabaaaaaaaaabcmaaaaaaaaaaaaabmgaaacaaanaaabaaaaaaaaabcmaaaaaaaa
aaaaabnbaaacaabaaaabaaaaaaaaabcmaaaaaaaaaaaaabnlaaacaaagaaabaaaa
aaaaabcmaaaaaaaafpengbgjgofegfhifpfdfeaaaaabaaadaaabaaaeaaabaaaa
aaaaaaaafpepgcgkgfgdhedcfhgphcgmgeaaklklaaadaaadaaaeaaaeaaabaaaa
aaaaaaaafpfahcgpgkgfgdhegjgpgofagbhcgbgnhdaafpfdgdhcgfgfgofagbhc
gbgnhdaaghgmhdhegbhegffpgngbhehcgjhifpgnhghaaahfgogjhehjfpfdeieb
gcaahfgogjhehjfpfdeiebghaahfgogjhehjfpfdeiebhcaahfgogjhehjfpfdei
ecgcaahfgogjhehjfpfdeiecghaahfgogjhehjfpfdeiechcaahfgogjhehjfpfd
eiedaahfgogjhehjfpfdgdgbgmgfaahghdfpddfpdaaadccodacodcdadddfddco
daaaklklaaaaaaaaaaaaaaabaaaaaaaaaaaaaaaaaaaaaabeaapmaabaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaeaaaaaabheaadbaaaeaaaaaaaaaaaaaaaa
aaaadaieaaaaaaabaaaaaaadaaaaaaafaaaaacjaaabaaaaeaaaadaafaadafaag
aaaadafaaaabhbfbaaachcfcaaadpdfdaaaababdaaaababcaaaababnaaaaaabb
aaaabablaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadpaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaahabfdaaeaaaabcaamcaaaaaaaaaafaahaaaabcaameaaaaaaaaaagaam
gabcbcaabcaaaaaaaaaagabiaaaaccaaaaaaaaaaafpidaaaaaaaagiiaaaaaaaa
afpicaaaaaaaaoiiaaaaaaaaafpiaaaaaaaaapmiaaaaaaaamiapaaabaabliiaa
kbadadaamiapaaabaamgnapikladacabmiapaaabaalbdepikladababmiapaaab
aagmiipikladaaabmiapiadoaaiiiiaaocababaamialaaacaagfblaakbacagaa
ceihaeadaalblegmkbacajiamiahaaacaagmlemaklacaiadmiahaaaeaabllema
klacahacaibhabadaaligmggkbabppaemiamiaadaaigigaaocababaamiahiaab
aaleleaaocaeaeaamiadiaaaaalalabkilaabbbbaicbabacaadoanmbgpakaeae
aiecabacaadoanlbgpalaeaeaiieabacaadoanlmgpamaeaemiabaaaaaakhkhaa
kpabanaamiacaaaaaakhkhaakpabaoaaaibeabaaaakhkhgmkpabapaeaiciabad
aalbgmmgkbadaeaemiadiaadaamgbkbikladafadgeihaaaaaalologboaacaaab
miahiaacaablmagfklaabaaaaaaaaaaaaaaaaaaaaaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 256 [glstate_matrix_mvp]
Vector 467 [_ProjectionParams]
Vector 466 [unity_Scale]
Matrix 260 [_Object2World]
Vector 465 [unity_SHAr]
Vector 464 [unity_SHAg]
Vector 463 [unity_SHAb]
Vector 462 [unity_SHBr]
Vector 461 [unity_SHBg]
Vector 460 [unity_SHBb]
Vector 459 [unity_SHC]
Vector 458 [_MainTex_ST]
"sce_vp_rsx // 29 instructions using 3 registers
[Configuration]
8
0000001d01050300
[Defaults]
1
457 1
3f000000
[Microcode]
464
00009c6c009d220c013fc0c36041dffc401f9c6c011ca808010400d740619f9c
00001c6c01d0300d8106c0c360403ffc00001c6c01d0200d8106c0c360405ffc
00001c6c01d0100d8106c0c360409ffc00001c6c01d0000d8106c0c360411ffc
00011c6c0150600c028600c360411ffc00011c6c0150500c028600c360409ffc
00009c6c0150400c028600c360411ffc401f9c6c0040000d8086c0836041ff80
401f9c6c004000558086c08360407fa800001c6c009c900e008000c36041dffc
00001c6c009d302a808000c360409ffc401f9c6c004000000286c08360411fa0
00001c6c0080002a8495424360403ffc40009c6c0040002a8486c08360409fa0
40009c6c004000000486c08360405fa0401f9c6c00c000080086c09540219fa8
00001c6c019cf00c0286c0c360405ffc00001c6c019d000c0286c0c360409ffc
00001c6c019d100c0286c0c360411ffc00001c6c010000000280017fe0203ffc
00009c6c0080000d029a01436041fffc00011c6c01dcc00d8286c0c360405ffc
00011c6c01dcd00d8286c0c360409ffc00011c6c01dce00d8286c0c360411ffc
00001c6c00c0000c0086c0830121dffc00009c6c009cb07f808600c36041dffc
401f9c6c00c0000c0286c0830021dfa5
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (gl_ModelViewProjectionMatrix * _glesVertex);
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  mediump vec3 tmpvar_7;
  mediump vec4 normal;
  normal = tmpvar_6;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_8;
  tmpvar_8 = dot (unity_SHAr, normal);
  x1.x = tmpvar_8;
  highp float tmpvar_9;
  tmpvar_9 = dot (unity_SHAg, normal);
  x1.y = tmpvar_9;
  highp float tmpvar_10;
  tmpvar_10 = dot (unity_SHAb, normal);
  x1.z = tmpvar_10;
  mediump vec4 tmpvar_11;
  tmpvar_11 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHBr, tmpvar_11);
  x2.x = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHBg, tmpvar_11);
  x2.y = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHBb, tmpvar_11);
  x2.z = tmpvar_14;
  mediump float tmpvar_15;
  tmpvar_15 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (unity_SHC.xyz * vC);
  x3 = tmpvar_16;
  tmpvar_7 = ((x1 + x2) + x3);
  shlight = tmpvar_7;
  tmpvar_2 = shlight;
  highp vec4 o_i0;
  highp vec4 tmpvar_17;
  tmpvar_17 = (tmpvar_3 * 0.5);
  o_i0 = tmpvar_17;
  highp vec2 tmpvar_18;
  tmpvar_18.x = tmpvar_17.x;
  tmpvar_18.y = (tmpvar_17.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_18 + tmpvar_17.w);
  o_i0.zw = tmpvar_3.zw;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = o_i0;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_1.xyz * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD1, _WorldSpaceLightPos0.xyz)) * texture2DProj (_ShadowMapTexture, xlv_TEXCOORD3).x) * 2.0));
  c_i0_i1.w = tmpvar_1.w;
  c = c_i0_i1;
  c.xyz = (c_i0_i1.xyz + (tmpvar_1.xyz * xlv_TEXCOORD2));
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (gl_ModelViewProjectionMatrix * _glesVertex);
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  mediump vec3 tmpvar_7;
  mediump vec4 normal;
  normal = tmpvar_6;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_8;
  tmpvar_8 = dot (unity_SHAr, normal);
  x1.x = tmpvar_8;
  highp float tmpvar_9;
  tmpvar_9 = dot (unity_SHAg, normal);
  x1.y = tmpvar_9;
  highp float tmpvar_10;
  tmpvar_10 = dot (unity_SHAb, normal);
  x1.z = tmpvar_10;
  mediump vec4 tmpvar_11;
  tmpvar_11 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHBr, tmpvar_11);
  x2.x = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHBg, tmpvar_11);
  x2.y = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHBb, tmpvar_11);
  x2.z = tmpvar_14;
  mediump float tmpvar_15;
  tmpvar_15 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (unity_SHC.xyz * vC);
  x3 = tmpvar_16;
  tmpvar_7 = ((x1 + x2) + x3);
  shlight = tmpvar_7;
  tmpvar_2 = shlight;
  highp vec4 o_i0;
  highp vec4 tmpvar_17;
  tmpvar_17 = (tmpvar_3 * 0.5);
  o_i0 = tmpvar_17;
  highp vec2 tmpvar_18;
  tmpvar_18.x = tmpvar_17.x;
  tmpvar_18.y = (tmpvar_17.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_18 + tmpvar_17.w);
  o_i0.zw = tmpvar_3.zw;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = o_i0;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_1.xyz * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD1, _WorldSpaceLightPos0.xyz)) * texture2DProj (_ShadowMapTexture, xlv_TEXCOORD3).x) * 2.0));
  c_i0_i1.w = tmpvar_1.w;
  c = c_i0_i1;
  c.xyz = (c_i0_i1.xyz + (tmpvar_1.xyz * xlv_TEXCOORD2));
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [unity_NPOTScale]
Vector 10 [unity_Scale]
Matrix 4 [_Object2World]
Vector 11 [unity_SHAr]
Vector 12 [unity_SHAg]
Vector 13 [unity_SHAb]
Vector 14 [unity_SHBr]
Vector 15 [unity_SHBg]
Vector 16 [unity_SHBb]
Vector 17 [unity_SHC]
Vector 18 [_MainTex_ST]
"agal_vs
c19 1.0 0.5 0.0 0.0
[bc]
adaaaaaaaaaaahacabaaaaoeaaaaaaaaakaaaappabaaaaaa mul r0.xyz, a1, c10.w
bcaaaaaaadaaaiacaaaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 r3.w, r0.xyzz, c5
bcaaaaaaacaaaiacaaaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 r2.w, r0.xyzz, c6
bcaaaaaaabaaaiacaaaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 r1.w, r0.xyzz, c4
aaaaaaaaabaaabacadaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r1.x, r3.w
aaaaaaaaabaaacacacaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r1.y, r2.w
aaaaaaaaabaaaeacbdaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r1.z, c19.x
adaaaaaaaaaaapacabaaaafdacaaaaaaabaaaaneacaaaaaa mul r0, r1.wxyy, r1.xyyw
bdaaaaaaacaaaeacabaaaajdacaaaaaaanaaaaoeabaaaaaa dp4 r2.z, r1.wxyz, c13
bdaaaaaaacaaacacabaaaajdacaaaaaaamaaaaoeabaaaaaa dp4 r2.y, r1.wxyz, c12
bdaaaaaaacaaabacabaaaajdacaaaaaaalaaaaoeabaaaaaa dp4 r2.x, r1.wxyz, c11
bdaaaaaaabaaaeacaaaaaaoeacaaaaaabaaaaaoeabaaaaaa dp4 r1.z, r0, c16
bdaaaaaaabaaacacaaaaaaoeacaaaaaaapaaaaoeabaaaaaa dp4 r1.y, r0, c15
bdaaaaaaabaaabacaaaaaaoeacaaaaaaaoaaaaoeabaaaaaa dp4 r1.x, r0, c14
adaaaaaaadaaabacadaaaappacaaaaaaadaaaappacaaaaaa mul r3.x, r3.w, r3.w
adaaaaaaaeaaabacabaaaappacaaaaaaabaaaappacaaaaaa mul r4.x, r1.w, r1.w
acaaaaaaaaaaabacaeaaaaaaacaaaaaaadaaaaaaacaaaaaa sub r0.x, r4.x, r3.x
abaaaaaaacaaahacacaaaakeacaaaaaaabaaaakeacaaaaaa add r2.xyz, r2.xyzz, r1.xyzz
adaaaaaaabaaahacaaaaaaaaacaaaaaabbaaaaoeabaaaaaa mul r1.xyz, r0.x, c17
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 r0.w, a0, c3
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 r0.z, a0, c2
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 r0.x, a0, c0
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 r0.y, a0, c1
adaaaaaaadaaahacaaaaaapeacaaaaaabdaaaaffabaaaaaa mul r3.xyz, r0.xyww, c19.y
abaaaaaaacaaahaeacaaaakeacaaaaaaabaaaakeacaaaaaa add v2.xyz, r2.xyzz, r1.xyzz
adaaaaaaabaaacacadaaaaffacaaaaaaaiaaaaaaabaaaaaa mul r1.y, r3.y, c8.x
aaaaaaaaabaaabacadaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r1.x, r3.x
abaaaaaaabaaadacabaaaafeacaaaaaaadaaaakkacaaaaaa add r1.xy, r1.xyyy, r3.z
adaaaaaaadaaadaeabaaaafeacaaaaaaajaaaaoeabaaaaaa mul v3.xy, r1.xyyy, c9
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
aaaaaaaaadaaamaeaaaaaaopacaaaaaaaaaaaaaaaaaaaaaa mov v3.zw, r0.wwzw
aaaaaaaaabaaaeaeacaaaappacaaaaaaaaaaaaaaaaaaaaaa mov v1.z, r2.w
aaaaaaaaabaaacaeadaaaappacaaaaaaaaaaaaaaaaaaaaaa mov v1.y, r3.w
aaaaaaaaabaaabaeabaaaappacaaaaaaaaaaaaaaaaaaaaaa mov v1.x, r1.w
adaaaaaaaeaaadacadaaaaoeaaaaaaaabcaaaaoeabaaaaaa mul r4.xy, a3, c18
abaaaaaaaaaaadaeaeaaaafeacaaaaaabcaaaaooabaaaaaa add v0.xy, r4.xyyy, c18.zwzw
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 9 [_ProjectionParams]
Vector 10 [unity_LightmapST]
Vector 11 [_MainTex_ST]
"!!ARBvp1.0
# 11 ALU
PARAM c[12] = { { 0.5 },
		state.matrix.mvp,
		program.local[5..11] };
TEMP R0;
TEMP R1;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].x;
MUL R1.y, R1, c[9].x;
ADD result.texcoord[2].xy, R1, R1.z;
MOV result.position, R0;
MOV result.texcoord[2].zw, R0;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[11], c[11].zwzw;
MAD result.texcoord[1].xy, vertex.texcoord[1], c[10], c[10].zwzw;
END
# 11 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_LightmapST]
Vector 11 [_MainTex_ST]
"vs_2_0
; 11 ALU
def c12, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_texcoord0 v2
dcl_texcoord1 v3
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c12.x
mul r1.y, r1, c8.x
mad oT2.xy, r1.z, c9.zwzw, r1
mov oPos, r0
mov oT2.zw, r0
mad oT0.xy, v2, c11, c11.zwzw
mad oT1.xy, v3, c10, c10.zwzw
"
}

SubProgram "xbox360 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 7 [_MainTex_ST]
Vector 4 [_ProjectionParams]
Vector 5 [_ScreenParams]
Matrix 0 [glstate_matrix_mvp] 4
Vector 6 [unity_LightmapST]
// Shader Timing Estimate, in Cycles/64 vertex vector:
// ALU: 14.67 (11 instructions), vertex: 32, texture: 0,
//   sequencer: 10,  3 GPRs, 31 threads,
// Performance (if enough threads): ~32 cycles per vector
// * Vertex cycle estimates are assuming 3 vfetch_minis for every vfetch_full,
//     with <= 32 bytes per vfetch_full group.

"vs_360
backbbabaaaaabkeaaaaabbiaaaaaaaaaaaaaaceaaaaabcmaaaaabfeaaaaaaaa
aaaaaaaaaaaaabaeaaaaaabmaaaaaapipppoadaaaaaaaaafaaaaaabmaaaaaaaa
aaaaaapbaaaaaaiaaaacaaahaaabaaaaaaaaaaimaaaaaaaaaaaaaajmaaacaaae
aaabaaaaaaaaaaimaaaaaaaaaaaaaakoaaacaaafaaabaaaaaaaaaaimaaaaaaaa
aaaaaalmaaacaaaaaaaeaaaaaaaaaanaaaaaaaaaaaaaaaoaaaacaaagaaabaaaa
aaaaaaimaaaaaaaafpengbgjgofegfhifpfdfeaaaaabaaadaaabaaaeaaabaaaa
aaaaaaaafpfahcgpgkgfgdhegjgpgofagbhcgbgnhdaafpfdgdhcgfgfgofagbhc
gbgnhdaaghgmhdhegbhegffpgngbhehcgjhifpgnhghaaaklaaadaaadaaaeaaae
aaabaaaaaaaaaaaahfgogjhehjfpemgjghgihegngbhafdfeaahghdfpddfpdaaa
dccodacodcdadddfddcodaaaaaaaaaaaaaaaaaabaaaaaaaaaaaaaaaaaaaaaabe
aapmaabaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaeaaaaaaaniaacbaaac
aaaaaaaaaaaaaaaaaaaacagdaaaaaaabaaaaaaadaaaaaaaeaaaaacjaaabaaaad
aaaafaaeaacbfaafaaaadafaaaabdbfbaaacpcfcaaaabaanaaaabaaoaaaaaaam
aaaababaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadpaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaahabfdaadaaaabcaamcaaaaaaaaaafaagaaaabcaameaaaaaaaaaagaal
aaaaccaaaaaaaaaaafpicaaaaaaaagiiaaaaaaaaafpibaaaaaaaacdpaaaaaaaa
afpibaaaaaaaapmiaaaaaaaamiapaaaaaabliiaakbacadaamiapaaaaaamgnapi
klacacaamiapaaaaaalbdepiklacabaamiapaaacaagmnajeklacaaaamiapiado
aananaaaocacacaamiahaaaaaamagmaakbacppaamiamiaacaanlnlaaocacacaa
miadiaaaaabklabkilabahahmiadiaabaalalabkilabagagkiiaaaaaaaaaaaeb
mcaaaaaemiadiaacaamgbkbiklaaafaaaaaaaaaaaaaaaaaaaaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 256 [glstate_matrix_mvp]
Vector 467 [_ProjectionParams]
Vector 466 [unity_LightmapST]
Vector 465 [_MainTex_ST]
"sce_vp_rsx // 11 instructions using 1 registers
[Configuration]
8
0000000b03010100
[Defaults]
1
464 1
3f000000
[Microcode]
176
401f9c6c011d1808010400d740619f9c00001c6c01d0300d8106c0c360403ffc
00001c6c01d0200d8106c0c360405ffc00001c6c01d0100d8106c0c360409ffc
00001c6c01d0000d8106c0c360411ffc401f9c6c011d2908010400d740619fa0
401f9c6c0040000d8086c0836041ff80401f9c6c004000558086c08360407fa4
00001c6c009d000e008000c36041dffc00001c6c009d302a808000c360409ffc
401f9c6c00c000080086c09540219fa5
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;

uniform highp vec4 _ProjectionParams;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_i0;
  highp vec4 tmpvar_2;
  tmpvar_2 = (tmpvar_1 * 0.5);
  o_i0 = tmpvar_2;
  highp vec2 tmpvar_3;
  tmpvar_3.x = tmpvar_2.x;
  tmpvar_3.y = (tmpvar_2.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_3 + tmpvar_2.w);
  o_i0.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD2 = o_i0;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  c = vec4(0.0, 0.0, 0.0, 0.0);
  c.xyz = (tmpvar_1.xyz * min ((2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD1).xyz), vec3((texture2DProj (_ShadowMapTexture, xlv_TEXCOORD2).x * 2.0))));
  c.w = tmpvar_1.w;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;

uniform highp vec4 _ProjectionParams;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_i0;
  highp vec4 tmpvar_2;
  tmpvar_2 = (tmpvar_1 * 0.5);
  o_i0 = tmpvar_2;
  highp vec2 tmpvar_3;
  tmpvar_3.x = tmpvar_2.x;
  tmpvar_3.y = (tmpvar_2.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_3 + tmpvar_2.w);
  o_i0.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD2 = o_i0;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD2);
  c = vec4(0.0, 0.0, 0.0, 0.0);
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (unity_Lightmap, xlv_TEXCOORD1);
  lowp vec3 tmpvar_4;
  tmpvar_4 = ((8.0 * tmpvar_3.w) * tmpvar_3.xyz);
  c.xyz = (tmpvar_1.xyz * max (min (tmpvar_4, ((tmpvar_2.x * 2.0) * tmpvar_3.xyz)), (tmpvar_4 * tmpvar_2.x)));
  c.w = tmpvar_1.w;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [unity_NPOTScale]
Vector 10 [unity_LightmapST]
Vector 11 [_MainTex_ST]
"agal_vs
c12 0.5 0.0 0.0 0.0
[bc]
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 r0.w, a0, c3
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 r0.z, a0, c2
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 r0.x, a0, c0
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 r0.y, a0, c1
adaaaaaaabaaahacaaaaaapeacaaaaaaamaaaaaaabaaaaaa mul r1.xyz, r0.xyww, c12.x
adaaaaaaabaaacacabaaaaffacaaaaaaaiaaaaaaabaaaaaa mul r1.y, r1.y, c8.x
abaaaaaaabaaadacabaaaafeacaaaaaaabaaaakkacaaaaaa add r1.xy, r1.xyyy, r1.z
adaaaaaaacaaadaeabaaaafeacaaaaaaajaaaaoeabaaaaaa mul v2.xy, r1.xyyy, c9
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
aaaaaaaaacaaamaeaaaaaaopacaaaaaaaaaaaaaaaaaaaaaa mov v2.zw, r0.wwzw
adaaaaaaaaaaadacadaaaaoeaaaaaaaaalaaaaoeabaaaaaa mul r0.xy, a3, c11
abaaaaaaaaaaadaeaaaaaafeacaaaaaaalaaaaooabaaaaaa add v0.xy, r0.xyyy, c11.zwzw
adaaaaaaaaaaadacaeaaaaoeaaaaaaaaakaaaaoeabaaaaaa mul r0.xy, a4, c10
abaaaaaaabaaadaeaaaaaafeacaaaaaaakaaaaooabaaaaaa add v1.xy, r0.xyyy, c10.zwzw
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
aaaaaaaaabaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.zw, c0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 9 [_ProjectionParams]
Vector 10 [unity_LightmapST]
Vector 11 [_MainTex_ST]
"!!ARBvp1.0
# 11 ALU
PARAM c[12] = { { 0.5 },
		state.matrix.mvp,
		program.local[5..11] };
TEMP R0;
TEMP R1;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].x;
MUL R1.y, R1, c[9].x;
ADD result.texcoord[2].xy, R1, R1.z;
MOV result.position, R0;
MOV result.texcoord[2].zw, R0;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[11], c[11].zwzw;
MAD result.texcoord[1].xy, vertex.texcoord[1], c[10], c[10].zwzw;
END
# 11 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_LightmapST]
Vector 11 [_MainTex_ST]
"vs_2_0
; 11 ALU
def c12, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_texcoord0 v2
dcl_texcoord1 v3
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c12.x
mul r1.y, r1, c8.x
mad oT2.xy, r1.z, c9.zwzw, r1
mov oPos, r0
mov oT2.zw, r0
mad oT0.xy, v2, c11, c11.zwzw
mad oT1.xy, v3, c10, c10.zwzw
"
}

SubProgram "xbox360 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 7 [_MainTex_ST]
Vector 4 [_ProjectionParams]
Vector 5 [_ScreenParams]
Matrix 0 [glstate_matrix_mvp] 4
Vector 6 [unity_LightmapST]
// Shader Timing Estimate, in Cycles/64 vertex vector:
// ALU: 14.67 (11 instructions), vertex: 32, texture: 0,
//   sequencer: 10,  3 GPRs, 31 threads,
// Performance (if enough threads): ~32 cycles per vector
// * Vertex cycle estimates are assuming 3 vfetch_minis for every vfetch_full,
//     with <= 32 bytes per vfetch_full group.

"vs_360
backbbabaaaaabkeaaaaabbiaaaaaaaaaaaaaaceaaaaabcmaaaaabfeaaaaaaaa
aaaaaaaaaaaaabaeaaaaaabmaaaaaapipppoadaaaaaaaaafaaaaaabmaaaaaaaa
aaaaaapbaaaaaaiaaaacaaahaaabaaaaaaaaaaimaaaaaaaaaaaaaajmaaacaaae
aaabaaaaaaaaaaimaaaaaaaaaaaaaakoaaacaaafaaabaaaaaaaaaaimaaaaaaaa
aaaaaalmaaacaaaaaaaeaaaaaaaaaanaaaaaaaaaaaaaaaoaaaacaaagaaabaaaa
aaaaaaimaaaaaaaafpengbgjgofegfhifpfdfeaaaaabaaadaaabaaaeaaabaaaa
aaaaaaaafpfahcgpgkgfgdhegjgpgofagbhcgbgnhdaafpfdgdhcgfgfgofagbhc
gbgnhdaaghgmhdhegbhegffpgngbhehcgjhifpgnhghaaaklaaadaaadaaaeaaae
aaabaaaaaaaaaaaahfgogjhehjfpemgjghgihegngbhafdfeaahghdfpddfpdaaa
dccodacodcdadddfddcodaaaaaaaaaaaaaaaaaabaaaaaaaaaaaaaaaaaaaaaabe
aapmaabaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaeaaaaaaaniaacbaaac
aaaaaaaaaaaaaaaaaaaacagdaaaaaaabaaaaaaadaaaaaaaeaaaaacjaaabaaaad
aaaafaaeaacbfaafaaaadafaaaabdbfbaaacpcfcaaaabaanaaaabaaoaaaaaaam
aaaababaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadpaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaahabfdaadaaaabcaamcaaaaaaaaaafaagaaaabcaameaaaaaaaaaagaal
aaaaccaaaaaaaaaaafpicaaaaaaaagiiaaaaaaaaafpibaaaaaaaacdpaaaaaaaa
afpibaaaaaaaapmiaaaaaaaamiapaaaaaabliiaakbacadaamiapaaaaaamgnapi
klacacaamiapaaaaaalbdepiklacabaamiapaaacaagmnajeklacaaaamiapiado
aananaaaocacacaamiahaaaaaamagmaakbacppaamiamiaacaanlnlaaocacacaa
miadiaaaaabklabkilabahahmiadiaabaalalabkilabagagkiiaaaaaaaaaaaeb
mcaaaaaemiadiaacaamgbkbiklaaafaaaaaaaaaaaaaaaaaaaaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 256 [glstate_matrix_mvp]
Vector 467 [_ProjectionParams]
Vector 466 [unity_LightmapST]
Vector 465 [_MainTex_ST]
"sce_vp_rsx // 11 instructions using 1 registers
[Configuration]
8
0000000b03010100
[Defaults]
1
464 1
3f000000
[Microcode]
176
401f9c6c011d1808010400d740619f9c00001c6c01d0300d8106c0c360403ffc
00001c6c01d0200d8106c0c360405ffc00001c6c01d0100d8106c0c360409ffc
00001c6c01d0000d8106c0c360411ffc401f9c6c011d2908010400d740619fa0
401f9c6c0040000d8086c0836041ff80401f9c6c004000558086c08360407fa4
00001c6c009d000e008000c36041dffc00001c6c009d302a808000c360409ffc
401f9c6c00c000080086c09540219fa5
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;

uniform highp vec4 _ProjectionParams;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_i0;
  highp vec4 tmpvar_2;
  tmpvar_2 = (tmpvar_1 * 0.5);
  o_i0 = tmpvar_2;
  highp vec2 tmpvar_3;
  tmpvar_3.x = tmpvar_2.x;
  tmpvar_3.y = (tmpvar_2.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_3 + tmpvar_2.w);
  o_i0.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD2 = o_i0;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  c = vec4(0.0, 0.0, 0.0, 0.0);
  mediump vec3 lm_i0;
  lowp vec3 tmpvar_2;
  tmpvar_2 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD1).xyz);
  lm_i0 = tmpvar_2;
  mediump vec4 tmpvar_3;
  tmpvar_3.w = 0.0;
  tmpvar_3.xyz = lm_i0;
  lowp vec3 tmpvar_4;
  tmpvar_4 = vec3((texture2DProj (_ShadowMapTexture, xlv_TEXCOORD2).x * 2.0));
  mediump vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_1.xyz * min (tmpvar_3.xyz, tmpvar_4));
  c.xyz = tmpvar_5;
  c.w = tmpvar_1.w;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;

uniform highp vec4 _ProjectionParams;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_i0;
  highp vec4 tmpvar_2;
  tmpvar_2 = (tmpvar_1 * 0.5);
  o_i0 = tmpvar_2;
  highp vec2 tmpvar_3;
  tmpvar_3.x = tmpvar_2.x;
  tmpvar_3.y = (tmpvar_2.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_3 + tmpvar_2.w);
  o_i0.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD2 = o_i0;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD2);
  c = vec4(0.0, 0.0, 0.0, 0.0);
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (unity_Lightmap, xlv_TEXCOORD1);
  mediump vec3 lm_i0;
  lowp vec3 tmpvar_4;
  tmpvar_4 = ((8.0 * tmpvar_3.w) * tmpvar_3.xyz);
  lm_i0 = tmpvar_4;
  mediump vec4 tmpvar_5;
  tmpvar_5.w = 0.0;
  tmpvar_5.xyz = lm_i0;
  mediump vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_1.xyz * max (min (tmpvar_5.xyz, ((tmpvar_2.x * 2.0) * tmpvar_3.xyz)), (lm_i0 * tmpvar_2.x)));
  c.xyz = tmpvar_6;
  c.w = tmpvar_1.w;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [unity_NPOTScale]
Vector 10 [unity_LightmapST]
Vector 11 [_MainTex_ST]
"agal_vs
c12 0.5 0.0 0.0 0.0
[bc]
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 r0.w, a0, c3
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 r0.z, a0, c2
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 r0.x, a0, c0
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 r0.y, a0, c1
adaaaaaaabaaahacaaaaaapeacaaaaaaamaaaaaaabaaaaaa mul r1.xyz, r0.xyww, c12.x
adaaaaaaabaaacacabaaaaffacaaaaaaaiaaaaaaabaaaaaa mul r1.y, r1.y, c8.x
abaaaaaaabaaadacabaaaafeacaaaaaaabaaaakkacaaaaaa add r1.xy, r1.xyyy, r1.z
adaaaaaaacaaadaeabaaaafeacaaaaaaajaaaaoeabaaaaaa mul v2.xy, r1.xyyy, c9
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
aaaaaaaaacaaamaeaaaaaaopacaaaaaaaaaaaaaaaaaaaaaa mov v2.zw, r0.wwzw
adaaaaaaaaaaadacadaaaaoeaaaaaaaaalaaaaoeabaaaaaa mul r0.xy, a3, c11
abaaaaaaaaaaadaeaaaaaafeacaaaaaaalaaaaooabaaaaaa add v0.xy, r0.xyyy, c11.zwzw
adaaaaaaaaaaadacaeaaaaoeaaaaaaaaakaaaaoeabaaaaaa mul r0.xy, a4, c10
abaaaaaaabaaadaeaaaaaafeacaaaaaaakaaaaooabaaaaaa add v1.xy, r0.xyyy, c10.zwzw
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
aaaaaaaaabaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.zw, c0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 9 [unity_Scale]
Matrix 5 [_Object2World]
Vector 10 [unity_4LightPosX0]
Vector 11 [unity_4LightPosY0]
Vector 12 [unity_4LightPosZ0]
Vector 13 [unity_4LightAtten0]
Vector 14 [unity_LightColor0]
Vector 15 [unity_LightColor1]
Vector 16 [unity_LightColor2]
Vector 17 [unity_LightColor3]
Vector 18 [unity_SHAr]
Vector 19 [unity_SHAg]
Vector 20 [unity_SHAb]
Vector 21 [unity_SHBr]
Vector 22 [unity_SHBg]
Vector 23 [unity_SHBb]
Vector 24 [unity_SHC]
Vector 25 [_MainTex_ST]
"!!ARBvp1.0
# 57 ALU
PARAM c[26] = { { 1, 0 },
		state.matrix.mvp,
		program.local[5..25] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R3.xyz, vertex.normal, c[9].w;
DP3 R4.x, R3, c[5];
DP3 R3.w, R3, c[6];
DP3 R3.x, R3, c[7];
DP4 R0.x, vertex.position, c[6];
ADD R1, -R0.x, c[11];
MUL R2, R3.w, R1;
DP4 R0.x, vertex.position, c[5];
ADD R0, -R0.x, c[10];
MUL R1, R1, R1;
MOV R4.z, R3.x;
MOV R4.w, c[0].x;
MAD R2, R4.x, R0, R2;
DP4 R4.y, vertex.position, c[7];
MAD R1, R0, R0, R1;
ADD R0, -R4.y, c[12];
MAD R1, R0, R0, R1;
MAD R0, R3.x, R0, R2;
MUL R2, R1, c[13];
MOV R4.y, R3.w;
RSQ R1.x, R1.x;
RSQ R1.y, R1.y;
RSQ R1.w, R1.w;
RSQ R1.z, R1.z;
MUL R0, R0, R1;
ADD R1, R2, c[0].x;
DP4 R2.z, R4, c[20];
DP4 R2.y, R4, c[19];
DP4 R2.x, R4, c[18];
RCP R1.x, R1.x;
RCP R1.y, R1.y;
RCP R1.w, R1.w;
RCP R1.z, R1.z;
MAX R0, R0, c[0].y;
MUL R0, R0, R1;
MUL R1.xyz, R0.y, c[15];
MAD R1.xyz, R0.x, c[14], R1;
MAD R0.xyz, R0.z, c[16], R1;
MAD R1.xyz, R0.w, c[17], R0;
MUL R0, R4.xyzz, R4.yzzx;
MUL R1.w, R3, R3;
DP4 R4.w, R0, c[23];
DP4 R4.z, R0, c[22];
DP4 R4.y, R0, c[21];
MAD R1.w, R4.x, R4.x, -R1;
MUL R0.xyz, R1.w, c[24];
ADD R2.xyz, R2, R4.yzww;
ADD R0.xyz, R2, R0;
ADD result.texcoord[2].xyz, R0, R1;
MOV result.texcoord[1].z, R3.x;
MOV result.texcoord[1].y, R3.w;
MOV result.texcoord[1].x, R4;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[25], c[25].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 57 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_Scale]
Matrix 4 [_Object2World]
Vector 9 [unity_4LightPosX0]
Vector 10 [unity_4LightPosY0]
Vector 11 [unity_4LightPosZ0]
Vector 12 [unity_4LightAtten0]
Vector 13 [unity_LightColor0]
Vector 14 [unity_LightColor1]
Vector 15 [unity_LightColor2]
Vector 16 [unity_LightColor3]
Vector 17 [unity_SHAr]
Vector 18 [unity_SHAg]
Vector 19 [unity_SHAb]
Vector 20 [unity_SHBr]
Vector 21 [unity_SHBg]
Vector 22 [unity_SHBb]
Vector 23 [unity_SHC]
Vector 24 [_MainTex_ST]
"vs_2_0
; 57 ALU
def c25, 1.00000000, 0.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r3.xyz, v1, c8.w
dp3 r4.x, r3, c4
dp3 r3.w, r3, c5
dp3 r3.x, r3, c6
dp4 r0.x, v0, c5
add r1, -r0.x, c10
mul r2, r3.w, r1
dp4 r0.x, v0, c4
add r0, -r0.x, c9
mul r1, r1, r1
mov r4.z, r3.x
mov r4.w, c25.x
mad r2, r4.x, r0, r2
dp4 r4.y, v0, c6
mad r1, r0, r0, r1
add r0, -r4.y, c11
mad r1, r0, r0, r1
mad r0, r3.x, r0, r2
mul r2, r1, c12
mov r4.y, r3.w
rsq r1.x, r1.x
rsq r1.y, r1.y
rsq r1.w, r1.w
rsq r1.z, r1.z
mul r0, r0, r1
add r1, r2, c25.x
dp4 r2.z, r4, c19
dp4 r2.y, r4, c18
dp4 r2.x, r4, c17
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c25.y
mul r0, r0, r1
mul r1.xyz, r0.y, c14
mad r1.xyz, r0.x, c13, r1
mad r0.xyz, r0.z, c15, r1
mad r1.xyz, r0.w, c16, r0
mul r0, r4.xyzz, r4.yzzx
mul r1.w, r3, r3
dp4 r4.w, r0, c22
dp4 r4.z, r0, c21
dp4 r4.y, r0, c20
mad r1.w, r4.x, r4.x, -r1
mul r0.xyz, r1.w, c23
add r2.xyz, r2, r4.yzww
add r0.xyz, r2, r0
add oT2.xyz, r0, r1
mov oT1.z, r3.x
mov oT1.y, r3.w
mov oT1.x, r4
mad oT0.xy, v2, c24, c24.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "xbox360 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 24 [_MainTex_ST]
Matrix 5 [_Object2World] 4
Matrix 0 [glstate_matrix_mvp] 4
Vector 12 [unity_4LightAtten0]
Vector 9 [unity_4LightPosX0]
Vector 10 [unity_4LightPosY0]
Vector 11 [unity_4LightPosZ0]
Vector 13 [unity_LightColor0]
Vector 14 [unity_LightColor1]
Vector 15 [unity_LightColor2]
Vector 16 [unity_LightColor3]
Vector 19 [unity_SHAb]
Vector 18 [unity_SHAg]
Vector 17 [unity_SHAr]
Vector 22 [unity_SHBb]
Vector 21 [unity_SHBg]
Vector 20 [unity_SHBr]
Vector 23 [unity_SHC]
Vector 4 [unity_Scale]
// Shader Timing Estimate, in Cycles/64 vertex vector:
// ALU: 68.00 (51 instructions), vertex: 32, texture: 0,
//   sequencer: 24,  8 GPRs, 24 threads,
// Performance (if enough threads): ~68 cycles per vector
// * Vertex cycle estimates are assuming 3 vfetch_minis for every vfetch_full,
//     with <= 32 bytes per vfetch_full group.

"vs_360
backbbabaaaaadcaaaaaadbmaaaaaaaaaaaaaaceaaaaackmaaaaacneaaaaaaaa
aaaaaaaaaaaaacieaaaaaabmaaaaachhpppoadaaaaaaaabaaaaaaabmaaaaaaaa
aaaaachaaaaaabfmaaacaabiaaabaaaaaaaaabgiaaaaaaaaaaaaabhiaaacaaaf
aaaeaaaaaaaaabiiaaaaaaaaaaaaabjiaaacaaaaaaaeaaaaaaaaabiiaaaaaaaa
aaaaabklaaacaaamaaabaaaaaaaaabgiaaaaaaaaaaaaabloaaacaaajaaabaaaa
aaaaabgiaaaaaaaaaaaaabnaaaacaaakaaabaaaaaaaaabgiaaaaaaaaaaaaaboc
aaacaaalaaabaaaaaaaaabgiaaaaaaaaaaaaabpeaaacaaanaaaeaaaaaaaaacai
aaaaaaaaaaaaacbiaaacaabdaaabaaaaaaaaabgiaaaaaaaaaaaaaccdaaacaabc
aaabaaaaaaaaabgiaaaaaaaaaaaaaccoaaacaabbaaabaaaaaaaaabgiaaaaaaaa
aaaaacdjaaacaabgaaabaaaaaaaaabgiaaaaaaaaaaaaaceeaaacaabfaaabaaaa
aaaaabgiaaaaaaaaaaaaacepaaacaabeaaabaaaaaaaaabgiaaaaaaaaaaaaacfk
aaacaabhaaabaaaaaaaaabgiaaaaaaaaaaaaacgeaaacaaaeaaabaaaaaaaaabgi
aaaaaaaafpengbgjgofegfhifpfdfeaaaaabaaadaaabaaaeaaabaaaaaaaaaaaa
fpepgcgkgfgdhedcfhgphcgmgeaaklklaaadaaadaaaeaaaeaaabaaaaaaaaaaaa
ghgmhdhegbhegffpgngbhehcgjhifpgnhghaaahfgogjhehjfpdeemgjghgiheeb
hehegfgodaaahfgogjhehjfpdeemgjghgihefagphdfidaaahfgogjhehjfpdeem
gjghgihefagphdfjdaaahfgogjhehjfpdeemgjghgihefagphdfkdaaahfgogjhe
hjfpemgjghgiheedgpgmgphcaaklklklaaabaaadaaabaaaeaaaeaaaaaaaaaaaa
hfgogjhehjfpfdeiebgcaahfgogjhehjfpfdeiebghaahfgogjhehjfpfdeiebhc
aahfgogjhehjfpfdeiecgcaahfgogjhehjfpfdeiecghaahfgogjhehjfpfdeiec
hcaahfgogjhehjfpfdeiedaahfgogjhehjfpfdgdgbgmgfaahghdfpddfpdaaadc
codacodcdadddfddcodaaaklaaaaaaaaaaaaaaabaaaaaaaaaaaaaaaaaaaaaabe
aapmaabaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaeaaaaaacnmaacbaaah
aaaaaaaaaaaaaaaaaaaacagdaaaaaaabaaaaaaadaaaaaaadaaaaacjaaabaaaag
aaaadaahaadafaaiaaaadafaaaabhbfbaaachcfcaaaababgaaaababfaaaabadl
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadpiaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
habfdaagaaaabcaamcaaaaaaaaaaeaajaaaabcaameaaaaaaaaaagaangabdbcaa
bcaaaaaaaaaagabjgabpbcaabcaaaaaaaaaagacfgaclbcaabcaaaaaaaaaagadb
fadhbcaaccaaaaaaafpidaaaaaaaaanbaaaaaaaaafpibaaaaaaaaoiiaaaaaaaa
afpiaaaaaaaaapmiaaaaaaaamiapaaacaamgiiaakbadadaamiapaaacaalbiiaa
kladacacmiapaaacaagmdejekladabacmiapiadoaablaadekladaaacmiahaaab
aagfblaakbabaeaamiahaaacaamgleaakbadaiaamiahaaaeaalbmalekladahac
miahaaacaalbleaakbabahaamiahaaacaagmlemaklabagacmiahaaadaagmlele
kladagaemialaaabaabllemakladafadmiahaaagaamglemaklabafacmiahiaab
aaleleaaocagagaamiadiaaaaalalabkilaabibiceipagaaaalehcgmobagagia
aibpadafaegmaagmkaabajagaicpadacaelbaamgkaabalagbeabaaaeabdoanbl
gpbbagabaebcahaeaadoangmepbcagakbeaeaaaeabdoanblgpbdagabaecbahab
aakhkhlbipaabeakbeacaaababkhkhblkpaabfabaeeeahabaakhkhmgipaabgak
beapaaaaabpipiblobacacabaeipahacaapilbblmbacagakmiapaaaaaajejepi
olahahaamiapaaacaajemgpiolahagacmiapaaacaajegmaaolafagacmiapaaaa
aaaaaapiolafafaageihababaalologboaaeabadmiahaaabaabllemnklabbhab
miapaaaeaapipigmilaaamppfibaaaaaaaaaaagmocaaaaiaficaaaaaaaaaaalb
ocaaaaiafieaaaaaaaaaaamgocaaaaiafiiaaaaaaaaaaablocaaaaiamiapaaaa
aapiaaaaobacaaaaemipaaadaapilbmgkcaappaeemecacaaaamgblgmobadaaae
emciacacaagmmgblobadacaeembbaaacaabllblbobadacaemiaeaaaaaalbgmaa
obadaaaakibhacaeaalmmaecibacapbakiciacaeaamgblicmbaeadbakieoacaf
aabgpmmaibacanbabeahaaaaaabbmalbkbaaaoafambiafaaaamgmggmobaaadad
beahaaaaaabebamgoaafaaacamihacaaaamabalboaaaaeadmiahaaaaaamabaaa
oaaaacaamiahiaacaalemaaaoaabaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 256 [glstate_matrix_mvp]
Vector 467 [unity_Scale]
Matrix 260 [_Object2World]
Vector 466 [unity_4LightPosX0]
Vector 465 [unity_4LightPosY0]
Vector 464 [unity_4LightPosZ0]
Vector 463 [unity_4LightAtten0]
Vector 462 [unity_LightColor0]
Vector 461 [unity_LightColor1]
Vector 460 [unity_LightColor2]
Vector 459 [unity_LightColor3]
Vector 458 [unity_SHAr]
Vector 457 [unity_SHAg]
Vector 456 [unity_SHAb]
Vector 455 [unity_SHBr]
Vector 454 [unity_SHBg]
Vector 453 [unity_SHBb]
Vector 452 [unity_SHC]
Vector 451 [_MainTex_ST]
"sce_vp_rsx // 48 instructions using 7 registers
[Configuration]
8
0000003001050700
[Defaults]
1
450 2
000000003f800000
[Microcode]
768
00009c6c009d320c013fc0c36041dffc401f9c6c011c3808010400d740619f9c
401f9c6c01d0300d8106c0c360403f8000001c6c01d0400d8106c0c360411ffc
00001c6c01d0500d8106c0c360409ffc00001c6c01d0600d8106c0c360405ffc
00029c6c0150400c028600c360411ffc00021c6c0150600c028600c360403ffc
00029c6c0150500c028600c360403ffc00009c6c00dd000d8186c0b54021fffc
00019c6c00dd100d8186c0aaa021fffc00001c6c00dd200d8186c0a00021fffc
00011c6c0080007f8a86c3436041fffc00019c6c0080000d8686c3436041fffc
00031c6c0080007f8abfc54360411ffc00029c6c0040007f8a86c08360409ffc
00029c6c0040007f8886c08360405ffc00011c6c010000000a86c0436121fffc
00019c6c0100000d8086c04361a1fffc00021c6c019c800c0a86c0c360405ffc
00021c6c019c900c0a86c0c360409ffc00021c6c019ca00c0a86c0c360411ffc
00001c6c0080000d0a9a05436041fffc00029c6c010000000a80056003209ffc
00011c6c0100007f8886c1436121fffc00009c6c0100000d8286c14361a1fffc
00019c6c01dc500d8086c0c360405ffc00019c6c01dc600d8086c0c360409ffc
00019c6c01dc700d8086c0c360411ffc00001c6c00c0000c0886c08301a1dffc
00019c6c009c402a8a8600c36041dffc00021c6c00c0000c0686c0830021dffc
401f9c6c21d0200d8106c0c000b04000401f9c6c21d0100d8106c0caa0a88000
00019c6c209cf00d8286c0d540a5e07c00019c6c00dc202a8186c08361a1fffc
401f9c6c21d0000d8106c0dfe0a30000401f9c6c1040007f8886c08001b040a0
401f9c6c1040007f8a86c08aa1a880a0401f9c6c104000000a86c09541a500a0
00001c6c1080000d8486c05fe1a3e0fc00001c6c029c200d808000c36041fffc
00001c6c0080000d8086c1436041fffc00009c6c009cd02a808600c36041dffc
00009c6c011ce000008600c300a1dffc00001c6c011cc055008600c300a1dffc
00001c6c011cb07f808600c30021dffc401f9c6c00c0000c0886c0830021dfa5
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightAtten0;

uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = tmpvar_4;
  mediump vec3 tmpvar_6;
  mediump vec4 normal;
  normal = tmpvar_5;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_7;
  tmpvar_7 = dot (unity_SHAr, normal);
  x1.x = tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = dot (unity_SHAg, normal);
  x1.y = tmpvar_8;
  highp float tmpvar_9;
  tmpvar_9 = dot (unity_SHAb, normal);
  x1.z = tmpvar_9;
  mediump vec4 tmpvar_10;
  tmpvar_10 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_11;
  tmpvar_11 = dot (unity_SHBr, tmpvar_10);
  x2.x = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHBg, tmpvar_10);
  x2.y = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHBb, tmpvar_10);
  x2.z = tmpvar_13;
  mediump float tmpvar_14;
  tmpvar_14 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = (unity_SHC.xyz * vC);
  x3 = tmpvar_15;
  tmpvar_6 = ((x1 + x2) + x3);
  shlight = tmpvar_6;
  tmpvar_2 = shlight;
  highp vec3 tmpvar_16;
  tmpvar_16 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_17;
  tmpvar_17 = (unity_4LightPosX0 - tmpvar_16.x);
  highp vec4 tmpvar_18;
  tmpvar_18 = (unity_4LightPosY0 - tmpvar_16.y);
  highp vec4 tmpvar_19;
  tmpvar_19 = (unity_4LightPosZ0 - tmpvar_16.z);
  highp vec4 tmpvar_20;
  tmpvar_20 = (((tmpvar_17 * tmpvar_17) + (tmpvar_18 * tmpvar_18)) + (tmpvar_19 * tmpvar_19));
  highp vec4 tmpvar_21;
  tmpvar_21 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_17 * tmpvar_4.x) + (tmpvar_18 * tmpvar_4.y)) + (tmpvar_19 * tmpvar_4.z)) * inversesqrt (tmpvar_20))) * (1.0/((1.0 + (tmpvar_20 * unity_4LightAtten0)))));
  highp vec3 tmpvar_22;
  tmpvar_22 = (tmpvar_2 + ((((unity_LightColor[0].xyz * tmpvar_21.x) + (unity_LightColor[1].xyz * tmpvar_21.y)) + (unity_LightColor[2].xyz * tmpvar_21.z)) + (unity_LightColor[3].xyz * tmpvar_21.w)));
  tmpvar_2 = tmpvar_22;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_1.xyz * _LightColor0.xyz) * (max (0.0, dot (xlv_TEXCOORD1, _WorldSpaceLightPos0.xyz)) * 2.0));
  c_i0_i1.w = tmpvar_1.w;
  c = c_i0_i1;
  c.xyz = (c_i0_i1.xyz + (tmpvar_1.xyz * xlv_TEXCOORD2));
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightAtten0;

uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = tmpvar_4;
  mediump vec3 tmpvar_6;
  mediump vec4 normal;
  normal = tmpvar_5;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_7;
  tmpvar_7 = dot (unity_SHAr, normal);
  x1.x = tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = dot (unity_SHAg, normal);
  x1.y = tmpvar_8;
  highp float tmpvar_9;
  tmpvar_9 = dot (unity_SHAb, normal);
  x1.z = tmpvar_9;
  mediump vec4 tmpvar_10;
  tmpvar_10 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_11;
  tmpvar_11 = dot (unity_SHBr, tmpvar_10);
  x2.x = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHBg, tmpvar_10);
  x2.y = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHBb, tmpvar_10);
  x2.z = tmpvar_13;
  mediump float tmpvar_14;
  tmpvar_14 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = (unity_SHC.xyz * vC);
  x3 = tmpvar_15;
  tmpvar_6 = ((x1 + x2) + x3);
  shlight = tmpvar_6;
  tmpvar_2 = shlight;
  highp vec3 tmpvar_16;
  tmpvar_16 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_17;
  tmpvar_17 = (unity_4LightPosX0 - tmpvar_16.x);
  highp vec4 tmpvar_18;
  tmpvar_18 = (unity_4LightPosY0 - tmpvar_16.y);
  highp vec4 tmpvar_19;
  tmpvar_19 = (unity_4LightPosZ0 - tmpvar_16.z);
  highp vec4 tmpvar_20;
  tmpvar_20 = (((tmpvar_17 * tmpvar_17) + (tmpvar_18 * tmpvar_18)) + (tmpvar_19 * tmpvar_19));
  highp vec4 tmpvar_21;
  tmpvar_21 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_17 * tmpvar_4.x) + (tmpvar_18 * tmpvar_4.y)) + (tmpvar_19 * tmpvar_4.z)) * inversesqrt (tmpvar_20))) * (1.0/((1.0 + (tmpvar_20 * unity_4LightAtten0)))));
  highp vec3 tmpvar_22;
  tmpvar_22 = (tmpvar_2 + ((((unity_LightColor[0].xyz * tmpvar_21.x) + (unity_LightColor[1].xyz * tmpvar_21.y)) + (unity_LightColor[2].xyz * tmpvar_21.z)) + (unity_LightColor[3].xyz * tmpvar_21.w)));
  tmpvar_2 = tmpvar_22;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_1.xyz * _LightColor0.xyz) * (max (0.0, dot (xlv_TEXCOORD1, _WorldSpaceLightPos0.xyz)) * 2.0));
  c_i0_i1.w = tmpvar_1.w;
  c = c_i0_i1;
  c.xyz = (c_i0_i1.xyz + (tmpvar_1.xyz * xlv_TEXCOORD2));
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_Scale]
Matrix 4 [_Object2World]
Vector 9 [unity_4LightPosX0]
Vector 10 [unity_4LightPosY0]
Vector 11 [unity_4LightPosZ0]
Vector 12 [unity_4LightAtten0]
Vector 13 [unity_LightColor0]
Vector 14 [unity_LightColor1]
Vector 15 [unity_LightColor2]
Vector 16 [unity_LightColor3]
Vector 17 [unity_SHAr]
Vector 18 [unity_SHAg]
Vector 19 [unity_SHAb]
Vector 20 [unity_SHBr]
Vector 21 [unity_SHBg]
Vector 22 [unity_SHBb]
Vector 23 [unity_SHC]
Vector 24 [_MainTex_ST]
"agal_vs
c25 1.0 0.0 0.0 0.0
[bc]
adaaaaaaadaaahacabaaaaoeaaaaaaaaaiaaaappabaaaaaa mul r3.xyz, a1, c8.w
bcaaaaaaaeaaabacadaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 r4.x, r3.xyzz, c4
bcaaaaaaadaaaiacadaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 r3.w, r3.xyzz, c5
bcaaaaaaadaaabacadaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 r3.x, r3.xyzz, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.x, a0, c5
bfaaaaaaabaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r1.x, r0.x
abaaaaaaabaaapacabaaaaaaacaaaaaaakaaaaoeabaaaaaa add r1, r1.x, c10
adaaaaaaacaaapacadaaaappacaaaaaaabaaaaoeacaaaaaa mul r2, r3.w, r1
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bfaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r0.x, r0.x
abaaaaaaaaaaapacaaaaaaaaacaaaaaaajaaaaoeabaaaaaa add r0, r0.x, c9
adaaaaaaabaaapacabaaaaoeacaaaaaaabaaaaoeacaaaaaa mul r1, r1, r1
aaaaaaaaaeaaaeacadaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r4.z, r3.x
aaaaaaaaaeaaaiacbjaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r4.w, c25.x
adaaaaaaafaaapacaeaaaaaaacaaaaaaaaaaaaoeacaaaaaa mul r5, r4.x, r0
abaaaaaaacaaapacafaaaaoeacaaaaaaacaaaaoeacaaaaaa add r2, r5, r2
bdaaaaaaaeaaacacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r4.y, a0, c6
adaaaaaaafaaapacaaaaaaoeacaaaaaaaaaaaaoeacaaaaaa mul r5, r0, r0
abaaaaaaabaaapacafaaaaoeacaaaaaaabaaaaoeacaaaaaa add r1, r5, r1
bfaaaaaaaaaaacacaeaaaaffacaaaaaaaaaaaaaaaaaaaaaa neg r0.y, r4.y
abaaaaaaaaaaapacaaaaaaffacaaaaaaalaaaaoeabaaaaaa add r0, r0.y, c11
adaaaaaaafaaapacaaaaaaoeacaaaaaaaaaaaaoeacaaaaaa mul r5, r0, r0
abaaaaaaabaaapacafaaaaoeacaaaaaaabaaaaoeacaaaaaa add r1, r5, r1
adaaaaaaaaaaapacadaaaaaaacaaaaaaaaaaaaoeacaaaaaa mul r0, r3.x, r0
abaaaaaaaaaaapacaaaaaaoeacaaaaaaacaaaaoeacaaaaaa add r0, r0, r2
adaaaaaaacaaapacabaaaaoeacaaaaaaamaaaaoeabaaaaaa mul r2, r1, c12
aaaaaaaaaeaaacacadaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r4.y, r3.w
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
akaaaaaaabaaacacabaaaaffacaaaaaaaaaaaaaaaaaaaaaa rsq r1.y, r1.y
akaaaaaaabaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r1.w, r1.w
akaaaaaaabaaaeacabaaaakkacaaaaaaaaaaaaaaaaaaaaaa rsq r1.z, r1.z
adaaaaaaaaaaapacaaaaaaoeacaaaaaaabaaaaoeacaaaaaa mul r0, r0, r1
abaaaaaaabaaapacacaaaaoeacaaaaaabjaaaaaaabaaaaaa add r1, r2, c25.x
bdaaaaaaacaaaeacaeaaaaoeacaaaaaabdaaaaoeabaaaaaa dp4 r2.z, r4, c19
bdaaaaaaacaaacacaeaaaaoeacaaaaaabcaaaaoeabaaaaaa dp4 r2.y, r4, c18
bdaaaaaaacaaabacaeaaaaoeacaaaaaabbaaaaoeabaaaaaa dp4 r2.x, r4, c17
afaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r1.x, r1.x
afaaaaaaabaaacacabaaaaffacaaaaaaaaaaaaaaaaaaaaaa rcp r1.y, r1.y
afaaaaaaabaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa rcp r1.w, r1.w
afaaaaaaabaaaeacabaaaakkacaaaaaaaaaaaaaaaaaaaaaa rcp r1.z, r1.z
ahaaaaaaaaaaapacaaaaaaoeacaaaaaabjaaaaffabaaaaaa max r0, r0, c25.y
adaaaaaaaaaaapacaaaaaaoeacaaaaaaabaaaaoeacaaaaaa mul r0, r0, r1
adaaaaaaabaaahacaaaaaaffacaaaaaaaoaaaaoeabaaaaaa mul r1.xyz, r0.y, c14
adaaaaaaafaaahacaaaaaaaaacaaaaaaanaaaaoeabaaaaaa mul r5.xyz, r0.x, c13
abaaaaaaabaaahacafaaaakeacaaaaaaabaaaakeacaaaaaa add r1.xyz, r5.xyzz, r1.xyzz
adaaaaaaaaaaahacaaaaaakkacaaaaaaapaaaaoeabaaaaaa mul r0.xyz, r0.z, c15
abaaaaaaaaaaahacaaaaaakeacaaaaaaabaaaakeacaaaaaa add r0.xyz, r0.xyzz, r1.xyzz
adaaaaaaabaaahacaaaaaappacaaaaaabaaaaaoeabaaaaaa mul r1.xyz, r0.w, c16
abaaaaaaabaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r1.xyz, r1.xyzz, r0.xyzz
adaaaaaaaaaaapacaeaaaakeacaaaaaaaeaaaacjacaaaaaa mul r0, r4.xyzz, r4.yzzx
adaaaaaaabaaaiacadaaaappacaaaaaaadaaaappacaaaaaa mul r1.w, r3.w, r3.w
bdaaaaaaaeaaaiacaaaaaaoeacaaaaaabgaaaaoeabaaaaaa dp4 r4.w, r0, c22
bdaaaaaaaeaaaeacaaaaaaoeacaaaaaabfaaaaoeabaaaaaa dp4 r4.z, r0, c21
bdaaaaaaaeaaacacaaaaaaoeacaaaaaabeaaaaoeabaaaaaa dp4 r4.y, r0, c20
adaaaaaaafaaaiacaeaaaaaaacaaaaaaaeaaaaaaacaaaaaa mul r5.w, r4.x, r4.x
acaaaaaaabaaaiacafaaaappacaaaaaaabaaaappacaaaaaa sub r1.w, r5.w, r1.w
adaaaaaaaaaaahacabaaaappacaaaaaabhaaaaoeabaaaaaa mul r0.xyz, r1.w, c23
abaaaaaaacaaahacacaaaakeacaaaaaaaeaaaapjacaaaaaa add r2.xyz, r2.xyzz, r4.yzww
abaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r2.xyzz, r0.xyzz
abaaaaaaacaaahaeaaaaaakeacaaaaaaabaaaakeacaaaaaa add v2.xyz, r0.xyzz, r1.xyzz
aaaaaaaaabaaaeaeadaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov v1.z, r3.x
aaaaaaaaabaaacaeadaaaappacaaaaaaaaaaaaaaaaaaaaaa mov v1.y, r3.w
aaaaaaaaabaaabaeaeaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov v1.x, r4.x
adaaaaaaafaaadacadaaaaoeaaaaaaaabiaaaaoeabaaaaaa mul r5.xy, a3, c24
abaaaaaaaaaaadaeafaaaafeacaaaaaabiaaaaooabaaaaaa add v0.xy, r5.xyyy, c24.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 9 [_ProjectionParams]
Vector 10 [unity_Scale]
Matrix 5 [_Object2World]
Vector 11 [unity_4LightPosX0]
Vector 12 [unity_4LightPosY0]
Vector 13 [unity_4LightPosZ0]
Vector 14 [unity_4LightAtten0]
Vector 15 [unity_LightColor0]
Vector 16 [unity_LightColor1]
Vector 17 [unity_LightColor2]
Vector 18 [unity_LightColor3]
Vector 19 [unity_SHAr]
Vector 20 [unity_SHAg]
Vector 21 [unity_SHAb]
Vector 22 [unity_SHBr]
Vector 23 [unity_SHBg]
Vector 24 [unity_SHBb]
Vector 25 [unity_SHC]
Vector 26 [_MainTex_ST]
"!!ARBvp1.0
# 63 ALU
PARAM c[27] = { { 1, 0, 0.5 },
		state.matrix.mvp,
		program.local[5..26] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R3.xyz, vertex.normal, c[10].w;
DP3 R4.x, R3, c[5];
DP3 R3.w, R3, c[6];
DP3 R3.x, R3, c[7];
DP4 R0.x, vertex.position, c[6];
ADD R1, -R0.x, c[12];
MUL R2, R3.w, R1;
DP4 R0.x, vertex.position, c[5];
ADD R0, -R0.x, c[11];
MUL R1, R1, R1;
MOV R4.z, R3.x;
MOV R4.w, c[0].x;
MAD R2, R4.x, R0, R2;
DP4 R4.y, vertex.position, c[7];
MAD R1, R0, R0, R1;
ADD R0, -R4.y, c[13];
MAD R1, R0, R0, R1;
MAD R0, R3.x, R0, R2;
MUL R2, R1, c[14];
MOV R4.y, R3.w;
RSQ R1.x, R1.x;
RSQ R1.y, R1.y;
RSQ R1.w, R1.w;
RSQ R1.z, R1.z;
MUL R0, R0, R1;
ADD R1, R2, c[0].x;
DP4 R2.z, R4, c[21];
DP4 R2.y, R4, c[20];
DP4 R2.x, R4, c[19];
RCP R1.x, R1.x;
RCP R1.y, R1.y;
RCP R1.w, R1.w;
RCP R1.z, R1.z;
MAX R0, R0, c[0].y;
MUL R0, R0, R1;
MUL R1.xyz, R0.y, c[16];
MAD R1.xyz, R0.x, c[15], R1;
MAD R0.xyz, R0.z, c[17], R1;
MAD R1.xyz, R0.w, c[18], R0;
MUL R0, R4.xyzz, R4.yzzx;
MUL R1.w, R3, R3;
DP4 R4.w, R0, c[24];
DP4 R4.z, R0, c[23];
DP4 R4.y, R0, c[22];
MAD R1.w, R4.x, R4.x, -R1;
MUL R0.xyz, R1.w, c[25];
ADD R2.xyz, R2, R4.yzww;
ADD R4.yzw, R2.xxyz, R0.xxyz;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R2.xyz, R0.xyww, c[0].z;
ADD result.texcoord[2].xyz, R4.yzww, R1;
MOV R1.x, R2;
MUL R1.y, R2, c[9].x;
ADD result.texcoord[3].xy, R1, R2.z;
MOV result.position, R0;
MOV result.texcoord[3].zw, R0;
MOV result.texcoord[1].z, R3.x;
MOV result.texcoord[1].y, R3.w;
MOV result.texcoord[1].x, R4;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[26], c[26].zwzw;
END
# 63 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_Scale]
Matrix 4 [_Object2World]
Vector 11 [unity_4LightPosX0]
Vector 12 [unity_4LightPosY0]
Vector 13 [unity_4LightPosZ0]
Vector 14 [unity_4LightAtten0]
Vector 15 [unity_LightColor0]
Vector 16 [unity_LightColor1]
Vector 17 [unity_LightColor2]
Vector 18 [unity_LightColor3]
Vector 19 [unity_SHAr]
Vector 20 [unity_SHAg]
Vector 21 [unity_SHAb]
Vector 22 [unity_SHBr]
Vector 23 [unity_SHBg]
Vector 24 [unity_SHBb]
Vector 25 [unity_SHC]
Vector 26 [_MainTex_ST]
"vs_2_0
; 63 ALU
def c27, 1.00000000, 0.00000000, 0.50000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r3.xyz, v1, c10.w
dp3 r4.x, r3, c4
dp3 r3.w, r3, c5
dp3 r3.x, r3, c6
dp4 r0.x, v0, c5
add r1, -r0.x, c12
mul r2, r3.w, r1
dp4 r0.x, v0, c4
add r0, -r0.x, c11
mul r1, r1, r1
mov r4.z, r3.x
mov r4.w, c27.x
mad r2, r4.x, r0, r2
dp4 r4.y, v0, c6
mad r1, r0, r0, r1
add r0, -r4.y, c13
mad r1, r0, r0, r1
mad r0, r3.x, r0, r2
mul r2, r1, c14
mov r4.y, r3.w
rsq r1.x, r1.x
rsq r1.y, r1.y
rsq r1.w, r1.w
rsq r1.z, r1.z
mul r0, r0, r1
add r1, r2, c27.x
dp4 r2.z, r4, c21
dp4 r2.y, r4, c20
dp4 r2.x, r4, c19
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c27.y
mul r0, r0, r1
mul r1.xyz, r0.y, c16
mad r1.xyz, r0.x, c15, r1
mad r0.xyz, r0.z, c17, r1
mad r1.xyz, r0.w, c18, r0
mul r0, r4.xyzz, r4.yzzx
mul r1.w, r3, r3
dp4 r4.w, r0, c24
dp4 r4.z, r0, c23
dp4 r4.y, r0, c22
mad r1.w, r4.x, r4.x, -r1
mul r0.xyz, r1.w, c25
add r2.xyz, r2, r4.yzww
add r4.yzw, r2.xxyz, r0.xxyz
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r2.xyz, r0.xyww, c27.z
add oT2.xyz, r4.yzww, r1
mov r1.x, r2
mul r1.y, r2, c8.x
mad oT3.xy, r2.z, c9.zwzw, r1
mov oPos, r0
mov oT3.zw, r0
mov oT1.z, r3.x
mov oT1.y, r3.w
mov oT1.x, r4
mad oT0.xy, v2, c26, c26.zwzw
"
}

SubProgram "xbox360 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 26 [_MainTex_ST]
Matrix 7 [_Object2World] 4
Vector 4 [_ProjectionParams]
Vector 5 [_ScreenParams]
Matrix 0 [glstate_matrix_mvp] 4
Vector 14 [unity_4LightAtten0]
Vector 11 [unity_4LightPosX0]
Vector 12 [unity_4LightPosY0]
Vector 13 [unity_4LightPosZ0]
Vector 15 [unity_LightColor0]
Vector 16 [unity_LightColor1]
Vector 17 [unity_LightColor2]
Vector 18 [unity_LightColor3]
Vector 21 [unity_SHAb]
Vector 20 [unity_SHAg]
Vector 19 [unity_SHAr]
Vector 24 [unity_SHBb]
Vector 23 [unity_SHBg]
Vector 22 [unity_SHBr]
Vector 25 [unity_SHC]
Vector 6 [unity_Scale]
// Shader Timing Estimate, in Cycles/64 vertex vector:
// ALU: 73.33 (55 instructions), vertex: 32, texture: 0,
//   sequencer: 26,  9 GPRs, 21 threads,
// Performance (if enough threads): ~73 cycles per vector
// * Vertex cycle estimates are assuming 3 vfetch_minis for every vfetch_full,
//     with <= 32 bytes per vfetch_full group.

"vs_360
backbbabaaaaadheaaaaadfiaaaaaaaaaaaaaaceaaaaacpeaaaaadbmaaaaaaaa
aaaaaaaaaaaaacmmaaaaaabmaaaaaclppppoadaaaaaaaabcaaaaaabmaaaaaaaa
aaaaacliaaaaabieaaacaabkaaabaaaaaaaaabjaaaaaaaaaaaaaabkaaaacaaah
aaaeaaaaaaaaablaaaaaaaaaaaaaabmaaaacaaaeaaabaaaaaaaaabjaaaaaaaaa
aaaaabncaaacaaafaaabaaaaaaaaabjaaaaaaaaaaaaaaboaaaacaaaaaaaeaaaa
aaaaablaaaaaaaaaaaaaabpdaaacaaaoaaabaaaaaaaaabjaaaaaaaaaaaaaacag
aaacaaalaaabaaaaaaaaabjaaaaaaaaaaaaaacbiaaacaaamaaabaaaaaaaaabja
aaaaaaaaaaaaacckaaacaaanaaabaaaaaaaaabjaaaaaaaaaaaaaacdmaaacaaap
aaaeaaaaaaaaacfaaaaaaaaaaaaaacgaaaacaabfaaabaaaaaaaaabjaaaaaaaaa
aaaaacglaaacaabeaaabaaaaaaaaabjaaaaaaaaaaaaaachgaaacaabdaaabaaaa
aaaaabjaaaaaaaaaaaaaacibaaacaabiaaabaaaaaaaaabjaaaaaaaaaaaaaacim
aaacaabhaaabaaaaaaaaabjaaaaaaaaaaaaaacjhaaacaabgaaabaaaaaaaaabja
aaaaaaaaaaaaackcaaacaabjaaabaaaaaaaaabjaaaaaaaaaaaaaackmaaacaaag
aaabaaaaaaaaabjaaaaaaaaafpengbgjgofegfhifpfdfeaaaaabaaadaaabaaae
aaabaaaaaaaaaaaafpepgcgkgfgdhedcfhgphcgmgeaaklklaaadaaadaaaeaaae
aaabaaaaaaaaaaaafpfahcgpgkgfgdhegjgpgofagbhcgbgnhdaafpfdgdhcgfgf
gofagbhcgbgnhdaaghgmhdhegbhegffpgngbhehcgjhifpgnhghaaahfgogjhehj
fpdeemgjghgiheebhehegfgodaaahfgogjhehjfpdeemgjghgihefagphdfidaaa
hfgogjhehjfpdeemgjghgihefagphdfjdaaahfgogjhehjfpdeemgjghgihefagp
hdfkdaaahfgogjhehjfpemgjghgiheedgpgmgphcaaklklklaaabaaadaaabaaae
aaaeaaaaaaaaaaaahfgogjhehjfpfdeiebgcaahfgogjhehjfpfdeiebghaahfgo
gjhehjfpfdeiebhcaahfgogjhehjfpfdeiecgcaahfgogjhehjfpfdeiecghaahf
gogjhehjfpfdeiechcaahfgogjhehjfpfdeiedaahfgogjhehjfpfdgdgbgmgfaa
hghdfpddfpdaaadccodacodcdadddfddcodaaaklaaaaaaaaaaaaaaabaaaaaaaa
aaaaaaaaaaaaaabeaapmaabaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaea
aaaaadbiaadbaaaiaaaaaaaaaaaaaaaaaaaadaieaaaaaaabaaaaaaadaaaaaaaf
aaaaacjaaabaaaahaaaadaaiaacafaajaaaadafaaaabhbfbaaachcfcaaadpdfd
aaaababnaaaababmaaaabaeaaaaaaablaaaabaciaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaadpaaaaaaaaaaaaaadpiaaaaaaaaaaaaahabfdaahaaaabcaamcaaaaaa
aaaafaakaaaabcaameaaaaaaaaaagaapgabfbcaabcaaaaaaaaaagablgacbbcaa
bcaaaaaaaaaagachgacnbcaabcaaaaaaaaaagaddgadjbcaabcaaaaaaaaaacadp
aaaaccaaaaaaaaaaafpibaaaaaaaaanbaaaaaaaaafpiaaaaaaaaaeehaaaaaaaa
afpidaaaaaaaacdpaaaaaaaamiapaaacaamgiiaakbabadaamiapaaacaalbnapi
klabacacmiapaaacaagmdepiklababacmiapaaaeaablnajeklabaaacmiapiado
aananaaaocaeaeaamialaaaaaalkblaakbaaagaamiahaaacaamgleaakbabakaa
miahaaacaalbmaleklabajacmiahaaafaalbleaakbaaajaamiahaaaaaagmlema
klaaaiafmiahaaabaagmleleklabaiacmialaaabaabllemaklabahabmiahaaah
aabllemaklaaahaaceihahaaaamagmgmkbaeppiaaibpadafaalehcgmobahahah
aicpadagaegmaamgkaabalahbeapaaacaflbaablkaabanabmiamiaadaanlnlaa
ocaeaeaamiahiaabaaleleaaocahahaamiadiaaaaabklabkiladbkbkaebbaiae
aadoangmepbdahambeacaaaeabdoanblgpbeahabaeceaiaeaadoanlbepbfaham
beabaaababkhkhblkpafbgabaeecaiabaakhkhmgipafbhambeaeaaababkhkhbl
kpafbiabaeipaiafaapipiblmbacacamkiipaaacaapilbebmbacahaemiapaaaf
aajejepiolaiaiafmiapaaacaajemgpiolaiahacmiadiaadaamgbkbiklaaafaa
miapaaacaajegmaaolagahacmiapaaaaaaaaaapiolagagafgeihababaalologb
oaaeabadmiahaaabaabllemnklabbjabmiapaaaeaapipimgilaaaoppfibaaaaa
aaaaaagmocaaaaiaficaaaaaaaaaaalbocaaaaiafieaaaaaaaaaaamgocaaaaia
fiiaaaaaaaaaaablocaaaaiamiapaaaaaapiaaaaobacaaaaemipaaadaapilbmg
kcaappaeemecacaaaamgblgmobadaaaeemciacacaagmmgblobadacaeembbaaac
aabllblbobadacaemiaeaaaaaalbgmaaobadaaaakibhacaeaalmmaecibacbbbc
kiciacaeaamgblicmbaeadbckieoacafaabgpmmaibacapbcbeahaaaaaabbmalb
kbaabaafambiafaaaamgmggmobaaadadbeahaaaaaabebamgoaafaaacamihacaa
aamabalboaaaaeadmiahaaaaaamabaaaoaaaacaamiahiaacaalemaaaoaabaaaa
aaaaaaaaaaaaaaaaaaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 256 [glstate_matrix_mvp]
Vector 467 [_ProjectionParams]
Vector 466 [unity_Scale]
Matrix 260 [_Object2World]
Vector 465 [unity_4LightPosX0]
Vector 464 [unity_4LightPosY0]
Vector 463 [unity_4LightPosZ0]
Vector 462 [unity_4LightAtten0]
Vector 461 [unity_LightColor0]
Vector 460 [unity_LightColor1]
Vector 459 [unity_LightColor2]
Vector 458 [unity_LightColor3]
Vector 457 [unity_SHAr]
Vector 456 [unity_SHAg]
Vector 455 [unity_SHAb]
Vector 454 [unity_SHBr]
Vector 453 [unity_SHBg]
Vector 452 [unity_SHBb]
Vector 451 [unity_SHC]
Vector 450 [_MainTex_ST]
"sce_vp_rsx // 54 instructions using 8 registers
[Configuration]
8
0000003601050800
[Defaults]
1
449 3
000000003f8000003f000000
[Microcode]
864
00009c6c009d220c013fc0c36041dffc401f9c6c011c2808010400d740619f9c
00001c6c01d0200d8106c0c360405ffc00001c6c01d0300d8106c0c360403ffc
00001c6c01d0100d8106c0c360409ffc00001c6c01d0000d8106c0c360411ffc
00019c6c01d0500d8106c0c360411ffc00009c6c01d0400d8106c0c360403ffc
00011c6c01d0600d8106c0c360411ffc00031c6c0150400c028600c360411ffc
00029c6c0150600c028600c360403ffc00031c6c0150500c028600c360403ffc
00011c6c00dcf00d8186c0a00121fffc00009c6c00dd100d8186c0bfe0a1fffc
00021c6c00dd000d8186c0a001a1fffc00029c6c009c100e00aa80c36041dffc
00019c6c0080007f8c86c4436041fffc00029c6c009d302a8a8000c360409ffc
00021c6c0080000d8886c4436041fffc00039c6c0080007f8cbfc64360411ffc
00031c6c0040007f8c86c08360409ffc00031c6c0040007f8a86c08360405ffc
00019c6c010000000c86c14361a1fffc00021c6c0100000d8286c1436221fffc
401f9c6c00c000080a86c09542a19fa800029c6c019c700c0c86c0c360405ffc
00029c6c019c800c0c86c0c360409ffc00029c6c019c900c0c86c0c360411ffc
00009c6c0080000d0c9a06436041fffc00031c6c010000000c80066003a09ffc
00019c6c0100007f8a86c24361a1fffc00011c6c0100000d8486c2436221fffc
00021c6c01dc400d8286c0c360405ffc00021c6c01dc500d8286c0c360409ffc
00021c6c01dc600d8286c0c360411ffc00009c6c00c0000c0a86c0830221dffc
00021c6c009c302a8c8600c36041dffc00021c6c00c0000c0886c08300a1dffc
401f9c6c2040000d8086c0800131e080001f9c6c2000000d8106c08aa12800fc
00039c6c209ce00d8486c0d54125e0fc00039c6c00dc102a8186c08363a1fffc
401f9c6c204000558086c09fe12260a8401f9c6c1040007f8a86c08003b04020
401f9c6c1040007f8c86c08aa3a88020401f9c6c104000000c86c09543a50020
00009c6c1080000d8686c15fe3a3e07c00009c6c029c100d828000c36041fffc
00001c6c0080000d8286c0436041fffc00009c6c009cc02a808600c36041dffc
00009c6c011cd000008600c300a1dffc00001c6c011cb055008600c300a1dffc
00001c6c011ca07f808600c30021dffc401f9c6c00c0000c0886c0830021dfa5
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightAtten0;

uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (gl_ModelViewProjectionMatrix * _glesVertex);
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  mediump vec3 tmpvar_7;
  mediump vec4 normal;
  normal = tmpvar_6;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_8;
  tmpvar_8 = dot (unity_SHAr, normal);
  x1.x = tmpvar_8;
  highp float tmpvar_9;
  tmpvar_9 = dot (unity_SHAg, normal);
  x1.y = tmpvar_9;
  highp float tmpvar_10;
  tmpvar_10 = dot (unity_SHAb, normal);
  x1.z = tmpvar_10;
  mediump vec4 tmpvar_11;
  tmpvar_11 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHBr, tmpvar_11);
  x2.x = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHBg, tmpvar_11);
  x2.y = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHBb, tmpvar_11);
  x2.z = tmpvar_14;
  mediump float tmpvar_15;
  tmpvar_15 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (unity_SHC.xyz * vC);
  x3 = tmpvar_16;
  tmpvar_7 = ((x1 + x2) + x3);
  shlight = tmpvar_7;
  tmpvar_2 = shlight;
  highp vec3 tmpvar_17;
  tmpvar_17 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_18;
  tmpvar_18 = (unity_4LightPosX0 - tmpvar_17.x);
  highp vec4 tmpvar_19;
  tmpvar_19 = (unity_4LightPosY0 - tmpvar_17.y);
  highp vec4 tmpvar_20;
  tmpvar_20 = (unity_4LightPosZ0 - tmpvar_17.z);
  highp vec4 tmpvar_21;
  tmpvar_21 = (((tmpvar_18 * tmpvar_18) + (tmpvar_19 * tmpvar_19)) + (tmpvar_20 * tmpvar_20));
  highp vec4 tmpvar_22;
  tmpvar_22 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_18 * tmpvar_5.x) + (tmpvar_19 * tmpvar_5.y)) + (tmpvar_20 * tmpvar_5.z)) * inversesqrt (tmpvar_21))) * (1.0/((1.0 + (tmpvar_21 * unity_4LightAtten0)))));
  highp vec3 tmpvar_23;
  tmpvar_23 = (tmpvar_2 + ((((unity_LightColor[0].xyz * tmpvar_22.x) + (unity_LightColor[1].xyz * tmpvar_22.y)) + (unity_LightColor[2].xyz * tmpvar_22.z)) + (unity_LightColor[3].xyz * tmpvar_22.w)));
  tmpvar_2 = tmpvar_23;
  highp vec4 o_i0;
  highp vec4 tmpvar_24;
  tmpvar_24 = (tmpvar_3 * 0.5);
  o_i0 = tmpvar_24;
  highp vec2 tmpvar_25;
  tmpvar_25.x = tmpvar_24.x;
  tmpvar_25.y = (tmpvar_24.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_25 + tmpvar_24.w);
  o_i0.zw = tmpvar_3.zw;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = o_i0;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_1.xyz * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD1, _WorldSpaceLightPos0.xyz)) * texture2DProj (_ShadowMapTexture, xlv_TEXCOORD3).x) * 2.0));
  c_i0_i1.w = tmpvar_1.w;
  c = c_i0_i1;
  c.xyz = (c_i0_i1.xyz + (tmpvar_1.xyz * xlv_TEXCOORD2));
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightAtten0;

uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (gl_ModelViewProjectionMatrix * _glesVertex);
  mat3 tmpvar_4;
  tmpvar_4[0] = _Object2World[0].xyz;
  tmpvar_4[1] = _Object2World[1].xyz;
  tmpvar_4[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_5;
  mediump vec3 tmpvar_7;
  mediump vec4 normal;
  normal = tmpvar_6;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_8;
  tmpvar_8 = dot (unity_SHAr, normal);
  x1.x = tmpvar_8;
  highp float tmpvar_9;
  tmpvar_9 = dot (unity_SHAg, normal);
  x1.y = tmpvar_9;
  highp float tmpvar_10;
  tmpvar_10 = dot (unity_SHAb, normal);
  x1.z = tmpvar_10;
  mediump vec4 tmpvar_11;
  tmpvar_11 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHBr, tmpvar_11);
  x2.x = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHBg, tmpvar_11);
  x2.y = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHBb, tmpvar_11);
  x2.z = tmpvar_14;
  mediump float tmpvar_15;
  tmpvar_15 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (unity_SHC.xyz * vC);
  x3 = tmpvar_16;
  tmpvar_7 = ((x1 + x2) + x3);
  shlight = tmpvar_7;
  tmpvar_2 = shlight;
  highp vec3 tmpvar_17;
  tmpvar_17 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_18;
  tmpvar_18 = (unity_4LightPosX0 - tmpvar_17.x);
  highp vec4 tmpvar_19;
  tmpvar_19 = (unity_4LightPosY0 - tmpvar_17.y);
  highp vec4 tmpvar_20;
  tmpvar_20 = (unity_4LightPosZ0 - tmpvar_17.z);
  highp vec4 tmpvar_21;
  tmpvar_21 = (((tmpvar_18 * tmpvar_18) + (tmpvar_19 * tmpvar_19)) + (tmpvar_20 * tmpvar_20));
  highp vec4 tmpvar_22;
  tmpvar_22 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_18 * tmpvar_5.x) + (tmpvar_19 * tmpvar_5.y)) + (tmpvar_20 * tmpvar_5.z)) * inversesqrt (tmpvar_21))) * (1.0/((1.0 + (tmpvar_21 * unity_4LightAtten0)))));
  highp vec3 tmpvar_23;
  tmpvar_23 = (tmpvar_2 + ((((unity_LightColor[0].xyz * tmpvar_22.x) + (unity_LightColor[1].xyz * tmpvar_22.y)) + (unity_LightColor[2].xyz * tmpvar_22.z)) + (unity_LightColor[3].xyz * tmpvar_22.w)));
  tmpvar_2 = tmpvar_23;
  highp vec4 o_i0;
  highp vec4 tmpvar_24;
  tmpvar_24 = (tmpvar_3 * 0.5);
  o_i0 = tmpvar_24;
  highp vec2 tmpvar_25;
  tmpvar_25.x = tmpvar_24.x;
  tmpvar_25.y = (tmpvar_24.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_25 + tmpvar_24.w);
  o_i0.zw = tmpvar_3.zw;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = o_i0;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_1.xyz * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD1, _WorldSpaceLightPos0.xyz)) * texture2DProj (_ShadowMapTexture, xlv_TEXCOORD3).x) * 2.0));
  c_i0_i1.w = tmpvar_1.w;
  c = c_i0_i1;
  c.xyz = (c_i0_i1.xyz + (tmpvar_1.xyz * xlv_TEXCOORD2));
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [unity_NPOTScale]
Vector 10 [unity_Scale]
Matrix 4 [_Object2World]
Vector 11 [unity_4LightPosX0]
Vector 12 [unity_4LightPosY0]
Vector 13 [unity_4LightPosZ0]
Vector 14 [unity_4LightAtten0]
Vector 15 [unity_LightColor0]
Vector 16 [unity_LightColor1]
Vector 17 [unity_LightColor2]
Vector 18 [unity_LightColor3]
Vector 19 [unity_SHAr]
Vector 20 [unity_SHAg]
Vector 21 [unity_SHAb]
Vector 22 [unity_SHBr]
Vector 23 [unity_SHBg]
Vector 24 [unity_SHBb]
Vector 25 [unity_SHC]
Vector 26 [_MainTex_ST]
"agal_vs
c27 1.0 0.0 0.5 0.0
[bc]
adaaaaaaadaaahacabaaaaoeaaaaaaaaakaaaappabaaaaaa mul r3.xyz, a1, c10.w
bcaaaaaaaeaaabacadaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 r4.x, r3.xyzz, c4
bcaaaaaaadaaaiacadaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 r3.w, r3.xyzz, c5
bcaaaaaaadaaabacadaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 r3.x, r3.xyzz, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.x, a0, c5
bfaaaaaaabaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r1.x, r0.x
abaaaaaaabaaapacabaaaaaaacaaaaaaamaaaaoeabaaaaaa add r1, r1.x, c12
adaaaaaaacaaapacadaaaappacaaaaaaabaaaaoeacaaaaaa mul r2, r3.w, r1
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bfaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r0.x, r0.x
abaaaaaaaaaaapacaaaaaaaaacaaaaaaalaaaaoeabaaaaaa add r0, r0.x, c11
adaaaaaaabaaapacabaaaaoeacaaaaaaabaaaaoeacaaaaaa mul r1, r1, r1
aaaaaaaaaeaaaeacadaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r4.z, r3.x
aaaaaaaaaeaaaiacblaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r4.w, c27.x
adaaaaaaafaaapacaeaaaaaaacaaaaaaaaaaaaoeacaaaaaa mul r5, r4.x, r0
abaaaaaaacaaapacafaaaaoeacaaaaaaacaaaaoeacaaaaaa add r2, r5, r2
bdaaaaaaaeaaacacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r4.y, a0, c6
adaaaaaaafaaapacaaaaaaoeacaaaaaaaaaaaaoeacaaaaaa mul r5, r0, r0
abaaaaaaabaaapacafaaaaoeacaaaaaaabaaaaoeacaaaaaa add r1, r5, r1
bfaaaaaaaaaaacacaeaaaaffacaaaaaaaaaaaaaaaaaaaaaa neg r0.y, r4.y
abaaaaaaaaaaapacaaaaaaffacaaaaaaanaaaaoeabaaaaaa add r0, r0.y, c13
adaaaaaaafaaapacaaaaaaoeacaaaaaaaaaaaaoeacaaaaaa mul r5, r0, r0
abaaaaaaabaaapacafaaaaoeacaaaaaaabaaaaoeacaaaaaa add r1, r5, r1
adaaaaaaaaaaapacadaaaaaaacaaaaaaaaaaaaoeacaaaaaa mul r0, r3.x, r0
abaaaaaaaaaaapacaaaaaaoeacaaaaaaacaaaaoeacaaaaaa add r0, r0, r2
adaaaaaaacaaapacabaaaaoeacaaaaaaaoaaaaoeabaaaaaa mul r2, r1, c14
aaaaaaaaaeaaacacadaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r4.y, r3.w
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
akaaaaaaabaaacacabaaaaffacaaaaaaaaaaaaaaaaaaaaaa rsq r1.y, r1.y
akaaaaaaabaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r1.w, r1.w
akaaaaaaabaaaeacabaaaakkacaaaaaaaaaaaaaaaaaaaaaa rsq r1.z, r1.z
adaaaaaaaaaaapacaaaaaaoeacaaaaaaabaaaaoeacaaaaaa mul r0, r0, r1
abaaaaaaabaaapacacaaaaoeacaaaaaablaaaaaaabaaaaaa add r1, r2, c27.x
bdaaaaaaacaaaeacaeaaaaoeacaaaaaabfaaaaoeabaaaaaa dp4 r2.z, r4, c21
bdaaaaaaacaaacacaeaaaaoeacaaaaaabeaaaaoeabaaaaaa dp4 r2.y, r4, c20
bdaaaaaaacaaabacaeaaaaoeacaaaaaabdaaaaoeabaaaaaa dp4 r2.x, r4, c19
afaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r1.x, r1.x
afaaaaaaabaaacacabaaaaffacaaaaaaaaaaaaaaaaaaaaaa rcp r1.y, r1.y
afaaaaaaabaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa rcp r1.w, r1.w
afaaaaaaabaaaeacabaaaakkacaaaaaaaaaaaaaaaaaaaaaa rcp r1.z, r1.z
ahaaaaaaaaaaapacaaaaaaoeacaaaaaablaaaaffabaaaaaa max r0, r0, c27.y
adaaaaaaaaaaapacaaaaaaoeacaaaaaaabaaaaoeacaaaaaa mul r0, r0, r1
adaaaaaaabaaahacaaaaaaffacaaaaaabaaaaaoeabaaaaaa mul r1.xyz, r0.y, c16
adaaaaaaafaaahacaaaaaaaaacaaaaaaapaaaaoeabaaaaaa mul r5.xyz, r0.x, c15
abaaaaaaabaaahacafaaaakeacaaaaaaabaaaakeacaaaaaa add r1.xyz, r5.xyzz, r1.xyzz
adaaaaaaaaaaahacaaaaaakkacaaaaaabbaaaaoeabaaaaaa mul r0.xyz, r0.z, c17
abaaaaaaaaaaahacaaaaaakeacaaaaaaabaaaakeacaaaaaa add r0.xyz, r0.xyzz, r1.xyzz
adaaaaaaabaaahacaaaaaappacaaaaaabcaaaaoeabaaaaaa mul r1.xyz, r0.w, c18
abaaaaaaabaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r1.xyz, r1.xyzz, r0.xyzz
adaaaaaaaaaaapacaeaaaakeacaaaaaaaeaaaacjacaaaaaa mul r0, r4.xyzz, r4.yzzx
adaaaaaaabaaaiacadaaaappacaaaaaaadaaaappacaaaaaa mul r1.w, r3.w, r3.w
bdaaaaaaaeaaaiacaaaaaaoeacaaaaaabiaaaaoeabaaaaaa dp4 r4.w, r0, c24
bdaaaaaaaeaaaeacaaaaaaoeacaaaaaabhaaaaoeabaaaaaa dp4 r4.z, r0, c23
bdaaaaaaaeaaacacaaaaaaoeacaaaaaabgaaaaoeabaaaaaa dp4 r4.y, r0, c22
adaaaaaaafaaaiacaeaaaaaaacaaaaaaaeaaaaaaacaaaaaa mul r5.w, r4.x, r4.x
acaaaaaaabaaaiacafaaaappacaaaaaaabaaaappacaaaaaa sub r1.w, r5.w, r1.w
adaaaaaaaaaaahacabaaaappacaaaaaabjaaaaoeabaaaaaa mul r0.xyz, r1.w, c25
abaaaaaaacaaahacacaaaakeacaaaaaaaeaaaapjacaaaaaa add r2.xyz, r2.xyzz, r4.yzww
abaaaaaaacaaahacacaaaakeacaaaaaaaaaaaakeacaaaaaa add r2.xyz, r2.xyzz, r0.xyzz
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 r0.w, a0, c3
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 r0.z, a0, c2
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 r0.x, a0, c0
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 r0.y, a0, c1
adaaaaaaaeaaaoacaaaaaandacaaaaaablaaaakkabaaaaaa mul r4.yzw, r0.wxyw, c27.z
abaaaaaaacaaahaeacaaaakeacaaaaaaabaaaakeacaaaaaa add v2.xyz, r2.xyzz, r1.xyzz
adaaaaaaabaaacacaeaaaakkacaaaaaaaiaaaaaaabaaaaaa mul r1.y, r4.z, c8.x
aaaaaaaaabaaabacaeaaaaffacaaaaaaaaaaaaaaaaaaaaaa mov r1.x, r4.y
abaaaaaaabaaadacabaaaafeacaaaaaaaeaaaappacaaaaaa add r1.xy, r1.xyyy, r4.w
adaaaaaaadaaadaeabaaaafeacaaaaaaajaaaaoeabaaaaaa mul v3.xy, r1.xyyy, c9
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
aaaaaaaaadaaamaeaaaaaaopacaaaaaaaaaaaaaaaaaaaaaa mov v3.zw, r0.wwzw
aaaaaaaaabaaaeaeadaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov v1.z, r3.x
aaaaaaaaabaaacaeadaaaappacaaaaaaaaaaaaaaaaaaaaaa mov v1.y, r3.w
aaaaaaaaabaaabaeaeaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov v1.x, r4.x
adaaaaaaafaaadacadaaaaoeaaaaaaaabkaaaaoeabaaaaaa mul r5.xy, a3, c26
abaaaaaaaaaaadaeafaaaafeacaaaaaabkaaaaooabaaaaaa add v0.xy, r5.xyyy, c26.zwzw
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
"
}

}
Program "fp" {
// Fragment combos: 6
//   opengl - ALU: 7 to 13, TEX: 1 to 3
//   d3d9 - ALU: 6 to 11, TEX: 1 to 3
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_Color]
SetTexture 0 [_MainTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 9 ALU, 1 TEX
PARAM c[4] = { program.local[0..2],
		{ 0, 2 } };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MUL R0, R0, c[2];
MUL R1.xyz, R0, fragment.texcoord[2];
DP3 R1.w, fragment.texcoord[1], c[0];
MUL R0.xyz, R0, c[1];
MAX R1.w, R1, c[3].x;
MUL R0.xyz, R1.w, R0;
MAD result.color.xyz, R0, c[3].y, R1;
MOV result.color.w, R0;
END
# 9 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_Color]
SetTexture 0 [_MainTex] 2D
"ps_2_0
; 9 ALU, 1 TEX
dcl_2d s0
def c3, 0.00000000, 2.00000000, 0, 0
dcl t0.xy
dcl t1.xyz
dcl t2.xyz
texld r0, t0, s0
mul r1, r0, c2
mul_pp r2.xyz, r1, t2
dp3_pp r0.x, t1, c0
mov_pp r0.w, r1
mul_pp r1.xyz, r1, c1
max_pp r0.x, r0, c3
mul_pp r0.xyz, r0.x, r1
mad_pp r0.xyz, r0, c3.y, r2
mov_pp oC0, r0
"
}

SubProgram "xbox360 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 2 [_Color]
Vector 1 [_LightColor0]
Vector 0 [_WorldSpaceLightPos0]
SetTexture 0 [_MainTex] 2D
// Shader Timing Estimate, in Cycles/64 pixel vector:
// ALU: 9.33 (7 instructions), vertex: 0, texture: 4,
//   sequencer: 8, interpolator: 12;    3 GPRs, 63 threads,
// Performance (if enough threads): ~12 cycles per vector
// * Texture cycle estimates are assuming an 8bit/component texture with no
//     aniso or trilinear filtering.

"ps_360
backbbaaaaaaabfaaaaaaameaaaaaaaaaaaaaaceaaaaaapmaaaaabceaaaaaaaa
aaaaaaaaaaaaaaneaaaaaabmaaaaaamippppadaaaaaaaaaeaaaaaabmaaaaaaaa
aaaaaambaaaaaagmaaacaaacaaabaaaaaaaaaaheaaaaaaaaaaaaaaieaaacaaab
aaabaaaaaaaaaaheaaaaaaaaaaaaaajbaaadaaaaaaabaaaaaaaaaajmaaaaaaaa
aaaaaakmaaacaaaaaaabaaaaaaaaaaheaaaaaaaafpedgpgmgphcaaklaaabaaad
aaabaaaeaaabaaaaaaaaaaaafpemgjghgiheedgpgmgphcdaaafpengbgjgofegf
hiaaklklaaaeaaamaaabaaabaaabaaaaaaaaaaaafpfhgphcgmgefdhagbgdgfem
gjghgihefagphddaaahahdfpddfpdaaadccodacodcdadddfddcodaaaaaaaaaaa
aaaaaaabaaaaaaaaaaaaaaaaaaaaaabeabpmaabaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaeaaaaaaaiebaaaacaaaaaaaaaeaaaaaaaaaaaacagdaaahaaah
aaaaaaabaaaadafaaaaahbfbaaaahcfcaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaabbaacaaaabcaameaaaaaaaaaagaad
baajbcaaccaaaaaabaaiaaabbpbppgiiaaaaeaaamiabaaabaaloloaalaabaaaa
miaiiaaaaablblaakbaaacaamiaiaaaaaagmgmaakcabppaamiahaaaaaamamaaa
kbaaacaamiahaaabaamamaaakbaaabaaaaihaaaaaamamablobaaacaamiahiaaa
aamablmaolabaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_Color]
SetTexture 0 [_MainTex] 2D
"sce_fp_rsx // 12 instructions using 2 registers
[Configuration]
24
ffffffff0001c0200007fff9000000000000840002000000
[Offsets]
3
_WorldSpaceLightPos0 1 0
00000050
_LightColor0 1 0
000000a0
_Color 1 0
00000020
[Microcode]
192
9e001700c8011c9dc8000001c8003fe11e800200c8001c9dc8020001c8000001
0000000000000000000000000000000010800140c9001c9dc8000001c8000001
a2820540c8011c9dc8020001c8003fe100000000000000000000000000000000
1082090001041c9c00020000c800000100000000000000000000000000000000
ce820240c9001c9dc8015001c8003fe10e800240c9001c9dc8020001c8000001
000000000000000000000000000000000e810440ff041c9dc9001001c9040001
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_Color]
SetTexture 0 [_MainTex] 2D
"agal_ps
c3 0.0 2.0 0.0 0.0
[bc]
ciaaaaaaaaaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r0, v0, s0 <2d wrap linear point>
adaaaaaaabaaapacaaaaaaoeacaaaaaaacaaaaoeabaaaaaa mul r1, r0, c2
adaaaaaaacaaahacabaaaakeacaaaaaaacaaaaoeaeaaaaaa mul r2.xyz, r1.xyzz, v2
bcaaaaaaaaaaabacabaaaaoeaeaaaaaaaaaaaaoeabaaaaaa dp3 r0.x, v1, c0
aaaaaaaaaaaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.w, r1.w
adaaaaaaabaaahacabaaaakeacaaaaaaabaaaaoeabaaaaaa mul r1.xyz, r1.xyzz, c1
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaadaaaaoeabaaaaaa max r0.x, r0.x, c3
adaaaaaaaaaaahacaaaaaaaaacaaaaaaabaaaakeacaaaaaa mul r0.xyz, r0.x, r1.xyzz
adaaaaaaaaaaahacaaaaaakeacaaaaaaadaaaaffabaaaaaa mul r0.xyz, r0.xyzz, c3.y
abaaaaaaaaaaahacaaaaaakeacaaaaaaacaaaakeacaaaaaa add r0.xyz, r0.xyzz, r2.xyzz
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [unity_Lightmap] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 7 ALU, 2 TEX
PARAM c[2] = { program.local[0],
		{ 8 } };
TEMP R0;
TEMP R1;
TEX R1, fragment.texcoord[1], texture[1], 2D;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MUL R0, R0, c[0];
MUL R1.xyz, R1.w, R1;
MUL R0.xyz, R0, R1;
MUL result.color.xyz, R0, c[1].x;
MOV result.color.w, R0;
END
# 7 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [unity_Lightmap] 2D
"ps_2_0
; 6 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c1, 8.00000000, 0, 0, 0
dcl t0.xy
dcl t1.xy
texld r0, t1, s1
texld r1, t0, s0
mul_pp r0.xyz, r0.w, r0
mul r1, r1, c0
mul_pp r0.xyz, r1, r0
mul_pp r0.xyz, r0, c1.x
mov_pp r0.w, r1
mov_pp oC0, r0
"
}

SubProgram "xbox360 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [unity_Lightmap] 2D
// Shader Timing Estimate, in Cycles/64 pixel vector:
// ALU: 4.00 (3 instructions), vertex: 0, texture: 8,
//   sequencer: 6, interpolator: 8;    3 GPRs, 63 threads,
// Performance (if enough threads): ~8 cycles per vector
// * Texture cycle estimates are assuming an 8bit/component texture with no
//     aniso or trilinear filtering.

"ps_360
backbbaaaaaaabciaaaaaakaaaaaaaaaaaaaaaceaaaaaaniaaaaabaaaaaaaaaa
aaaaaaaaaaaaaalaaaaaaabmaaaaaakcppppadaaaaaaaaadaaaaaabmaaaaaaaa
aaaaaajlaaaaaafiaaacaaaaaaabaaaaaaaaaagaaaaaaaaaaaaaaahaaaadaaaa
aaabaaaaaaaaaahmaaaaaaaaaaaaaaimaaadaaabaaabaaaaaaaaaahmaaaaaaaa
fpedgpgmgphcaaklaaabaaadaaabaaaeaaabaaaaaaaaaaaafpengbgjgofegfhi
aaklklklaaaeaaamaaabaaabaaabaaaaaaaaaaaahfgogjhehjfpemgjghgihegn
gbhaaahahdfpddfpdaaadccodacodcdadddfddcodaaaklklaaaaaaaaaaaaaaab
aaaaaaaaaaaaaaaaaaaaaabeabpmaabaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaeaaaaaaagabaaaacaaaaaaaaaeaaaaaaaaaaaabaecaaadaaadaaaaaaab
aaaadafaaaaadbfbaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaebaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaafcaacaaaabcaameaaaaaaaaaadaaeaaaaccaaaaaaaaaa
babicacbbpbppgiiaaaaeaaabaaiaaabbpbppeedaaaaeaaakiihababaabfmaed
kbaaaappbeboaaaaaablpmgmobabacaakiihiaaaaamabfaambabaaaaaaaaaaaa
aaaaaaaaaaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [unity_Lightmap] 2D
"sce_fp_rsx // 7 instructions using 2 registers
[Configuration]
24
ffffffff0000c0200003ffff000000000000840002000000
[Offsets]
1
_Color 1 0
00000020
[Microcode]
112
9e001700c8011c9dc8000001c8003fe11e800200c8001c9dc8020001c8000001
00000000000000000000000000000000be021702c8011c9dc8000001c8003fe1
0e800240c9001c9dfe040001c800000110800140c9001c9dc8000001c8000001
0e810240c9001c9dc8043001c8000001
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [unity_Lightmap] 2D
"agal_ps
c1 8.0 0.0 0.0 0.0
[bc]
ciaaaaaaaaaaapacabaaaaoeaeaaaaaaabaaaaaaafaababb tex r0, v1, s1 <2d wrap linear point>
ciaaaaaaabaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r1, v0, s0 <2d wrap linear point>
adaaaaaaaaaaahacaaaaaappacaaaaaaaaaaaakeacaaaaaa mul r0.xyz, r0.w, r0.xyzz
adaaaaaaabaaapacabaaaaoeacaaaaaaaaaaaaoeabaaaaaa mul r1, r1, c0
adaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa mul r0.xyz, r1.xyzz, r0.xyzz
adaaaaaaaaaaahacaaaaaakeacaaaaaaabaaaaaaabaaaaaa mul r0.xyz, r0.xyzz, c1.x
aaaaaaaaaaaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.w, r1.w
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [unity_Lightmap] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 7 ALU, 2 TEX
PARAM c[2] = { program.local[0],
		{ 8 } };
TEMP R0;
TEMP R1;
TEX R1, fragment.texcoord[1], texture[1], 2D;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MUL R0, R0, c[0];
MUL R1.xyz, R1.w, R1;
MUL R0.xyz, R0, R1;
MUL result.color.xyz, R0, c[1].x;
MOV result.color.w, R0;
END
# 7 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [unity_Lightmap] 2D
"ps_2_0
; 6 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c1, 8.00000000, 0, 0, 0
dcl t0.xy
dcl t1.xy
texld r0, t1, s1
texld r1, t0, s0
mul_pp r0.xyz, r0.w, r0
mul r1, r1, c0
mul_pp r0.xyz, r1, r0
mul_pp r0.xyz, r0, c1.x
mov_pp r0.w, r1
mov_pp oC0, r0
"
}

SubProgram "xbox360 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [unity_Lightmap] 2D
// Shader Timing Estimate, in Cycles/64 pixel vector:
// ALU: 4.00 (3 instructions), vertex: 0, texture: 8,
//   sequencer: 6, interpolator: 8;    3 GPRs, 63 threads,
// Performance (if enough threads): ~8 cycles per vector
// * Texture cycle estimates are assuming an 8bit/component texture with no
//     aniso or trilinear filtering.

"ps_360
backbbaaaaaaabciaaaaaakaaaaaaaaaaaaaaaceaaaaaaniaaaaabaaaaaaaaaa
aaaaaaaaaaaaaalaaaaaaabmaaaaaakcppppadaaaaaaaaadaaaaaabmaaaaaaaa
aaaaaajlaaaaaafiaaacaaaaaaabaaaaaaaaaagaaaaaaaaaaaaaaahaaaadaaaa
aaabaaaaaaaaaahmaaaaaaaaaaaaaaimaaadaaabaaabaaaaaaaaaahmaaaaaaaa
fpedgpgmgphcaaklaaabaaadaaabaaaeaaabaaaaaaaaaaaafpengbgjgofegfhi
aaklklklaaaeaaamaaabaaabaaabaaaaaaaaaaaahfgogjhehjfpemgjghgihegn
gbhaaahahdfpddfpdaaadccodacodcdadddfddcodaaaklklaaaaaaaaaaaaaaab
aaaaaaaaaaaaaaaaaaaaaabeabpmaabaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaeaaaaaaagabaaaacaaaaaaaaaeaaaaaaaaaaaabaecaaadaaadaaaaaaab
aaaadafaaaaadbfbaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaebaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaafcaacaaaabcaameaaaaaaaaaadaaeaaaaccaaaaaaaaaa
babicacbbpbppgiiaaaaeaaabaaiaaabbpbppeedaaaaeaaakiihababaabfmaed
kbaaaappbeboaaaaaablpmgmobabacaakiihiaaaaamabfaambabaaaaaaaaaaaa
aaaaaaaaaaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [unity_Lightmap] 2D
"sce_fp_rsx // 7 instructions using 2 registers
[Configuration]
24
ffffffff0000c0200003ffff000000000000840002000000
[Offsets]
1
_Color 1 0
00000020
[Microcode]
112
9e001700c8011c9dc8000001c8003fe11e800200c8001c9dc8020001c8000001
00000000000000000000000000000000be021702c8011c9dc8000001c8003fe1
0e800240c9001c9dfe040001c800000110800140c9001c9dc8000001c8000001
0e810240c9001c9dc8043001c8000001
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [unity_Lightmap] 2D
"agal_ps
c1 8.0 0.0 0.0 0.0
[bc]
ciaaaaaaaaaaapacabaaaaoeaeaaaaaaabaaaaaaafaababb tex r0, v1, s1 <2d wrap linear point>
ciaaaaaaabaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r1, v0, s0 <2d wrap linear point>
adaaaaaaaaaaahacaaaaaappacaaaaaaaaaaaakeacaaaaaa mul r0.xyz, r0.w, r0.xyzz
adaaaaaaabaaapacabaaaaoeacaaaaaaaaaaaaoeabaaaaaa mul r1, r1, c0
adaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa mul r0.xyz, r1.xyzz, r0.xyzz
adaaaaaaaaaaahacaaaaaakeacaaaaaaabaaaaaaabaaaaaa mul r0.xyz, r0.xyzz, c1.x
aaaaaaaaaaaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.w, r1.w
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_ShadowMapTexture] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 11 ALU, 2 TEX
PARAM c[4] = { program.local[0..2],
		{ 0, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TXP R2.x, fragment.texcoord[3], texture[1], 2D;
MUL R0, R0, c[2];
MUL R1.xyz, R0, fragment.texcoord[2];
DP3 R1.w, fragment.texcoord[1], c[0];
MAX R1.w, R1, c[3].x;
MUL R0.xyz, R0, c[1];
MUL R1.w, R1, R2.x;
MUL R0.xyz, R1.w, R0;
MAD result.color.xyz, R0, c[3].y, R1;
MOV result.color.w, R0;
END
# 11 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_ShadowMapTexture] 2D
"ps_2_0
; 10 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c3, 0.00000000, 2.00000000, 0, 0
dcl t0.xy
dcl t1.xyz
dcl t2.xyz
dcl t3
texld r0, t0, s0
texldp r3, t3, s1
mul r1, r0, c2
mul_pp r2.xyz, r1, c1
dp3_pp r0.x, t1, c0
max_pp r0.x, r0, c3
mul_pp r0.x, r0, r3
mul_pp r0.xyz, r0.x, r2
mul_pp r1.xyz, r1, t2
mov_pp r0.w, r1
mad_pp r0.xyz, r0, c3.y, r1
mov_pp oC0, r0
"
}

SubProgram "xbox360 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 2 [_Color]
Vector 1 [_LightColor0]
Vector 0 [_WorldSpaceLightPos0]
SetTexture 0 [_ShadowMapTexture] 2D
SetTexture 1 [_MainTex] 2D
// Shader Timing Estimate, in Cycles/64 pixel vector:
// ALU: 12.00 (9 instructions), vertex: 0, texture: 8,
//   sequencer: 8, interpolator: 16;    4 GPRs, 48 threads,
// Performance (if enough threads): ~16 cycles per vector
// * Texture cycle estimates are assuming an 8bit/component texture with no
//     aniso or trilinear filtering.

"ps_360
backbbaaaaaaabhmaaaaaaoiaaaaaaaaaaaaaaceaaaaabceaaaaabemaaaaaaaa
aaaaaaaaaaaaaapmaaaaaabmaaaaaaooppppadaaaaaaaaafaaaaaabmaaaaaaaa
aaaaaaohaaaaaaiaaaacaaacaaabaaaaaaaaaaiiaaaaaaaaaaaaaajiaaacaaab
aaabaaaaaaaaaaiiaaaaaaaaaaaaaakfaaadaaabaaabaaaaaaaaaalaaaaaaaaa
aaaaaamaaaadaaaaaaabaaaaaaaaaalaaaaaaaaaaaaaaancaaacaaaaaaabaaaa
aaaaaaiiaaaaaaaafpedgpgmgphcaaklaaabaaadaaabaaaeaaabaaaaaaaaaaaa
fpemgjghgiheedgpgmgphcdaaafpengbgjgofegfhiaaklklaaaeaaamaaabaaab
aaabaaaaaaaaaaaafpfdgigbgegphhengbhafegfhihehfhcgfaafpfhgphcgmge
fdhagbgdgfemgjghgihefagphddaaahahdfpddfpdaaadccodacodcdadddfddco
daaaklklaaaaaaaaaaaaaaabaaaaaaaaaaaaaaaaaaaaaabeabpmaabaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaeaaaaaaakibaaaadaaaaaaaaaeaaaaaaaa
aaaadaieaaapaaapaaaaaaabaaaadafaaaaahbfbaaaahcfcaaaapdfdaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaafaeaac
aaaabcaameaaaaaaaaaagaagbaambcaaccaaaaaaemieaaaaaalolobllaabaaad
miadaaadaabllaaaobaaadaababibaabbpbppgiiaaaaeaaabaaiaagbbpbppppi
aaaaeaaamiaiiaaaaablblaakbabacaaaaecaaaaaamggmgmkcaappaabeahaaab
aamamamgkbabacaaambhaaadaamamalbkbababaamialaaaaaamalmaaobadaaaa
miaeaaaaaablmgaaobaaaaaamiahiaaaaamamamaolabacaaaaaaaaaaaaaaaaaa
aaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_ShadowMapTexture] 2D
"sce_fp_rsx // 14 instructions using 2 registers
[Configuration]
24
ffffffff0003c020000ffff1000000000000840002000000
[Offsets]
3
_WorldSpaceLightPos0 1 0
00000010
_LightColor0 1 0
000000c0
_Color 1 0
00000070
[Microcode]
224
a2800540c8011c9dc8020001c8003fe100000000000000000000000000000000
e2021802c8011c9dc8000001c8003fe10884090001001c9c00020000c8000001
000000000000000000000000000000009e001700c8011c9dc8000001c8003fe1
1e800200c8001c9dc8020001c800000100000000000000000000000000000000
1082024055081c9d00040000c8000001ce820240c9001c9dc8015001c8003fe1
10800140c9001c9dc8000001c80000010e800240c9001c9dc8020001c8000001
000000000000000000000000000000000e810440ff041c9dc9001001c9040001
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_ShadowMapTexture] 2D
"agal_ps
c3 0.0 2.0 0.0 0.0
[bc]
ciaaaaaaaaaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r0, v0, s0 <2d wrap linear point>
aeaaaaaaabaaapacadaaaaoeaeaaaaaaadaaaappaeaaaaaa div r1, v3, v3.w
ciaaaaaaadaaapacabaaaafeacaaaaaaabaaaaaaafaababb tex r3, r1.xyyy, s1 <2d wrap linear point>
adaaaaaaabaaapacaaaaaaoeacaaaaaaacaaaaoeabaaaaaa mul r1, r0, c2
adaaaaaaacaaahacabaaaakeacaaaaaaabaaaaoeabaaaaaa mul r2.xyz, r1.xyzz, c1
bcaaaaaaaaaaabacabaaaaoeaeaaaaaaaaaaaaoeabaaaaaa dp3 r0.x, v1, c0
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaadaaaaoeabaaaaaa max r0.x, r0.x, c3
adaaaaaaaaaaabacaaaaaaaaacaaaaaaadaaaaaaacaaaaaa mul r0.x, r0.x, r3.x
adaaaaaaaaaaahacaaaaaaaaacaaaaaaacaaaakeacaaaaaa mul r0.xyz, r0.x, r2.xyzz
adaaaaaaabaaahacabaaaakeacaaaaaaacaaaaoeaeaaaaaa mul r1.xyz, r1.xyzz, v2
aaaaaaaaaaaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.w, r1.w
adaaaaaaaaaaahacaaaaaakeacaaaaaaadaaaaffabaaaaaa mul r0.xyz, r0.xyzz, c3.y
abaaaaaaaaaaahacaaaaaakeacaaaaaaabaaaakeacaaaaaa add r0.xyz, r0.xyzz, r1.xyzz
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_ShadowMapTexture] 2D
SetTexture 2 [unity_Lightmap] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 13 ALU, 3 TEX
PARAM c[2] = { program.local[0],
		{ 8, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R2, fragment.texcoord[1], texture[2], 2D;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TXP R3.x, fragment.texcoord[2], texture[1], 2D;
MUL R1.xyz, R2.w, R2;
MUL R2.xyz, R2, R3.x;
MUL R1.xyz, R1, c[1].x;
MUL R0, R0, c[0];
MUL R3.xyz, R1, R3.x;
MUL R2.xyz, R2, c[1].y;
MIN R1.xyz, R1, R2;
MAX R1.xyz, R1, R3;
MUL result.color.xyz, R0, R1;
MOV result.color.w, R0;
END
# 13 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_ShadowMapTexture] 2D
SetTexture 2 [unity_Lightmap] 2D
"ps_2_0
; 11 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c1, 8.00000000, 2.00000000, 0, 0
dcl t0.xy
dcl t1.xy
dcl t2
texld r1, t0, s0
texldp r3, t2, s1
texld r0, t1, s2
mul_pp r2.xyz, r0, r3.x
mul_pp r0.xyz, r0.w, r0
mul r1, r1, c0
mul_pp r0.xyz, r0, c1.x
mul_pp r2.xyz, r2, c1.y
min_pp r2.xyz, r0, r2
mul_pp r0.xyz, r0, r3.x
max_pp r0.xyz, r2, r0
mul_pp r0.xyz, r1, r0
mov_pp r0.w, r1
mov_pp oC0, r0
"
}

SubProgram "xbox360 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_Color]
SetTexture 0 [_ShadowMapTexture] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [unity_Lightmap] 2D
// Shader Timing Estimate, in Cycles/64 pixel vector:
// ALU: 12.00 (9 instructions), vertex: 0, texture: 12,
//   sequencer: 8, interpolator: 12;    4 GPRs, 48 threads,
// Performance (if enough threads): ~12 cycles per vector
// * Texture cycle estimates are assuming an 8bit/component texture with no
//     aniso or trilinear filtering.

"ps_360
backbbaaaaaaabfaaaaaaapeaaaaaaaaaaaaaaceaaaaaapmaaaaabceaaaaaaaa
aaaaaaaaaaaaaaneaaaaaabmaaaaaamippppadaaaaaaaaaeaaaaaabmaaaaaaaa
aaaaaambaaaaaagmaaacaaaaaaabaaaaaaaaaaheaaaaaaaaaaaaaaieaaadaaab
aaabaaaaaaaaaajaaaaaaaaaaaaaaakaaaadaaaaaaabaaaaaaaaaajaaaaaaaaa
aaaaaalcaaadaaacaaabaaaaaaaaaajaaaaaaaaafpedgpgmgphcaaklaaabaaad
aaabaaaeaaabaaaaaaaaaaaafpengbgjgofegfhiaaklklklaaaeaaamaaabaaab
aaabaaaaaaaaaaaafpfdgigbgegphhengbhafegfhihehfhcgfaahfgogjhehjfp
emgjghgihegngbhaaahahdfpddfpdaaadccodacodcdadddfddcodaaaaaaaaaaa
aaaaaaabaaaaaaaaaaaaaaaaaaaaaabeabpmaabaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaeaaaaaaalebaaaadaaaaaaaaaeaaaaaaaaaaaacagdaaahaaah
aaaaaaabaaaadafaaaaadbfbaaaapcfcaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
ebaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaabfafaacaaaabcaameaaaaaaaaaagaah
baanbcaaccaaaaaaemeaaaaaaaaaaablocaaaaacmiamaaabaamgkmaaobaaacaa
bacicacbbpbppgiiaaaaeaaababiaaabbpbppeedaaaaeaaaliaibacbbpbppbpp
aaaaeaaaaabbabadaablgmblkbacppabbebhaaabaagmmagmobabacaabecoaaac
aagmpmlbobadacaakibhacadaabfblebmbacabaakichacabaabfmaicmdacabaa
kiehacabaamamamdmcadabaakiihiaaaaamamaaambacabaaaaaaaaaaaaaaaaaa
aaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_ShadowMapTexture] 2D
SetTexture 2 [unity_Lightmap] 2D
"sce_fp_rsx // 12 instructions using 3 registers
[Configuration]
24
ffffffff0001c0200007fffb000000000000840003000000
[Offsets]
1
_Color 1 0
00000020
[Microcode]
192
9e001700c8011c9dc8000001c8003fe11e840200c8001c9dc8020001c8000001
00000000000000000000000000000000be001704c8011c9dc8000001c8003fe1
0e860240fe001c9dc8003001c8000001c2041802c8011c9dc8000001c8003fe1
0e800240c8001c9d00081000c800000110800140c9081c9dc8000001c8000001
0e8a0840c90c1c9dc9000001c80000010e860240c90c1c9d00080000c8000001
0e800940c9141c9dc90c0001c80000010e810240c9081c9dc9000001c8000001
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_ShadowMapTexture] 2D
SetTexture 2 [unity_Lightmap] 2D
"agal_ps
c1 8.0 2.0 0.0 0.0
[bc]
ciaaaaaaabaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r1, v0, s0 <2d wrap linear point>
aeaaaaaaaaaaapacacaaaaoeaeaaaaaaacaaaappaeaaaaaa div r0, v2, v2.w
ciaaaaaaadaaapacaaaaaafeacaaaaaaabaaaaaaafaababb tex r3, r0.xyyy, s1 <2d wrap linear point>
ciaaaaaaaaaaapacabaaaaoeaeaaaaaaacaaaaaaafaababb tex r0, v1, s2 <2d wrap linear point>
adaaaaaaacaaahacaaaaaakeacaaaaaaadaaaaaaacaaaaaa mul r2.xyz, r0.xyzz, r3.x
adaaaaaaaaaaahacaaaaaappacaaaaaaaaaaaakeacaaaaaa mul r0.xyz, r0.w, r0.xyzz
adaaaaaaabaaapacabaaaaoeacaaaaaaaaaaaaoeabaaaaaa mul r1, r1, c0
adaaaaaaaaaaahacaaaaaakeacaaaaaaabaaaaaaabaaaaaa mul r0.xyz, r0.xyzz, c1.x
adaaaaaaacaaahacacaaaakeacaaaaaaabaaaaffabaaaaaa mul r2.xyz, r2.xyzz, c1.y
agaaaaaaacaaahacaaaaaakeacaaaaaaacaaaakeacaaaaaa min r2.xyz, r0.xyzz, r2.xyzz
adaaaaaaaaaaahacaaaaaakeacaaaaaaadaaaaaaacaaaaaa mul r0.xyz, r0.xyzz, r3.x
ahaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaakeacaaaaaa max r0.xyz, r2.xyzz, r0.xyzz
adaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa mul r0.xyz, r1.xyzz, r0.xyzz
aaaaaaaaaaaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.w, r1.w
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_ShadowMapTexture] 2D
SetTexture 2 [unity_Lightmap] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 13 ALU, 3 TEX
PARAM c[2] = { program.local[0],
		{ 8, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R2, fragment.texcoord[1], texture[2], 2D;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TXP R3.x, fragment.texcoord[2], texture[1], 2D;
MUL R1.xyz, R2.w, R2;
MUL R2.xyz, R2, R3.x;
MUL R1.xyz, R1, c[1].x;
MUL R0, R0, c[0];
MUL R3.xyz, R1, R3.x;
MUL R2.xyz, R2, c[1].y;
MIN R1.xyz, R1, R2;
MAX R1.xyz, R1, R3;
MUL result.color.xyz, R0, R1;
MOV result.color.w, R0;
END
# 13 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_ShadowMapTexture] 2D
SetTexture 2 [unity_Lightmap] 2D
"ps_2_0
; 11 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c1, 8.00000000, 2.00000000, 0, 0
dcl t0.xy
dcl t1.xy
dcl t2
texld r1, t0, s0
texldp r3, t2, s1
texld r0, t1, s2
mul_pp r2.xyz, r0, r3.x
mul_pp r0.xyz, r0.w, r0
mul r1, r1, c0
mul_pp r0.xyz, r0, c1.x
mul_pp r2.xyz, r2, c1.y
min_pp r2.xyz, r0, r2
mul_pp r0.xyz, r0, r3.x
max_pp r0.xyz, r2, r0
mul_pp r0.xyz, r1, r0
mov_pp r0.w, r1
mov_pp oC0, r0
"
}

SubProgram "xbox360 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Vector 0 [_Color]
SetTexture 0 [_ShadowMapTexture] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [unity_Lightmap] 2D
// Shader Timing Estimate, in Cycles/64 pixel vector:
// ALU: 12.00 (9 instructions), vertex: 0, texture: 12,
//   sequencer: 8, interpolator: 12;    4 GPRs, 48 threads,
// Performance (if enough threads): ~12 cycles per vector
// * Texture cycle estimates are assuming an 8bit/component texture with no
//     aniso or trilinear filtering.

"ps_360
backbbaaaaaaabfaaaaaaapeaaaaaaaaaaaaaaceaaaaaapmaaaaabceaaaaaaaa
aaaaaaaaaaaaaaneaaaaaabmaaaaaamippppadaaaaaaaaaeaaaaaabmaaaaaaaa
aaaaaambaaaaaagmaaacaaaaaaabaaaaaaaaaaheaaaaaaaaaaaaaaieaaadaaab
aaabaaaaaaaaaajaaaaaaaaaaaaaaakaaaadaaaaaaabaaaaaaaaaajaaaaaaaaa
aaaaaalcaaadaaacaaabaaaaaaaaaajaaaaaaaaafpedgpgmgphcaaklaaabaaad
aaabaaaeaaabaaaaaaaaaaaafpengbgjgofegfhiaaklklklaaaeaaamaaabaaab
aaabaaaaaaaaaaaafpfdgigbgegphhengbhafegfhihehfhcgfaahfgogjhehjfp
emgjghgihegngbhaaahahdfpddfpdaaadccodacodcdadddfddcodaaaaaaaaaaa
aaaaaaabaaaaaaaaaaaaaaaaaaaaaabeabpmaabaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaeaaaaaaalebaaaadaaaaaaaaaeaaaaaaaaaaaacagdaaahaaah
aaaaaaabaaaadafaaaaadbfbaaaapcfcaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
ebaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaabfafaacaaaabcaameaaaaaaaaaagaah
baanbcaaccaaaaaaemeaaaaaaaaaaablocaaaaacmiamaaabaamgkmaaobaaacaa
bacicacbbpbppgiiaaaaeaaababiaaabbpbppeedaaaaeaaaliaibacbbpbppbpp
aaaaeaaaaabbabadaablgmblkbacppabbebhaaabaagmmagmobabacaabecoaaac
aagmpmlbobadacaakibhacadaabfblebmbacabaakichacabaabfmaicmdacabaa
kiehacabaamamamdmcadabaakiihiaaaaamamaaambacabaaaaaaaaaaaaaaaaaa
aaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_ShadowMapTexture] 2D
SetTexture 2 [unity_Lightmap] 2D
"sce_fp_rsx // 12 instructions using 3 registers
[Configuration]
24
ffffffff0001c0200007fffb000000000000840003000000
[Offsets]
1
_Color 1 0
00000020
[Microcode]
192
9e001700c8011c9dc8000001c8003fe11e840200c8001c9dc8020001c8000001
00000000000000000000000000000000be001704c8011c9dc8000001c8003fe1
0e860240fe001c9dc8003001c8000001c2041802c8011c9dc8000001c8003fe1
0e800240c8001c9d00081000c800000110800140c9081c9dc8000001c8000001
0e8a0840c90c1c9dc9000001c80000010e860240c90c1c9d00080000c8000001
0e800940c9141c9dc90c0001c80000010e810240c9081c9dc9000001c8000001
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_ShadowMapTexture] 2D
SetTexture 2 [unity_Lightmap] 2D
"agal_ps
c1 8.0 2.0 0.0 0.0
[bc]
ciaaaaaaabaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r1, v0, s0 <2d wrap linear point>
aeaaaaaaaaaaapacacaaaaoeaeaaaaaaacaaaappaeaaaaaa div r0, v2, v2.w
ciaaaaaaadaaapacaaaaaafeacaaaaaaabaaaaaaafaababb tex r3, r0.xyyy, s1 <2d wrap linear point>
ciaaaaaaaaaaapacabaaaaoeaeaaaaaaacaaaaaaafaababb tex r0, v1, s2 <2d wrap linear point>
adaaaaaaacaaahacaaaaaakeacaaaaaaadaaaaaaacaaaaaa mul r2.xyz, r0.xyzz, r3.x
adaaaaaaaaaaahacaaaaaappacaaaaaaaaaaaakeacaaaaaa mul r0.xyz, r0.w, r0.xyzz
adaaaaaaabaaapacabaaaaoeacaaaaaaaaaaaaoeabaaaaaa mul r1, r1, c0
adaaaaaaaaaaahacaaaaaakeacaaaaaaabaaaaaaabaaaaaa mul r0.xyz, r0.xyzz, c1.x
adaaaaaaacaaahacacaaaakeacaaaaaaabaaaaffabaaaaaa mul r2.xyz, r2.xyzz, c1.y
agaaaaaaacaaahacaaaaaakeacaaaaaaacaaaakeacaaaaaa min r2.xyz, r0.xyzz, r2.xyzz
adaaaaaaaaaaahacaaaaaakeacaaaaaaadaaaaaaacaaaaaa mul r0.xyz, r0.xyzz, r3.x
ahaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaakeacaaaaaa max r0.xyz, r2.xyzz, r0.xyzz
adaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa mul r0.xyz, r1.xyzz, r0.xyzz
aaaaaaaaaaaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.w, r1.w
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

}
	}
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardAdd" }
		ZWrite Off Blend One One Fog { Color (0,0,0,0) }
Program "vp" {
// Vertex combos: 5
//   opengl - ALU: 10 to 18
//   d3d9 - ALU: 10 to 18
SubProgram "opengl " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 13 [unity_Scale]
Vector 14 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_LightMatrix0]
Vector 15 [_MainTex_ST]
"!!ARBvp1.0
# 17 ALU
PARAM c[16] = { program.local[0],
		state.matrix.mvp,
		program.local[5..15] };
TEMP R0;
TEMP R1;
MUL R1.xyz, vertex.normal, c[13].w;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
DP4 result.texcoord[3].z, R0, c[11];
DP4 result.texcoord[3].y, R0, c[10];
DP4 result.texcoord[3].x, R0, c[9];
DP3 result.texcoord[1].z, R1, c[7];
DP3 result.texcoord[1].y, R1, c[6];
DP3 result.texcoord[1].x, R1, c[5];
ADD result.texcoord[2].xyz, -R0, c[14];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[15], c[15].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 17 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 14 [_MainTex_ST]
"vs_2_0
; 17 ALU
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c12.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 oT3.z, r0, c10
dp4 oT3.y, r0, c9
dp4 oT3.x, r0, c8
dp3 oT1.z, r1, c6
dp3 oT1.y, r1, c5
dp3 oT1.x, r1, c4
add oT2.xyz, -r0, c13
mad oT0.xy, v2, c14, c14.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "xbox360 " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 10 [_LightMatrix0] 4
Vector 14 [_MainTex_ST]
Matrix 6 [_Object2World] 4
Vector 5 [_WorldSpaceLightPos0]
Matrix 0 [glstate_matrix_mvp] 4
Vector 4 [unity_Scale]
// Shader Timing Estimate, in Cycles/64 vertex vector:
// ALU: 24.00 (18 instructions), vertex: 32, texture: 0,
//   sequencer: 14,  5 GPRs, 31 threads,
// Performance (if enough threads): ~32 cycles per vector
// * Vertex cycle estimates are assuming 3 vfetch_minis for every vfetch_full,
//     with <= 32 bytes per vfetch_full group.

"vs_360
backbbabaaaaabkeaaaaabdiaaaaaaaaaaaaaaceaaaaaaaaaaaaabfaaaaaaaaa
aaaaaaaaaaaaabciaaaaaabmaaaaabbjpppoadaaaaaaaaagaaaaaabmaaaaaaaa
aaaaabbcaaaaaajeaaacaaakaaaeaaaaaaaaaakeaaaaaaaaaaaaaaleaaacaaao
aaabaaaaaaaaaamaaaaaaaaaaaaaaanaaaacaaagaaaeaaaaaaaaaakeaaaaaaaa
aaaaaanoaaacaaafaaabaaaaaaaaaamaaaaaaaaaaaaaaapdaaacaaaaaaaeaaaa
aaaaaakeaaaaaaaaaaaaabagaaacaaaeaaabaaaaaaaaaamaaaaaaaaafpemgjgh
giheengbhehcgjhidaaaklklaaadaaadaaaeaaaeaaabaaaaaaaaaaaafpengbgj
gofegfhifpfdfeaaaaabaaadaaabaaaeaaabaaaaaaaaaaaafpepgcgkgfgdhedc
fhgphcgmgeaafpfhgphcgmgefdhagbgdgfemgjghgihefagphddaaaghgmhdhegb
hegffpgngbhehcgjhifpgnhghaaahfgogjhehjfpfdgdgbgmgfaahghdfpddfpda
aadccodacodcdadddfddcodaaaklklklaaaaaaaaaaaaabdiaadbaaaeaaaaaaaa
aaaaaaaaaaaacmieaaaaaaabaaaaaaadaaaaaaaeaaaaacjaaabaaaaeaaaadaaf
aacafaagaaaadafaaaabhbfbaaachcfcaaadhdfdaaaababeaaaababdaaaababc
aaaababihabfdaaeaaaabcaamcaaaaaaaaaaeaahaaaabcaameaaaaaaaaaagaal
gabbbcaabcaaaaaaaaaacabhaaaaccaaaaaaaaaaafpidaaaaaaaagiiaaaaaaaa
afpiaaaaaaaaaeehaaaaaaaaafpibaaaaaaaapmiaaaaaaaamiapaaacaabliiaa
kbadadaamiapaaacaamgiiaakladacacmiapaaacaalbdejekladabacmiapiado
aagmaadekladaaacmialaaacaalkblaakbaaaeaamiapaaaaaablaaaakbadajaa
miapaaaaaamgaaaakladaiaamiahaaaeaalbleaakbacaiaamiahaaacaagmlema
klacahaemiapaaaaaalbaaaakladahaamiapaaaaaagmffffkladagaamiahiaac
aelpmaaakaaaafaamiahiaabaablmaleklacagacmiadiaaaaalalabkilabaoao
miahaaabaamgleaakbaaanaamiahaaabaalbmaleklaaamabmiahaaaaaagmlele
klaaalabmiahiaadaablmaleklaaakaaaaaaaaaaaaaaaaaaaaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 256 [glstate_matrix_mvp]
Vector 467 [unity_Scale]
Vector 466 [_WorldSpaceLightPos0]
Matrix 260 [_Object2World]
Matrix 264 [_LightMatrix0]
Vector 465 [_MainTex_ST]
"sce_vp_rsx // 17 instructions using 2 registers
[Configuration]
8
0000001101050200
[Microcode]
272
00009c6c009d320c013fc0c36041dffc401f9c6c011d1808010400d740619f9c
401f9c6c01d0300d8106c0c360403f80401f9c6c01d0200d8106c0c360405f80
401f9c6c01d0100d8106c0c360409f80401f9c6c01d0000d8106c0c360411f80
00001c6c01d0700d8106c0c360403ffc00001c6c01d0600d8106c0c360405ffc
00001c6c01d0500d8106c0c360409ffc00001c6c01d0400d8106c0c360411ffc
401f9c6c0150600c028600c360405fa0401f9c6c0150500c028600c360409fa0
401f9c6c0150400c028600c360411fa0401f9c6c00dd200c0186c0a30021dfa4
401f9c6c01d0a00d8086c0c360405fa8401f9c6c01d0900d8086c0c360409fa8
401f9c6c01d0800d8086c0c360411fa9
"
}

SubProgram "gles " {
Keywords { "POINT" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_5;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  lowp vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  mediump vec3 tmpvar_2;
  tmpvar_2 = normalize (xlv_TEXCOORD2);
  lightDir = tmpvar_2;
  highp vec2 tmpvar_3;
  tmpvar_3 = vec2(dot (xlv_TEXCOORD3, xlv_TEXCOORD3));
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_1.xyz * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD1, lightDir)) * texture2D (_LightTexture0, tmpvar_3).w) * 2.0));
  c_i0_i1.w = tmpvar_1.w;
  c = c_i0_i1;
  c.w = 0.0;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "POINT" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_5;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  lowp vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  mediump vec3 tmpvar_2;
  tmpvar_2 = normalize (xlv_TEXCOORD2);
  lightDir = tmpvar_2;
  highp vec2 tmpvar_3;
  tmpvar_3 = vec2(dot (xlv_TEXCOORD3, xlv_TEXCOORD3));
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_1.xyz * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD1, lightDir)) * texture2D (_LightTexture0, tmpvar_3).w) * 2.0));
  c_i0_i1.w = tmpvar_1.w;
  c = c_i0_i1;
  c.w = 0.0;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "flash " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 14 [_MainTex_ST]
"agal_vs
[bc]
adaaaaaaabaaahacabaaaaoeaaaaaaaaamaaaappabaaaaaa mul r1.xyz, a1, c12.w
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 r0.w, a0, c7
bdaaaaaaadaaaeaeaaaaaaoeacaaaaaaakaaaaoeabaaaaaa dp4 v3.z, r0, c10
bdaaaaaaadaaacaeaaaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 v3.y, r0, c9
bdaaaaaaadaaabaeaaaaaaoeacaaaaaaaiaaaaoeabaaaaaa dp4 v3.x, r0, c8
bcaaaaaaabaaaeaeabaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v1.z, r1.xyzz, c6
bcaaaaaaabaaacaeabaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v1.y, r1.xyzz, c5
bcaaaaaaabaaabaeabaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v1.x, r1.xyzz, c4
bfaaaaaaaaaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r0.xyz, r0.xyzz
abaaaaaaacaaahaeaaaaaakeacaaaaaaanaaaaoeabaaaaaa add v2.xyz, r0.xyzz, c13
adaaaaaaaaaaadacadaaaaoeaaaaaaaaaoaaaaoeabaaaaaa mul r0.xy, a3, c14
abaaaaaaaaaaadaeaaaaaafeacaaaaaaaoaaaaooabaaaaaa add v0.xy, r0.xyyy, c14.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 9 [unity_Scale]
Vector 10 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Vector 11 [_MainTex_ST]
"!!ARBvp1.0
# 10 ALU
PARAM c[12] = { program.local[0],
		state.matrix.mvp,
		program.local[5..11] };
TEMP R0;
MUL R0.xyz, vertex.normal, c[9].w;
DP3 result.texcoord[1].z, R0, c[7];
DP3 result.texcoord[1].y, R0, c[6];
DP3 result.texcoord[1].x, R0, c[5];
MOV result.texcoord[2].xyz, c[10];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[11], c[11].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 10 instructions, 1 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_Scale]
Vector 9 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Vector 10 [_MainTex_ST]
"vs_2_0
; 10 ALU
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1, c8.w
dp3 oT1.z, r0, c6
dp3 oT1.y, r0, c5
dp3 oT1.x, r0, c4
mov oT2.xyz, c9
mad oT0.xy, v2, c10, c10.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "xbox360 " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 9 [_MainTex_ST]
Matrix 6 [_Object2World] 3
Vector 5 [_WorldSpaceLightPos0]
Matrix 0 [glstate_matrix_mvp] 4
Vector 4 [unity_Scale]
// Shader Timing Estimate, in Cycles/64 vertex vector:
// ALU: 13.33 (10 instructions), vertex: 32, texture: 0,
//   sequencer: 10,  4 GPRs, 31 threads,
// Performance (if enough threads): ~32 cycles per vector
// * Vertex cycle estimates are assuming 3 vfetch_minis for every vfetch_full,
//     with <= 32 bytes per vfetch_full group.

"vs_360
backbbabaaaaabhiaaaaaammaaaaaaaaaaaaaaceaaaaaaaaaaaaabcmaaaaaaaa
aaaaaaaaaaaaabaeaaaaaabmaaaaaaphpppoadaaaaaaaaafaaaaaabmaaaaaaaa
aaaaaapaaaaaaaiaaaacaaajaaabaaaaaaaaaaimaaaaaaaaaaaaaajmaaacaaag
aaadaaaaaaaaaakmaaaaaaaaaaaaaalmaaacaaafaaabaaaaaaaaaaimaaaaaaaa
aaaaaanbaaacaaaaaaaeaaaaaaaaaakmaaaaaaaaaaaaaaoeaaacaaaeaaabaaaa
aaaaaaimaaaaaaaafpengbgjgofegfhifpfdfeaaaaabaaadaaabaaaeaaabaaaa
aaaaaaaafpepgcgkgfgdhedcfhgphcgmgeaaklklaaadaaadaaaeaaaeaaabaaaa
aaaaaaaafpfhgphcgmgefdhagbgdgfemgjghgihefagphddaaaghgmhdhegbhegf
fpgngbhehcgjhifpgnhghaaahfgogjhehjfpfdgdgbgmgfaahghdfpddfpdaaadc
codacodcdadddfddcodaaaklaaaaaaaaaaaaaammaacbaaadaaaaaaaaaaaaaaaa
aaaacagdaaaaaaabaaaaaaadaaaaaaadaaaaacjaaabaaaadaaaadaaeaadafaaf
aaaadafaaaabhbfbaaachcfcaaaabaapaaaabaaoaaaabaanhabfdaadaaaabcaa
mcaaaaaaaaaaeaagaaaabcaameaaaaaaaaaagaakaaaaccaaaaaaaaaaafpidaaa
aaaaagiiaaaaaaaaafpibaaaaaaaaoiiaaaaaaaaafpiaaaaaaaaapmiaaaaaaaa
miapaaacaabliiaakbadadaamiapaaacaamgiiaakladacacmiapaaacaalbdeje
kladabacmiapiadoaagmaadekladaaacmialaaabaagfblaakbabaeaamiahaaac
aalbleaakbabaiaamiahaaabaagmlemaklabahacmiahiaacaamamaaaccafafaa
miahiaabaablmaleklabagabmiadiaaaaalalabkilaaajajaaaaaaaaaaaaaaaa
aaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 256 [glstate_matrix_mvp]
Vector 467 [unity_Scale]
Vector 466 [_WorldSpaceLightPos0]
Matrix 260 [_Object2World]
Vector 465 [_MainTex_ST]
"sce_vp_rsx // 10 instructions using 1 registers
[Configuration]
8
0000000a01050100
[Microcode]
160
401f9c6c005d200c0186c0836041dfa400001c6c009d320c013fc0c36041dffc
401f9c6c011d1808010400d740619f9c401f9c6c01d0300d8106c0c360403f80
401f9c6c01d0200d8106c0c360405f80401f9c6c01d0100d8106c0c360409f80
401f9c6c01d0000d8106c0c360411f80401f9c6c0150600c008600c360405fa0
401f9c6c0150500c008600c360409fa0401f9c6c0150400c008600c360411fa1
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = _WorldSpaceLightPos0.xyz;
  tmpvar_2 = tmpvar_5;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
}



#endif
#ifdef FRAGMENT

varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  lowp vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  lightDir = xlv_TEXCOORD2;
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_1.xyz * _LightColor0.xyz) * (max (0.0, dot (xlv_TEXCOORD1, lightDir)) * 2.0));
  c_i0_i1.w = tmpvar_1.w;
  c = c_i0_i1;
  c.w = 0.0;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = _WorldSpaceLightPos0.xyz;
  tmpvar_2 = tmpvar_5;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
}



#endif
#ifdef FRAGMENT

varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  lowp vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  lightDir = xlv_TEXCOORD2;
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_1.xyz * _LightColor0.xyz) * (max (0.0, dot (xlv_TEXCOORD1, lightDir)) * 2.0));
  c_i0_i1.w = tmpvar_1.w;
  c = c_i0_i1;
  c.w = 0.0;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_Scale]
Vector 9 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Vector 10 [_MainTex_ST]
"agal_vs
[bc]
adaaaaaaaaaaahacabaaaaoeaaaaaaaaaiaaaappabaaaaaa mul r0.xyz, a1, c8.w
bcaaaaaaabaaaeaeaaaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v1.z, r0.xyzz, c6
bcaaaaaaabaaacaeaaaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v1.y, r0.xyzz, c5
bcaaaaaaabaaabaeaaaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v1.x, r0.xyzz, c4
aaaaaaaaacaaahaeajaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.xyz, c9
adaaaaaaaaaaadacadaaaaoeaaaaaaaaakaaaaoeabaaaaaa mul r0.xy, a3, c10
abaaaaaaaaaaadaeaaaaaafeacaaaaaaakaaaaooabaaaaaa add v0.xy, r0.xyyy, c10.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
"
}

SubProgram "opengl " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 13 [unity_Scale]
Vector 14 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_LightMatrix0]
Vector 15 [_MainTex_ST]
"!!ARBvp1.0
# 18 ALU
PARAM c[16] = { program.local[0],
		state.matrix.mvp,
		program.local[5..15] };
TEMP R0;
TEMP R1;
MUL R1.xyz, vertex.normal, c[13].w;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
DP4 result.texcoord[3].w, R0, c[12];
DP4 result.texcoord[3].z, R0, c[11];
DP4 result.texcoord[3].y, R0, c[10];
DP4 result.texcoord[3].x, R0, c[9];
DP3 result.texcoord[1].z, R1, c[7];
DP3 result.texcoord[1].y, R1, c[6];
DP3 result.texcoord[1].x, R1, c[5];
ADD result.texcoord[2].xyz, -R0, c[14];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[15], c[15].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 18 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 14 [_MainTex_ST]
"vs_2_0
; 18 ALU
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c12.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 oT3.w, r0, c11
dp4 oT3.z, r0, c10
dp4 oT3.y, r0, c9
dp4 oT3.x, r0, c8
dp3 oT1.z, r1, c6
dp3 oT1.y, r1, c5
dp3 oT1.x, r1, c4
add oT2.xyz, -r0, c13
mad oT0.xy, v2, c14, c14.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "xbox360 " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 10 [_LightMatrix0] 4
Vector 14 [_MainTex_ST]
Matrix 6 [_Object2World] 4
Vector 5 [_WorldSpaceLightPos0]
Matrix 0 [glstate_matrix_mvp] 4
Vector 4 [unity_Scale]
// Shader Timing Estimate, in Cycles/64 vertex vector:
// ALU: 24.00 (18 instructions), vertex: 32, texture: 0,
//   sequencer: 14,  5 GPRs, 31 threads,
// Performance (if enough threads): ~32 cycles per vector
// * Vertex cycle estimates are assuming 3 vfetch_minis for every vfetch_full,
//     with <= 32 bytes per vfetch_full group.

"vs_360
backbbabaaaaabkeaaaaabdiaaaaaaaaaaaaaaceaaaaaaaaaaaaabfaaaaaaaaa
aaaaaaaaaaaaabciaaaaaabmaaaaabbjpppoadaaaaaaaaagaaaaaabmaaaaaaaa
aaaaabbcaaaaaajeaaacaaakaaaeaaaaaaaaaakeaaaaaaaaaaaaaaleaaacaaao
aaabaaaaaaaaaamaaaaaaaaaaaaaaanaaaacaaagaaaeaaaaaaaaaakeaaaaaaaa
aaaaaanoaaacaaafaaabaaaaaaaaaamaaaaaaaaaaaaaaapdaaacaaaaaaaeaaaa
aaaaaakeaaaaaaaaaaaaabagaaacaaaeaaabaaaaaaaaaamaaaaaaaaafpemgjgh
giheengbhehcgjhidaaaklklaaadaaadaaaeaaaeaaabaaaaaaaaaaaafpengbgj
gofegfhifpfdfeaaaaabaaadaaabaaaeaaabaaaaaaaaaaaafpepgcgkgfgdhedc
fhgphcgmgeaafpfhgphcgmgefdhagbgdgfemgjghgihefagphddaaaghgmhdhegb
hegffpgngbhehcgjhifpgnhghaaahfgogjhehjfpfdgdgbgmgfaahghdfpddfpda
aadccodacodcdadddfddcodaaaklklklaaaaaaaaaaaaabdiaadbaaaeaaaaaaaa
aaaaaaaaaaaadaieaaaaaaabaaaaaaadaaaaaaaeaaaaacjaaabaaaaeaaaadaaf
aadafaagaaaadafaaaabhbfbaaachcfcaaadpdfdaaaababeaaaababdaaaababc
aaaababihabfdaaeaaaabcaamcaaaaaaaaaaeaahaaaabcaameaaaaaaaaaagaal
gabbbcaabcaaaaaaaaaacabhaaaaccaaaaaaaaaaafpidaaaaaaaagiiaaaaaaaa
afpibaaaaaaaaoiiaaaaaaaaafpiaaaaaaaaapmiaaaaaaaamiapaaacaabliiaa
kbadadaamiapaaacaamgiiaakladacacmiapaaacaalbdejekladabacmiapiado
aagmaadekladaaacmialaaacaagfblaakbabaeaamiapaaabaablaaaakbadajaa
miapaaabaamgaaaakladaiabmiahaaaeaalbleaakbacaiaamiahaaacaagmlema
klacahaemiapaaabaalbaaaakladahabmiapaaabaagmaaaakladagabmiahiaac
aemamaaakaabafaamiahiaabaablmaleklacagacmiadiaaaaalalabkilaaaoao
miapaaaaaabliiaakbabanaamiapaaaaaamgiiaaklabamaamiapaaaaaalbdeje
klabalaamiapiaadaagmaadeklabakaaaaaaaaaaaaaaaaaaaaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 256 [glstate_matrix_mvp]
Vector 467 [unity_Scale]
Vector 466 [_WorldSpaceLightPos0]
Matrix 260 [_Object2World]
Matrix 264 [_LightMatrix0]
Vector 465 [_MainTex_ST]
"sce_vp_rsx // 18 instructions using 2 registers
[Configuration]
8
0000001201050200
[Microcode]
288
00009c6c009d320c013fc0c36041dffc401f9c6c011d1808010400d740619f9c
401f9c6c01d0300d8106c0c360403f80401f9c6c01d0200d8106c0c360405f80
401f9c6c01d0100d8106c0c360409f80401f9c6c01d0000d8106c0c360411f80
00001c6c01d0700d8106c0c360403ffc00001c6c01d0600d8106c0c360405ffc
00001c6c01d0500d8106c0c360409ffc00001c6c01d0400d8106c0c360411ffc
401f9c6c0150600c028600c360405fa0401f9c6c0150500c028600c360409fa0
401f9c6c0150400c028600c360411fa0401f9c6c00dd200c0186c0a30021dfa4
401f9c6c01d0b00d8086c0c360403fa8401f9c6c01d0a00d8086c0c360405fa8
401f9c6c01d0900d8086c0c360409fa8401f9c6c01d0800d8086c0c360411fa9
"
}

SubProgram "gles " {
Keywords { "SPOT" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_5;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  lowp vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  mediump vec3 tmpvar_2;
  tmpvar_2 = normalize (xlv_TEXCOORD2);
  lightDir = tmpvar_2;
  highp vec3 LightCoord_i0;
  LightCoord_i0 = xlv_TEXCOORD3.xyz;
  highp vec2 tmpvar_3;
  tmpvar_3 = vec2(dot (LightCoord_i0, LightCoord_i0));
  lowp float atten;
  atten = ((float((xlv_TEXCOORD3.z > 0.0)) * texture2D (_LightTexture0, ((xlv_TEXCOORD3.xy / xlv_TEXCOORD3.w) + 0.5)).w) * texture2D (_LightTextureB0, tmpvar_3).w);
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_1.xyz * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD1, lightDir)) * atten) * 2.0));
  c_i0_i1.w = tmpvar_1.w;
  c = c_i0_i1;
  c.w = 0.0;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "SPOT" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_5;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  lowp vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  mediump vec3 tmpvar_2;
  tmpvar_2 = normalize (xlv_TEXCOORD2);
  lightDir = tmpvar_2;
  highp vec3 LightCoord_i0;
  LightCoord_i0 = xlv_TEXCOORD3.xyz;
  highp vec2 tmpvar_3;
  tmpvar_3 = vec2(dot (LightCoord_i0, LightCoord_i0));
  lowp float atten;
  atten = ((float((xlv_TEXCOORD3.z > 0.0)) * texture2D (_LightTexture0, ((xlv_TEXCOORD3.xy / xlv_TEXCOORD3.w) + 0.5)).w) * texture2D (_LightTextureB0, tmpvar_3).w);
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_1.xyz * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD1, lightDir)) * atten) * 2.0));
  c_i0_i1.w = tmpvar_1.w;
  c = c_i0_i1;
  c.w = 0.0;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "flash " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 14 [_MainTex_ST]
"agal_vs
[bc]
adaaaaaaabaaahacabaaaaoeaaaaaaaaamaaaappabaaaaaa mul r1.xyz, a1, c12.w
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 r0.w, a0, c7
bdaaaaaaadaaaiaeaaaaaaoeacaaaaaaalaaaaoeabaaaaaa dp4 v3.w, r0, c11
bdaaaaaaadaaaeaeaaaaaaoeacaaaaaaakaaaaoeabaaaaaa dp4 v3.z, r0, c10
bdaaaaaaadaaacaeaaaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 v3.y, r0, c9
bdaaaaaaadaaabaeaaaaaaoeacaaaaaaaiaaaaoeabaaaaaa dp4 v3.x, r0, c8
bcaaaaaaabaaaeaeabaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v1.z, r1.xyzz, c6
bcaaaaaaabaaacaeabaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v1.y, r1.xyzz, c5
bcaaaaaaabaaabaeabaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v1.x, r1.xyzz, c4
bfaaaaaaaaaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r0.xyz, r0.xyzz
abaaaaaaacaaahaeaaaaaakeacaaaaaaanaaaaoeabaaaaaa add v2.xyz, r0.xyzz, c13
adaaaaaaaaaaadacadaaaaoeaaaaaaaaaoaaaaoeabaaaaaa mul r0.xy, a3, c14
abaaaaaaaaaaadaeaaaaaafeacaaaaaaaoaaaaooabaaaaaa add v0.xy, r0.xyyy, c14.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
"
}

SubProgram "opengl " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 13 [unity_Scale]
Vector 14 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_LightMatrix0]
Vector 15 [_MainTex_ST]
"!!ARBvp1.0
# 17 ALU
PARAM c[16] = { program.local[0],
		state.matrix.mvp,
		program.local[5..15] };
TEMP R0;
TEMP R1;
MUL R1.xyz, vertex.normal, c[13].w;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
DP4 result.texcoord[3].z, R0, c[11];
DP4 result.texcoord[3].y, R0, c[10];
DP4 result.texcoord[3].x, R0, c[9];
DP3 result.texcoord[1].z, R1, c[7];
DP3 result.texcoord[1].y, R1, c[6];
DP3 result.texcoord[1].x, R1, c[5];
ADD result.texcoord[2].xyz, -R0, c[14];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[15], c[15].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 17 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 14 [_MainTex_ST]
"vs_2_0
; 17 ALU
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c12.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 oT3.z, r0, c10
dp4 oT3.y, r0, c9
dp4 oT3.x, r0, c8
dp3 oT1.z, r1, c6
dp3 oT1.y, r1, c5
dp3 oT1.x, r1, c4
add oT2.xyz, -r0, c13
mad oT0.xy, v2, c14, c14.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "xbox360 " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 10 [_LightMatrix0] 4
Vector 14 [_MainTex_ST]
Matrix 6 [_Object2World] 4
Vector 5 [_WorldSpaceLightPos0]
Matrix 0 [glstate_matrix_mvp] 4
Vector 4 [unity_Scale]
// Shader Timing Estimate, in Cycles/64 vertex vector:
// ALU: 24.00 (18 instructions), vertex: 32, texture: 0,
//   sequencer: 14,  5 GPRs, 31 threads,
// Performance (if enough threads): ~32 cycles per vector
// * Vertex cycle estimates are assuming 3 vfetch_minis for every vfetch_full,
//     with <= 32 bytes per vfetch_full group.

"vs_360
backbbabaaaaabkeaaaaabdiaaaaaaaaaaaaaaceaaaaaaaaaaaaabfaaaaaaaaa
aaaaaaaaaaaaabciaaaaaabmaaaaabbjpppoadaaaaaaaaagaaaaaabmaaaaaaaa
aaaaabbcaaaaaajeaaacaaakaaaeaaaaaaaaaakeaaaaaaaaaaaaaaleaaacaaao
aaabaaaaaaaaaamaaaaaaaaaaaaaaanaaaacaaagaaaeaaaaaaaaaakeaaaaaaaa
aaaaaanoaaacaaafaaabaaaaaaaaaamaaaaaaaaaaaaaaapdaaacaaaaaaaeaaaa
aaaaaakeaaaaaaaaaaaaabagaaacaaaeaaabaaaaaaaaaamaaaaaaaaafpemgjgh
giheengbhehcgjhidaaaklklaaadaaadaaaeaaaeaaabaaaaaaaaaaaafpengbgj
gofegfhifpfdfeaaaaabaaadaaabaaaeaaabaaaaaaaaaaaafpepgcgkgfgdhedc
fhgphcgmgeaafpfhgphcgmgefdhagbgdgfemgjghgihefagphddaaaghgmhdhegb
hegffpgngbhehcgjhifpgnhghaaahfgogjhehjfpfdgdgbgmgfaahghdfpddfpda
aadccodacodcdadddfddcodaaaklklklaaaaaaaaaaaaabdiaadbaaaeaaaaaaaa
aaaaaaaaaaaacmieaaaaaaabaaaaaaadaaaaaaaeaaaaacjaaabaaaaeaaaadaaf
aacafaagaaaadafaaaabhbfbaaachcfcaaadhdfdaaaababeaaaababdaaaababc
aaaababihabfdaaeaaaabcaamcaaaaaaaaaaeaahaaaabcaameaaaaaaaaaagaal
gabbbcaabcaaaaaaaaaacabhaaaaccaaaaaaaaaaafpidaaaaaaaagiiaaaaaaaa
afpiaaaaaaaaaeehaaaaaaaaafpibaaaaaaaapmiaaaaaaaamiapaaacaabliiaa
kbadadaamiapaaacaamgiiaakladacacmiapaaacaalbdejekladabacmiapiado
aagmaadekladaaacmialaaacaalkblaakbaaaeaamiapaaaaaablaaaakbadajaa
miapaaaaaamgaaaakladaiaamiahaaaeaalbleaakbacaiaamiahaaacaagmlema
klacahaemiapaaaaaalbaaaakladahaamiapaaaaaagmffffkladagaamiahiaac
aelpmaaakaaaafaamiahiaabaablmaleklacagacmiadiaaaaalalabkilabaoao
miahaaabaamgleaakbaaanaamiahaaabaalbmaleklaaamabmiahaaaaaagmlele
klaaalabmiahiaadaablmaleklaaakaaaaaaaaaaaaaaaaaaaaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 256 [glstate_matrix_mvp]
Vector 467 [unity_Scale]
Vector 466 [_WorldSpaceLightPos0]
Matrix 260 [_Object2World]
Matrix 264 [_LightMatrix0]
Vector 465 [_MainTex_ST]
"sce_vp_rsx // 17 instructions using 2 registers
[Configuration]
8
0000001101050200
[Microcode]
272
00009c6c009d320c013fc0c36041dffc401f9c6c011d1808010400d740619f9c
401f9c6c01d0300d8106c0c360403f80401f9c6c01d0200d8106c0c360405f80
401f9c6c01d0100d8106c0c360409f80401f9c6c01d0000d8106c0c360411f80
00001c6c01d0700d8106c0c360403ffc00001c6c01d0600d8106c0c360405ffc
00001c6c01d0500d8106c0c360409ffc00001c6c01d0400d8106c0c360411ffc
401f9c6c0150600c028600c360405fa0401f9c6c0150500c028600c360409fa0
401f9c6c0150400c028600c360411fa0401f9c6c00dd200c0186c0a30021dfa4
401f9c6c01d0a00d8086c0c360405fa8401f9c6c01d0900d8086c0c360409fa8
401f9c6c01d0800d8086c0c360411fa9
"
}

SubProgram "gles " {
Keywords { "POINT_COOKIE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_5;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  lowp vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  mediump vec3 tmpvar_2;
  tmpvar_2 = normalize (xlv_TEXCOORD2);
  lightDir = tmpvar_2;
  highp vec2 tmpvar_3;
  tmpvar_3 = vec2(dot (xlv_TEXCOORD3, xlv_TEXCOORD3));
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_1.xyz * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD1, lightDir)) * (texture2D (_LightTextureB0, tmpvar_3).w * textureCube (_LightTexture0, xlv_TEXCOORD3).w)) * 2.0));
  c_i0_i1.w = tmpvar_1.w;
  c = c_i0_i1;
  c.w = 0.0;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "POINT_COOKIE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_2 = tmpvar_5;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  lowp vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  mediump vec3 tmpvar_2;
  tmpvar_2 = normalize (xlv_TEXCOORD2);
  lightDir = tmpvar_2;
  highp vec2 tmpvar_3;
  tmpvar_3 = vec2(dot (xlv_TEXCOORD3, xlv_TEXCOORD3));
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_1.xyz * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD1, lightDir)) * (texture2D (_LightTextureB0, tmpvar_3).w * textureCube (_LightTexture0, xlv_TEXCOORD3).w)) * 2.0));
  c_i0_i1.w = tmpvar_1.w;
  c = c_i0_i1;
  c.w = 0.0;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "flash " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 14 [_MainTex_ST]
"agal_vs
[bc]
adaaaaaaabaaahacabaaaaoeaaaaaaaaamaaaappabaaaaaa mul r1.xyz, a1, c12.w
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 r0.w, a0, c7
bdaaaaaaadaaaeaeaaaaaaoeacaaaaaaakaaaaoeabaaaaaa dp4 v3.z, r0, c10
bdaaaaaaadaaacaeaaaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 v3.y, r0, c9
bdaaaaaaadaaabaeaaaaaaoeacaaaaaaaiaaaaoeabaaaaaa dp4 v3.x, r0, c8
bcaaaaaaabaaaeaeabaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v1.z, r1.xyzz, c6
bcaaaaaaabaaacaeabaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v1.y, r1.xyzz, c5
bcaaaaaaabaaabaeabaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v1.x, r1.xyzz, c4
bfaaaaaaaaaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r0.xyz, r0.xyzz
abaaaaaaacaaahaeaaaaaakeacaaaaaaanaaaaoeabaaaaaa add v2.xyz, r0.xyzz, c13
adaaaaaaaaaaadacadaaaaoeaaaaaaaaaoaaaaoeabaaaaaa mul r0.xy, a3, c14
abaaaaaaaaaaadaeaaaaaafeacaaaaaaaoaaaaooabaaaaaa add v0.xy, r0.xyyy, c14.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 13 [unity_Scale]
Vector 14 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_LightMatrix0]
Vector 15 [_MainTex_ST]
"!!ARBvp1.0
# 16 ALU
PARAM c[16] = { program.local[0],
		state.matrix.mvp,
		program.local[5..15] };
TEMP R0;
TEMP R1;
MUL R1.xyz, vertex.normal, c[13].w;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 result.texcoord[3].y, R0, c[10];
DP4 result.texcoord[3].x, R0, c[9];
DP3 result.texcoord[1].z, R1, c[7];
DP3 result.texcoord[1].y, R1, c[6];
DP3 result.texcoord[1].x, R1, c[5];
MOV result.texcoord[2].xyz, c[14];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[15], c[15].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 16 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 14 [_MainTex_ST]
"vs_2_0
; 16 ALU
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c12.w
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 oT3.y, r0, c9
dp4 oT3.x, r0, c8
dp3 oT1.z, r1, c6
dp3 oT1.y, r1, c5
dp3 oT1.x, r1, c4
mov oT2.xyz, c13
mad oT0.xy, v2, c14, c14.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "xbox360 " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 10 [_LightMatrix0] 4
Vector 14 [_MainTex_ST]
Matrix 6 [_Object2World] 4
Vector 5 [_WorldSpaceLightPos0]
Matrix 0 [glstate_matrix_mvp] 4
Vector 4 [unity_Scale]
// Shader Timing Estimate, in Cycles/64 vertex vector:
// ALU: 24.00 (18 instructions), vertex: 32, texture: 0,
//   sequencer: 14,  5 GPRs, 31 threads,
// Performance (if enough threads): ~32 cycles per vector
// * Vertex cycle estimates are assuming 3 vfetch_minis for every vfetch_full,
//     with <= 32 bytes per vfetch_full group.

"vs_360
backbbabaaaaabkeaaaaabdiaaaaaaaaaaaaaaceaaaaaaaaaaaaabfaaaaaaaaa
aaaaaaaaaaaaabciaaaaaabmaaaaabbjpppoadaaaaaaaaagaaaaaabmaaaaaaaa
aaaaabbcaaaaaajeaaacaaakaaaeaaaaaaaaaakeaaaaaaaaaaaaaaleaaacaaao
aaabaaaaaaaaaamaaaaaaaaaaaaaaanaaaacaaagaaaeaaaaaaaaaakeaaaaaaaa
aaaaaanoaaacaaafaaabaaaaaaaaaamaaaaaaaaaaaaaaapdaaacaaaaaaaeaaaa
aaaaaakeaaaaaaaaaaaaabagaaacaaaeaaabaaaaaaaaaamaaaaaaaaafpemgjgh
giheengbhehcgjhidaaaklklaaadaaadaaaeaaaeaaabaaaaaaaaaaaafpengbgj
gofegfhifpfdfeaaaaabaaadaaabaaaeaaabaaaaaaaaaaaafpepgcgkgfgdhedc
fhgphcgmgeaafpfhgphcgmgefdhagbgdgfemgjghgihefagphddaaaghgmhdhegb
hegffpgngbhehcgjhifpgnhghaaahfgogjhehjfpfdgdgbgmgfaahghdfpddfpda
aadccodacodcdadddfddcodaaaklklklaaaaaaaaaaaaabdiaadbaaaeaaaaaaaa
aaaaaaaaaaaaciieaaaaaaabaaaaaaadaaaaaaaeaaaaacjaaabaaaaeaaaadaaf
aacafaagaaaadafaaaabhbfbaaachcfcaaadddfdaaaababeaaaababdaaaababc
aaaababihabfdaaeaaaabcaamcaaaaaaaaaaeaahaaaabcaameaaaaaaaaaagaal
gabbbcaabcaaaaaaaaaacabhaaaaccaaaaaaaaaaafpidaaaaaaaagiiaaaaaaaa
afpiaaaaaaaaaeehaaaaaaaaafpibaaaaaaaapmiaaaaaaaamiapaaacaabliiaa
kbadadaamiapaaacaamgiiaakladacacmiapaaacaalbdejekladabacmiapiado
aagmaadekladaaacmialaaacaalkblaakbaaaeaamiapaaaaaabliiaakbadajaa
miapaaaaaamgiiaakladaiaamiahaaaeaalbleaakbacaiaamiahaaacaagmlema
klacahaemiapaaaaaalbdejekladahaamiapaaaaaagmojkkkladagaamiahiaac
aamamaaaccafafaamiahiaabaablmaleklacagacmiadiaaaaalalabkilabaoao
miadaaabaalblaaakbaaanaamiadaaabaabllalaklaaamabmiadaaaaaagmlala
klaaalabmiadiaadaamglalaklaaakaaaaaaaaaaaaaaaaaaaaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 256 [glstate_matrix_mvp]
Vector 467 [unity_Scale]
Vector 466 [_WorldSpaceLightPos0]
Matrix 260 [_Object2World]
Matrix 264 [_LightMatrix0]
Vector 465 [_MainTex_ST]
"sce_vp_rsx // 16 instructions using 2 registers
[Configuration]
8
0000001001050200
[Microcode]
256
401f9c6c005d200c0186c0836041dfa400009c6c009d320c013fc0c36041dffc
401f9c6c011d1808010400d740619f9c401f9c6c01d0300d8106c0c360403f80
401f9c6c01d0200d8106c0c360405f80401f9c6c01d0100d8106c0c360409f80
401f9c6c01d0000d8106c0c360411f8000001c6c01d0700d8106c0c360403ffc
00001c6c01d0600d8106c0c360405ffc00001c6c01d0500d8106c0c360409ffc
00001c6c01d0400d8106c0c360411ffc401f9c6c0150600c028600c360405fa0
401f9c6c0150500c028600c360409fa0401f9c6c0150400c028600c360411fa0
401f9c6c01d0900d8086c0c360409fa8401f9c6c01d0800d8086c0c360411fa9
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = _WorldSpaceLightPos0.xyz;
  tmpvar_2 = tmpvar_5;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xy;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  lowp vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  lightDir = xlv_TEXCOORD2;
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_1.xyz * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD1, lightDir)) * texture2D (_LightTexture0, xlv_TEXCOORD3).w) * 2.0));
  c_i0_i1.w = tmpvar_1.w;
  c = c_i0_i1;
  c.w = 0.0;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  mat3 tmpvar_3;
  tmpvar_3[0] = _Object2World[0].xyz;
  tmpvar_3[1] = _Object2World[1].xyz;
  tmpvar_3[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_4;
  tmpvar_4 = (tmpvar_3 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = _WorldSpaceLightPos0.xyz;
  tmpvar_2 = tmpvar_5;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xy;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  lowp vec4 tmpvar_1;
  tmpvar_1 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  lightDir = xlv_TEXCOORD2;
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_1.xyz * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD1, lightDir)) * texture2D (_LightTexture0, xlv_TEXCOORD3).w) * 2.0));
  c_i0_i1.w = tmpvar_1.w;
  c = c_i0_i1;
  c.w = 0.0;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_LightMatrix0]
Vector 14 [_MainTex_ST]
"agal_vs
[bc]
adaaaaaaabaaahacabaaaaoeaaaaaaaaamaaaappabaaaaaa mul r1.xyz, a1, c12.w
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 r0.w, a0, c7
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
bdaaaaaaadaaacaeaaaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 v3.y, r0, c9
bdaaaaaaadaaabaeaaaaaaoeacaaaaaaaiaaaaoeabaaaaaa dp4 v3.x, r0, c8
bcaaaaaaabaaaeaeabaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v1.z, r1.xyzz, c6
bcaaaaaaabaaacaeabaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v1.y, r1.xyzz, c5
bcaaaaaaabaaabaeabaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v1.x, r1.xyzz, c4
aaaaaaaaacaaahaeanaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.xyz, c13
adaaaaaaaaaaadacadaaaaoeaaaaaaaaaoaaaaoeabaaaaaa mul r0.xy, a3, c14
abaaaaaaaaaaadaeaaaaaafeacaaaaaaaoaaaaooabaaaaaa add v0.xy, r0.xyyy, c14.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.zw, c0
"
}

}
Program "fp" {
// Fragment combos: 5
//   opengl - ALU: 9 to 20, TEX: 1 to 3
//   d3d9 - ALU: 9 to 19, TEX: 1 to 3
SubProgram "opengl " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTexture0] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 14 ALU, 2 TEX
PARAM c[3] = { program.local[0..1],
		{ 0, 2 } };
TEMP R0;
TEMP R1;
TEX R0.xyz, fragment.texcoord[0], texture[0], 2D;
DP3 R0.w, fragment.texcoord[3], fragment.texcoord[3];
DP3 R1.x, fragment.texcoord[2], fragment.texcoord[2];
RSQ R1.x, R1.x;
MUL R1.xyz, R1.x, fragment.texcoord[2];
MUL R0.xyz, R0, c[1];
DP3 R1.x, fragment.texcoord[1], R1;
MUL R0.xyz, R0, c[0];
MAX R1.x, R1, c[2];
MOV result.color.w, c[2].x;
TEX R0.w, R0.w, texture[1], 2D;
MUL R0.w, R1.x, R0;
MUL R0.xyz, R0.w, R0;
MUL result.color.xyz, R0, c[2].y;
END
# 14 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTexture0] 2D
"ps_2_0
; 14 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c2, 0.00000000, 2.00000000, 0, 0
dcl t0.xy
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
texld r1, t0, s0
dp3 r0.x, t3, t3
mov r0.xy, r0.x
mul r1.xyz, r1, c1
mul_pp r1.xyz, r1, c0
mov_pp r0.w, c2.x
texld r2, r0, s1
dp3_pp r0.x, t2, t2
rsq_pp r0.x, r0.x
mul_pp r0.xyz, r0.x, t2
dp3_pp r0.x, t1, r0
max_pp r0.x, r0, c2
mul_pp r0.x, r0, r2
mul_pp r0.xyz, r0.x, r1
mul_pp r0.xyz, r0, c2.y
mov_pp oC0, r0
"
}

SubProgram "xbox360 " {
Keywords { "POINT" }
Vector 1 [_Color]
Vector 0 [_LightColor0]
SetTexture 0 [_LightTexture0] 2D
SetTexture 1 [_MainTex] 2D
// Shader Timing Estimate, in Cycles/64 pixel vector:
// ALU: 13.33 (10 instructions), vertex: 0, texture: 8,
//   sequencer: 8, interpolator: 16;    4 GPRs, 48 threads,
// Performance (if enough threads): ~16 cycles per vector
// * Texture cycle estimates are assuming an 8bit/component texture with no
//     aniso or trilinear filtering.

"ps_360
backbbaaaaaaabemaaaaaapeaaaaaaaaaaaaaaceaaaaaapeaaaaabbmaaaaaaaa
aaaaaaaaaaaaaammaaaaaabmaaaaaamappppadaaaaaaaaaeaaaaaabmaaaaaaaa
aaaaaaljaaaaaagmaaacaaabaaabaaaaaaaaaaheaaaaaaaaaaaaaaieaaacaaaa
aaabaaaaaaaaaaheaaaaaaaaaaaaaajbaaadaaaaaaabaaaaaaaaaakaaaaaaaaa
aaaaaalaaaadaaabaaabaaaaaaaaaakaaaaaaaaafpedgpgmgphcaaklaaabaaad
aaabaaaeaaabaaaaaaaaaaaafpemgjghgiheedgpgmgphcdaaafpemgjghgihefe
gfhihehfhcgfdaaaaaaeaaamaaabaaabaaabaaaaaaaaaaaafpengbgjgofegfhi
aahahdfpddfpdaaadccodacodcdadddfddcodaaaaaaaaaaaaaaaaaabaaaaaaaa
aaaaaaaaaaaaaabeabpmaabaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaea
aaaaaalebaaaadaaaaaaaaaeaaaaaaaaaaaacmieaaapaaapaaaaaaabaaaadafa
aaaahbfbaaaahcfcaaaahdfdaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaabedaacaaaabcaameaaaaaaaaaagaafdaalbcaa
ccaaaaaamiaiaaaaaaloloaapaadadaababiaaabbpbppoiiaaaaeaaapmaiaaab
bpbppbppaaaaeaaamiaiaaabaaloloaapaacacaafiihabaaaaloloblkbaaabib
aaihabacaablmablobabacaakibiacaaaaloloebnaacabaakicbacabaablgmic
icaappaakiecacabaablgmmambababaamiaoaaaaaaebhbaaobacabaamiabaaaa
aablblaaobaaabaamiahmaaaaamamaaaocaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
"
}

SubProgram "ps3 " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTexture0] 2D
"sce_fp_rsx // 17 instructions using 2 registers
[Configuration]
24
ffffffff0003c020000ffff1000000000000840002000000
[Offsets]
2
_LightColor0 1 0
000000f0
_Color 1 0
00000020
[Microcode]
272
8e001700c8011c9dc8000001c8003fe10e820200c8001c9dc8020001c8000001
0000000000000000000000000000000010800140c8021c9dc8000001c8000001
00000000000000000000000000000000ee020100c8011c9dc8000001c8003fe1
02000500c8041c9dc8040001c80000010202170200001c9cc8000001c8000001
ce803940c8011c9dc8000029c800bfe11e7e7d00c8001c9dc8000001c8000001
a2800540c8011c9dc9000001c8003fe102800900c9001c9d00020000c8000001
000000000000000000000000000000001082024001001c9c00040000c8000001
0e800240c9041c9dc8020001c800000100000000000000000000000000000000
0e810240ff041c9dc9001001c8000001
"
}

SubProgram "gles " {
Keywords { "POINT" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "POINT" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTexture0] 2D
"agal_ps
c2 0.0 2.0 0.0 0.0
[bc]
ciaaaaaaabaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r1, v0, s0 <2d wrap linear point>
bcaaaaaaaaaaabacadaaaaoeaeaaaaaaadaaaaoeaeaaaaaa dp3 r0.x, v3, v3
aaaaaaaaaaaaadacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r0.xy, r0.x
adaaaaaaabaaahacabaaaakeacaaaaaaabaaaaoeabaaaaaa mul r1.xyz, r1.xyzz, c1
adaaaaaaabaaahacabaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r1.xyz, r1.xyzz, c0
ciaaaaaaaaaaapacaaaaaafeacaaaaaaabaaaaaaafaababb tex r0, r0.xyyy, s1 <2d wrap linear point>
bcaaaaaaaaaaabacacaaaaoeaeaaaaaaacaaaaoeaeaaaaaa dp3 r0.x, v2, v2
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
adaaaaaaaaaaahacaaaaaaaaacaaaaaaacaaaaoeaeaaaaaa mul r0.xyz, r0.x, v2
bcaaaaaaaaaaabacabaaaaoeaeaaaaaaaaaaaakeacaaaaaa dp3 r0.x, v1, r0.xyzz
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaacaaaaoeabaaaaaa max r0.x, r0.x, c2
adaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaappacaaaaaa mul r0.x, r0.x, r0.w
adaaaaaaaaaaahacaaaaaaaaacaaaaaaabaaaakeacaaaaaa mul r0.xyz, r0.x, r1.xyzz
adaaaaaaaaaaahacaaaaaakeacaaaaaaacaaaaffabaaaaaa mul r0.xyz, r0.xyzz, c2.y
aaaaaaaaaaaaaiacacaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c2.x
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 9 ALU, 1 TEX
PARAM c[3] = { program.local[0..1],
		{ 0, 2 } };
TEMP R0;
TEMP R1;
TEX R0.xyz, fragment.texcoord[0], texture[0], 2D;
MOV R1.xyz, fragment.texcoord[2];
MUL R0.xyz, R0, c[1];
DP3 R0.w, fragment.texcoord[1], R1;
MUL R0.xyz, R0, c[0];
MAX R0.w, R0, c[2].x;
MUL R0.xyz, R0.w, R0;
MUL result.color.xyz, R0, c[2].y;
MOV result.color.w, c[2].x;
END
# 9 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
"ps_2_0
; 9 ALU, 1 TEX
dcl_2d s0
def c2, 0.00000000, 2.00000000, 0, 0
dcl t0.xy
dcl t1.xyz
dcl t2.xyz
texld r1, t0, s0
mov_pp r0.xyz, t2
dp3_pp r0.x, t1, r0
mul r1.xyz, r1, c1
mul_pp r1.xyz, r1, c0
max_pp r0.x, r0, c2
mul_pp r0.xyz, r0.x, r1
mul_pp r0.xyz, r0, c2.y
mov_pp r0.w, c2.x
mov_pp oC0, r0
"
}

SubProgram "xbox360 " {
Keywords { "DIRECTIONAL" }
Vector 1 [_Color]
Vector 0 [_LightColor0]
SetTexture 0 [_MainTex] 2D
// Shader Timing Estimate, in Cycles/64 pixel vector:
// ALU: 6.67 (5 instructions), vertex: 0, texture: 4,
//   sequencer: 6, interpolator: 12;    3 GPRs, 63 threads,
// Performance (if enough threads): ~12 cycles per vector
// * Texture cycle estimates are assuming an 8bit/component texture with no
//     aniso or trilinear filtering.

"ps_360
backbbaaaaaaabciaaaaaakmaaaaaaaaaaaaaaceaaaaaaneaaaaaapmaaaaaaaa
aaaaaaaaaaaaaakmaaaaaabmaaaaaajpppppadaaaaaaaaadaaaaaabmaaaaaaaa
aaaaaajiaaaaaafiaaacaaabaaabaaaaaaaaaagaaaaaaaaaaaaaaahaaaacaaaa
aaabaaaaaaaaaagaaaaaaaaaaaaaaahnaaadaaaaaaabaaaaaaaaaaiiaaaaaaaa
fpedgpgmgphcaaklaaabaaadaaabaaaeaaabaaaaaaaaaaaafpemgjghgiheedgp
gmgphcdaaafpengbgjgofegfhiaaklklaaaeaaamaaabaaabaaabaaaaaaaaaaaa
hahdfpddfpdaaadccodacodcdadddfddcodaaaklaaaaaaaaaaaaaaabaaaaaaaa
aaaaaaaaaaaaaabeabpmaabaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaea
aaaaaagmbaaaacaaaaaaaaaeaaaaaaaaaaaacagdaaahaaahaaaaaaabaaaadafa
aaaahbfbaaaahcfcaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaabbaacaaaabcaameaaaaaaaaaafaadaaaaccaaaaaaaaaa
baaiaaabbpbppeehaaaaeaaamiabaaaaaaloloaapaabacaamiaoaaaaaaabpmaa
kbaaabaamiabaaaaaagmgmaakcaappaaaaboaaaaaaabpmgmkbaaaaaamiahmaaa
aabfgmaaobaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "DIRECTIONAL" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
"sce_fp_rsx // 13 instructions using 2 registers
[Configuration]
24
ffffffff0001c0200007fff9000000000000840002000000
[Offsets]
2
_LightColor0 1 0
00000090
_Color 1 0
00000050
[Microcode]
208
ce800140c8011c9dc8000001c8003fe11e7e7d00c8001c9dc8000001c8000001
a8820540c8011c9dc9000001c8003fe18e001700c8011c9dc8000001c8003fe1
0e800200c8001c9dc8020001c800000100000000000000000000000000000000
1082090055041c9dc8020001c800000100000000000000000000000000000000
0e800240c9001c9dc8020001c800000100000000000000000000000000000000
10800140c8021c9dc8000001c800000100000000000000000000000000000000
0e810240ff041c9dc9001001c8000001
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
"agal_ps
c2 0.0 2.0 0.0 0.0
[bc]
ciaaaaaaabaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r1, v0, s0 <2d wrap linear point>
aaaaaaaaaaaaahacacaaaaoeaeaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, v2
bcaaaaaaaaaaabacabaaaaoeaeaaaaaaaaaaaakeacaaaaaa dp3 r0.x, v1, r0.xyzz
adaaaaaaabaaahacabaaaakeacaaaaaaabaaaaoeabaaaaaa mul r1.xyz, r1.xyzz, c1
adaaaaaaabaaahacabaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r1.xyz, r1.xyzz, c0
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaacaaaaoeabaaaaaa max r0.x, r0.x, c2
adaaaaaaaaaaahacaaaaaaaaacaaaaaaabaaaakeacaaaaaa mul r0.xyz, r0.x, r1.xyzz
adaaaaaaaaaaahacaaaaaakeacaaaaaaacaaaaffabaaaaaa mul r0.xyz, r0.xyzz, c2.y
aaaaaaaaaaaaaiacacaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c2.x
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "opengl " {
Keywords { "SPOT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTexture0] 2D
SetTexture 2 [_LightTextureB0] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 20 ALU, 3 TEX
PARAM c[3] = { program.local[0..1],
		{ 0, 0.5, 2 } };
TEMP R0;
TEMP R1;
RCP R0.x, fragment.texcoord[3].w;
MAD R1.xy, fragment.texcoord[3], R0.x, c[2].y;
DP3 R1.z, fragment.texcoord[3], fragment.texcoord[3];
MOV result.color.w, c[2].x;
TEX R0.w, R1, texture[1], 2D;
TEX R0.xyz, fragment.texcoord[0], texture[0], 2D;
TEX R1.w, R1.z, texture[2], 2D;
DP3 R1.x, fragment.texcoord[2], fragment.texcoord[2];
RSQ R1.x, R1.x;
MUL R1.xyz, R1.x, fragment.texcoord[2];
DP3 R1.x, fragment.texcoord[1], R1;
SLT R1.y, c[2].x, fragment.texcoord[3].z;
MUL R0.w, R1.y, R0;
MUL R1.y, R0.w, R1.w;
MUL R0.xyz, R0, c[1];
MAX R0.w, R1.x, c[2].x;
MUL R0.xyz, R0, c[0];
MUL R0.w, R0, R1.y;
MUL R0.xyz, R0.w, R0;
MUL result.color.xyz, R0, c[2].z;
END
# 20 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "SPOT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTexture0] 2D
SetTexture 2 [_LightTextureB0] 2D
"ps_2_0
; 19 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c2, 0.50000000, 0.00000000, 1.00000000, 2.00000000
dcl t0.xy
dcl t1.xyz
dcl t2.xyz
dcl t3
texld r2, t0, s0
dp3 r0.x, t3, t3
rcp r1.x, t3.w
mov r0.xy, r0.x
mad r1.xy, t3, r1.x, c2.x
mul r2.xyz, r2, c1
mul_pp r2.xyz, r2, c0
texld r0, r0, s2
texld r1, r1, s1
cmp r1.x, -t3.z, c2.y, c2.z
mul_pp r3.x, r1, r1.w
dp3_pp r1.x, t2, t2
rsq_pp r1.x, r1.x
mul_pp r1.xyz, r1.x, t2
dp3_pp r1.x, t1, r1
mul_pp r0.x, r3, r0
max_pp r1.x, r1, c2.y
mul_pp r0.x, r1, r0
mul_pp r0.xyz, r0.x, r2
mul_pp r0.xyz, r0, c2.w
mov_pp r0.w, c2.y
mov_pp oC0, r0
"
}

SubProgram "xbox360 " {
Keywords { "SPOT" }
Vector 1 [_Color]
Vector 0 [_LightColor0]
SetTexture 0 [_LightTexture0] 2D
SetTexture 1 [_LightTextureB0] 2D
SetTexture 2 [_MainTex] 2D
// Shader Timing Estimate, in Cycles/64 pixel vector:
// ALU: 17.33 (13 instructions), vertex: 0, texture: 12,
//   sequencer: 8, interpolator: 16;    5 GPRs, 36 threads,
// Performance (if enough threads): ~17 cycles per vector
// * Texture cycle estimates are assuming an 8bit/component texture with no
//     aniso or trilinear filtering.

"ps_360
backbbaaaaaaabhaaaaaabceaaaaaaaaaaaaaaceaaaaabbiaaaaabeaaaaaaaaa
aaaaaaaaaaaaaapaaaaaaabmaaaaaaoeppppadaaaaaaaaafaaaaaabmaaaaaaaa
aaaaaannaaaaaaiaaaacaaabaaabaaaaaaaaaaiiaaaaaaaaaaaaaajiaaacaaaa
aaabaaaaaaaaaaiiaaaaaaaaaaaaaakfaaadaaaaaaabaaaaaaaaaaleaaaaaaaa
aaaaaameaaadaaabaaabaaaaaaaaaaleaaaaaaaaaaaaaaneaaadaaacaaabaaaa
aaaaaaleaaaaaaaafpedgpgmgphcaaklaaabaaadaaabaaaeaaabaaaaaaaaaaaa
fpemgjghgiheedgpgmgphcdaaafpemgjghgihefegfhihehfhcgfdaaaaaaeaaam
aaabaaabaaabaaaaaaaaaaaafpemgjghgihefegfhihehfhcgfecdaaafpengbgj
gofegfhiaahahdfpddfpdaaadccodacodcdadddfddcodaaaaaaaaaaaaaaaaaab
aaaaaaaaaaaaaaaaaaaaaabeabpmaabaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaeaaaaaaaoebaaaaeaaaaaaaaaeaaaaaaaaaaaadaieaaapaaapaaaaaaab
aaaadafaaaaahbfbaaaahcfcaaaapdfdaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaadpaaaaaaaaaaaaaaaaaaaaaaabfafaacaaaabcaameaaaaaaaaaagaah
faanbcaaccaaaaaaemieaaaaaaloloblpaadadadmiadaaaeaabllalbmlaaadpp
kibibaabbpbppbppaaaaeaaabaciaaabbpbppoiiaaaaeaaabaaieaibbpbppppl
aaaaeaaacaiiacaaaalolomgpaacacadmiaiaaacaagmblaaobaeacaafiihaaaa
aaloloblkbaaabiamiaiaaabaablblgmnbacabppmiahaaacaablmaaaobaaacaa
kibiacaaaaloloebnaacabaakiccacabaablgmicicaappaakiebacabaabllbma
mbababaamialaaaaaamalmaaobacabaamiaeaaaaaablblaaobaaabaamiahmaaa
aamamaaaocaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "SPOT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTexture0] 2D
SetTexture 2 [_LightTextureB0] 2D
"sce_fp_rsx // 24 instructions using 3 registers
[Configuration]
24
ffffffff0003c020000ffff1000000000000840003000000
[Offsets]
2
_LightColor0 1 0
00000160
_Color 1 0
00000060
[Microcode]
384
fe000100c8011c9dc8000001c8003fe102020500c8001c9dc8000001c8000001
8e041700c8011c9dc8000001c8003fe1108a0d0054001c9dc8020001c8000001
000000000000000000000000000000000e860200c8081c9dc8020001c8000001
0000000000000000000000000000000018003a0080001c9cfe000001c8000001
0200170400041c9cc8000001c800000118000300c8001c9d00020000c8000001
00003f00000000000000000000000000100017025c001c9dc8000001c8000001
ce843940c8011c9dc8000029c800bfe110800240c9141c9dc8000001c8000001
10840240c9001c9d00000000c8000001a2800540c8011c9dc9080001c8003fe1
1080014000021c9cc8000001c800000100000000000000000000000000000000
02800900c9001c9d00020000c800000100000000000000000000000000000000
1084024001001c9cc9080001c80000010e840240c90c1c9dc8020001c8000001
000000000000000000000000000000000e810240ff081c9dc9081001c8000001
"
}

SubProgram "gles " {
Keywords { "SPOT" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "SPOT" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "SPOT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTexture0] 2D
SetTexture 2 [_LightTextureB0] 2D
"agal_ps
c2 0.5 0.0 1.0 2.0
[bc]
ciaaaaaaacaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r2, v0, s0 <2d wrap linear point>
bcaaaaaaaaaaabacadaaaaoeaeaaaaaaadaaaaoeaeaaaaaa dp3 r0.x, v3, v3
afaaaaaaabaaabacadaaaappaeaaaaaaaaaaaaaaaaaaaaaa rcp r1.x, v3.w
aaaaaaaaaaaaadacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r0.xy, r0.x
adaaaaaaabaaadacadaaaaoeaeaaaaaaabaaaaaaacaaaaaa mul r1.xy, v3, r1.x
abaaaaaaabaaadacabaaaafeacaaaaaaacaaaaaaabaaaaaa add r1.xy, r1.xyyy, c2.x
adaaaaaaacaaahacacaaaakeacaaaaaaabaaaaoeabaaaaaa mul r2.xyz, r2.xyzz, c1
adaaaaaaacaaahacacaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r2.xyz, r2.xyzz, c0
ciaaaaaaabaaapacabaaaafeacaaaaaaabaaaaaaafaababb tex r1, r1.xyyy, s1 <2d wrap linear point>
ciaaaaaaaaaaapacaaaaaafeacaaaaaaacaaaaaaafaababb tex r0, r0.xyyy, s2 <2d wrap linear point>
bfaaaaaaacaaaiacadaaaakkaeaaaaaaaaaaaaaaaaaaaaaa neg r2.w, v3.z
ckaaaaaaaaaaabacacaaaappacaaaaaaacaaaaffabaaaaaa slt r0.x, r2.w, c2.y
adaaaaaaaaaaabacaaaaaaaaacaaaaaaabaaaappacaaaaaa mul r0.x, r0.x, r1.w
adaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaappacaaaaaa mul r0.x, r0.x, r0.w
bcaaaaaaabaaabacacaaaaoeaeaaaaaaacaaaaoeaeaaaaaa dp3 r1.x, v2, v2
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
adaaaaaaabaaahacabaaaaaaacaaaaaaacaaaaoeaeaaaaaa mul r1.xyz, r1.x, v2
bcaaaaaaabaaabacabaaaaoeaeaaaaaaabaaaakeacaaaaaa dp3 r1.x, v1, r1.xyzz
ahaaaaaaabaaabacabaaaaaaacaaaaaaacaaaaffabaaaaaa max r1.x, r1.x, c2.y
adaaaaaaaaaaabacabaaaaaaacaaaaaaaaaaaaaaacaaaaaa mul r0.x, r1.x, r0.x
adaaaaaaaaaaahacaaaaaaaaacaaaaaaacaaaakeacaaaaaa mul r0.xyz, r0.x, r2.xyzz
adaaaaaaaaaaahacaaaaaakeacaaaaaaacaaaappabaaaaaa mul r0.xyz, r0.xyzz, c2.w
aaaaaaaaaaaaaiacacaaaaffabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c2.y
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "opengl " {
Keywords { "POINT_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTextureB0] 2D
SetTexture 2 [_LightTexture0] CUBE
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 16 ALU, 3 TEX
PARAM c[3] = { program.local[0..1],
		{ 0, 2 } };
TEMP R0;
TEMP R1;
TEX R0.xyz, fragment.texcoord[0], texture[0], 2D;
TEX R1.w, fragment.texcoord[3], texture[2], CUBE;
DP3 R0.w, fragment.texcoord[3], fragment.texcoord[3];
DP3 R1.x, fragment.texcoord[2], fragment.texcoord[2];
RSQ R1.x, R1.x;
MUL R1.xyz, R1.x, fragment.texcoord[2];
MUL R0.xyz, R0, c[1];
DP3 R1.x, fragment.texcoord[1], R1;
MUL R0.xyz, R0, c[0];
MOV result.color.w, c[2].x;
TEX R0.w, R0.w, texture[1], 2D;
MUL R1.y, R0.w, R1.w;
MAX R0.w, R1.x, c[2].x;
MUL R0.w, R0, R1.y;
MUL R0.xyz, R0.w, R0;
MUL result.color.xyz, R0, c[2].y;
END
# 16 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTextureB0] 2D
SetTexture 2 [_LightTexture0] CUBE
"ps_2_0
; 15 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c2, 0.00000000, 2.00000000, 0, 0
dcl t0.xy
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
texld r2, t3, s2
texld r1, t0, s0
dp3 r0.x, t3, t3
mov r0.xy, r0.x
dp3_pp r2.x, t2, t2
rsq_pp r2.x, r2.x
mul_pp r2.xyz, r2.x, t2
mul r1.xyz, r1, c1
dp3_pp r2.x, t1, r2
mul_pp r1.xyz, r1, c0
max_pp r2.x, r2, c2
texld r0, r0, s1
mul r0.x, r0, r2.w
mul_pp r0.x, r2, r0
mul_pp r0.xyz, r0.x, r1
mul_pp r0.xyz, r0, c2.y
mov_pp r0.w, c2.x
mov_pp oC0, r0
"
}

SubProgram "xbox360 " {
Keywords { "POINT_COOKIE" }
Vector 1 [_Color]
Vector 0 [_LightColor0]
SetTexture 0 [_LightTexture0] CUBE
SetTexture 1 [_LightTextureB0] 2D
SetTexture 2 [_MainTex] 2D
// Shader Timing Estimate, in Cycles/64 pixel vector:
// ALU: 18.67 (14 instructions), vertex: 0, texture: 12,
//   sequencer: 10, interpolator: 16;    5 GPRs, 36 threads,
// Performance (if enough threads): ~18 cycles per vector
// * Texture cycle estimates are assuming an 8bit/component texture with no
//     aniso or trilinear filtering.

"ps_360
backbbaaaaaaabiaaaaaabdmaaaaaaaaaaaaaaceaaaaabciaaaaabfaaaaaaaaa
aaaaaaaaaaaaabaaaaaaaabmaaaaaapeppppadaaaaaaaaafaaaaaabmaaaaaaaa
aaaaaaonaaaaaaiaaaacaaabaaabaaaaaaaaaaiiaaaaaaaaaaaaaajiaaacaaaa
aaabaaaaaaaaaaiiaaaaaaaaaaaaaakfaaadaaaaaaabaaaaaaaaaaleaaaaaaaa
aaaaaameaaadaaabaaabaaaaaaaaaaneaaaaaaaaaaaaaaoeaaadaaacaaabaaaa
aaaaaaneaaaaaaaafpedgpgmgphcaaklaaabaaadaaabaaaeaaabaaaaaaaaaaaa
fpemgjghgiheedgpgmgphcdaaafpemgjghgihefegfhihehfhcgfdaaaaaaeaaao
aaabaaabaaabaaaaaaaaaaaafpemgjghgihefegfhihehfhcgfecdaaaaaaeaaam
aaabaaabaaabaaaaaaaaaaaafpengbgjgofegfhiaahahdfpddfpdaaadccodaco
dcdadddfddcodaaaaaaaaaaaaaaaaaabaaaaaaaaaaaaaaaaaaaaaabeabpmaaba
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaeaaaaaaapmbaaaaeaaaaaaaaae
aaaaaaaaaaaacmieaaapaaapaaaaaaabaaaadafaaaaahbfbaaaahcfcaaaahdfd
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadpmaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
afaagaadbaajbcaabcaaaaabaaaaaaaagaakmeaabcaaaaaaaaaaeabaaaaaccaa
aaaaaaaamiaiaaaaaaloloaapaadadaamiapaaadaakgmnaapcadadaaemeeaaae
aablblmgocadadidmiadaaaeaagnmggmmladaappbaciaaabbpbppoiiaaaaeaaa
jaaicaibbpbpphppaaaamaaapmbibaabbpbppbppaaaaeaaamiaiaaaaaaloloaa
paacacaamiaiaaabaablbllbnbacabppfiihaaaaaaloloblkbaaabiamiahaaac
aablmaaaobaaacaakibiacaaaaloloebnaacabaakicbacabaabllbicicaappaa
kiecacabaablgmmambababaamiaoaaaaaaebhbaaobacabaamiabaaaaaablblaa
obaaabaamiahmaaaaamamaaaocaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "POINT_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTextureB0] 2D
SetTexture 2 [_LightTexture0] CUBE
"sce_fp_rsx // 19 instructions using 3 registers
[Configuration]
24
ffffffff0003c020000ffff1000000000000840003000000
[Offsets]
2
_LightColor0 1 0
000000e0
_Color 1 0
000000c0
[Microcode]
304
ee000100c8011c9dc8000001c8003fe102000500c8001c9dc8000001c8000001
8e041700c8011c9dc8000001c8003fe1ce843940c8011c9dc8000029c800bfe1
1e7e7d00c8001c9dc8000001c8000001a2820540c8011c9dc9080001c8003fe1
f1001704c8011c9dc8000001c8003fe102820900c9041c9d00020000c8000001
000000000000000000000000000000000200170200001ff4c8000001c8000001
1080020000001c9cc8000001c80000010e800200c8081c9dc8020001c8000001
000000000000000000000000000000000e800240c9001c9dc8020001c8000001
000000000000000000000000000000001082024001041c9cc9000001c8000001
0e800240ff041c9dc9001001c80000011081014000021c9cc8000001c8000001
00000000000000000000000000000000
"
}

SubProgram "gles " {
Keywords { "POINT_COOKIE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "POINT_COOKIE" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "POINT_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTextureB0] 2D
SetTexture 2 [_LightTexture0] CUBE
"agal_ps
c2 0.0 2.0 0.0 0.0
[bc]
ciaaaaaaacaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r2, v0, s0 <2d wrap linear point>
bcaaaaaaaaaaabacadaaaaoeaeaaaaaaadaaaaoeaeaaaaaa dp3 r0.x, v3, v3
aaaaaaaaaaaaadacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r0.xy, r0.x
adaaaaaaacaaahacacaaaakeacaaaaaaabaaaaoeabaaaaaa mul r2.xyz, r2.xyzz, c1
adaaaaaaacaaahacacaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r2.xyz, r2.xyzz, c0
ciaaaaaaabaaapacaaaaaafeacaaaaaaabaaaaaaafaababb tex r1, r0.xyyy, s1 <2d wrap linear point>
ciaaaaaaaaaaapacadaaaaoeaeaaaaaaacaaaaaaafbababb tex r0, v3, s2 <cube wrap linear point>
adaaaaaaaaaaabacabaaaappacaaaaaaaaaaaappacaaaaaa mul r0.x, r1.w, r0.w
bcaaaaaaabaaabacacaaaaoeaeaaaaaaacaaaaoeaeaaaaaa dp3 r1.x, v2, v2
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
adaaaaaaabaaahacabaaaaaaacaaaaaaacaaaaoeaeaaaaaa mul r1.xyz, r1.x, v2
bcaaaaaaabaaabacabaaaaoeaeaaaaaaabaaaakeacaaaaaa dp3 r1.x, v1, r1.xyzz
ahaaaaaaabaaabacabaaaaaaacaaaaaaacaaaaoeabaaaaaa max r1.x, r1.x, c2
adaaaaaaaaaaabacabaaaaaaacaaaaaaaaaaaaaaacaaaaaa mul r0.x, r1.x, r0.x
adaaaaaaaaaaahacaaaaaaaaacaaaaaaacaaaakeacaaaaaa mul r0.xyz, r0.x, r2.xyzz
adaaaaaaaaaaahacaaaaaakeacaaaaaaacaaaaffabaaaaaa mul r0.xyz, r0.xyzz, c2.y
aaaaaaaaaaaaaiacacaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c2.x
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTexture0] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 11 ALU, 2 TEX
PARAM c[3] = { program.local[0..1],
		{ 0, 2 } };
TEMP R0;
TEMP R1;
TEX R0.xyz, fragment.texcoord[0], texture[0], 2D;
TEX R0.w, fragment.texcoord[3], texture[1], 2D;
MOV R1.xyz, fragment.texcoord[2];
MUL R0.xyz, R0, c[1];
DP3 R1.x, fragment.texcoord[1], R1;
MAX R1.x, R1, c[2];
MUL R0.xyz, R0, c[0];
MUL R0.w, R1.x, R0;
MUL R0.xyz, R0.w, R0;
MUL result.color.xyz, R0, c[2].y;
MOV result.color.w, c[2].x;
END
# 11 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTexture0] 2D
"ps_2_0
; 10 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c2, 0.00000000, 2.00000000, 0, 0
dcl t0.xy
dcl t1.xyz
dcl t2.xyz
dcl t3.xy
texld r0, t3, s1
texld r1, t0, s0
mov_pp r0.xyz, t2
dp3_pp r0.x, t1, r0
mul r1.xyz, r1, c1
max_pp r0.x, r0, c2
mul_pp r0.x, r0, r0.w
mul_pp r1.xyz, r1, c0
mul_pp r0.xyz, r0.x, r1
mul_pp r0.xyz, r0, c2.y
mov_pp r0.w, c2.x
mov_pp oC0, r0
"
}

SubProgram "xbox360 " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 1 [_Color]
Vector 0 [_LightColor0]
SetTexture 0 [_LightTexture0] 2D
SetTexture 1 [_MainTex] 2D
// Shader Timing Estimate, in Cycles/64 pixel vector:
// ALU: 9.33 (7 instructions), vertex: 0, texture: 8,
//   sequencer: 8, interpolator: 16;    5 GPRs, 36 threads,
// Performance (if enough threads): ~16 cycles per vector
// * Texture cycle estimates are assuming an 8bit/component texture with no
//     aniso or trilinear filtering.

"ps_360
backbbaaaaaaabemaaaaaanaaaaaaaaaaaaaaaceaaaaaapeaaaaabbmaaaaaaaa
aaaaaaaaaaaaaammaaaaaabmaaaaaamappppadaaaaaaaaaeaaaaaabmaaaaaaaa
aaaaaaljaaaaaagmaaacaaabaaabaaaaaaaaaaheaaaaaaaaaaaaaaieaaacaaaa
aaabaaaaaaaaaaheaaaaaaaaaaaaaajbaaadaaaaaaabaaaaaaaaaakaaaaaaaaa
aaaaaalaaaadaaabaaabaaaaaaaaaakaaaaaaaaafpedgpgmgphcaaklaaabaaad
aaabaaaeaaabaaaaaaaaaaaafpemgjghgiheedgpgmgphcdaaafpemgjghgihefe
gfhihehfhcgfdaaaaaaeaaamaaabaaabaaabaaaaaaaaaaaafpengbgjgofegfhi
aahahdfpddfpdaaadccodacodcdadddfddcodaaaaaaaaaaaaaaaaaabaaaaaaaa
aaaaaaaaaaaaaabeabpmaabaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaea
aaaaaajabaaaaeaaaaaaaaaeaaaaaaaaaaaaciieaaapaaapaaaaaaabaaaadafa
aaaahbfbaaaahcfcaaaaddfdaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaafcaacaaaabcaameaaaaaaaaaagaaebaakbcaa
ccaaaaaababieaabbpbppoiiaaaaeaaabaaiaagbbpbpppplaaaaeaaamiacaaaa
aaloloaapaabacaaaabcaaaaaalbgmgmkcaappaabeahaaabaamamagmkbaeabaa
amehaaabaamamalbkbabaaaamiaoaaaaaaebigaaobabaaaamiabaaaaaablgmaa
obaaaaaamiahmaaaaamamaaaocaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTexture0] 2D
"sce_fp_rsx // 14 instructions using 2 registers
[Configuration]
24
ffffffff0003c020000ffff9000000000000840002000000
[Offsets]
2
_LightColor0 1 0
00000050
_Color 1 0
00000020
[Microcode]
224
8e001700c8011c9dc8000001c8003fe10e800200c8001c9dc8020001c8000001
00000000000000000000000000000000ce820140c8011c9dc8000001c8003fe1
0e800240c9001c9dc8020001c800000100000000000000000000000000000000
b0800540c8011c9dc9040001c8003fe1f0021702c8011c9dc8000001c8003fe1
10800900c9001c9d00020000c800000100000000000000000000000000000000
10820240c9001c9dc8040001c80000010e800240ff041c9dc9001001c8000001
1081014000021c9cc8000001c800000100000000000000000000000000000000
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightTexture0] 2D
"agal_ps
c2 0.0 2.0 0.0 0.0
[bc]
ciaaaaaaaaaaapacadaaaaoeaeaaaaaaabaaaaaaafaababb tex r0, v3, s1 <2d wrap linear point>
ciaaaaaaabaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r1, v0, s0 <2d wrap linear point>
aaaaaaaaaaaaahacacaaaaoeaeaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, v2
bcaaaaaaaaaaabacabaaaaoeaeaaaaaaaaaaaakeacaaaaaa dp3 r0.x, v1, r0.xyzz
adaaaaaaabaaahacabaaaakeacaaaaaaabaaaaoeabaaaaaa mul r1.xyz, r1.xyzz, c1
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaacaaaaoeabaaaaaa max r0.x, r0.x, c2
adaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaappacaaaaaa mul r0.x, r0.x, r0.w
adaaaaaaabaaahacabaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r1.xyz, r1.xyzz, c0
adaaaaaaaaaaahacaaaaaaaaacaaaaaaabaaaakeacaaaaaa mul r0.xyz, r0.x, r1.xyzz
adaaaaaaaaaaahacaaaaaakeacaaaaaaacaaaaffabaaaaaa mul r0.xyz, r0.xyzz, c2.y
aaaaaaaaaaaaaiacacaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c2.x
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

}
	}
	Pass {
		Name "PREPASS"
		Tags { "LightMode" = "PrePassBase" }
		Fog {Mode Off}
Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 8 to 8
//   d3d9 - ALU: 8 to 8
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Vector 9 [unity_Scale]
Matrix 5 [_Object2World]
"!!ARBvp1.0
# 8 ALU
PARAM c[10] = { program.local[0],
		state.matrix.mvp,
		program.local[5..9] };
TEMP R0;
MUL R0.xyz, vertex.normal, c[9].w;
DP3 result.texcoord[0].z, R0, c[7];
DP3 result.texcoord[0].y, R0, c[6];
DP3 result.texcoord[0].x, R0, c[5];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 8 instructions, 1 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_Scale]
Matrix 4 [_Object2World]
"vs_2_0
; 8 ALU
dcl_position0 v0
dcl_normal0 v1
mul r0.xyz, v1, c8.w
dp3 oT0.z, r0, c6
dp3 oT0.y, r0, c5
dp3 oT0.x, r0, c4
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "xbox360 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 5 [_Object2World] 3
Matrix 0 [glstate_matrix_mvp] 4
Vector 4 [unity_Scale]
// Shader Timing Estimate, in Cycles/64 vertex vector:
// ALU: 10.67 (8 instructions), vertex: 32, texture: 0,
//   sequencer: 10,  3 GPRs, 31 threads,
// Performance (if enough threads): ~32 cycles per vector
// * Vertex cycle estimates are assuming 3 vfetch_minis for every vfetch_full,
//     with <= 32 bytes per vfetch_full group.

"vs_360
backbbabaaaaabbmaaaaaakiaaaaaaaaaaaaaaceaaaaaaaaaaaaaaoeaaaaaaaa
aaaaaaaaaaaaaalmaaaaaabmaaaaaakppppoadaaaaaaaaadaaaaaabmaaaaaaaa
aaaaaakiaaaaaafiaaacaaafaaadaaaaaaaaaagiaaaaaaaaaaaaaahiaaacaaaa
aaaeaaaaaaaaaagiaaaaaaaaaaaaaailaaacaaaeaaabaaaaaaaaaajiaaaaaaaa
fpepgcgkgfgdhedcfhgphcgmgeaaklklaaadaaadaaaeaaaeaaabaaaaaaaaaaaa
ghgmhdhegbhegffpgngbhehcgjhifpgnhghaaahfgogjhehjfpfdgdgbgmgfaakl
aaabaaadaaabaaaeaaabaaaaaaaaaaaahghdfpddfpdaaadccodacodcdadddfdd
codaaaklaaaaaaaaaaaaaakiaaabaaacaaaaaaaaaaaaaaaaaaaaamcbaaaaaaab
aaaaaaacaaaaaaabaaaaacjaaabaaaadaadadaaeaaaahafaaaaabaamdaafcaad
aaaabcaamcaaaaaaaaaaeaafaaaabcaameaaaaaaaaaaeaajaaaaccaaaaaaaaaa
afpicaaaaaaaagiiaaaaaaaaafpiaaaaaaaaaoiiaaaaaaaamiapaaabaabliiaa
kbacadaamiapaaabaamgiiaaklacacabmiapaaabaalbdejeklacababmiapiado
aagmaadeklacaaabmialaaaaaagfblaakbaaaeaamiahaaabaalbleaakbaaahaa
miahaaaaaagmlemaklaaagabmiahiaaaaablmaleklaaafaaaaaaaaaaaaaaaaaa
aaaaaaaa"
}

SubProgram "ps3 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 256 [glstate_matrix_mvp]
Vector 467 [unity_Scale]
Matrix 260 [_Object2World]
"sce_vp_rsx // 8 instructions using 1 registers
[Configuration]
8
0000000800050100
[Microcode]
128
00001c6c009d320c013fc0c36041dffc401f9c6c01d0300d8106c0c360403f80
401f9c6c01d0200d8106c0c360405f80401f9c6c01d0100d8106c0c360409f80
401f9c6c01d0000d8106c0c360411f80401f9c6c0150600c008600c360405f9c
401f9c6c0150500c008600c360409f9c401f9c6c0150400c008600c360411f9d
"
}

SubProgram "gles " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp mat4 _Object2World;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_3;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 res;
  res.xyz = ((xlv_TEXCOORD0 * 0.5) + 0.5);
  res.w = 0.0;
  gl_FragData[0] = res;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp mat4 _Object2World;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * (normalize (_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_3;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 res;
  res.xyz = ((xlv_TEXCOORD0 * 0.5) + 0.5);
  res.w = 0.0;
  gl_FragData[0] = res;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 2 to 2, TEX: 0 to 0
//   d3d9 - ALU: 3 to 3
SubProgram "opengl " {
Keywords { }
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 2 ALU, 0 TEX
PARAM c[1] = { { 0, 0.5 } };
MAD result.color.xyz, fragment.texcoord[0], c[0].y, c[0].y;
MOV result.color.w, c[0].x;
END
# 2 instructions, 0 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
"ps_2_0
; 3 ALU
def c0, 0.50000000, 0.00000000, 0, 0
dcl t0.xyz
mad_pp r0.xyz, t0, c0.x, c0.x
mov_pp r0.w, c0.y
mov_pp oC0, r0
"
}

SubProgram "xbox360 " {
Keywords { }
// Shader Timing Estimate, in Cycles/64 pixel vector:
// ALU: 1.33 (1 instructions), vertex: 0, texture: 0,
//   sequencer: 4, interpolator: 8;    1 GPR, 63 threads,
// Performance (if enough threads): ~8 cycles per vector

"ps_360
backbbaaaaaaaakeaaaaaageaaaaaaaaaaaaaaceaaaaaafiaaaaaaiaaaaaaaaa
aaaaaaaaaaaaaadaaaaaaabmaaaaaacdppppadaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaabmhahdfpddfpdaaadccodacodcdadddfddcodaaaklaaaaaaaaaaaaaaab
aaaaaaaaaaaaaaaaaaaaaabeabpmaabaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaeaaaaaaacebaaaaaaaaaaaaaaeaaaaaaaaaaaaamcbaaabaaabaaaaaaab
aaaahafaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadpaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaabaabmeaaccaaaaaamiahmaaaaamagmgmilaappppaaaaaaaa
aaaaaaaaaaaaaaaa"
}

SubProgram "ps3 " {
Keywords { }
"sce_fp_rsx // 3 instructions using 2 registers
[Configuration]
24
ffffffff000040200001fffe000000000000840002000000
[Microcode]
48
8e800140c8011c9dc8000001c8003fe10e810440c9001c9d0002000000020000
00003f00000000000000000000000000
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { }
"!!GLES"
}

}
	}
	Pass {
		Name "PREPASS"
		Tags { "LightMode" = "PrePassFinal" }
		ZWrite Off
Program "vp" {
// Vertex combos: 6
//   opengl - ALU: 11 to 28
//   d3d9 - ALU: 11 to 28
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 9 [_ProjectionParams]
Vector 10 [unity_Scale]
Matrix 5 [_Object2World]
Vector 11 [unity_SHAr]
Vector 12 [unity_SHAg]
Vector 13 [unity_SHAb]
Vector 14 [unity_SHBr]
Vector 15 [unity_SHBg]
Vector 16 [unity_SHBb]
Vector 17 [unity_SHC]
Vector 18 [_MainTex_ST]
"!!ARBvp1.0
# 28 ALU
PARAM c[19] = { { 0.5, 1 },
		state.matrix.mvp,
		program.local[5..18] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R1.xyz, vertex.normal, c[10].w;
DP3 R2.w, R1, c[6];
DP3 R0.x, R1, c[5];
DP3 R0.z, R1, c[7];
MOV R0.y, R2.w;
MUL R1, R0.xyzz, R0.yzzx;
MOV R0.w, c[0].y;
DP4 R2.z, R0, c[13];
DP4 R2.y, R0, c[12];
DP4 R2.x, R0, c[11];
MUL R0.y, R2.w, R2.w;
DP4 R3.z, R1, c[16];
DP4 R3.y, R1, c[15];
DP4 R3.x, R1, c[14];
DP4 R1.w, vertex.position, c[4];
DP4 R1.z, vertex.position, c[3];
MAD R0.x, R0, R0, -R0.y;
ADD R3.xyz, R2, R3;
MUL R2.xyz, R0.x, c[17];
DP4 R1.x, vertex.position, c[1];
DP4 R1.y, vertex.position, c[2];
MUL R0.xyz, R1.xyww, c[0].x;
MUL R0.y, R0, c[9].x;
ADD result.texcoord[2].xyz, R3, R2;
ADD result.texcoord[1].xy, R0, R0.z;
MOV result.position, R1;
MOV result.texcoord[1].zw, R1;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[18], c[18].zwzw;
END
# 28 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_Scale]
Matrix 4 [_Object2World]
Vector 11 [unity_SHAr]
Vector 12 [unity_SHAg]
Vector 13 [unity_SHAb]
Vector 14 [unity_SHBr]
Vector 15 [unity_SHBg]
Vector 16 [unity_SHBb]
Vector 17 [unity_SHC]
Vector 18 [_MainTex_ST]
"vs_2_0
; 28 ALU
def c19, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c10.w
dp3 r2.w, r1, c5
dp3 r0.x, r1, c4
dp3 r0.z, r1, c6
mov r0.y, r2.w
mul r1, r0.xyzz, r0.yzzx
mov r0.w, c19.y
dp4 r2.z, r0, c13
dp4 r2.y, r0, c12
dp4 r2.x, r0, c11
mul r0.y, r2.w, r2.w
dp4 r3.z, r1, c16
dp4 r3.y, r1, c15
dp4 r3.x, r1, c14
dp4 r1.w, v0, c3
dp4 r1.z, v0, c2
mad r0.x, r0, r0, -r0.y
add r3.xyz, r2, r3
mul r2.xyz, r0.x, c17
dp4 r1.x, v0, c0
dp4 r1.y, v0, c1
mul r0.xyz, r1.xyww, c19.x
mul r0.y, r0, c8.x
add oT2.xyz, r3, r2
mad oT1.xy, r0.z, c9.zwzw, r0
mov oPos, r1
mov oT1.zw, r1
mad oT0.xy, v2, c18, c18.zwzw
"
}

SubProgram "xbox360 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 17 [_MainTex_ST]
Matrix 7 [_Object2World] 3
Vector 4 [_ProjectionParams]
Vector 5 [_ScreenParams]
Matrix 0 [glstate_matrix_mvp] 4
Vector 12 [unity_SHAb]
Vector 11 [unity_SHAg]
Vector 10 [unity_SHAr]
Vector 15 [unity_SHBb]
Vector 14 [unity_SHBg]
Vector 13 [unity_SHBr]
Vector 16 [unity_SHC]
Vector 6 [unity_Scale]
// Shader Timing Estimate, in Cycles/64 vertex vector:
// ALU: 29.33 (22 instructions), vertex: 32, texture: 0,
//   sequencer: 14,  5 GPRs, 31 threads,
// Performance (if enough threads): ~32 cycles per vector
// * Vertex cycle estimates are assuming 3 vfetch_minis for every vfetch_full,
//     with <= 32 bytes per vfetch_full group.

"vs_360
backbbabaaaaacjmaaaaabkiaaaaaaaaaaaaaaceaaaaacceaaaaacemaaaaaaaa
aaaaaaaaaaaaabpmaaaaaabmaaaaaboopppoadaaaaaaaaanaaaaaabmaaaaaaaa
aaaaabohaaaaabcaaaacaabbaaabaaaaaaaaabcmaaaaaaaaaaaaabdmaaacaaah
aaadaaaaaaaaabemaaaaaaaaaaaaabfmaaacaaaeaaabaaaaaaaaabcmaaaaaaaa
aaaaabgoaaacaaafaaabaaaaaaaaabcmaaaaaaaaaaaaabhmaaacaaaaaaaeaaaa
aaaaabemaaaaaaaaaaaaabipaaacaaamaaabaaaaaaaaabcmaaaaaaaaaaaaabjk
aaacaaalaaabaaaaaaaaabcmaaaaaaaaaaaaabkfaaacaaakaaabaaaaaaaaabcm
aaaaaaaaaaaaablaaaacaaapaaabaaaaaaaaabcmaaaaaaaaaaaaabllaaacaaao
aaabaaaaaaaaabcmaaaaaaaaaaaaabmgaaacaaanaaabaaaaaaaaabcmaaaaaaaa
aaaaabnbaaacaabaaaabaaaaaaaaabcmaaaaaaaaaaaaabnlaaacaaagaaabaaaa
aaaaabcmaaaaaaaafpengbgjgofegfhifpfdfeaaaaabaaadaaabaaaeaaabaaaa
aaaaaaaafpepgcgkgfgdhedcfhgphcgmgeaaklklaaadaaadaaaeaaaeaaabaaaa
aaaaaaaafpfahcgpgkgfgdhegjgpgofagbhcgbgnhdaafpfdgdhcgfgfgofagbhc
gbgnhdaaghgmhdhegbhegffpgngbhehcgjhifpgnhghaaahfgogjhehjfpfdeieb
gcaahfgogjhehjfpfdeiebghaahfgogjhehjfpfdeiebhcaahfgogjhehjfpfdei
ecgcaahfgogjhehjfpfdeiecghaahfgogjhehjfpfdeiechcaahfgogjhehjfpfd
eiedaahfgogjhehjfpfdgdgbgmgfaahghdfpddfpdaaadccodacodcdadddfddco
daaaklklaaaaaaaaaaaaaaabaaaaaaaaaaaaaaaaaaaaaabeaapmaabaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaeaaaaaabgiaacbaaaeaaaaaaaaaaaaaaaa
aaaacegdaaaaaaabaaaaaaadaaaaaaaeaaaaacjaaabaaaaeaaaadaafaadafaag
aaaadafaaaabpbfbaaadhcfcaaaababcaaaaaabbaaaababkaaaababmaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaadpaaaaaaaaaaaaaaaaaaaaaaaaaaaaaahabfdaae
aaaabcaamcaaaaaaaaaafaahaaaabcaameaaaaaaaaaagaamgabcbcaabcaaaaaa
aaaafabiaaaaccaaaaaaaaaaafpidaaaaaaaagiiaaaaaaaaafpicaaaaaaaaoii
aaaaaaaaafpiaaaaaaaaapmiaaaaaaaamiapaaabaabliiaakbadadaamiapaaab
aamgnapikladacabmiapaaabaalbdepikladababmiapaaabaagmiipikladaaab
miapiadoaaiiiiaaocababaamialaaacaagfblaakbacagaaceihaeadaalblegm
kbacajiamiahaaacaagmlemaklacaiadmiahaaaeaabllemaklacahacaibhabad
aaligmggkbabppaemiamiaabaaigigaaocababaamiadiaaaaalalabkilaabbbb
aicbabacaadoanmbgpakaeaeaiecabacaadoanlbgpalaeaeaiieabacaadoanlm
gpamaeaemiabaaaaaakhkhaakpabanaamiacaaaaaakhkhaakpabaoaaaibeabaa
aakhkhgmkpabapaeaiciabadaalbgmmgkbadaeaemiadiaabaamgbkbikladafad
geihaaaaaalologboaacaaabmiahiaacaablmagfklaabaaaaaaaaaaaaaaaaaaa
aaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 256 [glstate_matrix_mvp]
Vector 467 [_ProjectionParams]
Vector 466 [unity_Scale]
Matrix 260 [_Object2World]
Vector 465 [unity_SHAr]
Vector 464 [unity_SHAg]
Vector 463 [unity_SHAb]
Vector 462 [unity_SHBr]
Vector 461 [unity_SHBg]
Vector 460 [unity_SHBb]
Vector 459 [unity_SHC]
Vector 458 [_MainTex_ST]
"sce_vp_rsx // 27 instructions using 3 registers
[Configuration]
8
0000001b01050300
[Defaults]
1
457 1
3f000000
[Microcode]
432
00009c6c009d220c013fc0c36041dffc401f9c6c011ca808010400d740619f9c
00001c6c01d0300d8106c0c360403ffc00001c6c01d0200d8106c0c360405ffc
00001c6c01d0100d8106c0c360409ffc00001c6c01d0000d8106c0c360411ffc
00011c6c0150400c028600c360411ffc00011c6c0150600c028600c360405ffc
00009c6c0150500c028600c360411ffc401f9c6c0040000d8086c0836041ff80
401f9c6c004000558086c08360407fa000001c6c009c900e008000c36041dffc
00001c6c009d302a808000c360409ffc00001c6c008000000280014360403ffc
00011c6c004000000286c08360409ffc401f9c6c00c000080086c09540219fa0
00001c6c019cf00c0486c0c360405ffc00001c6c019d000c0486c0c360409ffc
00001c6c019d100c0486c0c360411ffc00001c6c010000000480027fe0203ffc
00009c6c0080000d049a02436041fffc00011c6c01dcc00d8286c0c360405ffc
00011c6c01dcd00d8286c0c360409ffc00011c6c01dce00d8286c0c360411ffc
00001c6c00c0000c0086c0830121dffc00009c6c009cb07f808600c36041dffc
401f9c6c00c0000c0286c0830021dfa5
"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_i0;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * 0.5);
  o_i0 = tmpvar_3;
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_4 + tmpvar_3.w);
  o_i0.zw = tmpvar_2.zw;
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = (tmpvar_5 * (normalize (_glesNormal) * unity_Scale.w));
  mediump vec3 tmpvar_7;
  mediump vec4 normal;
  normal = tmpvar_6;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_8;
  tmpvar_8 = dot (unity_SHAr, normal);
  x1.x = tmpvar_8;
  highp float tmpvar_9;
  tmpvar_9 = dot (unity_SHAg, normal);
  x1.y = tmpvar_9;
  highp float tmpvar_10;
  tmpvar_10 = dot (unity_SHAb, normal);
  x1.z = tmpvar_10;
  mediump vec4 tmpvar_11;
  tmpvar_11 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHBr, tmpvar_11);
  x2.x = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHBg, tmpvar_11);
  x2.y = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHBb, tmpvar_11);
  x2.z = tmpvar_14;
  mediump float tmpvar_15;
  tmpvar_15 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (unity_SHC.xyz * vC);
  x3 = tmpvar_16;
  tmpvar_7 = ((x1 + x2) + x3);
  tmpvar_1 = tmpvar_7;
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = o_i0;
  xlv_TEXCOORD2 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform sampler2D _LightBuffer;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c;
  mediump vec4 light;
  lowp vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light = tmpvar_3;
  mediump vec4 tmpvar_4;
  tmpvar_4 = -(log2 (max (light, vec4(0.001, 0.001, 0.001, 0.001))));
  light = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4.xyz + xlv_TEXCOORD2);
  light.xyz = tmpvar_5;
  lowp vec4 c_i0_i1;
  mediump vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_2.xyz * light.xyz);
  c_i0_i1.xyz = tmpvar_6;
  c_i0_i1.w = tmpvar_2.w;
  c = c_i0_i1;
  tmpvar_1 = c;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_i0;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * 0.5);
  o_i0 = tmpvar_3;
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_4 + tmpvar_3.w);
  o_i0.zw = tmpvar_2.zw;
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = (tmpvar_5 * (normalize (_glesNormal) * unity_Scale.w));
  mediump vec3 tmpvar_7;
  mediump vec4 normal;
  normal = tmpvar_6;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_8;
  tmpvar_8 = dot (unity_SHAr, normal);
  x1.x = tmpvar_8;
  highp float tmpvar_9;
  tmpvar_9 = dot (unity_SHAg, normal);
  x1.y = tmpvar_9;
  highp float tmpvar_10;
  tmpvar_10 = dot (unity_SHAb, normal);
  x1.z = tmpvar_10;
  mediump vec4 tmpvar_11;
  tmpvar_11 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHBr, tmpvar_11);
  x2.x = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHBg, tmpvar_11);
  x2.y = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHBb, tmpvar_11);
  x2.z = tmpvar_14;
  mediump float tmpvar_15;
  tmpvar_15 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (unity_SHC.xyz * vC);
  x3 = tmpvar_16;
  tmpvar_7 = ((x1 + x2) + x3);
  tmpvar_1 = tmpvar_7;
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = o_i0;
  xlv_TEXCOORD2 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform sampler2D _LightBuffer;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c;
  mediump vec4 light;
  lowp vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light = tmpvar_3;
  mediump vec4 tmpvar_4;
  tmpvar_4 = -(log2 (max (light, vec4(0.001, 0.001, 0.001, 0.001))));
  light = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4.xyz + xlv_TEXCOORD2);
  light.xyz = tmpvar_5;
  lowp vec4 c_i0_i1;
  mediump vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_2.xyz * light.xyz);
  c_i0_i1.xyz = tmpvar_6;
  c_i0_i1.w = tmpvar_2.w;
  c = c_i0_i1;
  tmpvar_1 = c;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 13 [_ProjectionParams]
Matrix 9 [_Object2World]
Vector 14 [unity_LightmapST]
Vector 15 [unity_ShadowFadeCenterAndType]
Vector 16 [_MainTex_ST]
"!!ARBvp1.0
# 20 ALU
PARAM c[17] = { { 0.5, 1 },
		state.matrix.modelview[0],
		state.matrix.mvp,
		program.local[9..16] };
TEMP R0;
TEMP R1;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MUL R1.xyz, R0.xyww, c[0].x;
MUL R1.y, R1, c[13].x;
ADD result.texcoord[1].xy, R1, R1.z;
MOV result.position, R0;
MOV R0.x, c[0].y;
ADD R0.y, R0.x, -c[15].w;
DP4 R0.x, vertex.position, c[3];
DP4 R1.z, vertex.position, c[11];
DP4 R1.x, vertex.position, c[9];
DP4 R1.y, vertex.position, c[10];
ADD R1.xyz, R1, -c[15];
MOV result.texcoord[1].zw, R0;
MUL result.texcoord[3].xyz, R1, c[15].w;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[16], c[16].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[1], c[14], c[14].zwzw;
MUL result.texcoord[3].w, -R0.x, R0.y;
END
# 20 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_modelview0]
Matrix 4 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Matrix 8 [_Object2World]
Vector 14 [unity_LightmapST]
Vector 15 [unity_ShadowFadeCenterAndType]
Vector 16 [_MainTex_ST]
"vs_2_0
; 20 ALU
def c17, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
dcl_texcoord1 v2
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mul r1.xyz, r0.xyww, c17.x
mul r1.y, r1, c12.x
mad oT1.xy, r1.z, c13.zwzw, r1
mov oPos, r0
mov r0.x, c15.w
add r0.y, c17, -r0.x
dp4 r0.x, v0, c2
dp4 r1.z, v0, c10
dp4 r1.x, v0, c8
dp4 r1.y, v0, c9
add r1.xyz, r1, -c15
mov oT1.zw, r0
mul oT3.xyz, r1, c15.w
mad oT0.xy, v1, c16, c16.zwzw
mad oT2.xy, v2, c14, c14.zwzw
mul oT3.w, -r0.x, r0.y
"
}

SubProgram "xbox360 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 16 [_MainTex_ST]
Matrix 10 [_Object2World] 4
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Matrix 4 [glstate_matrix_modelview0] 4
Matrix 0 [glstate_matrix_mvp] 4
Vector 14 [unity_LightmapST]
Vector 15 [unity_ShadowFadeCenterAndType]
// Shader Timing Estimate, in Cycles/64 vertex vector:
// ALU: 28.00 (21 instructions), vertex: 32, texture: 0,
//   sequencer: 14,  7 GPRs, 27 threads,
// Performance (if enough threads): ~32 cycles per vector
// * Vertex cycle estimates are assuming 3 vfetch_minis for every vfetch_full,
//     with <= 32 bytes per vfetch_full group.

"vs_360
backbbabaaaaacdeaaaaabjmaaaaaaaaaaaaaaceaaaaablaaaaaabniaaaaaaaa
aaaaaaaaaaaaabiiaaaaaabmaaaaabhlpppoadaaaaaaaaaiaaaaaabmaaaaaaaa
aaaaabheaaaaaalmaaacaabaaaabaaaaaaaaaamiaaaaaaaaaaaaaaniaaacaaak
aaaeaaaaaaaaaaoiaaaaaaaaaaaaaapiaaacaaaiaaabaaaaaaaaaamiaaaaaaaa
aaaaabakaaacaaajaaabaaaaaaaaaamiaaaaaaaaaaaaabbiaaacaaaeaaaeaaaa
aaaaaaoiaaaaaaaaaaaaabdcaaacaaaaaaaeaaaaaaaaaaoiaaaaaaaaaaaaabef
aaacaaaoaaabaaaaaaaaaamiaaaaaaaaaaaaabfgaaacaaapaaabaaaaaaaaaami
aaaaaaaafpengbgjgofegfhifpfdfeaaaaabaaadaaabaaaeaaabaaaaaaaaaaaa
fpepgcgkgfgdhedcfhgphcgmgeaaklklaaadaaadaaaeaaaeaaabaaaaaaaaaaaa
fpfahcgpgkgfgdhegjgpgofagbhcgbgnhdaafpfdgdhcgfgfgofagbhcgbgnhdaa
ghgmhdhegbhegffpgngbhehcgjhifpgngpgegfgmhggjgfhhdaaaghgmhdhegbhe
gffpgngbhehcgjhifpgnhghaaahfgogjhehjfpemgjghgihegngbhafdfeaahfgo
gjhehjfpfdgigbgegphheggbgegfedgfgohegfhcebgogefehjhagfaahghdfpdd
fpdaaadccodacodcdadddfddcodaaaklaaaaaaaaaaaaaaabaaaaaaaaaaaaaaaa
aaaaaabeaapmaabaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaeaaaaaabfm
aadbaaagaaaaaaaaaaaaaaaaaaaadaieaaaaaaabaaaaaaadaaaaaaagaaaaacja
aabaaaaeaaaafaafaacbfaagaaaadafaaaabpbfbaaaddcfcaaaepdfdaaaababe
aaaaaabdaaaabablaaaababfaaaaaabiaaaababkaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaadpiaaaaadpaaaaaaaaaaaaaaaaaaaaaahabfdaaeaaaabcaamcaaaaaa
aaaafaahaaaabcaameaaaaaaaaaagaamgabcbcaabcaaaaaaaaaaeabiaaaaccaa
aaaaaaaaafpicaaaaaaaagiiaaaaaaaaafpieaaaaaaaapmiaaaaaaaaafpibaaa
aaaaaoehaaaaaaaamiapaaaaaabliiaakbacadaamiapaaaaaamgnapiklacacaa
miapaaaaaalbdepiklacabaamiapaaafaagmnajeklacaaaamiapiadoaananaaa
ocafafaakiibagabaeblgmmacaapppaemiahaaadaablleaakbacanaabeboaaaa
aamgimlbkbacamacmiaoaaaaaalbimabklacalaamiahaaagaagmlebfklacakaa
kiioadaaaapmlbmaibafppafmiapaaadaadedeaaoaagadaamiamiaabaanlnlaa
ocafafaamiadiaaaaalalabkilaebabamiadiaacaamflabkilabaoaomiacaaab
aamgmgblklacagadkibhaaadacmamaeciaadapaimiahiaadaamablaakbadapaa
miacaaabaablmglbklacahabmiaiiaadaelbgmaaobababaamiadiaabaablbkgn
klaaajaaaaaaaaaaaaaaaaaaaaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 256 [glstate_matrix_mvp]
Matrix 260 [glstate_matrix_modelview0]
Vector 467 [_ProjectionParams]
Matrix 264 [_Object2World]
Vector 466 [unity_LightmapST]
Vector 465 [unity_ShadowFadeCenterAndType]
Vector 464 [_MainTex_ST]
"sce_vp_rsx // 21 instructions using 3 registers
[Configuration]
8
0000001503010300
[Defaults]
1
463 2
3f0000003f800000
[Microcode]
336
401f9c6c011d0808010400d740619f9c401f9c6c011d2908010400d740619fa4
00001c6c01d0600d8106c0c360403ffc00009c6c01d0300d8106c0c360403ffc
00009c6c01d0200d8106c0c360405ffc00009c6c01d0100d8106c0c360409ffc
00009c6c01d0000d8106c0c360411ffc00011c6c005d107f8186c08360411ffc
00001c6c01d0a00d8106c0c360405ffc00001c6c01d0900d8106c0c360409ffc
00001c6c01d0800d8106c0c360411ffc00001c6c00dd108c0186c0830021dffc
00011c6c00dcf02a8186c0a001211ffc401f9c6c0040000d8286c0836041ff80
401f9c6c004000558286c08360407fa000009c6c009cf00e028000c36041dffc
401f9c6c009d100c00bfc0c36041dfa8401f9c6c008000ff8080024360403fa8
00001c6c004000000286c08360411ffc00001c6c009d302a828000c360409ffc
401f9c6c00c000080086c09540a19fa1
"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 unity_LightmapST;


uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_i0;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * 0.5);
  o_i0 = tmpvar_3;
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_4 + tmpvar_3.w);
  o_i0.zw = tmpvar_2.zw;
  tmpvar_1.xyz = (((_Object2World * _glesVertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w);
  tmpvar_1.w = (-((gl_ModelViewMatrix * _glesVertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w));
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = o_i0;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD3 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_LightmapInd;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D unity_Lightmap;
uniform sampler2D _MainTex;
uniform sampler2D _LightBuffer;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c;
  mediump vec3 lmIndirect;
  mediump vec3 lmFull;
  mediump vec4 light;
  lowp vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light = tmpvar_3;
  mediump vec4 tmpvar_4;
  tmpvar_4 = -(log2 (max (light, vec4(0.001, 0.001, 0.001, 0.001))));
  light = tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD2).xyz);
  lmFull = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = (2.0 * texture2D (unity_LightmapInd, xlv_TEXCOORD2).xyz);
  lmIndirect = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = vec3(clamp (((length (xlv_TEXCOORD3) * unity_LightmapFade.z) + unity_LightmapFade.w), 0.0, 1.0));
  light.xyz = (tmpvar_4.xyz + mix (lmIndirect, lmFull, tmpvar_7));
  lowp vec4 c_i0_i1;
  mediump vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_2.xyz * light.xyz);
  c_i0_i1.xyz = tmpvar_8;
  c_i0_i1.w = tmpvar_2.w;
  c = c_i0_i1;
  tmpvar_1 = c;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 unity_LightmapST;


uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_i0;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * 0.5);
  o_i0 = tmpvar_3;
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_4 + tmpvar_3.w);
  o_i0.zw = tmpvar_2.zw;
  tmpvar_1.xyz = (((_Object2World * _glesVertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w);
  tmpvar_1.w = (-((gl_ModelViewMatrix * _glesVertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w));
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = o_i0;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD3 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_LightmapInd;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D unity_Lightmap;
uniform sampler2D _MainTex;
uniform sampler2D _LightBuffer;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c;
  mediump vec3 lmIndirect;
  mediump vec3 lmFull;
  mediump vec4 light;
  lowp vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light = tmpvar_3;
  mediump vec4 tmpvar_4;
  tmpvar_4 = -(log2 (max (light, vec4(0.001, 0.001, 0.001, 0.001))));
  light = tmpvar_4;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (unity_Lightmap, xlv_TEXCOORD2);
  lowp vec3 tmpvar_6;
  tmpvar_6 = ((8.0 * tmpvar_5.w) * tmpvar_5.xyz);
  lmFull = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (unity_LightmapInd, xlv_TEXCOORD2);
  lowp vec3 tmpvar_8;
  tmpvar_8 = ((8.0 * tmpvar_7.w) * tmpvar_7.xyz);
  lmIndirect = tmpvar_8;
  highp vec3 tmpvar_9;
  tmpvar_9 = vec3(clamp (((length (xlv_TEXCOORD3) * unity_LightmapFade.z) + unity_LightmapFade.w), 0.0, 1.0));
  light.xyz = (tmpvar_4.xyz + mix (lmIndirect, lmFull, tmpvar_9));
  lowp vec4 c_i0_i1;
  mediump vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_2.xyz * light.xyz);
  c_i0_i1.xyz = tmpvar_10;
  c_i0_i1.w = tmpvar_2.w;
  c = c_i0_i1;
  tmpvar_1 = c;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 5 [_ProjectionParams]
Vector 6 [unity_LightmapST]
Vector 7 [_MainTex_ST]
"!!ARBvp1.0
# 11 ALU
PARAM c[8] = { { 0.5 },
		state.matrix.mvp,
		program.local[5..7] };
TEMP R0;
TEMP R1;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].x;
MUL R1.y, R1, c[5].x;
ADD result.texcoord[1].xy, R1, R1.z;
MOV result.position, R0;
MOV result.texcoord[1].zw, R0;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[7], c[7].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[1], c[6], c[6].zwzw;
END
# 11 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 4 [_ProjectionParams]
Vector 5 [_ScreenParams]
Vector 6 [unity_LightmapST]
Vector 7 [_MainTex_ST]
"vs_2_0
; 11 ALU
def c8, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
dcl_texcoord1 v2
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c8.x
mul r1.y, r1, c4.x
mad oT1.xy, r1.z, c5.zwzw, r1
mov oPos, r0
mov oT1.zw, r0
mad oT0.xy, v1, c7, c7.zwzw
mad oT2.xy, v2, c6, c6.zwzw
"
}

SubProgram "xbox360 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 7 [_MainTex_ST]
Vector 4 [_ProjectionParams]
Vector 5 [_ScreenParams]
Matrix 0 [glstate_matrix_mvp] 4
Vector 6 [unity_LightmapST]
// Shader Timing Estimate, in Cycles/64 vertex vector:
// ALU: 14.67 (11 instructions), vertex: 32, texture: 0,
//   sequencer: 10,  3 GPRs, 31 threads,
// Performance (if enough threads): ~32 cycles per vector
// * Vertex cycle estimates are assuming 3 vfetch_minis for every vfetch_full,
//     with <= 32 bytes per vfetch_full group.

"vs_360
backbbabaaaaabkeaaaaabbiaaaaaaaaaaaaaaceaaaaabcmaaaaabfeaaaaaaaa
aaaaaaaaaaaaabaeaaaaaabmaaaaaapipppoadaaaaaaaaafaaaaaabmaaaaaaaa
aaaaaapbaaaaaaiaaaacaaahaaabaaaaaaaaaaimaaaaaaaaaaaaaajmaaacaaae
aaabaaaaaaaaaaimaaaaaaaaaaaaaakoaaacaaafaaabaaaaaaaaaaimaaaaaaaa
aaaaaalmaaacaaaaaaaeaaaaaaaaaanaaaaaaaaaaaaaaaoaaaacaaagaaabaaaa
aaaaaaimaaaaaaaafpengbgjgofegfhifpfdfeaaaaabaaadaaabaaaeaaabaaaa
aaaaaaaafpfahcgpgkgfgdhegjgpgofagbhcgbgnhdaafpfdgdhcgfgfgofagbhc
gbgnhdaaghgmhdhegbhegffpgngbhehcgjhifpgnhghaaaklaaadaaadaaaeaaae
aaabaaaaaaaaaaaahfgogjhehjfpemgjghgihegngbhafdfeaahghdfpddfpdaaa
dccodacodcdadddfddcodaaaaaaaaaaaaaaaaaabaaaaaaaaaaaaaaaaaaaaaabe
aapmaabaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaeaaaaaaaniaacbaaac
aaaaaaaaaaaaaaaaaaaacagdaaaaaaabaaaaaaadaaaaaaaeaaaaacjaaabaaaad
aaaafaaeaacbfaafaaaadafaaaabpbfbaaaddcfcaaaabaanaaaaaaamaaaababa
aaaabaaoaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadpaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaahabfdaadaaaabcaamcaaaaaaaaaafaagaaaabcaameaaaaaaaaaagaal
aaaaccaaaaaaaaaaafpicaaaaaaaagiiaaaaaaaaafpibaaaaaaaacdpaaaaaaaa
afpibaaaaaaaapmiaaaaaaaamiapaaaaaabliiaakbacadaamiapaaaaaamgnapi
klacacaamiapaaaaaalbdepiklacabaamiapaaacaagmnajeklacaaaamiapiado
aananaaaocacacaamiahaaaaaamagmaakbacppaamiamiaabaanlnlaaocacacaa
miadiaaaaabklabkilabahahmiadiaacaalalabkilabagagkiiaaaaaaaaaaaeb
mcaaaaaemiadiaabaamgbkbiklaaafaaaaaaaaaaaaaaaaaaaaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 256 [glstate_matrix_mvp]
Vector 467 [_ProjectionParams]
Vector 466 [unity_LightmapST]
Vector 465 [_MainTex_ST]
"sce_vp_rsx // 11 instructions using 1 registers
[Configuration]
8
0000000b03010100
[Defaults]
1
464 1
3f000000
[Microcode]
176
401f9c6c011d1808010400d740619f9c00001c6c01d0300d8106c0c360403ffc
00001c6c01d0200d8106c0c360405ffc00001c6c01d0100d8106c0c360409ffc
00001c6c01d0000d8106c0c360411ffc401f9c6c011d2908010400d740619fa4
401f9c6c0040000d8086c0836041ff80401f9c6c004000558086c08360407fa0
00001c6c009d000e008000c36041dffc00001c6c009d302a808000c360409ffc
401f9c6c00c000080086c09540219fa1
"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;

uniform highp vec4 _ProjectionParams;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_i0;
  highp vec4 tmpvar_2;
  tmpvar_2 = (tmpvar_1 * 0.5);
  o_i0 = tmpvar_2;
  highp vec2 tmpvar_3;
  tmpvar_3.x = tmpvar_2.x;
  tmpvar_3.y = (tmpvar_2.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_3 + tmpvar_2.w);
  o_i0.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = o_i0;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _MainTex;
uniform sampler2D _LightBuffer;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c;
  mediump vec4 light;
  lowp vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light = tmpvar_3;
  mediump vec3 lm_i0;
  lowp vec3 tmpvar_4;
  tmpvar_4 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD2).xyz);
  lm_i0 = tmpvar_4;
  mediump vec4 tmpvar_5;
  tmpvar_5.w = 0.0;
  tmpvar_5.xyz = lm_i0;
  mediump vec4 tmpvar_6;
  tmpvar_6 = (-(log2 (max (light, vec4(0.001, 0.001, 0.001, 0.001)))) + tmpvar_5);
  light = tmpvar_6;
  lowp vec4 c_i0_i1;
  mediump vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_2.xyz * tmpvar_6.xyz);
  c_i0_i1.xyz = tmpvar_7;
  c_i0_i1.w = tmpvar_2.w;
  c = c_i0_i1;
  tmpvar_1 = c;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;

uniform highp vec4 _ProjectionParams;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_i0;
  highp vec4 tmpvar_2;
  tmpvar_2 = (tmpvar_1 * 0.5);
  o_i0 = tmpvar_2;
  highp vec2 tmpvar_3;
  tmpvar_3.x = tmpvar_2.x;
  tmpvar_3.y = (tmpvar_2.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_3 + tmpvar_2.w);
  o_i0.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = o_i0;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _MainTex;
uniform sampler2D _LightBuffer;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c;
  mediump vec4 light;
  lowp vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light = tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (unity_Lightmap, xlv_TEXCOORD2);
  mediump vec3 lm_i0;
  lowp vec3 tmpvar_5;
  tmpvar_5 = ((8.0 * tmpvar_4.w) * tmpvar_4.xyz);
  lm_i0 = tmpvar_5;
  mediump vec4 tmpvar_6;
  tmpvar_6.w = 0.0;
  tmpvar_6.xyz = lm_i0;
  mediump vec4 tmpvar_7;
  tmpvar_7 = (-(log2 (max (light, vec4(0.001, 0.001, 0.001, 0.001)))) + tmpvar_6);
  light = tmpvar_7;
  lowp vec4 c_i0_i1;
  mediump vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_2.xyz * tmpvar_7.xyz);
  c_i0_i1.xyz = tmpvar_8;
  c_i0_i1.w = tmpvar_2.w;
  c = c_i0_i1;
  tmpvar_1 = c;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 9 [_ProjectionParams]
Vector 10 [unity_Scale]
Matrix 5 [_Object2World]
Vector 11 [unity_SHAr]
Vector 12 [unity_SHAg]
Vector 13 [unity_SHAb]
Vector 14 [unity_SHBr]
Vector 15 [unity_SHBg]
Vector 16 [unity_SHBb]
Vector 17 [unity_SHC]
Vector 18 [_MainTex_ST]
"!!ARBvp1.0
# 28 ALU
PARAM c[19] = { { 0.5, 1 },
		state.matrix.mvp,
		program.local[5..18] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R1.xyz, vertex.normal, c[10].w;
DP3 R2.w, R1, c[6];
DP3 R0.x, R1, c[5];
DP3 R0.z, R1, c[7];
MOV R0.y, R2.w;
MUL R1, R0.xyzz, R0.yzzx;
MOV R0.w, c[0].y;
DP4 R2.z, R0, c[13];
DP4 R2.y, R0, c[12];
DP4 R2.x, R0, c[11];
MUL R0.y, R2.w, R2.w;
DP4 R3.z, R1, c[16];
DP4 R3.y, R1, c[15];
DP4 R3.x, R1, c[14];
DP4 R1.w, vertex.position, c[4];
DP4 R1.z, vertex.position, c[3];
MAD R0.x, R0, R0, -R0.y;
ADD R3.xyz, R2, R3;
MUL R2.xyz, R0.x, c[17];
DP4 R1.x, vertex.position, c[1];
DP4 R1.y, vertex.position, c[2];
MUL R0.xyz, R1.xyww, c[0].x;
MUL R0.y, R0, c[9].x;
ADD result.texcoord[2].xyz, R3, R2;
ADD result.texcoord[1].xy, R0, R0.z;
MOV result.position, R1;
MOV result.texcoord[1].zw, R1;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[18], c[18].zwzw;
END
# 28 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_Scale]
Matrix 4 [_Object2World]
Vector 11 [unity_SHAr]
Vector 12 [unity_SHAg]
Vector 13 [unity_SHAb]
Vector 14 [unity_SHBr]
Vector 15 [unity_SHBg]
Vector 16 [unity_SHBb]
Vector 17 [unity_SHC]
Vector 18 [_MainTex_ST]
"vs_2_0
; 28 ALU
def c19, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c10.w
dp3 r2.w, r1, c5
dp3 r0.x, r1, c4
dp3 r0.z, r1, c6
mov r0.y, r2.w
mul r1, r0.xyzz, r0.yzzx
mov r0.w, c19.y
dp4 r2.z, r0, c13
dp4 r2.y, r0, c12
dp4 r2.x, r0, c11
mul r0.y, r2.w, r2.w
dp4 r3.z, r1, c16
dp4 r3.y, r1, c15
dp4 r3.x, r1, c14
dp4 r1.w, v0, c3
dp4 r1.z, v0, c2
mad r0.x, r0, r0, -r0.y
add r3.xyz, r2, r3
mul r2.xyz, r0.x, c17
dp4 r1.x, v0, c0
dp4 r1.y, v0, c1
mul r0.xyz, r1.xyww, c19.x
mul r0.y, r0, c8.x
add oT2.xyz, r3, r2
mad oT1.xy, r0.z, c9.zwzw, r0
mov oPos, r1
mov oT1.zw, r1
mad oT0.xy, v2, c18, c18.zwzw
"
}

SubProgram "xbox360 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 17 [_MainTex_ST]
Matrix 7 [_Object2World] 3
Vector 4 [_ProjectionParams]
Vector 5 [_ScreenParams]
Matrix 0 [glstate_matrix_mvp] 4
Vector 12 [unity_SHAb]
Vector 11 [unity_SHAg]
Vector 10 [unity_SHAr]
Vector 15 [unity_SHBb]
Vector 14 [unity_SHBg]
Vector 13 [unity_SHBr]
Vector 16 [unity_SHC]
Vector 6 [unity_Scale]
// Shader Timing Estimate, in Cycles/64 vertex vector:
// ALU: 29.33 (22 instructions), vertex: 32, texture: 0,
//   sequencer: 14,  5 GPRs, 31 threads,
// Performance (if enough threads): ~32 cycles per vector
// * Vertex cycle estimates are assuming 3 vfetch_minis for every vfetch_full,
//     with <= 32 bytes per vfetch_full group.

"vs_360
backbbabaaaaacjmaaaaabkiaaaaaaaaaaaaaaceaaaaacceaaaaacemaaaaaaaa
aaaaaaaaaaaaabpmaaaaaabmaaaaaboopppoadaaaaaaaaanaaaaaabmaaaaaaaa
aaaaabohaaaaabcaaaacaabbaaabaaaaaaaaabcmaaaaaaaaaaaaabdmaaacaaah
aaadaaaaaaaaabemaaaaaaaaaaaaabfmaaacaaaeaaabaaaaaaaaabcmaaaaaaaa
aaaaabgoaaacaaafaaabaaaaaaaaabcmaaaaaaaaaaaaabhmaaacaaaaaaaeaaaa
aaaaabemaaaaaaaaaaaaabipaaacaaamaaabaaaaaaaaabcmaaaaaaaaaaaaabjk
aaacaaalaaabaaaaaaaaabcmaaaaaaaaaaaaabkfaaacaaakaaabaaaaaaaaabcm
aaaaaaaaaaaaablaaaacaaapaaabaaaaaaaaabcmaaaaaaaaaaaaabllaaacaaao
aaabaaaaaaaaabcmaaaaaaaaaaaaabmgaaacaaanaaabaaaaaaaaabcmaaaaaaaa
aaaaabnbaaacaabaaaabaaaaaaaaabcmaaaaaaaaaaaaabnlaaacaaagaaabaaaa
aaaaabcmaaaaaaaafpengbgjgofegfhifpfdfeaaaaabaaadaaabaaaeaaabaaaa
aaaaaaaafpepgcgkgfgdhedcfhgphcgmgeaaklklaaadaaadaaaeaaaeaaabaaaa
aaaaaaaafpfahcgpgkgfgdhegjgpgofagbhcgbgnhdaafpfdgdhcgfgfgofagbhc
gbgnhdaaghgmhdhegbhegffpgngbhehcgjhifpgnhghaaahfgogjhehjfpfdeieb
gcaahfgogjhehjfpfdeiebghaahfgogjhehjfpfdeiebhcaahfgogjhehjfpfdei
ecgcaahfgogjhehjfpfdeiecghaahfgogjhehjfpfdeiechcaahfgogjhehjfpfd
eiedaahfgogjhehjfpfdgdgbgmgfaahghdfpddfpdaaadccodacodcdadddfddco
daaaklklaaaaaaaaaaaaaaabaaaaaaaaaaaaaaaaaaaaaabeaapmaabaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaeaaaaaabgiaacbaaaeaaaaaaaaaaaaaaaa
aaaacegdaaaaaaabaaaaaaadaaaaaaaeaaaaacjaaabaaaaeaaaadaafaadafaag
aaaadafaaaabpbfbaaadhcfcaaaababcaaaaaabbaaaababkaaaababmaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaadpaaaaaaaaaaaaaaaaaaaaaaaaaaaaaahabfdaae
aaaabcaamcaaaaaaaaaafaahaaaabcaameaaaaaaaaaagaamgabcbcaabcaaaaaa
aaaafabiaaaaccaaaaaaaaaaafpidaaaaaaaagiiaaaaaaaaafpicaaaaaaaaoii
aaaaaaaaafpiaaaaaaaaapmiaaaaaaaamiapaaabaabliiaakbadadaamiapaaab
aamgnapikladacabmiapaaabaalbdepikladababmiapaaabaagmiipikladaaab
miapiadoaaiiiiaaocababaamialaaacaagfblaakbacagaaceihaeadaalblegm
kbacajiamiahaaacaagmlemaklacaiadmiahaaaeaabllemaklacahacaibhabad
aaligmggkbabppaemiamiaabaaigigaaocababaamiadiaaaaalalabkilaabbbb
aicbabacaadoanmbgpakaeaeaiecabacaadoanlbgpalaeaeaiieabacaadoanlm
gpamaeaemiabaaaaaakhkhaakpabanaamiacaaaaaakhkhaakpabaoaaaibeabaa
aakhkhgmkpabapaeaiciabadaalbgmmgkbadaeaemiadiaabaamgbkbikladafad
geihaaaaaalologboaacaaabmiahiaacaablmagfklaabaaaaaaaaaaaaaaaaaaa
aaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 256 [glstate_matrix_mvp]
Vector 467 [_ProjectionParams]
Vector 466 [unity_Scale]
Matrix 260 [_Object2World]
Vector 465 [unity_SHAr]
Vector 464 [unity_SHAg]
Vector 463 [unity_SHAb]
Vector 462 [unity_SHBr]
Vector 461 [unity_SHBg]
Vector 460 [unity_SHBb]
Vector 459 [unity_SHC]
Vector 458 [_MainTex_ST]
"sce_vp_rsx // 27 instructions using 3 registers
[Configuration]
8
0000001b01050300
[Defaults]
1
457 1
3f000000
[Microcode]
432
00009c6c009d220c013fc0c36041dffc401f9c6c011ca808010400d740619f9c
00001c6c01d0300d8106c0c360403ffc00001c6c01d0200d8106c0c360405ffc
00001c6c01d0100d8106c0c360409ffc00001c6c01d0000d8106c0c360411ffc
00011c6c0150400c028600c360411ffc00011c6c0150600c028600c360405ffc
00009c6c0150500c028600c360411ffc401f9c6c0040000d8086c0836041ff80
401f9c6c004000558086c08360407fa000001c6c009c900e008000c36041dffc
00001c6c009d302a808000c360409ffc00001c6c008000000280014360403ffc
00011c6c004000000286c08360409ffc401f9c6c00c000080086c09540219fa0
00001c6c019cf00c0486c0c360405ffc00001c6c019d000c0486c0c360409ffc
00001c6c019d100c0486c0c360411ffc00001c6c010000000480027fe0203ffc
00009c6c0080000d049a02436041fffc00011c6c01dcc00d8286c0c360405ffc
00011c6c01dcd00d8286c0c360409ffc00011c6c01dce00d8286c0c360411ffc
00001c6c00c0000c0086c0830121dffc00009c6c009cb07f808600c36041dffc
401f9c6c00c0000c0286c0830021dfa5
"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_i0;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * 0.5);
  o_i0 = tmpvar_3;
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_4 + tmpvar_3.w);
  o_i0.zw = tmpvar_2.zw;
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = (tmpvar_5 * (normalize (_glesNormal) * unity_Scale.w));
  mediump vec3 tmpvar_7;
  mediump vec4 normal;
  normal = tmpvar_6;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_8;
  tmpvar_8 = dot (unity_SHAr, normal);
  x1.x = tmpvar_8;
  highp float tmpvar_9;
  tmpvar_9 = dot (unity_SHAg, normal);
  x1.y = tmpvar_9;
  highp float tmpvar_10;
  tmpvar_10 = dot (unity_SHAb, normal);
  x1.z = tmpvar_10;
  mediump vec4 tmpvar_11;
  tmpvar_11 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHBr, tmpvar_11);
  x2.x = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHBg, tmpvar_11);
  x2.y = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHBb, tmpvar_11);
  x2.z = tmpvar_14;
  mediump float tmpvar_15;
  tmpvar_15 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (unity_SHC.xyz * vC);
  x3 = tmpvar_16;
  tmpvar_7 = ((x1 + x2) + x3);
  tmpvar_1 = tmpvar_7;
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = o_i0;
  xlv_TEXCOORD2 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform sampler2D _LightBuffer;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c;
  mediump vec4 light;
  lowp vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light = tmpvar_3;
  mediump vec4 tmpvar_4;
  tmpvar_4 = max (light, vec4(0.001, 0.001, 0.001, 0.001));
  light = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4.xyz + xlv_TEXCOORD2);
  light.xyz = tmpvar_5;
  lowp vec4 c_i0_i1;
  mediump vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_2.xyz * light.xyz);
  c_i0_i1.xyz = tmpvar_6;
  c_i0_i1.w = tmpvar_2.w;
  c = c_i0_i1;
  tmpvar_1 = c;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_i0;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * 0.5);
  o_i0 = tmpvar_3;
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_4 + tmpvar_3.w);
  o_i0.zw = tmpvar_2.zw;
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = (tmpvar_5 * (normalize (_glesNormal) * unity_Scale.w));
  mediump vec3 tmpvar_7;
  mediump vec4 normal;
  normal = tmpvar_6;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_8;
  tmpvar_8 = dot (unity_SHAr, normal);
  x1.x = tmpvar_8;
  highp float tmpvar_9;
  tmpvar_9 = dot (unity_SHAg, normal);
  x1.y = tmpvar_9;
  highp float tmpvar_10;
  tmpvar_10 = dot (unity_SHAb, normal);
  x1.z = tmpvar_10;
  mediump vec4 tmpvar_11;
  tmpvar_11 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHBr, tmpvar_11);
  x2.x = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHBg, tmpvar_11);
  x2.y = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHBb, tmpvar_11);
  x2.z = tmpvar_14;
  mediump float tmpvar_15;
  tmpvar_15 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (unity_SHC.xyz * vC);
  x3 = tmpvar_16;
  tmpvar_7 = ((x1 + x2) + x3);
  tmpvar_1 = tmpvar_7;
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = o_i0;
  xlv_TEXCOORD2 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform sampler2D _LightBuffer;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c;
  mediump vec4 light;
  lowp vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light = tmpvar_3;
  mediump vec4 tmpvar_4;
  tmpvar_4 = max (light, vec4(0.001, 0.001, 0.001, 0.001));
  light = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = (tmpvar_4.xyz + xlv_TEXCOORD2);
  light.xyz = tmpvar_5;
  lowp vec4 c_i0_i1;
  mediump vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_2.xyz * light.xyz);
  c_i0_i1.xyz = tmpvar_6;
  c_i0_i1.w = tmpvar_2.w;
  c = c_i0_i1;
  tmpvar_1 = c;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 13 [_ProjectionParams]
Matrix 9 [_Object2World]
Vector 14 [unity_LightmapST]
Vector 15 [unity_ShadowFadeCenterAndType]
Vector 16 [_MainTex_ST]
"!!ARBvp1.0
# 20 ALU
PARAM c[17] = { { 0.5, 1 },
		state.matrix.modelview[0],
		state.matrix.mvp,
		program.local[9..16] };
TEMP R0;
TEMP R1;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MUL R1.xyz, R0.xyww, c[0].x;
MUL R1.y, R1, c[13].x;
ADD result.texcoord[1].xy, R1, R1.z;
MOV result.position, R0;
MOV R0.x, c[0].y;
ADD R0.y, R0.x, -c[15].w;
DP4 R0.x, vertex.position, c[3];
DP4 R1.z, vertex.position, c[11];
DP4 R1.x, vertex.position, c[9];
DP4 R1.y, vertex.position, c[10];
ADD R1.xyz, R1, -c[15];
MOV result.texcoord[1].zw, R0;
MUL result.texcoord[3].xyz, R1, c[15].w;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[16], c[16].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[1], c[14], c[14].zwzw;
MUL result.texcoord[3].w, -R0.x, R0.y;
END
# 20 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_modelview0]
Matrix 4 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Matrix 8 [_Object2World]
Vector 14 [unity_LightmapST]
Vector 15 [unity_ShadowFadeCenterAndType]
Vector 16 [_MainTex_ST]
"vs_2_0
; 20 ALU
def c17, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
dcl_texcoord1 v2
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mul r1.xyz, r0.xyww, c17.x
mul r1.y, r1, c12.x
mad oT1.xy, r1.z, c13.zwzw, r1
mov oPos, r0
mov r0.x, c15.w
add r0.y, c17, -r0.x
dp4 r0.x, v0, c2
dp4 r1.z, v0, c10
dp4 r1.x, v0, c8
dp4 r1.y, v0, c9
add r1.xyz, r1, -c15
mov oT1.zw, r0
mul oT3.xyz, r1, c15.w
mad oT0.xy, v1, c16, c16.zwzw
mad oT2.xy, v2, c14, c14.zwzw
mul oT3.w, -r0.x, r0.y
"
}

SubProgram "xbox360 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 16 [_MainTex_ST]
Matrix 10 [_Object2World] 4
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Matrix 4 [glstate_matrix_modelview0] 4
Matrix 0 [glstate_matrix_mvp] 4
Vector 14 [unity_LightmapST]
Vector 15 [unity_ShadowFadeCenterAndType]
// Shader Timing Estimate, in Cycles/64 vertex vector:
// ALU: 28.00 (21 instructions), vertex: 32, texture: 0,
//   sequencer: 14,  7 GPRs, 27 threads,
// Performance (if enough threads): ~32 cycles per vector
// * Vertex cycle estimates are assuming 3 vfetch_minis for every vfetch_full,
//     with <= 32 bytes per vfetch_full group.

"vs_360
backbbabaaaaacdeaaaaabjmaaaaaaaaaaaaaaceaaaaablaaaaaabniaaaaaaaa
aaaaaaaaaaaaabiiaaaaaabmaaaaabhlpppoadaaaaaaaaaiaaaaaabmaaaaaaaa
aaaaabheaaaaaalmaaacaabaaaabaaaaaaaaaamiaaaaaaaaaaaaaaniaaacaaak
aaaeaaaaaaaaaaoiaaaaaaaaaaaaaapiaaacaaaiaaabaaaaaaaaaamiaaaaaaaa
aaaaabakaaacaaajaaabaaaaaaaaaamiaaaaaaaaaaaaabbiaaacaaaeaaaeaaaa
aaaaaaoiaaaaaaaaaaaaabdcaaacaaaaaaaeaaaaaaaaaaoiaaaaaaaaaaaaabef
aaacaaaoaaabaaaaaaaaaamiaaaaaaaaaaaaabfgaaacaaapaaabaaaaaaaaaami
aaaaaaaafpengbgjgofegfhifpfdfeaaaaabaaadaaabaaaeaaabaaaaaaaaaaaa
fpepgcgkgfgdhedcfhgphcgmgeaaklklaaadaaadaaaeaaaeaaabaaaaaaaaaaaa
fpfahcgpgkgfgdhegjgpgofagbhcgbgnhdaafpfdgdhcgfgfgofagbhcgbgnhdaa
ghgmhdhegbhegffpgngbhehcgjhifpgngpgegfgmhggjgfhhdaaaghgmhdhegbhe
gffpgngbhehcgjhifpgnhghaaahfgogjhehjfpemgjghgihegngbhafdfeaahfgo
gjhehjfpfdgigbgegphheggbgegfedgfgohegfhcebgogefehjhagfaahghdfpdd
fpdaaadccodacodcdadddfddcodaaaklaaaaaaaaaaaaaaabaaaaaaaaaaaaaaaa
aaaaaabeaapmaabaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaeaaaaaabfm
aadbaaagaaaaaaaaaaaaaaaaaaaadaieaaaaaaabaaaaaaadaaaaaaagaaaaacja
aabaaaaeaaaafaafaacbfaagaaaadafaaaabpbfbaaaddcfcaaaepdfdaaaababe
aaaaaabdaaaabablaaaababfaaaaaabiaaaababkaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaadpiaaaaadpaaaaaaaaaaaaaaaaaaaaaahabfdaaeaaaabcaamcaaaaaa
aaaafaahaaaabcaameaaaaaaaaaagaamgabcbcaabcaaaaaaaaaaeabiaaaaccaa
aaaaaaaaafpicaaaaaaaagiiaaaaaaaaafpieaaaaaaaapmiaaaaaaaaafpibaaa
aaaaaoehaaaaaaaamiapaaaaaabliiaakbacadaamiapaaaaaamgnapiklacacaa
miapaaaaaalbdepiklacabaamiapaaafaagmnajeklacaaaamiapiadoaananaaa
ocafafaakiibagabaeblgmmacaapppaemiahaaadaablleaakbacanaabeboaaaa
aamgimlbkbacamacmiaoaaaaaalbimabklacalaamiahaaagaagmlebfklacakaa
kiioadaaaapmlbmaibafppafmiapaaadaadedeaaoaagadaamiamiaabaanlnlaa
ocafafaamiadiaaaaalalabkilaebabamiadiaacaamflabkilabaoaomiacaaab
aamgmgblklacagadkibhaaadacmamaeciaadapaimiahiaadaamablaakbadapaa
miacaaabaablmglbklacahabmiaiiaadaelbgmaaobababaamiadiaabaablbkgn
klaaajaaaaaaaaaaaaaaaaaaaaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 256 [glstate_matrix_mvp]
Matrix 260 [glstate_matrix_modelview0]
Vector 467 [_ProjectionParams]
Matrix 264 [_Object2World]
Vector 466 [unity_LightmapST]
Vector 465 [unity_ShadowFadeCenterAndType]
Vector 464 [_MainTex_ST]
"sce_vp_rsx // 21 instructions using 3 registers
[Configuration]
8
0000001503010300
[Defaults]
1
463 2
3f0000003f800000
[Microcode]
336
401f9c6c011d0808010400d740619f9c401f9c6c011d2908010400d740619fa4
00001c6c01d0600d8106c0c360403ffc00009c6c01d0300d8106c0c360403ffc
00009c6c01d0200d8106c0c360405ffc00009c6c01d0100d8106c0c360409ffc
00009c6c01d0000d8106c0c360411ffc00011c6c005d107f8186c08360411ffc
00001c6c01d0a00d8106c0c360405ffc00001c6c01d0900d8106c0c360409ffc
00001c6c01d0800d8106c0c360411ffc00001c6c00dd108c0186c0830021dffc
00011c6c00dcf02a8186c0a001211ffc401f9c6c0040000d8286c0836041ff80
401f9c6c004000558286c08360407fa000009c6c009cf00e028000c36041dffc
401f9c6c009d100c00bfc0c36041dfa8401f9c6c008000ff8080024360403fa8
00001c6c004000000286c08360411ffc00001c6c009d302a828000c360409ffc
401f9c6c00c000080086c09540a19fa1
"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 unity_LightmapST;


uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_i0;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * 0.5);
  o_i0 = tmpvar_3;
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_4 + tmpvar_3.w);
  o_i0.zw = tmpvar_2.zw;
  tmpvar_1.xyz = (((_Object2World * _glesVertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w);
  tmpvar_1.w = (-((gl_ModelViewMatrix * _glesVertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w));
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = o_i0;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD3 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_LightmapInd;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D unity_Lightmap;
uniform sampler2D _MainTex;
uniform sampler2D _LightBuffer;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c;
  mediump vec3 lmIndirect;
  mediump vec3 lmFull;
  mediump vec4 light;
  lowp vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light = tmpvar_3;
  mediump vec4 tmpvar_4;
  tmpvar_4 = max (light, vec4(0.001, 0.001, 0.001, 0.001));
  light = tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD2).xyz);
  lmFull = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = (2.0 * texture2D (unity_LightmapInd, xlv_TEXCOORD2).xyz);
  lmIndirect = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = vec3(clamp (((length (xlv_TEXCOORD3) * unity_LightmapFade.z) + unity_LightmapFade.w), 0.0, 1.0));
  light.xyz = (tmpvar_4.xyz + mix (lmIndirect, lmFull, tmpvar_7));
  lowp vec4 c_i0_i1;
  mediump vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_2.xyz * light.xyz);
  c_i0_i1.xyz = tmpvar_8;
  c_i0_i1.w = tmpvar_2.w;
  c = c_i0_i1;
  tmpvar_1 = c;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 unity_LightmapST;


uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_i0;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * 0.5);
  o_i0 = tmpvar_3;
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_4 + tmpvar_3.w);
  o_i0.zw = tmpvar_2.zw;
  tmpvar_1.xyz = (((_Object2World * _glesVertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w);
  tmpvar_1.w = (-((gl_ModelViewMatrix * _glesVertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w));
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = o_i0;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD3 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_LightmapInd;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D unity_Lightmap;
uniform sampler2D _MainTex;
uniform sampler2D _LightBuffer;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c;
  mediump vec3 lmIndirect;
  mediump vec3 lmFull;
  mediump vec4 light;
  lowp vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light = tmpvar_3;
  mediump vec4 tmpvar_4;
  tmpvar_4 = max (light, vec4(0.001, 0.001, 0.001, 0.001));
  light = tmpvar_4;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (unity_Lightmap, xlv_TEXCOORD2);
  lowp vec3 tmpvar_6;
  tmpvar_6 = ((8.0 * tmpvar_5.w) * tmpvar_5.xyz);
  lmFull = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (unity_LightmapInd, xlv_TEXCOORD2);
  lowp vec3 tmpvar_8;
  tmpvar_8 = ((8.0 * tmpvar_7.w) * tmpvar_7.xyz);
  lmIndirect = tmpvar_8;
  highp vec3 tmpvar_9;
  tmpvar_9 = vec3(clamp (((length (xlv_TEXCOORD3) * unity_LightmapFade.z) + unity_LightmapFade.w), 0.0, 1.0));
  light.xyz = (tmpvar_4.xyz + mix (lmIndirect, lmFull, tmpvar_9));
  lowp vec4 c_i0_i1;
  mediump vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_2.xyz * light.xyz);
  c_i0_i1.xyz = tmpvar_10;
  c_i0_i1.w = tmpvar_2.w;
  c = c_i0_i1;
  tmpvar_1 = c;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 5 [_ProjectionParams]
Vector 6 [unity_LightmapST]
Vector 7 [_MainTex_ST]
"!!ARBvp1.0
# 11 ALU
PARAM c[8] = { { 0.5 },
		state.matrix.mvp,
		program.local[5..7] };
TEMP R0;
TEMP R1;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].x;
MUL R1.y, R1, c[5].x;
ADD result.texcoord[1].xy, R1, R1.z;
MOV result.position, R0;
MOV result.texcoord[1].zw, R0;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[7], c[7].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[1], c[6], c[6].zwzw;
END
# 11 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 4 [_ProjectionParams]
Vector 5 [_ScreenParams]
Vector 6 [unity_LightmapST]
Vector 7 [_MainTex_ST]
"vs_2_0
; 11 ALU
def c8, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
dcl_texcoord1 v2
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c8.x
mul r1.y, r1, c4.x
mad oT1.xy, r1.z, c5.zwzw, r1
mov oPos, r0
mov oT1.zw, r0
mad oT0.xy, v1, c7, c7.zwzw
mad oT2.xy, v2, c6, c6.zwzw
"
}

SubProgram "xbox360 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 7 [_MainTex_ST]
Vector 4 [_ProjectionParams]
Vector 5 [_ScreenParams]
Matrix 0 [glstate_matrix_mvp] 4
Vector 6 [unity_LightmapST]
// Shader Timing Estimate, in Cycles/64 vertex vector:
// ALU: 14.67 (11 instructions), vertex: 32, texture: 0,
//   sequencer: 10,  3 GPRs, 31 threads,
// Performance (if enough threads): ~32 cycles per vector
// * Vertex cycle estimates are assuming 3 vfetch_minis for every vfetch_full,
//     with <= 32 bytes per vfetch_full group.

"vs_360
backbbabaaaaabkeaaaaabbiaaaaaaaaaaaaaaceaaaaabcmaaaaabfeaaaaaaaa
aaaaaaaaaaaaabaeaaaaaabmaaaaaapipppoadaaaaaaaaafaaaaaabmaaaaaaaa
aaaaaapbaaaaaaiaaaacaaahaaabaaaaaaaaaaimaaaaaaaaaaaaaajmaaacaaae
aaabaaaaaaaaaaimaaaaaaaaaaaaaakoaaacaaafaaabaaaaaaaaaaimaaaaaaaa
aaaaaalmaaacaaaaaaaeaaaaaaaaaanaaaaaaaaaaaaaaaoaaaacaaagaaabaaaa
aaaaaaimaaaaaaaafpengbgjgofegfhifpfdfeaaaaabaaadaaabaaaeaaabaaaa
aaaaaaaafpfahcgpgkgfgdhegjgpgofagbhcgbgnhdaafpfdgdhcgfgfgofagbhc
gbgnhdaaghgmhdhegbhegffpgngbhehcgjhifpgnhghaaaklaaadaaadaaaeaaae
aaabaaaaaaaaaaaahfgogjhehjfpemgjghgihegngbhafdfeaahghdfpddfpdaaa
dccodacodcdadddfddcodaaaaaaaaaaaaaaaaaabaaaaaaaaaaaaaaaaaaaaaabe
aapmaabaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaeaaaaaaaniaacbaaac
aaaaaaaaaaaaaaaaaaaacagdaaaaaaabaaaaaaadaaaaaaaeaaaaacjaaabaaaad
aaaafaaeaacbfaafaaaadafaaaabpbfbaaaddcfcaaaabaanaaaaaaamaaaababa
aaaabaaoaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadpaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaahabfdaadaaaabcaamcaaaaaaaaaafaagaaaabcaameaaaaaaaaaagaal
aaaaccaaaaaaaaaaafpicaaaaaaaagiiaaaaaaaaafpibaaaaaaaacdpaaaaaaaa
afpibaaaaaaaapmiaaaaaaaamiapaaaaaabliiaakbacadaamiapaaaaaamgnapi
klacacaamiapaaaaaalbdepiklacabaamiapaaacaagmnajeklacaaaamiapiado
aananaaaocacacaamiahaaaaaamagmaakbacppaamiamiaabaanlnlaaocacacaa
miadiaaaaabklabkilabahahmiadiaacaalalabkilabagagkiiaaaaaaaaaaaeb
mcaaaaaemiadiaabaamgbkbiklaaafaaaaaaaaaaaaaaaaaaaaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 256 [glstate_matrix_mvp]
Vector 467 [_ProjectionParams]
Vector 466 [unity_LightmapST]
Vector 465 [_MainTex_ST]
"sce_vp_rsx // 11 instructions using 1 registers
[Configuration]
8
0000000b03010100
[Defaults]
1
464 1
3f000000
[Microcode]
176
401f9c6c011d1808010400d740619f9c00001c6c01d0300d8106c0c360403ffc
00001c6c01d0200d8106c0c360405ffc00001c6c01d0100d8106c0c360409ffc
00001c6c01d0000d8106c0c360411ffc401f9c6c011d2908010400d740619fa4
401f9c6c0040000d8086c0836041ff80401f9c6c004000558086c08360407fa0
00001c6c009d000e008000c36041dffc00001c6c009d302a808000c360409ffc
401f9c6c00c000080086c09540219fa1
"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;

uniform highp vec4 _ProjectionParams;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_i0;
  highp vec4 tmpvar_2;
  tmpvar_2 = (tmpvar_1 * 0.5);
  o_i0 = tmpvar_2;
  highp vec2 tmpvar_3;
  tmpvar_3.x = tmpvar_2.x;
  tmpvar_3.y = (tmpvar_2.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_3 + tmpvar_2.w);
  o_i0.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = o_i0;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _MainTex;
uniform sampler2D _LightBuffer;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c;
  mediump vec4 light;
  lowp vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light = tmpvar_3;
  mediump vec3 lm_i0;
  lowp vec3 tmpvar_4;
  tmpvar_4 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD2).xyz);
  lm_i0 = tmpvar_4;
  mediump vec4 tmpvar_5;
  tmpvar_5.w = 0.0;
  tmpvar_5.xyz = lm_i0;
  mediump vec4 tmpvar_6;
  tmpvar_6 = (max (light, vec4(0.001, 0.001, 0.001, 0.001)) + tmpvar_5);
  light = tmpvar_6;
  lowp vec4 c_i0_i1;
  mediump vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_2.xyz * tmpvar_6.xyz);
  c_i0_i1.xyz = tmpvar_7;
  c_i0_i1.w = tmpvar_2.w;
  c = c_i0_i1;
  tmpvar_1 = c;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;

uniform highp vec4 _ProjectionParams;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_i0;
  highp vec4 tmpvar_2;
  tmpvar_2 = (tmpvar_1 * 0.5);
  o_i0 = tmpvar_2;
  highp vec2 tmpvar_3;
  tmpvar_3.x = tmpvar_2.x;
  tmpvar_3.y = (tmpvar_2.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_3 + tmpvar_2.w);
  o_i0.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = o_i0;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _MainTex;
uniform sampler2D _LightBuffer;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c;
  mediump vec4 light;
  lowp vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_MainTex, xlv_TEXCOORD0) * _Color);
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light = tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (unity_Lightmap, xlv_TEXCOORD2);
  mediump vec3 lm_i0;
  lowp vec3 tmpvar_5;
  tmpvar_5 = ((8.0 * tmpvar_4.w) * tmpvar_4.xyz);
  lm_i0 = tmpvar_5;
  mediump vec4 tmpvar_6;
  tmpvar_6.w = 0.0;
  tmpvar_6.xyz = lm_i0;
  mediump vec4 tmpvar_7;
  tmpvar_7 = (max (light, vec4(0.001, 0.001, 0.001, 0.001)) + tmpvar_6);
  light = tmpvar_7;
  lowp vec4 c_i0_i1;
  mediump vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_2.xyz * tmpvar_7.xyz);
  c_i0_i1.xyz = tmpvar_8;
  c_i0_i1.w = tmpvar_2.w;
  c = c_i0_i1;
  tmpvar_1 = c;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 6
//   opengl - ALU: 6 to 20, TEX: 2 to 4
//   d3d9 - ALU: 5 to 17, TEX: 2 to 4
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightBuffer] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 9 ALU, 2 TEX
PARAM c[1] = { program.local[0] };
TEMP R0;
TEMP R1;
TXP R1.xyz, fragment.texcoord[1], texture[1], 2D;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MUL R0, R0, c[0];
LG2 R1.x, R1.x;
LG2 R1.z, R1.z;
LG2 R1.y, R1.y;
ADD R1.xyz, -R1, fragment.texcoord[2];
MUL result.color.xyz, R0, R1;
MOV result.color.w, R0;
END
# 9 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightBuffer] 2D
"ps_2_0
; 8 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
dcl t0.xy
dcl t1
dcl t2.xyz
texldp r0, t1, s1
texld r1, t0, s0
mul r1, r1, c0
log_pp r0.x, r0.x
log_pp r0.z, r0.z
log_pp r0.y, r0.y
add_pp r0.xyz, -r0, t2
mul_pp r0.xyz, r1, r0
mov_pp r0.w, r1
mov_pp oC0, r0
"
}

SubProgram "xbox360 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightBuffer] 2D
// Shader Timing Estimate, in Cycles/64 pixel vector:
// ALU: 9.33 (7 instructions), vertex: 0, texture: 8,
//   sequencer: 6, interpolator: 12;    4 GPRs, 48 threads,
// Performance (if enough threads): ~12 cycles per vector
// * Texture cycle estimates are assuming an 8bit/component texture with no
//     aniso or trilinear filtering.

"ps_360
backbbaaaaaaabaaaaaaaajaaaaaaaaaaaaaaaceaaaaaaaaaaaaaaneaaaaaaaa
aaaaaaaaaaaaaakmaaaaaabmaaaaaakappppadaaaaaaaaadaaaaaabmaaaaaaaa
aaaaaajjaaaaaafiaaacaaaaaaabaaaaaaaaaagaaaaaaaaaaaaaaahaaaadaaab
aaabaaaaaaaaaaiaaaaaaaaaaaaaaajaaaadaaaaaaabaaaaaaaaaaiaaaaaaaaa
fpedgpgmgphcaaklaaabaaadaaabaaaeaaabaaaaaaaaaaaafpemgjghgiheechf
gggggfhcaaklklklaaaeaaamaaabaaabaaabaaaaaaaaaaaafpengbgjgofegfhi
aahahdfpddfpdaaadccodacodcdadddfddcodaaaaaaaaaaaaaaaaajabaaaadaa
aaaaaaaeaaaaaaaaaaaacegdaaahaaahaaaaaaabaaaadafaaaaapbfbaaaahcfc
aafaeaacaaaabcaameaaaaaaaaaafaagaaaaccaaaaaaaaaaemeaaaaaaaaaaabl
ocaaaaabmiamaaaaaamgkmaaobaaabaalibibaabbpbppfmiaaaaeaaabaaiaaab
bpbppeedaaaaeaaaeabaadaaaaaaaagmocaaaaibeacaadaaaaaaaalbocaaaaib
eaehadabaabfmablkbaaaaibbeboaaaaaepmpmgmoaadacaakiihiaaaaamabfaa
mbabaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightBuffer] 2D
"sce_fp_rsx // 10 instructions using 3 registers
[Configuration]
24
ffffffff0001c0200007fff9000000000000840003000000
[Offsets]
1
_Color 1 0
00000050
[Microcode]
160
ae041802c8011c9dc8000001c8003fe102801d40c8081c9dc8000001c8000001
9e021700c8011c9dc8000001c8003fe104801d40aa081c9cc8000001c8000001
1e820200c8041c9dc8020001c800000100000000000000000000000000000000
08801d4054081c9dc8000001c8000001ce800300c8011c9dc9000003c8003fe1
10800140c9041c9dc8000001c80000010e810240c9041c9dc9000001c8000001
"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Vector 0 [_Color]
Vector 1 [unity_LightmapFade]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightBuffer] 2D
SetTexture 2 [unity_Lightmap] 2D
SetTexture 3 [unity_LightmapInd] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 20 ALU, 4 TEX
PARAM c[3] = { program.local[0..1],
		{ 8 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R1, fragment.texcoord[2], texture[3], 2D;
TEX R2, fragment.texcoord[2], texture[2], 2D;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TXP R3.xyz, fragment.texcoord[1], texture[1], 2D;
MUL R2.xyz, R2.w, R2;
MUL R1.xyz, R1.w, R1;
MUL R1.xyz, R1, c[2].x;
MUL R0, R0, c[0];
DP4 R2.w, fragment.texcoord[3], fragment.texcoord[3];
RSQ R1.w, R2.w;
RCP R1.w, R1.w;
MAD R2.xyz, R2, c[2].x, -R1;
MAD_SAT R1.w, R1, c[1].z, c[1];
MAD R1.xyz, R1.w, R2, R1;
LG2 R2.x, R3.x;
LG2 R2.y, R3.y;
LG2 R2.z, R3.z;
ADD R1.xyz, -R2, R1;
MUL result.color.xyz, R0, R1;
MOV result.color.w, R0;
END
# 20 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Vector 0 [_Color]
Vector 1 [unity_LightmapFade]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightBuffer] 2D
SetTexture 2 [unity_Lightmap] 2D
SetTexture 3 [unity_LightmapInd] 2D
"ps_2_0
; 17 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c2, 8.00000000, 0, 0, 0
dcl t0.xy
dcl t1
dcl t2.xy
dcl t3
texld r1, t0, s0
texldp r2, t1, s1
texld r0, t2, s2
texld r3, t2, s3
mul_pp r4.xyz, r0.w, r0
dp4 r0.x, t3, t3
mul_pp r3.xyz, r3.w, r3
mul_pp r3.xyz, r3, c2.x
rsq r0.x, r0.x
rcp r0.x, r0.x
mul r1, r1, c0
mad_pp r4.xyz, r4, c2.x, -r3
mad_sat r0.x, r0, c1.z, c1.w
mad_pp r0.xyz, r0.x, r4, r3
log_pp r2.x, r2.x
log_pp r2.y, r2.y
log_pp r2.z, r2.z
add_pp r0.xyz, -r2, r0
mul_pp r0.xyz, r1, r0
mov_pp r0.w, r1
mov_pp oC0, r0
"
}

SubProgram "xbox360 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Vector 0 [_Color]
Vector 1 [unity_LightmapFade]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightBuffer] 2D
SetTexture 2 [unity_Lightmap] 2D
SetTexture 3 [unity_LightmapInd] 2D
// Shader Timing Estimate, in Cycles/64 pixel vector:
// ALU: 14.67 (11 instructions), vertex: 0, texture: 16,
//   sequencer: 8, interpolator: 16;    6 GPRs, 30 threads,
// Performance (if enough threads): ~16 cycles per vector
// * Texture cycle estimates are assuming an 8bit/component texture with no
//     aniso or trilinear filtering.

"ps_360
backbbaaaaaaabjmaaaaabbiaaaaaaaaaaaaaaceaaaaabeeaaaaabgmaaaaaaaa
aaaaaaaaaaaaabbmaaaaaabmaaaaabbappppadaaaaaaaaagaaaaaabmaaaaaaaa
aaaaabajaaaaaajeaaacaaaaaaabaaaaaaaaaajmaaaaaaaaaaaaaakmaaadaaab
aaabaaaaaaaaaalmaaaaaaaaaaaaaammaaadaaaaaaabaaaaaaaaaalmaaaaaaaa
aaaaaanfaaadaaacaaabaaaaaaaaaalmaaaaaaaaaaaaaaoeaaacaaabaaabaaaa
aaaaaajmaaaaaaaaaaaaaaphaaadaaadaaabaaaaaaaaaalmaaaaaaaafpedgpgm
gphcaaklaaabaaadaaabaaaeaaabaaaaaaaaaaaafpemgjghgiheechfgggggfhc
aaklklklaaaeaaamaaabaaabaaabaaaaaaaaaaaafpengbgjgofegfhiaahfgogj
hehjfpemgjghgihegngbhaaahfgogjhehjfpemgjghgihegngbhaeggbgegfaahf
gogjhehjfpemgjghgihegngbhaejgogeaahahdfpddfpdaaadccodacodcdadddf
ddcodaaaaaaaaaaaaaaaaaabaaaaaaaaaaaaaaaaaaaaaabeabpmaabaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaeaaaaaaanibaaaafaaaaaaaaaeaaaaaaaa
aaaadaieaaapaaapaaaaaaabaaaadafaaaaapbfbaaaadcfcaaaapdfdaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaebaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaffagaac
aaaabcaameaaaaaaaaaagaaidaaobcaaccaaaaaaemecaaafaakhkhblopadadab
miamaaaaaamgkmaaobaaabaabadidaebbpbppgiiaaaaeaaabacieaebbpbppgii
aaaaeaaalibicaabbpbppoiiaaaaeaaabaaiaaabbpbppeedaaaaeaaaeabhacab
aabfmagmkbaaaaiceaciacacaablgmlbkbaeppickaibabafaablgmlbkbadppif
mjaiaaabaablmgblilabababeaehacadaagmmamgobafadicmiahaaaeabblmama
olacaeadmiahaaadaamablmaolaeabadbeboaaaaacpmpmgmoaadacaakiihiaaa
aamabfaambabaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Vector 0 [_Color]
Vector 1 [unity_LightmapFade]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightBuffer] 2D
SetTexture 2 [unity_Lightmap] 2D
SetTexture 3 [unity_LightmapInd] 2D
"sce_fp_rsx // 23 instructions using 4 registers
[Configuration]
24
ffffffff0003c020000ffff5000000000000840004000000
[Offsets]
2
_Color 1 0
000000a0
unity_LightmapFade 2 0
00000110000000c0
[Microcode]
368
fe000100c8011c9dc8000001c8003fe102000600c8001c9dc8000001c8000001
ae041802c8011c9dc8000001c8003fe1028e1d40c8081c9dc8000001c8000001
02021b00c8001c9dc8000001c8000001048e1d40aa081c9cc8000001c8000001
de001706c8011c9dc8000001c8003fe10e8c0240fe001c9dc8003001c8000001
9e001700c8011c9dc8000001c8003fe11e880200c8001c9dc8020001c8000001
0000000000000000000000000000000010063a0054021c9dc8040001c8000001
00000000000000000000000000000000de021704c8011c9dc8000001c8003fe1
08860140fe041c9dc8003001c80000010e000400550c1c9dc8040001c9180003
10008300c80c1c9dc8020001c800000100000000000000000000000000000000
0e8c0400fe001c9dc8000001c9180001088e1d4054081c9dc8000001c8000001
0e800340c91c1c9fc9180001c800000110800140c9101c9dc8000001c8000001
0e810240c9101c9dc9000001c8000001
"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightBuffer] 2D
SetTexture 2 [unity_Lightmap] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 11 ALU, 3 TEX
PARAM c[2] = { program.local[0],
		{ 8 } };
TEMP R0;
TEMP R1;
TEMP R2;
TXP R2.xyz, fragment.texcoord[1], texture[1], 2D;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R1, fragment.texcoord[2], texture[2], 2D;
MUL R0, R0, c[0];
MUL R1.xyz, R1.w, R1;
LG2 R2.x, R2.x;
LG2 R2.z, R2.z;
LG2 R2.y, R2.y;
MAD R1.xyz, R1, c[1].x, -R2;
MUL result.color.xyz, R0, R1;
MOV result.color.w, R0;
END
# 11 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightBuffer] 2D
SetTexture 2 [unity_Lightmap] 2D
"ps_2_0
; 9 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c1, 8.00000000, 0, 0, 0
dcl t0.xy
dcl t1
dcl t2.xy
texldp r2, t1, s1
texld r1, t0, s0
texld r0, t2, s2
mul_pp r0.xyz, r0.w, r0
mul r1, r1, c0
log_pp r2.x, r2.x
log_pp r2.z, r2.z
log_pp r2.y, r2.y
mad_pp r0.xyz, r0, c1.x, -r2
mul_pp r0.xyz, r1, r0
mov_pp r0.w, r1
mov_pp oC0, r0
"
}

SubProgram "xbox360 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightBuffer] 2D
SetTexture 2 [unity_Lightmap] 2D
// Shader Timing Estimate, in Cycles/64 pixel vector:
// ALU: 10.67 (8 instructions), vertex: 0, texture: 12,
//   sequencer: 6, interpolator: 12;    4 GPRs, 48 threads,
// Performance (if enough threads): ~12 cycles per vector
// * Texture cycle estimates are assuming an 8bit/component texture with no
//     aniso or trilinear filtering.

"ps_360
backbbaaaaaaabemaaaaaaoiaaaaaaaaaaaaaaceaaaaaapiaaaaabcaaaaaaaaa
aaaaaaaaaaaaaanaaaaaaabmaaaaaamdppppadaaaaaaaaaeaaaaaabmaaaaaaaa
aaaaaalmaaaaaagmaaacaaaaaaabaaaaaaaaaaheaaaaaaaaaaaaaaieaaadaaab
aaabaaaaaaaaaajeaaaaaaaaaaaaaakeaaadaaaaaaabaaaaaaaaaajeaaaaaaaa
aaaaaaknaaadaaacaaabaaaaaaaaaajeaaaaaaaafpedgpgmgphcaaklaaabaaad
aaabaaaeaaabaaaaaaaaaaaafpemgjghgiheechfgggggfhcaaklklklaaaeaaam
aaabaaabaaabaaaaaaaaaaaafpengbgjgofegfhiaahfgogjhehjfpemgjghgihe
gngbhaaahahdfpddfpdaaadccodacodcdadddfddcodaaaklaaaaaaaaaaaaaaab
aaaaaaaaaaaaaaaaaaaaaabeabpmaabaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaeaaaaaaakibaaaadaaaaaaaaaeaaaaaaaaaaaacagdaaahaaahaaaaaaab
aaaadafaaaaapbfbaaaadcfcaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaebaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaabfafaacaaaabcaameaaaaaaaaaagaahaaaaccaa
aaaaaaaaemeaaaaaaaaaaablocaaaaabmiamaaaaaamgkmaaobaaabaabacicaeb
bpbppgiiaaaaeaaalibibaabbpbppfmiaaaaeaaabaaidaabbpbppgiiaaaaeaaa
miaiiaaaaablblaakbadaaaaeabaaaaaaaaaaagmocaaaaibeaciaaaaaablgmlb
kbacppibeaehaaabaamamablkbadaaibmiahaaaaabblmamaolaaacaamiahiaaa
aamamaaaobabaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightBuffer] 2D
SetTexture 2 [unity_Lightmap] 2D
"sce_fp_rsx // 12 instructions using 3 registers
[Configuration]
24
ffffffff0001c0200007fffd000000000000840003000000
[Offsets]
1
_Color 1 0
00000080
[Microcode]
192
ae001802c8011c9dc8000001c8003fe104801d40c8001c9dc8000001c8000001
de021704c8011c9dc8000001c8003fe102800140fe041c9dc8003001c8000001
08801d40aa001c9cc8000001c800000110801d4054001c9dc8000001c8000001
9e041700c8011c9dc8000001c8003fe11e820200c8081c9dc8020001c8000001
000000000000000000000000000000000e80044001001c9cc8040001f3000003
10800140c9041c9dc8000001c80000010e810240c9041c9dc9000001c8000001
"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightBuffer] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 6 ALU, 2 TEX
PARAM c[1] = { program.local[0] };
TEMP R0;
TEMP R1;
TXP R1.xyz, fragment.texcoord[1], texture[1], 2D;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MUL R0, R0, c[0];
ADD R1.xyz, R1, fragment.texcoord[2];
MUL result.color.xyz, R0, R1;
MOV result.color.w, R0;
END
# 6 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightBuffer] 2D
"ps_2_0
; 5 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
dcl t0.xy
dcl t1
dcl t2.xyz
texldp r0, t1, s1
texld r1, t0, s0
mul r1, r1, c0
add_pp r0.xyz, r0, t2
mul_pp r0.xyz, r1, r0
mov_pp r0.w, r1
mov_pp oC0, r0
"
}

SubProgram "xbox360 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightBuffer] 2D
// Shader Timing Estimate, in Cycles/64 pixel vector:
// ALU: 6.67 (5 instructions), vertex: 0, texture: 8,
//   sequencer: 6, interpolator: 12;    4 GPRs, 48 threads,
// Performance (if enough threads): ~12 cycles per vector
// * Texture cycle estimates are assuming an 8bit/component texture with no
//     aniso or trilinear filtering.

"ps_360
backbbaaaaaaabaaaaaaaahiaaaaaaaaaaaaaaceaaaaaaaaaaaaaaneaaaaaaaa
aaaaaaaaaaaaaakmaaaaaabmaaaaaakappppadaaaaaaaaadaaaaaabmaaaaaaaa
aaaaaajjaaaaaafiaaacaaaaaaabaaaaaaaaaagaaaaaaaaaaaaaaahaaaadaaab
aaabaaaaaaaaaaiaaaaaaaaaaaaaaajaaaadaaaaaaabaaaaaaaaaaiaaaaaaaaa
fpedgpgmgphcaaklaaabaaadaaabaaaeaaabaaaaaaaaaaaafpemgjghgiheechf
gggggfhcaaklklklaaaeaaamaaabaaabaaabaaaaaaaaaaaafpengbgjgofegfhi
aahahdfpddfpdaaadccodacodcdadddfddcodaaaaaaaaaaaaaaaaahibaaaadaa
aaaaaaaeaaaaaaaaaaaacegdaaahaaahaaaaaaabaaaadafaaaaapbfbaaaahcfc
aafaeaacaaaabcaameaaaaaaaaaadaagaaaaccaaaaaaaaaaemeaaaaaaaaaaabl
ocaaaaabmiamaaaaaamgkmaaobaaabaalibidaabbpbppoiiaaaaeaaabaaiaaab
bpbppeedaaaaeaaamiahaaabaabfmaaakbaaaaaabeboaaaaaapmpmgmoaadacaa
kiihiaaaaamabfaambabaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightBuffer] 2D
"sce_fp_rsx // 7 instructions using 2 registers
[Configuration]
24
ffffffff0001c0200007fff9000000000000840002000000
[Offsets]
1
_Color 1 0
00000020
[Microcode]
112
9e001700c8011c9dc8000001c8003fe11e800200c8001c9dc8020001c8000001
00000000000000000000000000000000ae021802c8011c9dc8000001c8003fe1
10800140c9001c9dc8000001c8000001ce820300c8011c9dc8040001c8003fe1
0e810240c9001c9dc9040001c8000001
"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Vector 0 [_Color]
Vector 1 [unity_LightmapFade]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightBuffer] 2D
SetTexture 2 [unity_Lightmap] 2D
SetTexture 3 [unity_LightmapInd] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 17 ALU, 4 TEX
PARAM c[3] = { program.local[0..1],
		{ 8 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R1, fragment.texcoord[2], texture[3], 2D;
TEX R2, fragment.texcoord[2], texture[2], 2D;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TXP R3.xyz, fragment.texcoord[1], texture[1], 2D;
MUL R2.xyz, R2.w, R2;
MUL R1.xyz, R1.w, R1;
MUL R1.xyz, R1, c[2].x;
MUL R0, R0, c[0];
DP4 R2.w, fragment.texcoord[3], fragment.texcoord[3];
RSQ R1.w, R2.w;
RCP R1.w, R1.w;
MAD R2.xyz, R2, c[2].x, -R1;
MAD_SAT R1.w, R1, c[1].z, c[1];
MAD R1.xyz, R1.w, R2, R1;
ADD R1.xyz, R3, R1;
MUL result.color.xyz, R0, R1;
MOV result.color.w, R0;
END
# 17 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Vector 0 [_Color]
Vector 1 [unity_LightmapFade]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightBuffer] 2D
SetTexture 2 [unity_Lightmap] 2D
SetTexture 3 [unity_LightmapInd] 2D
"ps_2_0
; 14 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c2, 8.00000000, 0, 0, 0
dcl t0.xy
dcl t1
dcl t2.xy
dcl t3
texldp r2, t1, s1
texld r1, t0, s0
texld r0, t2, s2
texld r3, t2, s3
mul_pp r4.xyz, r0.w, r0
dp4 r0.x, t3, t3
mul_pp r3.xyz, r3.w, r3
mul_pp r3.xyz, r3, c2.x
rsq r0.x, r0.x
rcp r0.x, r0.x
mul r1, r1, c0
mad_pp r4.xyz, r4, c2.x, -r3
mad_sat r0.x, r0, c1.z, c1.w
mad_pp r0.xyz, r0.x, r4, r3
add_pp r0.xyz, r2, r0
mul_pp r0.xyz, r1, r0
mov_pp r0.w, r1
mov_pp oC0, r0
"
}

SubProgram "xbox360 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Vector 0 [_Color]
Vector 1 [unity_LightmapFade]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightBuffer] 2D
SetTexture 2 [unity_Lightmap] 2D
SetTexture 3 [unity_LightmapInd] 2D
// Shader Timing Estimate, in Cycles/64 pixel vector:
// ALU: 13.33 (10 instructions), vertex: 0, texture: 16,
//   sequencer: 8, interpolator: 16;    5 GPRs, 36 threads,
// Performance (if enough threads): ~16 cycles per vector
// * Texture cycle estimates are assuming an 8bit/component texture with no
//     aniso or trilinear filtering.

"ps_360
backbbaaaaaaabjmaaaaabamaaaaaaaaaaaaaaceaaaaabeeaaaaabgmaaaaaaaa
aaaaaaaaaaaaabbmaaaaaabmaaaaabbappppadaaaaaaaaagaaaaaabmaaaaaaaa
aaaaabajaaaaaajeaaacaaaaaaabaaaaaaaaaajmaaaaaaaaaaaaaakmaaadaaab
aaabaaaaaaaaaalmaaaaaaaaaaaaaammaaadaaaaaaabaaaaaaaaaalmaaaaaaaa
aaaaaanfaaadaaacaaabaaaaaaaaaalmaaaaaaaaaaaaaaoeaaacaaabaaabaaaa
aaaaaajmaaaaaaaaaaaaaaphaaadaaadaaabaaaaaaaaaalmaaaaaaaafpedgpgm
gphcaaklaaabaaadaaabaaaeaaabaaaaaaaaaaaafpemgjghgiheechfgggggfhc
aaklklklaaaeaaamaaabaaabaaabaaaaaaaaaaaafpengbgjgofegfhiaahfgogj
hehjfpemgjghgihegngbhaaahfgogjhehjfpemgjghgihegngbhaeggbgegfaahf
gogjhehjfpemgjghgihegngbhaejgogeaahahdfpddfpdaaadccodacodcdadddf
ddcodaaaaaaaaaaaaaaaaaabaaaaaaaaaaaaaaaaaaaaaabeabpmaabaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaeaaaaaaammbaaaaeaaaaaaaaaeaaaaaaaa
aaaadaieaaapaaapaaaaaaabaaaadafaaaaapbfbaaaadcfcaaaapdfdaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaebaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaffagaac
aaaabcaameaaaaaaaaaagaaicaaobcaaccaaaaaaemieaaaaaakhkhblopadadab
miadaaabaabllaaaobaaabaababidacbbpbppoiiaaaaeaaabadieaebbpbppgii
aaaaeaaabacicaebbpbppeedaaaaeaaabaaibaabbpbppgiiaaaaeaaabecbaaaa
aablgmgmkbaeppackaehaaabaamamamgkbabaaiamjabaaacaamgmgblilaaabab
kicnaaaaaagmpaebmbaaaeppmiaoaaacablbabamolaaacaamiahaaaaaabfgmbe
olacacaabeboaaaaaapmpmbloaaaadabkiihiaaaaamabfaambabaaaaaaaaaaaa
aaaaaaaaaaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Vector 0 [_Color]
Vector 1 [unity_LightmapFade]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightBuffer] 2D
SetTexture 2 [unity_Lightmap] 2D
SetTexture 3 [unity_LightmapInd] 2D
"sce_fp_rsx // 20 instructions using 4 registers
[Configuration]
24
ffffffff0003c020000ffff5000000000000840004000000
[Offsets]
2
_Color 1 0
00000100
unity_LightmapFade 2 0
000000b000000090
[Microcode]
320
fe020100c8011c9dc8000001c8003fe102020600c8041c9dc8040001c8000001
de041704c8011c9dc8000001c8003fe1108c0140c8081c9dc8003001c8000001
de001706c8011c9dc8000001c8003fe10e8c0240fe001c9dc8003001c8000001
10041b00c8041c9dc8000001c80000010e000400ff181c9dc8080001c9180003
10003a0054021c9dfe080001c800000100000000000000000000000000000000
10008300c8001c9dc8020001c800000100000000000000000000000000000000
ae021802c8011c9dc8000001c8003fe10e880400fe001c9dc8000001c9180001
9e001700c8011c9dc8000001c8003fe11e8a0200c8001c9dc8020001c8000001
0000000000000000000000000000000010800140c9141c9dc8000001c8000001
0e800340c8041c9dc9100001c80000010e810240c9141c9dc9000001c8000001
"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightBuffer] 2D
SetTexture 2 [unity_Lightmap] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 8 ALU, 3 TEX
PARAM c[2] = { program.local[0],
		{ 8 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R1, fragment.texcoord[2], texture[2], 2D;
TXP R2.xyz, fragment.texcoord[1], texture[1], 2D;
MUL R0, R0, c[0];
MUL R1.xyz, R1.w, R1;
MAD R1.xyz, R1, c[1].x, R2;
MUL result.color.xyz, R0, R1;
MOV result.color.w, R0;
END
# 8 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightBuffer] 2D
SetTexture 2 [unity_Lightmap] 2D
"ps_2_0
; 6 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c1, 8.00000000, 0, 0, 0
dcl t0.xy
dcl t1
dcl t2.xy
texldp r2, t1, s1
texld r1, t0, s0
texld r0, t2, s2
mul_pp r0.xyz, r0.w, r0
mul r1, r1, c0
mad_pp r0.xyz, r0, c1.x, r2
mul_pp r0.xyz, r1, r0
mov_pp r0.w, r1
mov_pp oC0, r0
"
}

SubProgram "xbox360 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightBuffer] 2D
SetTexture 2 [unity_Lightmap] 2D
// Shader Timing Estimate, in Cycles/64 pixel vector:
// ALU: 8.00 (6 instructions), vertex: 0, texture: 12,
//   sequencer: 6, interpolator: 12;    4 GPRs, 48 threads,
// Performance (if enough threads): ~12 cycles per vector
// * Texture cycle estimates are assuming an 8bit/component texture with no
//     aniso or trilinear filtering.

"ps_360
backbbaaaaaaabemaaaaaanaaaaaaaaaaaaaaaceaaaaaapiaaaaabcaaaaaaaaa
aaaaaaaaaaaaaanaaaaaaabmaaaaaamdppppadaaaaaaaaaeaaaaaabmaaaaaaaa
aaaaaalmaaaaaagmaaacaaaaaaabaaaaaaaaaaheaaaaaaaaaaaaaaieaaadaaab
aaabaaaaaaaaaajeaaaaaaaaaaaaaakeaaadaaaaaaabaaaaaaaaaajeaaaaaaaa
aaaaaaknaaadaaacaaabaaaaaaaaaajeaaaaaaaafpedgpgmgphcaaklaaabaaad
aaabaaaeaaabaaaaaaaaaaaafpemgjghgiheechfgggggfhcaaklklklaaaeaaam
aaabaaabaaabaaaaaaaaaaaafpengbgjgofegfhiaahfgogjhehjfpemgjghgihe
gngbhaaahahdfpddfpdaaadccodacodcdadddfddcodaaaklaaaaaaaaaaaaaaab
aaaaaaaaaaaaaaaaaaaaaabeabpmaabaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaeaaaaaaajabaaaadaaaaaaaaaeaaaaaaaaaaaacagdaaahaaahaaaaaaab
aaaadafaaaaapbfbaaaadcfcaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaebaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaabfafaacaaaabcaameaaaaaaaaaaeaahaaaaccaa
aaaaaaaaemeaaaaaaaaaaablocaaaaabmiamaaaaaamgkmaaobaaabaalibidaab
bpbppoiiaaaaeaaabacicaebbpbppgiiaaaaeaaabaaibaabbpbppgiiaaaaeaaa
kicaaaaaaaaaaaedocaaaappbebhaaabaamamablkbabaaabmiaoaaaaaalbpmpm
olaaacadkiihiaaaaamabfaambabaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
}

SubProgram "ps3 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_LightBuffer] 2D
SetTexture 2 [unity_Lightmap] 2D
"sce_fp_rsx // 9 instructions using 3 registers
[Configuration]
24
ffffffff0001c0200007fffd000000000000840003000000
[Offsets]
1
_Color 1 0
00000020
[Microcode]
144
9e001700c8011c9dc8000001c8003fe11e800200c8001c9dc8020001c8000001
00000000000000000000000000000000de021704c8011c9dc8000001c8003fe1
08860140fe041c9dc8003001c8000001ae041802c8011c9dc8000001c8003fe1
0e820440550c1c9dc8040001c808000110800140c9001c9dc8000001c8000001
0e810240c9001c9dc9040001c8000001
"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
"!!GLES"
}

}
	}

#LINE 25

}

Fallback "VertexLit"
}
